class Rule:
    id = "205"
    description = "Verify Localized Policy Definition references"
    severity = "HIGH"

    paths = []
    # Verify Policy Definition Names referenced in the Localized Policies
    localized_policy_definition_types = ['ipv4_access_control_lists', 'ipv4_device_access_policies', 'ipv6_access_control_lists', 'ipv6_device_access_policies', 'rewrite_rules', 'route_policies', 'qos_maps']
    for type in localized_policy_definition_types:
        paths.append({
            "key": str("sdwan.localized_policies.definitions." + type + ".name"),
            "references": [
                str("policy_templates.policy_definitions." + type)
            ]
        })

    @classmethod
    def build_policy_feature_dict(cls, inventory):
        # Build the dictionary of per-type policy definitions in the localized policies
        policy_template_dict = {
            "policy_templates": []
        }
        for policy_template in inventory.get('sdwan', {}).get('localized_policies', {}).get('feature_policies', {}):
            policy_template_definitions = {}
            if "definitions" in policy_template:
                for policy_definition_type, policy_definition_names in policy_template['definitions'].items():
                    if not policy_definition_type in policy_template_definitions:
                        policy_template_definitions[policy_definition_type] = []
                    for policy_definition_name in policy_definition_names:
                        policy_template_definitions[policy_definition_type].append(policy_definition_name)
            policy_template_dict['policy_templates'].append({
                "name": policy_template['name'],
                "policy_definitions": policy_template_definitions
                })
        return policy_template_dict

    @classmethod
    def match_path(cls, inventory, full_path, search_path, targets):
        results = []
        path_elements = search_path.split(".")
        inv_element = inventory
        for idx, path_element in enumerate(path_elements):
            if isinstance(inv_element, dict):
                inv_element = inv_element.get(path_element)
            elif isinstance(inv_element, list):
                for i in inv_element:
                    r = cls.match_path(
                        i, full_path, ".".join(path_elements[idx:]), targets
                    )
                    results.extend(r)
                return results
            if inv_element is None:
                return results
        if isinstance(inv_element, list):
            for e in inv_element:
                if str(e) not in targets:
                    results.append(full_path + " - " + str(e))
        elif str(inv_element) not in targets:
            results.append(full_path + " - " + str(inv_element))
        return results

    @classmethod
    def match(cls, inventory):
        policy_template_dict = cls.build_policy_feature_dict(inventory)
        results = []
        for path in cls.paths:
            key_elements = path["key"].split(".")
            try:
                element = inventory
                for k in key_elements[:-1]:
                    element = element[k]
                keys = [str(obj.get(key_elements[-1])) for obj in element]
            except KeyError:
                continue
            for ref in path["references"]:
                r = cls.match_path(policy_template_dict, ref, ref, keys)
                results.extend(r)
        return results
