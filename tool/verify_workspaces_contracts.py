"""Sprawdza zgodność metod HTTP Retrofit z trasami OpenAPI Workspaces.

Użycie:
    python3 tool/verify_workspaces_contracts.py /ścieżka/do/swagger.json

Porównanie celowo normalizuje końcowy slash, ponieważ ASP.NET Minimal APIs
publikują w Swaggerze trasę bez slash, nawet gdy grupa endpointu używa "/".
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


HTTP_METHODS = {"get", "post", "put", "patch", "delete"}
ANNOTATION = re.compile(
    r"@(GET|POST|PUT|PATCH|DELETE)\s*\(\s*['\"]([^'\"]+)['\"]\s*,?\s*\)",
    re.DOTALL,
)


def normalize(method: str, path: str) -> tuple[str, str]:
    return method.upper(), path.rstrip("/") or "/"


def swagger_routes(swagger_path: Path) -> set[tuple[str, str]]:
    document = json.loads(swagger_path.read_text(encoding="utf-8"))
    return {
        normalize(method, path)
        for path, operations in document["paths"].items()
        if operations
        for method in operations
        if method.lower() in HTTP_METHODS
    }


def retrofit_routes(data_root: Path) -> set[tuple[str, str]]:
    routes: set[tuple[str, str]] = set()
    for api_file in sorted(data_root.rglob("*_api.dart")):
        source = api_file.read_text(encoding="utf-8")
        routes.update(normalize(method, path) for method, path in ANNOTATION.findall(source))
    return routes


def main() -> int:
    if len(sys.argv) != 2:
        print(f"Użycie: {sys.argv[0]} /ścieżka/do/swagger.json", file=sys.stderr)
        return 2

    swagger = swagger_routes(Path(sys.argv[1]))
    flutter = retrofit_routes(Path(__file__).parents[1] / "lib" / "workspaces" / "data")
    missing = sorted(swagger - flutter)
    extra = sorted(flutter - swagger)

    print(f"Swagger: {len(swagger)} | Flutter: {len(flutter)}")
    print(f"Brakujące: {len(missing)} | Nadmiarowe: {len(extra)}")
    for method, path in missing:
        print(f"MISSING\t{method}\t{path}")
    for method, path in extra:
        print(f"EXTRA\t{method}\t{path}")
    return 1 if missing or extra else 0


if __name__ == "__main__":
    raise SystemExit(main())
