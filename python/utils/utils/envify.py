import sys
from typing import Any

import boto3
import yaml

create_client = lambda: boto3.session.Session().client(
    service_name="secretsmanager",
    region_name="eu-west-1",
)


def load(path: str) -> list[dict[str, str]]:
    with open(path) as fp:
        return yaml.safe_load(fp)["environmentVariables"]


def reveal(client: Any, vars: list[dict[str, str]]) -> list[dict[str, str]]:
    return [
        {
            "name": var["name"],
            "value": (
                var["value"]
                if "value" in var
                else client.get_secret_value(SecretId=var["secret"])["SecretString"]
            ),
        }
        for var in vars
    ]


def encode(revealed: list[dict[str, str]]) -> str:
    return "\n".join(f"{var['name']}=\"{var['value']}\"" for var in revealed)


if __name__ == "__main__":
    import sys

    _ = load(sys.argv[-1])
    _ = reveal(create_client(), _)
    _ = encode(_)
    print(_)
