import pins
import pandas as pd

board = pins.board_connect(
    server_url="https://rsc.ds.umcutrecht.nl/",
    api_key="<API_KEY>"
)

df = pd.DataFrame({
    "name": ["Alice", "Bob", "Charlie"],
    "score": [90, 85, 95]
})

board.pin_write(
    df,
    name="<umcuEmailAddress/namePin>",
    title="Student Scores",
    description="Scores from the recent math quiz",
    type="csv"
)