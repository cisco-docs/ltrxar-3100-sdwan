class Rule:
    id = "101"
    description = "Verify unique keys"
    severity = "HIGH"

    # Verify unique keys in the following fields:
    # - Site Ids
    # - Device Template Names
    # - Localized Policy Template Names
    # - Centralized Policy definition Names
    paths = [
        "sdwan.sites.id",
        "sdwan.edge_device_templates.name",
        "sdwan.localized_policies.feature_policies.name",
        "sdwan.centralized_policies.feature_policies.name",
        "sdwan.centralized_policies.definitions.control_policy.hub_and_spoke_topology.name",
        "sdwan.centralized_policies.definitions.control_policy.mesh_topology.name",
        "sdwan.centralized_policies.definitions.control_policy.vpn_membership.name",
        "sdwan.centralized_policies.definitions.control_policy.custom_control_topology.name",
        "sdwan.centralized_policies.definitions.data_policy.traffic_data.name",
        "sdwan.centralized_policies.definitions.data_policy.cflowd.name",
        "sdwan.centralized_policies.definitions.data_policy.application_aware_routing.name",
        "sdwan.security_policies.feature_policies.name",
        "sdwan.security_policies.definitions.zone_based_firewall.name",
        "sdwan.security_policies.definitions.intrusion_prevention.name",
    ]

    # Verify unique feature template names per type
    feature_template_types = ["aaa_templates", "banner_templates", "bfd_templates", "bgp_templates", "cli_templates", "dhcp_server_templates", "ethernet_interface_templates", "global_settings_templates", "ipsec_interface_templates", "logging_templates", "ntp_templates", "omp_templates", "ospf_templates", "secure_internet_gateway_templates", "security_templates", "sig_credentials_templates", "snmp_templates", "svi_interface_templates", "switchport_templates", "system_templates", "thousandeyes_templates", "vpn_templates"]
    for type in feature_template_types:
        paths.append(str("sdwan.edge_feature_templates." + type + ".name"))
    
    # Verify unique policy objects names per type
    policy_object_types = ['app_probe_classes', 'application_lists', 'as_path_lists', 'class_maps', 'color_lists', 'expanded_community_lists', 'extended_community_lists', 'ipv4_data_prefix_lists', 'ipv4_prefix_lists', 'ipv6_data_prefix_lists', 'ipv6_prefix_lists', 'mirror_lists', 'policers', 'preferred_color_groups', 'region_lists', 'site_lists', 'sla_classes', 'standard_community_lists', 'tloc_lists', 'vpn_lists', 'fqdn_lists', 'zones', 'local_application_lists']
    for type in policy_object_types:
        paths.append(str("sdwan.policy_objects." + type + ".name"))

    # Verify unique policy definition names per type
    localized_policy_definition_types = ['ipv4_access_control_lists', 'ipv4_device_access_policies', 'ipv6_access_control_lists', 'ipv6_device_access_policies', 'rewrite_rules', 'route_policies', 'qos_maps']
    for type in localized_policy_definition_types:
        paths.append(str("sdwan.localized_policies.definitions." + type + ".name"))

    @classmethod
    def match_path(cls, inventory, full_path, search_path):
        results = []
        path_elements = search_path.split(".")
        inv_element = inventory
        for idx, path_element in enumerate(path_elements[:-1]):
            if isinstance(inv_element, dict):
                inv_element = inv_element.get(path_element)
            elif isinstance(inv_element, list):
                for i in inv_element:
                    r = cls.match_path(i, full_path, ".".join(path_elements[idx:]))
                    results.extend(r)
                return results
            if inv_element is None:
                return results
        values = []
        if isinstance(inv_element, list):
            for i in inv_element:
                if not isinstance(i, dict):
                    continue
                value = i.get(path_elements[-1])
                if isinstance(value, list):
                    values = []
                    for v in value:
                        if v not in values:
                            values.append(v)
                        else:
                            results.append(full_path + " - " + str(v))
                elif value:
                    if value not in values:
                        values.append(value)
                    else:
                        results.append(full_path + " - " + str(value))
        elif isinstance(inv_element, dict):
            list_element = inv_element.get(path_elements[-1])
            if isinstance(list_element, list):
                for value in list_element:
                    if value:
                        if value not in values:
                            values.append(value)
                        else:
                            results.append(full_path + " - " + str(value))
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        for path in cls.paths:
            r = cls.match_path(inventory, path, path)
            results.extend(r)
        return results