# Banking Transaction Processing Pipeline

This project implements a serverless data pipeline using AWS services and Infrastructure as Code (Terraform/OpenTofu). The pipeline simulates a basic anti-fraud system for banking transactions.

## Overview

The pipeline processes incoming transaction data and determines whether each transaction should be approved automatically or sent for manual review based on risk analysis.

The architecture consists of:

- 3 AWS Lambda functions
- 1 AWS Step Function with a Choice state
- 1 Amazon S3 bucket for storing results

## Workflow

1. **Validate Lambda**
   - Verifies that the input data is correct.
   - Checks that the transaction amount is greater than zero.
   - Ensures the country code has two characters.
   - Confirms the account format is valid.
   - Adds a `validated` field to the event.

2. **Risk Assessment Lambda**
   - Evaluates the risk of the transaction.
   - If the amount is greater than 10,000 or the country is not "MX", the risk is set to `high`.
   - Otherwise, the risk is `low`.
   - Adds a `risk_level` field.

3. **Choice State (Step Function)**
   - Reads the `risk_level`.
   - Routes the execution:
     - `high` → review path
     - `low` → approved path

4. **Route Lambda**
   - Stores the transaction JSON in an S3 bucket.
   - Saves under:
     - `review/` for high risk
     - `approved/` for low risk

## Example Input

```json
{
  "transaction_id": "tx-1",
  "account": "1234-5678",
  "amount": 15000,
  "country": "MX",
  "merchant": "Amazon"
}