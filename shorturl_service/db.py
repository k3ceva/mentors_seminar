import os
import sqlite3
from contextlib import contextmanager
from schemas import LongURLGet

DB_PATH = os.getenv("DATA_DIR", "./data/shorturl.db")

def init_db() -> None:
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS short_urls (
                short_url TEXT PRIMARY KEY,
                long_url TEXT NOT NULL
            )
        """)
        conn.commit()

@contextmanager
def get_conn():
    conn = sqlite3.connect(DB_PATH, check_same_thread=False)
    conn.row_factory = sqlite3.Row
    try:
        yield conn
    finally:
        conn.close()

def create_shorturl(short_id: str, long_url: str) -> bool:
    with get_conn() as conn:
        try:
            conn.execute(
                "INSERT INTO short_urls (short_url, long_url) VALUES (?, ?)",
                (short_id, long_url),
            )
        except sqlite3.IntegrityError:
            return False
        conn.commit()
        return True

def get_longurl(short_id: str) -> LongURLGet:
    with get_conn() as conn:
        row = conn.execute("SELECT long_url FROM short_urls WHERE short_url = ?", (short_id, )).fetchone()
        if row:
            return LongURLGet(exists=True, long_url=row['long_url'])
        else:
            return LongURLGet(exists=False)
