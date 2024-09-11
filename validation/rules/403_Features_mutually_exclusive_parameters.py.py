import jmespath
import ruamel.yaml

class Rule:
    id = "403"
    description = "Features mutually exclusive parameters"
    severity = "HIGH"


    #########################################################################################################################################
    # In UX 2.0 features, some parameters are mutually exclusive and should not be defined together.
    # This rule checks if the mutually exclusive parameters are defined in the configuration features, including:
    # - verify if same parameter is not defined as global and variable at the same time (e.g. "endpoint_ip" and "endpoint_ip_variable" are not allowed at the same time)
    # - verify if mutually exclusive parameters defined in below list are not defined together
    # For any additional parameters where the validation is required, add the mutually exclusive parameters data to the below list
    # No additional code changes should be required
    # The mutually exclusive parameters are defined in the list with the following details:
    # 1. feature_profile_type: Type of feature profile, for example transport, service, system, etc.
    # 2. feature_type: Type of feature in the feature profile, for example ipv4_trackers, ipv6_trackers, aaa, bfd, etc.
    # 3. parameter_path: Path to the Flattened data of the feature in the Data Model, where the required parameters should be defined.
    #    Define only if the parameter is not at the root level of the feature
    # 4. parameter names: The list of the parameter names which are mutually exclusive to each other (always write the global parameter name as the variable parameter "<global>_variable" is checked automatically)
    # For example, the below list will check if the parameter "endpoint_ip" and "endpoint_url" are not defined together in one tracker
    # mutually_exclusive_parameters_data = [
    #     {
    #         "feature_profile_type": "service",
    #         "feature_type": "ipv4_trackers",
    #         "parameter_path": "",
    #         "parameter_names" : ["endpoint_ip", "endpoint_url"],
    #     },
    # ]    
    
    #########################################################################################################################################

    mutually_exclusive_parameters_data = [
        {
            "feature_profile_type": "service",
            "feature_type": "ipv4_trackers",
            "parameter_path": "",
            "parameter_names" : ["endpoint_ip", "endpoint_url"],
        },
        {
            "feature_profile_type": "service",
            "feature_type": "ipv4_trackers",
            "parameter_path": "",
            "parameter_names" : ["endpoint_port", "endpoint_url"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "security",
            "parameter_path": "keys[]",
            "parameter_names": ["accept_life_time_duration", "accept_life_time_exact", "accept_life_time_infinite"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "security",
            "parameter_path": "keys[]",
            "parameter_names": ["send_life_time_duration", "send_life_time_exact", "send_life_time_infinite"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "snmp",
            "parameter_path": "",
            "parameter_names": ["communities", "groups"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "snmp",
            "parameter_path": "",
            "parameter_names": ["communities", "users"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "ipv4_trackers",
            "parameter_path": "",
            "parameter_names" : ["endpoint_ip", "endpoint_api_url", "endpoint_dns_name"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "ipv6_trackers",
            "parameter_path": "",
            "parameter_names" : ["endpoint_ip", "endpoint_api_url", "endpoint_dns_name"],
        }
    ]

    @classmethod
    def check_parameters(cls, data, path=""):
        # This function checks if the any parameter is defined as global and variable at the same time
        results = []
        if isinstance(data, dict):
            for key, value in data.items():
                new_path = f"{path}.{key}" if path else key
                if key.endswith("_variable") and key[:-9] in data:
                    results.append(f'Mutually exclusive parameters {key[:-9]} and {key} are defined in the {path}')
                results.extend(cls.check_parameters(value, new_path))
        elif isinstance(data, list):
            for index, value in enumerate(data):
                if isinstance(value, dict) or isinstance(value, ruamel.yaml.comments.CommentedMap):
                    path_extenstion = value.get("name", index)
                else:
                    path_extenstion = index
                new_path = f"{path}[{path_extenstion}]"
                results.extend(cls.check_parameters(value, new_path))
        return results


    @classmethod
    def match(cls, inventory):
        results = []
        # Loop over all parameters and report if the same parameter is defined as global and variable at the same time
        results.extend(cls.check_parameters(inventory.get("sdwan", {}).get("feature_profiles", {})))
        # Loop through the mutually exclusive parameters data
        for parameter_data in cls.mutually_exclusive_parameters_data:
            for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get(parameter_data["feature_profile_type"] + "_profiles", []):
                features = feature_profile.get(parameter_data["feature_type"], [])                
                if isinstance(features, ruamel.yaml.comments.CommentedMap):
                    features = [features]
                for feature in features:
                    # Check if the mutually exclusive parameters are defined in the feature
                    if parameter_data.get('parameter_path') == "":
                        detected_parameters = []
                        for parameter_name in parameter_data["parameter_names"]:
                            if jmespath.search(parameter_name, feature):
                                detected_parameters.append(parameter_name)
                            if jmespath.search(parameter_name + "_variable", feature) and parameter_name not in detected_parameters:
                                # If parameter is already on the list of detected parameters, do not add paramter_variable to the list as this is checked by another rule already before
                                detected_parameters.append(parameter_name + "_variable")
                            if len(detected_parameters) > 1:
                                results.append(f"Mutually exclusive parameters {detected_parameters} are defined in the sdwan.feature_profiles.{parameter_data['feature_profile_type']}_profiles[{feature_profile['name']}].{parameter_data['feature_type']}[{feature.get('name', parameter_data['feature_type'])}]")
                    else:
                        search_result = jmespath.search(parameter_data.get('parameter_path'), feature)
                        if isinstance(search_result, list):
                            for index, element in enumerate(search_result):
                                detected_parameters = []
                                for parameter_name in parameter_data["parameter_names"]:
                                    if jmespath.search(parameter_name, element):
                                        detected_parameters.append(parameter_name)
                                    if jmespath.search(parameter_name + "_variable", element) and parameter_name not in detected_parameters:
                                        # If parameter is already on the list of detected parameters, do not add paramter_variable to the list as this is checked by another rule already before
                                        detected_parameters.append(parameter_name + "_variable")
                                if len(detected_parameters) > 1:
                                    results.append(f"Mutually exclusive parameters {detected_parameters} are defined in the sdwan.feature_profiles.{parameter_data['feature_profile_type']}_profiles[{feature_profile['name']}].{parameter_data['feature_type']}[{feature.get('name', parameter_data['feature_type'][-2])}][{index}]")
        return results