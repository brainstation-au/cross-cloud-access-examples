import os

from google.auth import aws
from google.cloud import storage


def get_credentials(google_identity_provider: str) -> aws.Credentials:
    config = {
        "type": "external_account",
        "audience": f"//iam.googleapis.com/{google_identity_provider}",
        "subject_token_type": "urn:ietf:params:aws:token-type:aws4_request",
        "token_url": "https://sts.googleapis.com/v1/token",
        "credential_source": {
            "environment_id": "aws1",
            "region_url": "http://169.254.169.254/latest/meta-data/placement/availability-zone",
            "url": "http://169.254.169.254/latest/meta-data/iam/security-credentials",
            "regional_cred_verification_url": "https://sts.{region}.amazonaws.com?Action=GetCallerIdentity&Version=2011-06-15"
        }
    }
    credentials = aws.Credentials.from_info(config)
    return credentials.with_scopes(["https://www.googleapis.com/auth/cloud-platform"])

def write_object(project_id: str, credentials: aws.Credentials, bucket_name: str, object_name: str, data: str) -> None:
    storage_client = storage.Client(
        project=project_id,
        credentials=credentials,
    )
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(object_name)
    blob.upload_from_string(data)

def handler(event, context) -> None:
    google_identity_provider = os.getenv("GOOGLE_IDENTITY_PROVIDER")
    credentials = get_credentials(google_identity_provider)
    google_project_id = os.getenv("GOOGLE_PROJECT_ID")
    bucket_name = os.getenv("GCS_BUCKET_NAME")
    write_object(
        project_id=google_project_id,
        credentials=credentials,
        bucket_name=bucket_name,
        object_name="foo/bar/test.txt",
        data="Hello, World!"
    )
