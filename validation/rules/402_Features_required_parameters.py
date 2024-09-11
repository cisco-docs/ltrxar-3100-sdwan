import jmespath
import ruamel.yaml

class Rule:
    id = "402"
    description = "Features required parameters"
    severity = "HIGH"


    #########################################################################################################################################
    # In UX 2.0 features, some parameters have no default value and are required to be set as global or as variable.
    # This rule checks if the required parameters are set in the features.
    # For any additional parameters where the validation is required, add the required parameters data to the below list
    # No additional code changes should be required
    # The required parameters are defined in the list with the following details:
    # 1. feature_profile_type: Type of feature profile, for example transport, service, system, etc.
    # 2. feature_type: Type of feature in the feature profile, for example ipv4_trackers, ipv6_trackers, aaa, bfd, etc.
    # 3. parameter_path: Path to the Flattened data of the feature in the Data Model, where the required parameters should be defined.
    #    Define only if the parameter is not at the root level of the feature
    # 4. parameter names: The list of the parameter names which are required to be set (always write the global parameter name as the variable parameter "<global>_variable" is checked automatically)
    # For example, the below list will check if the parameter 'tracker_name' or "tracker_name_variable" is defined in each service ipv4 tracker
    # required_parameters_data = [
    #     {
    #         "feature_profile_type": "service",
    #         "feature_type": "ipv4_trackers",
    #         "parameter_path": "",
    #         "parameter_names" : ["tracker_name"],
    #     },
    # ]    
    
    #########################################################################################################################################

    required_parameters_data = [
        {
            "feature_profile_type": "other",
            "feature_type": "thousandeyes",
            "parameter_path": "",
            "parameter_names" : ["account_group_token"],
        },
        {
            "feature_profile_type": "service",
            "feature_type": "ipv4_trackers",
            "parameter_path": "",
            "parameter_names" : ["tracker_name"],
        },
        {
            "feature_profile_type": "service",
            "feature_type": "object_tracker_groups",
            "parameter_path": "",
            "parameter_names" : ["id"],
        },
        {
            "feature_profile_type": "service",
            "feature_type": "object_trackers",
            "parameter_path": "",
            "parameter_names" : ["id"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "aaa",
            "parameter_path": "users[]",
            "parameter_names" : ["name", "password"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "bfd",
            "parameter_path": "colors[]",
            "parameter_names" : ["color"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "logging",
            "parameter_path": "ipv4_servers[]",
            "parameter_names" : ["hostname_ip"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "logging",
            "parameter_path": "ipv6_servers[]",
            "parameter_names" : ["hostname_ip"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "logging",
            "parameter_path": "tls_profiles[]",
            "parameter_names" : ["name"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "ntp",
            "parameter_path": "authentication_keys[]",
            "parameter_names" : ["id", "md5_value"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "ntp",
            "parameter_path": "servers[]",
            "parameter_names" : ["hostname_ip"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "security",
            "parameter_path": "",
            "parameter_names": ["integrity_types"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "security",
            "parameter_path": "keys[]",
            "parameter_names": ["key_string", "receiver_id", "send_id"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "snmp",
            "parameter_path": "communities[]",
            "parameter_names": ["authorization", "view"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "snmp",
            "parameter_path": "groups[]",
            "parameter_names": ["view"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "snmp",
            "parameter_path": "trap_target_servers[]",
            "parameter_names": ["ip", "port", "source_interface", "vpn_id"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "snmp",
            "parameter_path": "users[]",
            "parameter_names": ["group"],
        },
        {
            "feature_profile_type": "system",
            "feature_type": "snmp",
            "parameter_path": "views[].oids[]",
            "parameter_names": ["id"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "ipv4_trackers",
            "parameter_path": "",
            "parameter_names" : ["tracker_name"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "ipv6_tracker_groups",
            "parameter_path": "",
            "parameter_names" : ["tracker_name"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "ipv6_trackers",
            "parameter_path": "",
            "parameter_names" : ["tracker_name"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "wan_vpn",
            "parameter_path": "host_mappings[]",
            "parameter_names" : ["hostname", "ips"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "wan_vpn",
            "parameter_path": "ipv4_static_routes[]",
            "parameter_names" : ["network_address", "subnet_mask"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "wan_vpn",
            "parameter_path": "ipv4_static_routes[].next_hops[]",
            "parameter_names" : ["address"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "wan_vpn",
            "parameter_path": "ipv6_static_routes[]",
            "parameter_names" : ["prefix"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "wan_vpn",
            "parameter_path": "ipv6_static_routes[].next_hops[]",
            "parameter_names" : ["address"],
        },
        {
            "feature_profile_type": "transport",
            "feature_type": "wan_vpn",
            "parameter_path": "nat_64_v4_pools[]",
            "parameter_names" : ["name", "range_start", "range_end"],
        },
    ]

    @classmethod
    def match(cls, inventory):
        results = []
        # Loop through the required parameters data
        for parameter_data in cls.required_parameters_data:
            for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get(parameter_data["feature_profile_type"] + "_profiles", []):
                features = feature_profile.get(parameter_data["feature_type"], [])
                if isinstance(features, ruamel.yaml.comments.CommentedMap):
                    features = [features]
                for feature in features:
                    for parameter_name in parameter_data["parameter_names"]:
                        # Check if the parameter is defined in the feature
                        if parameter_data.get('parameter_path') == "":
                            if not jmespath.search(parameter_name, feature) and not jmespath.search(parameter_name + "_variable", feature):
                                results.append(f"Required parameter {parameter_name} or {parameter_name}_variable is not defined in the sdwan.feature_profiles.{parameter_data['feature_profile_type']}_profiles[{feature_profile['name']}].{parameter_data['feature_type']}[{feature.get('name', parameter_data['feature_type'])}]")
                        else:
                            search_result = jmespath.search(parameter_data.get('parameter_path'), feature)
                            if isinstance(search_result, list):
                                for index, element in enumerate(search_result):
                                    if not jmespath.search(parameter_name, element) and not jmespath.search(parameter_name + "_variable", element):
                                        results.append(f"Required parameter {parameter_name} or {parameter_name}_variable is not defined in the sdwan.feature_profiles.{parameter_data['feature_profile_type']}_profiles[{feature_profile['name']}].{parameter_data['feature_type']}[{feature.get('name', parameter_data['feature_type'])}].{parameter_data['parameter_path'][:-2]}[{index}]")
        return results
