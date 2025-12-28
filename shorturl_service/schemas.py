from pydantic import BaseModel, Field, HttpUrl
from typing import Annotated, Optional

class ShortURLCreate(BaseModel):
    url: HttpUrl

class ShortURLCreateResponse(BaseModel):
    short_url: HttpUrl

class LongURL(BaseModel):
    long_url: HttpUrl

class LongURLGet(BaseModel):
    long_url: Optional[HttpUrl] = None
    exists: bool

ShortURLPath = Annotated[str, Field(min_length=12, max_length=12, pattern="^[A-z0-9]{12}$")]

