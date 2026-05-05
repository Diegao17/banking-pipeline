import json

def lambda_handler(event, context):

    amount = event.get("amount", 0)
    country = event.get("country", "")

    # Lógica simple de riesgo
    if amount > 10000 or country != "MX":
        event["risk_level"] = "high"
    else:
        event["risk_level"] = "low"

    return event