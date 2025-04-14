import os
import shutil

import errorhandler
import iac_test.pabot
import pytest
import tftest
from util import render_templates


pytestmark = pytest.mark.integration
pytestmark = pytest.mark.sdwan

error_handler = errorhandler.ErrorHandler()

FILTERS_PATH = "jinja_filters/"
SDWAN_TEST_TEMPLATES_PATH = "templates/sdwan/test/"


def sdwan_render_run_tests(sdwan_url, data_paths, output_path):
    """Render SDWAN test suites and run them using iac-test"""
    error = render_templates(
        data_paths, output_path, SDWAN_TEST_TEMPLATES_PATH, filters_path=FILTERS_PATH
    )
    if error:
        pytest.fail(error)
    os.environ["SDWAN_URL"] = sdwan_url
    try:
        iac_test.pabot.run_pabot(output_path)
    except SystemExit as e:
        if e.code != 0:
            return "Robot testing failed."
    return None


def full_sdwan_terraform_test(data_paths, terraform_path, sdwan_url, version, tmpdir):
    """Deploy config to SDWAN instance using Terraform"""

    os.environ["SDWAN_URL"] = sdwan_url
    tf = tftest.TerraformTest(terraform_path)

    try:
        tf.setup(cleanup_on_exit=False, upgrade="upgrade")

        tf.apply()

        # check idempotency
        output = tf.apply()
        if "No changes. Your infrastructure matches the configuration." not in output:
            pytest.fail(output)

        # Run tests
        data_paths.append(os.path.join(terraform_path, "defaults.yaml"))
        error = sdwan_render_run_tests(
            sdwan_url, data_paths, os.path.join(tmpdir, "results/")
        )
        shutil.copy(
            os.path.join(tmpdir, "results/", "log.html"),
            "sdwan_tf_{}_log.html".format(version),
        )
        shutil.copy(
            os.path.join(tmpdir, "results/", "report.html"),
            "sdwan_tf_{}_report.html".format(version),
        )
        shutil.copy(
            os.path.join(tmpdir, "results/", "output.xml"),
            "sdwan_tf_{}_output.xml".format(version),
        )
        shutil.copy(
            os.path.join(tmpdir, "results/", "xunit.xml"),
            "sdwan_tf_{}_xunit.xml".format(version),
        )
        if error:
            pytest.fail(error)
    finally:
        try:
            tf.destroy()
        except:
            tf.destroy()
        state_path = os.path.join(terraform_path, "terraform.tfstate")
        state_backup_path = os.path.join(terraform_path, "terraform.tfstate.backup")
        if os.path.exists(state_path):
            os.remove(state_path)
        if os.path.exists(state_backup_path):
            os.remove(state_backup_path)


@pytest.mark.sdwan_209
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, sdwan_url, version",
    [
        (
            [
                "tests/integration/fixtures/sdwan/standard/",
                "tests/integration/fixtures/sdwan/standard_209/",
            ],
            "tests/integration/fixtures/sdwan/terraform_209",
            "https://10.50.202.8",
            "20.9",
        ),
    ],
)
def test_sdwan_terraform_209(data_paths, terraform_path, sdwan_url, version, tmpdir):
    full_sdwan_terraform_test(data_paths, terraform_path, sdwan_url, version, tmpdir)


@pytest.mark.sdwan_2012
@pytest.mark.terraform
@pytest.mark.parametrize(
    "data_paths, terraform_path, sdwan_url, version",
    [
        (
            [
                "tests/integration/fixtures/sdwan/standard/",
                "tests/integration/fixtures/sdwan/standard_2012/",
            ],
            "tests/integration/fixtures/sdwan/terraform_2012",
            "https://10.50.202.6",
            "20.12",
        ),
    ],
)
def test_sdwan_terraform_2012(data_paths, terraform_path, sdwan_url, version, tmpdir):
    full_sdwan_terraform_test(data_paths, terraform_path, sdwan_url, version, tmpdir)
