import json
import os
import requests
from azure.identity import ManagedIdentityCredential
from google.oauth2.credentials import Credentials
from google.cloud import storage


def get_azure_token(scope: str) -> str:
    credential = ManagedIdentityCredential()
    return credential.get_token(scope).token

def get_google_access_token(azure_token: str, audience: str) -> str:
    payload = {
        "audience": audience,
        "grant_type": "urn:ietf:params:oauth:grant-type:token-exchange",
        "requested_token_type": "urn:ietf:params:oauth:token-type:access_token",
        "scope": "https://www.googleapis.com/auth/cloud-platform",
        "subject_token_type": "urn:ietf:params:oauth:token-type:jwt",
        "subject_token": azure_token,
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

if __name__ == "__main__":
    audience = f"//iam.googleapis.com/{os.getenv('GCP_IDENTITY_PROVIDER')}"
    scope = f"https:{audience}"
    azure_token = get_azure_token(scope)
    google_access_token = get_google_access_token(azure_token, audience)
    write_object(
        os.getenv("GOOGLE_PROJECT_ID"),
        google_access_token,
        os.getenv("GCS_BUCKET_NAME"),
        "foo/bar/test.txt",
        "Hello, World!"
    )
