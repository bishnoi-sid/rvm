import os
import json
import logging
import requests
import argparse
import boto3

AWS_REGION = "us-east-1"  # TODO - update to your desired region
RVM_ROLE = "github-assume-role-rvm"
GITHUB_REPO = os.getenv("GITHUB_REPO")
GITHUB_ORG = os.getenv("GITHUB_ORG")
VARIABLES_OUTPUT_FILE_NAME = "zz-do-not-modify-variables-accounts.tf"
PROVIDERS_OUTPUT_FILE_NAME = "zz-do-not-modify-providers.tf"
READONLY_PROVIDERS_OUTPUT_FILE_NAME = "zz-do-not-modify-providers-readonly.tf"

if os.environ.get("GITHUB_TOKEN") is None:
    raise EnvironmentError("GITHUB_TOKEN is not set in the environment")
else:
    headers = {
        "Authorization": "Bearer " + os.getenv("GITHUB_TOKEN"),
        "Accept": "application/vnd.github+json",
    }


# def get_account_list():
#     response = requests.get(
#         f"https://api.github.com/repos/{GITHUB_ORG}/{GITHUB_REPO}/contents/accounts.json",
#         headers=headers,
#         timeout=10,
#     )
#     response = requests.get(response.json().get("download_url"), timeout=10)
#     return response.json()


def main():
    # This section was used to support an account list that is maintained in a separate repo
    # However, it is likely simpler to configure delegated Organizations permissions to list the accounts from a member acct
    # try:
    #     # Attempt to grab the account list from a repo with a JSON of the Org's accounts
    #     account_list = get_account_list()
    # except Exception:
    #     # This fallback may fail if Organizations actions are not delegated to the RVM account
    #     logging.info("Failed to get account list from GitHub, defaulting to AWS list")
    account_list = boto3.client("organizations").list_accounts()["Accounts"]

    if not account_list:
        raise Exception("No accounts found")

    for file_name in [PROVIDERS_OUTPUT_FILE_NAME, READONLY_PROVIDERS_OUTPUT_FILE_NAME]:
        with open(f"role-vending-machine/{file_name}", "w") as f:
            if file_name == READONLY_PROVIDERS_OUTPUT_FILE_NAME:
                readonly_suffix = "-readonly"
            else:
                readonly_suffix = ""
            f.write(
                f"# DO NOT EDIT! Automatically generated by scripts/generate_providers_and_account_vars.py\n"
            )
            f.write(
                f"# To Rebuild {file_name}, execute the generate_providers_and_account_vars GitHub workflow.\n\n\n"
            )

            for account in account_list:
                provider_text = 'provider "aws" {\n'
                provider_text += (
                    f'  alias  = "{account.get("Name").replace(" ","_")}"\n'
                )
                provider_text += f'  region = "{AWS_REGION}"\n'
                provider_text += "  assume_role {\n"
                provider_text += f'    role_arn = "arn:aws:iam::{account.get("Id")}:role/{RVM_ROLE}{readonly_suffix}"\n'
                provider_text += "  }\n"
                provider_text += "}"
                provider_text += "\n\n"
                f.write(provider_text)

    with open(f"role-vending-machine/{VARIABLES_OUTPUT_FILE_NAME}", "w") as f:
        f.write(
            f"# DO NOT EDIT! Automatically generated by scripts/generate_providers_and_account_vars.py\n"
        )
        f.write(
            f"# To rebuild variables-accounts.tf, execute the generate_providers_and_account_vars GitHub workflow.\n\n\n"
        )

        for account in account_list:
            variable_text = f'variable "account_{account.get("Name").replace(" ","_")}"'
            variable_text += " {\n"
            variable_text += "  type    = string\n"
            variable_text += f'  default = "{account.get("Id")}"\n'
            variable_text += "}\n\n"

            f.write(variable_text)


if __name__ == "__main__":
    # parser = argparse.ArgumentParser()
    # parser.add_argument('--path', default = "", help='Provide a filename to write out account ist too')
    # args = parser.parse_args()
    # main(args.path)
    main()
