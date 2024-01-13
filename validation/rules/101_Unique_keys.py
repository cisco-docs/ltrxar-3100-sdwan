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
        "sdwan.cedge_device_templates.device_template.name",
        "sdwan.localized_policies.policies.feature.name",
        "sdwan.centralized_policies.feature_policies.name",
        "sdwan.centralized_policies.definitions.control_policy.hub_and_spoke_topology.name",
        "sdwan.centralized_policies.definitions.control_policy.mesh_topology.name",
        "sdwan.centralized_policies.definitions.control_policy.vpn_membership.name",
        "sdwan.centralized_policies.definitions.control_policy.custom_control_topology.name",
        "sdwan.centralized_policies.definitions.data_policy.traffic_data.name",
        "sdwan.centralized_policies.definitions.data_policy.cflowd.name",
        "sdwan.centralized_policies.definitions.data_policy.application_aware_routing.name",
    ]

    # Verify unique feature template names per type
    feature_template_types = ["cedge_aaa", "cedge_global", "cisco_banner", "cisco_bfd", "cisco_logging", "cisco_ntp", "cisco_omp", "cisco_security", "cisco_snmp", "cisco_system", "cisco_vpn", "cli-template"]
    for type in feature_template_types:
        paths.append(str("sdwan.cedge_feature_templates." + type + ".name"))
    
    # Verify unique policy list names per type
    localPolicyListTypes = ['asPath', 'class', 'community', 'dataPrefix', 'expandedCommunity', 'extCommunity', 'fqdn', 'ipssignature', 'localapp', 'localdomain', 'mirror', 'policer', 'prefix', 'tgapikey', 'umbrelladata', 'urlblacklist', 'urlwhitelist', 'vpn', 'zone']
    for type in localPolicyListTypes:
        paths.append(str("sdwan.localized_policies.lists." + type + ".name"))

    # Verify unique policy definition names per type
    localPolicyDefinitionTypes = ['acl', 'advancedMalwareProtection', 'deviceAccessPolicy', 'dnssecurity', 'intrusionprevention', 'qosMap', 'rewriteRule', 'ssldecryption', 'sslutdprofile', 'vedgeRoute', 'urlfiltering', 'zonebasedfw']
    for type in localPolicyDefinitionTypes:
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
