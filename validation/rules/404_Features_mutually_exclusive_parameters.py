import ruamel.yaml

class Rule:
    id = "404"
    description = "Features mutually exclusive parameters"
    severity = "HIGH"

    #########################################################################################################################################
    # In UX 2.0 features, some parameters are mutually exclusive and cannot be defined at the same time.
    # This rule checks if the mutually exclusive parameters are defined in the configuration features, including:
    # - verify if same parameter is not defined as global and variable at the same time (e.g. "endpoint_ip" and "endpoint_ip_variable" are not allowed at the same time)
    # - verify if mutually exclusive parameters defined in below list are not defined together
    # For any additional parameters where the validation is required, add the mutually exclusive parameters data to the below list
    # No additional code changes should be required
    # The mutually exclusive parameters are defined in the list with the following details:
    # path - flattened path to the location of the parameter
    # parameter_names - list of mutually exclusive parameters (use global value as variable value is automatically checked)
    #########################################################################################################################################

    mutually_exclusive_parameters_data = [
        {
            "path": "sdwan.feature_profiles.service_profiles.dhcp_servers.options",
            "parameter_names" : ["hex", "ascii", "ip_addresses"],
        },
        {
            "path": "sdwan.feature_profiles.service_profiles.ipv4_trackers",
            "parameter_names" : ["endpoint_ip", "endpoint_url"],
        },
        {
            "path": "sdwan.feature_profiles.service_profiles.ipv4_trackers",
            "parameter_names" : ["endpoint_port", "endpoint_url"],
        },
        {
            "path": "sdwan.feature_profiles.system_profiles.ipv4_device_access_policy.sequences.match_entries",
            "parameter_names": ["destination_data_prefix_list", "destination_data_prefixes"],
        },
        {
            "path": "sdwan.feature_profiles.system_profiles.ipv4_device_access_policy.sequences.match_entries",
            "parameter_names": ["source_data_prefix_list", "source_data_prefixes"],
        },
        {
            "path": "sdwan.feature_profiles.system_profiles.ipv6_device_access_policy.sequences.match_entries",
            "parameter_names": ["destination_data_prefix_list", "destination_data_prefixes"],
        },
        {
            "path": "sdwan.feature_profiles.system_profiles.ipv6_device_access_policy.sequences.match_entries",
            "parameter_names": ["source_data_prefix_list", "source_data_prefixes"],
        },
        {
            "path": "sdwan.feature_profiles.system_profiles.security.keys",
            "parameter_names": ["accept_life_time_duration", "accept_life_time_exact", "accept_life_time_infinite"],
        },
        {
            "path": "sdwan.feature_profiles.system_profiles.security.keys",
            "parameter_names": ["send_life_time_duration", "send_life_time_exact", "send_life_time_infinite"],
        },
        {
            "path": "sdwan.feature_profiles.system_profiles.snmp",
            "parameter_names": ["communities", "groups"],
        },
        {
            "path": "sdwan.feature_profiles.system_profiles.snmp",
            "parameter_names": ["communities", "users"],
        },
        {
            "path": "sdwan.feature_profiles.transport_profiles.ipv4_trackers",
            "parameter_names" : ["endpoint_ip", "endpoint_api_url", "endpoint_dns_name"],
        },
        {
            "path": "sdwan.feature_profiles.transport_profiles.ipv6_trackers",
            "parameter_names" : ["endpoint_ip", "endpoint_api_url", "endpoint_dns_name"],
        },
        {
            "path": "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces",
            "parameter_names" : ["ipv4_tracker", "ipv4_tracker_group"],
        },
        {
            "path": "sdwan.feature_profiles.transport_profiles.wan_vpn.ethernet_interfaces",
            "parameter_names" : ["ipv6_tracker", "ipv6_tracker_group"],
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
                if isinstance(value, dict) or isinstance(value, ruamel.yaml.comments.CommentedMap) and "base_action" not in value:
                    path_extenstion = value.get("name", index)
                else:
                    path_extenstion = index
                new_path = f"{path}[{path_extenstion}]"
                results.extend(cls.check_parameters(value, new_path))
        return results
    
    @classmethod
    def match_path(cls, inventory, full_path, search_path, global_parameter_names):
        results = []
        path_elements = search_path.split(".")
        inv_element = inventory
        if len(path_elements) == 1:
            # Verify if mutually exclusive parameters are defined in the path
            parameter_names = []
            for parameter_name in global_parameter_names:
                parameter_names.append(parameter_name)
                parameter_names.append(parameter_name + "_variable")
            detected_parameters = []
            for parameter_name in parameter_names:
                if parameter_name in inv_element:
                    detected_parameters.append(parameter_name)
            if len(detected_parameters) > 1:
                results.append(f"Mutually exclusive parameters {detected_parameters} are defined in the {full_path}")
        else:
            for idx, path_element in enumerate(path_elements):
                if isinstance(inv_element, dict) and idx + 1 == len(path_elements):
                    # Verify if mutually exclusive parameters are defined in the path
                    parameter_names = []
                    for parameter_name in global_parameter_names:
                        parameter_names.append(parameter_name)
                        parameter_names.append(parameter_name + "_variable")
                    detected_parameters = []
                    for parameter_name in parameter_names:
                        if parameter_name in inv_element:
                            detected_parameters.append(parameter_name)
                    if len(detected_parameters) > 1:
                        results.append(f"Mutually exclusive parameters {detected_parameters} are defined in the {full_path}")      
                if isinstance(inv_element, dict):
                    inv_element = inv_element.get(path_element)
                    full_path += path_element if not full_path else "." + path_element
                elif isinstance(inv_element, list):
                    for idx2, i in enumerate(inv_element):
                        r = cls.match_path(i, full_path + f"[{i['name']}]" if isinstance(i, dict) and "name" in i and "base_action" not in i else full_path + f"[{idx2}]", ".".join(path_elements[idx:]), global_parameter_names)
                        results.extend(r)
                    return results
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        # Loop over all parameters and report if the same parameter is defined as global and variable at the same time
        results.extend(cls.check_parameters(inventory.get("sdwan", {}).get("feature_profiles", {})))
        # Loop through the mutually exclusive parameters data
        for mutually_exclusive_parameters in cls.mutually_exclusive_parameters_data:
            path = mutually_exclusive_parameters.get('path') + '.'
            parameter_names = mutually_exclusive_parameters.get('parameter_names')
            results.extend(cls.match_path(inventory, '', path, parameter_names))
        return results