import argparse
import os
import sys
import time
from cisco_sdwan.base.rest_api import Rest
from cisco_sdwan.tasks.implementation import TaskDetach, DetachEdgeArgs, TaskDelete, DeleteArgs
from cisco_sdwan.tasks.common import Task


def get_env_variable(var_name):
  """Retrieve environment variable or exit if not set."""
  value = os.getenv(var_name)
  if not value:
    print(f"Error: Environment variable {var_name} is not set.")
    sys.exit(1)
  return value


def detach_edges(api):
  """Detach all edges from templates."""
  print("Detaching all edges from templates...")
  task = TaskDetach()
  task_args = DetachEdgeArgs()
  task.runner(task_args, api)

  # Workaround for https://github.com/CiscoDevNet/sastre/issues/56
  for config_group in api.get("/v1/config-group/"):
    if config_group.get("solution") == "sdwan" and config_group.get("numberOfDevices") > 0:
      associated_devices = api.get(f"/v1/config-group/{config_group['id']}/device/associate")
      disassociate_devices = [{"id": device["id"]} for device in associated_devices["devices"]]
      api.delete(
        f"/v1/config-group/{config_group['id']}/device/associate",
        input_data={"devices": disassociate_devices},
      )


def remove_tags(api):
  """Remove all tags."""
  print("Removing tags...")
  tags = api.get("/v1/tags")
  for tag in tags:
    for device in tag.get("tagAssociation", []):
      payload = {
        "data": [
          {
            "objects": [{"id": device["id"], "objectType": device["objectType"]}],
            "tagId": tag["id"],
          }
        ]
      }
      api.post(payload, "/v1/tags/associate?operationType=DELETE")
    api.delete(f"/v1/tags?tagId={tag['id']}")


def deactivate_policy(api):
  """Deactivate centralized policy."""
  print("Deactivating centralized policy...")
  task = Task()
  task.policy_deactivate(api, log_context="deactivating vSmart policy")


def delete_configuration(api):
  """Delete configuration and feature profiles."""
  print("Deleting configuration...")

  # Workaround: https://github.com/CiscoDevNet/sastre/issues/57
  task = TaskDelete()
  task_args = DeleteArgs(
    tag="config_group",
    not_regex="(_basic)|(umbrellaTokenList)|(Policy_Profile_Global)|(policy_objects)|(controller_system)",
  )
  task.runner(task_args, api)

  profiles = api.get("/v1/feature-profile/sdwan")
  for profile in profiles:
    if profile["profileType"] != "policy-object" and not any(
      excluded in profile.get("profileName", "")
      for excluded in {"_basic", "umbrellaTokenList", "Policy_Profile_Global", "policy_objects"}
    ):
      api.delete(f"/v1/feature-profile/sdwan/{profile['profileType']}/{profile['profileId']}")

  # In some versions, policy-object profile cannot be removed
  # Instead, we just remove all objects under this profile
  policy_objects_profile_id = next(
    (profile["profileId"] for profile in profiles if profile["profileType"] == "policy-object"),
    None
  )
  if policy_objects_profile_id:
    policy_objects_profile = api.get(f"/v1/feature-profile/sdwan/policy-object/{policy_objects_profile_id}")
    for feature in policy_objects_profile.get("associatedProfileParcels", []):
      api.delete(
        f"/v1/feature-profile/sdwan/policy-object/{policy_objects_profile['profileId']}/{feature['parcelType']}/{feature['parcelId']}"
      )
  # End of a workaround

  # Delete remaining configurations
  task_args = DeleteArgs(
    tag="all",
    not_regex="(_basic)|(umbrellaTokenList)|(Policy_Profile_Global)|(policy_objects)|(controller_system)",
  )
  task.runner(task_args, api)


def main():
  parser = argparse.ArgumentParser(description="SD-WAN Cleanup Script")
  parser.add_argument("sdwan_url", help="SD-WAN URL")
  args = parser.parse_args()

  sdwan_url = args.sdwan_url
  sdwan_username = get_env_variable("SDWAN_USERNAME")
  sdwan_password = get_env_variable("SDWAN_PASSWORD")

  with Rest(base_url=sdwan_url, username=sdwan_username, password=sdwan_password) as api:
    detach_edges(api)

    major, minor, _ = api.server_version.split(".")
    if int(major) > 20 or (int(major) == 20 and int(minor) >= 12):
      time.sleep(5) # required as otherwise tag deletion fails
      remove_tags(api)
    else:
      print(f"Skip tag deletion for versions < 20.12.")

    deactivate_policy(api)
    delete_configuration(api)

  print(f"{sdwan_url} cleanup completed.")


if __name__ == "__main__":
  main()
