import errorhandler
import pytest
from iac_validate.validator import Validator

pytestmark = pytest.mark.integration
pytestmark = pytest.mark.validate

error_handler = errorhandler.ErrorHandler()

SCHEMA_PATH = "schemas/sdwan.yaml"
VALIDATION_RULES_PATH = "validation/rules/"


@pytest.mark.parametrize(
    "data_paths",
    [
        (
            [
                "tests/integration/fixtures/sdwan/standard/",
                "tests/integration/fixtures/sdwan/standard_209/",
            ]
        ),
        (
            [
                "tests/integration/fixtures/sdwan/standard/",
                "tests/integration/fixtures/sdwan/standard_2012/",
            ]
        )
    ],
)
def test_sdwan_validation(data_paths):
    validator = Validator(SCHEMA_PATH, VALIDATION_RULES_PATH)
    validator.validate_syntax(data_paths)
    if validator.errors:
        pytest.fail("Syntactic validation has failed.")
    validator.validate_semantics(data_paths)
    if validator.errors:
        pytest.fail("Semantic validation has failed.")
