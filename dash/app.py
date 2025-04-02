import dash
from dash import html
import pins
import pandas as pd

board = pins.board_connect(
    server_url="https://rsc.ds.umcutrecht.nl/",
    api_key="oPhmqk9n9SjHBURULvc8hmJnLFOLfgVk"
)

df = board.pin_read("M.M.Dieperink@umcutrecht.nl/test_pin")

app = dash.Dash(__name__)
app.layout = html.H1("Hello from Dash on Posit Connect!")

server = app.server  # important for Posit Connect