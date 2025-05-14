from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, timedelta
from contextlib import asynccontextmanager
import asyncio
import socket
import logging

logging.basicConfig(level=logging.INFO)

# Store active routes for tracking (optional)
routes = {}
servers = {}

# Define the request schema
class OutgoingRequest(BaseModel):
    address: str
    tls: Optional[bool] = None

class RouteInfo:
    def __init__(self, address: str, port: int):
        self.address = address
        self.port = port
        self.last_used = datetime.now()

ALLOWED_PORT_RANGE = range(50000, 51000)

# Helper to get a free local TCP port
async def get_free_port():
    for port in ALLOWED_PORT_RANGE:
        with socket.socket() as s:
            try:
                s.bind(('', port))
                return s.getsockname()[1]
            except OSError:
                continue
    raise RuntimeError("No available port in allowed range.")

# Forward data between two streams
async def pipe(reader, writer):
    try:
        while not reader.at_eof():
            data = await reader.read(4096)
            if not data:
                break
            writer.write(data)
            await writer.drain()
    except Exception as e:
        logging.warning(f"Pipe error: {e}")
    finally:
        writer.close()
        await writer.wait_closed()

# Set up the proxy for a given target
async def handle_connection(client_reader, client_writer, target_host, target_port):
    try:
        target_reader, target_writer = await asyncio.open_connection(target_host, target_port)
        await asyncio.gather(
            pipe(client_reader, target_writer),
            pipe(target_reader, client_writer)
        )
    except Exception as e:
        logging.error(f"Error forwarding to {target_host}:{target_port}: {e}")
        client_writer.close()
        await client_writer.wait_closed()

ROUTE_TTL = timedelta(minutes=1)

# Cleans routes after one minute
async def cleanup_routes():
    while True:
        now = datetime.now()
        to_delete = []

        for addr, info in list(routes.items()):
            if now - info.last_used > ROUTE_TTL:
                port = info.port
                server = servers.get(port)
                if server:
                    server.close()
                    await server.wait_closed()
                    logging.info(f"Closed idle route {addr} on port {port}")
                    to_delete.append((addr, port))

        for addr, port in to_delete:
            routes.pop(addr, None)
            servers.pop(port, None)

        await asyncio.sleep(60)

@asynccontextmanager
async def lifespan(app: FastAPI):
    asyncio.create_task(cleanup_routes())
    yield

app = FastAPI(lifespan=lifespan)

@app.post("/outgoing/new")
async def create_outgoing(req: OutgoingRequest):
    # Just parse and respond with a dummy port
    try:
        host, port_str = req.address.split(":")
        port = int(port_str)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid address format. Use host:port")
    
    # Check if route already exists
    if req.address in routes:
        logging.info(f"Reusing existing route for {req.address} → {routes[req.address]}")
        return {"port": routes[req.address]}

    proxy_port = await get_free_port()

     # Start TCP server that forwards to the target address
    async def start_forwarder():
        server = await asyncio.start_server(
            lambda r, w: handle_connection(r, w, host, port),
            host="0.0.0.0",
            port=proxy_port
        )
        routes[req.address] = RouteInfo(req.address, proxy_port)
        servers[proxy_port] = server
        logging.info(f"Started TCP forwarder: :{proxy_port} → {req.address}")
        async with server:
            await server.serve_forever()

    asyncio.create_task(start_forwarder())
    return {"port": proxy_port}