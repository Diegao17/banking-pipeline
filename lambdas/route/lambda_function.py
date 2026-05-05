import json
import boto3

s3 = boto3.client("s3")

BUCKET_NAME = "mi-bucket-pipeline-diego-12345" 

def lambda_handler(event, context):

    risk = event.get("risk_level", "low")

    if risk == "high":
        key = f"review/{event['transaction_id']}.json"
    else:
        key = f"approved/{event['transaction_id']}.json"

    # Guardar en S3
    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=key,
        Body=json.dumps(event)
    )

    event["s3_path"] = key

    return event