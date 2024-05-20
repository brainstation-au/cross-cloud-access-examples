FROM --platform=amd64 python:3-slim

RUN pip install --no-cache-dir google-cloud-storage requests azure-identity

WORKDIR /opt/app

COPY main.py .

CMD ["python3", "main.py"]
