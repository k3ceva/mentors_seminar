FROM python:3.14-alpine

WORKDIR /app
COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .

VOLUME [ "/app/data" ]

ENV DB_PATH=/app/data/shorturl.db

CMD [ "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80" ] 
