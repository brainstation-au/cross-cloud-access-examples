FROM --platform=amd64 python:3-slim

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /opt/app

COPY main.py .

CMD ["python3", "main.py"]
