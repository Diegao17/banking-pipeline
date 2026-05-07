import json

def lambda_handler(event, context):
    
    # Validar amount
    if event.get("amount", 0) <= 0:
        raise Exception("Invalid amount")

    # Country
    country = event.get("country", "")
    if len(country) != 2:
        raise Exception("Invalid country code")

    # Account
    account = event.get("account", "")
    if "-" not in account:
        raise Exception("Invalid account format")

    event["validated"] = True

    return event