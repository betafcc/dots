import re
from dataclasses import dataclass
from typing import Any, Callable, Iterator

import boto3


@dataclass(frozen=True)
class Secrets:
    client: Any
    name_predicate: Callable[[str], bool]

    @staticmethod
    def create():
        return Secrets(
            client=boto3.session.Session().client(
                service_name="secretsmanager",
                region_name="eu-west-1",
            ),
            name_predicate=lambda _: True,
        )

    def filter(self, name_predicate: Callable[[str], bool]):
        return Secrets(client=self.client, name_predicate=name_predicate)

    def re_filter(self, regex: str):
        compiled = re.compile(regex, flags=re.IGNORECASE)

        return Secrets(
            client=self.client, name_predicate=lambda s: bool(compiled.findall(s))
        )

    def names(self) -> Iterator[str]:
        for page in self.client.get_paginator("list_secrets").paginate():
            for secret in page["SecretList"]:
                if self.name_predicate(secret["Name"]):
                    yield secret["Name"]

    def reveal(self, name: str) -> str:
        return self.client.get_secret_value(SecretId=name)["SecretString"]

    def reveal_all(self) -> Iterator[dict[str, str]]:
        for name in self.names():
            yield {name: self.reveal(name)}

    def __iter__(self):
        yield from self.reveal_all()


if __name__ == "__main__":
    try:
        import sys

        for secret in Secrets.create().re_filter(sys.argv[-1]):
            print(secret)
    except KeyboardInterrupt:
        pass
