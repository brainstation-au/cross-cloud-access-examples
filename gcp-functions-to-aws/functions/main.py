import os

import requests
import boto3
import functions_framework

def get_identity_token():
    url = "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity"
    params = {
        "format": "standard",
        "audience": "aws.amazon.com"
    }
    headers = {
        "Metadata-Flavor": "Google"
    }
    return requests.get(
        url=url,
        params=params,
        headers=headers,
    ).text

def get_aws_credentials(id_token):
    client = boto3.client('sts')
    return client.assume_role_with_web_identity(
        RoleArn=os.getenv("AWS_ROLE_ARN"),
        RoleSessionName=os.getenv("AWS_ROLE_SESSION_NAME"),
        WebIdentityToken=id_token,
    ).get("Credentials")

def write_object(credentials, key, content):
    client = boto3.client(
        's3',
        aws_access_key_id=credentials.get("AccessKeyId"),
        aws_secret_access_key=credentials.get("SecretAccessKey"),
        aws_session_token=credentials.get("SessionToken"),
    )
    return client.put_object(
        Bucket=os.getenv("S3_BUCKET_NAME"),
        Key=key,
        Body=content,
    )

@functions_framework.http
def hello_http(request):
    id_token = get_identity_token()
    credentials = get_aws_credentials(id_token)
    metadata = write_object(credentials, "foo/bar/test.txt", b"Hello, World!")
    return metadata.get("ETag")
