from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
import asyncio
import socket
import logging

app = FastAPI()
logging.basicConfig(level=logging.INFO)

# Define the request schema
class OutgoingRequest(BaseModel):
    address: str
    tls: Optional[bool] = None

# Store active routes for tracking (optional)
routes = {}

# Helper to get a free local TCP port
async def get_free_port():
    with socket.socket() as s:
        s.bind(('', 0))
        return s.getsockname()[1]

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

@app.post("/outgoing/new")
async def create_outgoing(req: OutgoingRequest):
    # Just parse and respond with a dummy port
    try:
        host, port_str = req.address.split(":")
        port = int(port_str)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid address format. Use host:port")

    proxy_port = await get_free_port()

     # Start TCP server that forwards to the target address
    async def start_forwarder():
        server = await asyncio.start_server(
            lambda r, w: handle_connection(r, w, host, port),
            host="0.0.0.0",
            port=proxy_port
        )
        async with server:
            await server.serve_forever()

    asyncio.create_task(start_forwarder())
    routes[proxy_port] = req.address
    logging.info(f"Started TCP forwarder: :{proxy_port} → {req.address}")

    return {"port": proxy_port}