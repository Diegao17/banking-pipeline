import json

def lambda_handler(event, context):
    
    # Validar amount
    if event.get("amount", 0) <= 0:
        raise Exception("Invalid amount")

    # Validar country (2 letras)
    country = event.get("country", "")
    if len(country) != 2:
        raise Exception("Invalid country code")

    # Validar account (formato simple)
    account = event.get("account", "")
    if "-" not in account:
        raise Exception("Invalid account format")

    # Agregamos campo indicando que pasó validación
    event["validated"] = True

    return event