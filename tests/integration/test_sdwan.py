import os

import errorhandler
import pytest
import tftest

pytestmark = pytest.mark.integration
pytestmark = pytest.mark.sdwan

error_handler = errorhandler.ErrorHandler()


def full_sdwan_terraform_test(terraform_path, sdwan_url):
    """Deploy config to SDWAN instance using Terraform"""

    os.environ["SDWAN_URL"] = sdwan_url

    try:
        tf = tftest.TerraformTest(terraform_path)
        tf.setup(cleanup_on_exit=False, upgrade="upgrade")

        tf.apply()

        # check idempotency
        output = tf.apply()
        if "No changes. Your infrastructure matches the configuration." not in output:
            pytest.fail(output)

        try:
            tf.destroy()
        except:
            tf.destroy()
    except Exception as e:
        # if something failed try another destroy
        try:
            tf.destroy()
        except:
            pass
        raise e
    finally:
        pass
        state_path = os.path.join(terraform_path, "terraform.tfstate")
        state_backup_path = os.path.join(terraform_path, "terraform.tfstate.backup")
        if os.path.exists(state_path):
            os.remove(state_path)
        if os.path.exists(state_backup_path):
            os.remove(state_backup_path)


@pytest.mark.sdwan_209
@pytest.mark.terraform
@pytest.mark.parametrize(
    "terraform_path, sdwan_url",
    [
        (
            "tests/integration/fixtures/sdwan/terraform_209",
            "https://10.50.221.225",
        ),
    ],
)
def test_sdwan_terraform_209(terraform_path, sdwan_url):
    full_sdwan_terraform_test(terraform_path, sdwan_url)
