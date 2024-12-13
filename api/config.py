import json
import boto3
from botocore.exceptions import ClientError
from fastapi import HTTPException

class SecretsManager:
    def __init__(self, secret_name: str = "my-super-jwt-secret-api-key", region_name: str = "us-east-1"):
        self.secret_name = secret_name
        self.region_name = region_name
        try:
            self.session = boto3.session.Session()
            self.client = self.session.client(
                service_name='secretsmanager',
                region_name=region_name
            )
            print(f"SecretsManager initialized with secret name: {self.secret_name}")
        except Exception as e:
            print(f"Error initializing SecretsManager: {e}")
            raise

    def get_secret(self) -> dict:
        try:
            print(f"Attempting to get secret: {self.secret_name}")
            get_secret_value_response = self.client.get_secret_value(
                SecretId=self.secret_name
            )
            if 'SecretString' in get_secret_value_response:
                return json.loads(get_secret_value_response['SecretString'])
            raise ValueError("No SecretString found in response")
        except ClientError as e:
            print(f"Error fetching secret: {e}")
            raise
        except json.JSONDecodeError as e:
            print(f"Error decoding secret JSON: {e}")
            raise
        except Exception as e:
            print(f"Unexpected error: {e}")
            raise
