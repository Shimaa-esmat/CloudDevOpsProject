FROM python:3.11-slim-bookworm

WORKDIR /app


RUN apt-get update && apt-get upgrade -y && apt-get clean


RUN pip install --upgrade pip setuptools wheel


COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY . .

EXPOSE 5000
CMD ["python", "app.py"]

