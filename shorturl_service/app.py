from fastapi import FastAPI, HTTPException, Header, Request, Response
from db import init_db, create_shorturl, get_longurl
import schemas
import secrets, string


app = FastAPI(title="Short URL Service", version="1.0.0")

@app.on_event("startup")
def startup():
    init_db()

@app.get("/{short_id}", status_code=307)
def f1(response: Response, short_id: schemas.ShortURLPath):
    lu = get_longurl(short_id)
    if lu.exists:
        response.headers["Location"] = str(lu.long_url)
        return
    else:
        raise HTTPException(status_code=404, detail="Short URL not found")

@app.get("/stats/{short_id}", status_code=200, response_model=schemas.LongURL)
def f1(short_id: schemas.ShortURLPath):
    lu = get_longurl(short_id)
    if lu.exists:
        return schemas.LongURL(long_url=lu.long_url)
    else:
        raise HTTPException(status_code=404, detail="Short URL not found")

@app.post("/shorten", status_code=201, response_model=schemas.ShortURLCreateResponse)
def f2(request: Request, payload: schemas.ShortURLCreate):
    for i in range(100):
        short_id = ''.join(secrets.choice(string.ascii_letters + string.digits) for _ in range(12))
        if create_shorturl(short_id, str(payload.url)):
            return schemas.ShortURLCreateResponse(short_url=f'{request.url.scheme}://{request.url.netloc}/{short_id}')
        else:
            print(f"Failed to create short url with id={short_id} url={payload.url}")
    raise ValueError('retry limit reached')
