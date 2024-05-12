import json
import os
import urllib

import requests
import boto3

from botocore.auth import SigV4Auth
from botocore.awsrequest import AWSRequest
from google.cloud import storage
from google.oauth2.credentials import Credentials


def get_access_token(google_identity_provider: str) -> dict:
    audience = f"//iam.googleapis.com/{google_identity_provider}"
    aws_request = AWSRequest(
        method="POST",
        url="https://sts.amazonaws.com/?Action=GetCallerIdentity&Version=2011-06-15",
        headers={
            "Host": "sts.amazonaws.com",
            "x-goog-cloud-target-resource": audience,
        },
    )

    SigV4Auth(boto3.Session().get_credentials(), "sts", "us-east-1").add_auth(aws_request)
    token = {"url": aws_request.url, "method": aws_request.method, "headers": []}
    for key, value in aws_request.headers.items():
        token["headers"].append({"key": key, "value": value})

    payload = {
        "audience": audience,
        "grant_type": "urn:ietf:params:oauth:grant-type:token-exchange",
        "requested_token_type": "urn:ietf:params:oauth:token-type:access_token",
        "scope": "https://www.googleapis.com/auth/cloud-platform",
        "subject_token_type": "urn:ietf:params:aws:token-type:aws4_request",
        "subject_token": urllib.parse.quote(json.dumps(token)),
    }
    response = requests.post(url="https://sts.googleapis.com/v1/token", data=json.dumps(payload))
    return response.json().get("access_token")

def write_object(project_id: str, access_token: str, bucket_name: str, object_name: str, data: str) -> None:
    storage_client = storage.Client(
        project=project_id,
        credentials=Credentials(access_token),
    )
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(object_name)
    blob.upload_from_string(data)

def handler(event, context) -> None:
    google_identity_provider = os.getenv("GOOGLE_IDENTITY_PROVIDER")
    access_token = get_access_token(google_identity_provider)

    google_project_id = os.getenv("GOOGLE_PROJECT_ID")
    bucket_name = os.getenv("GCS_BUCKET_NAME")
    write_object(google_project_id, access_token, bucket_name, "foo/bar/test.txt", "Hello, World!")
