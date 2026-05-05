import requests
import sys

TOKEN = ""
CHAT_ID = ""

msg = sys.argv[1]

requests.post(
    f"https://api.telegram.org/bot{TOKEN}/sendMessage",
    data={"chat_id": CHAT_ID, "text": msg}
)

