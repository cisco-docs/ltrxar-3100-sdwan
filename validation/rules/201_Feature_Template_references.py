class Rule:
    id = "201"
    description = "Verify Feature Template references"
    severity = "HIGH"

    paths = []
    # Verify Feature Template Names referenced in the Device Templates
    feature_template_types = ["aaa_templates", "banner_templates", "bfd_templates", "bgp_templates", "cli_templates", "dhcp_server_templates", "ethernet_interface_templates", "global_settings_templates", "ipsec_interface_templates", "logging_templates", "ntp_templates", "omp_templates", "ospf_templates", "secure_internet_gateway_templates", "security_templates", "sig_credentials_templates", "snmp_templates", "svi_interface_templates", "switchport_templates", "system_templates", "thousandeyes_templates", "vpn_templates"]
    for type in feature_template_types:
        paths.append({
            "key": str("sdwan.edge_feature_templates." + type + ".name"),
            "references": [
                str("device_templates.feature_templates." + type)
            ]
        })

    @classmethod
    def build_device_template_dict(cls, inventory):
        # Build the dictionary of per-type feature templates in the device templates
        device_template_dict = {
            "device_templates": []
        }
        for device_template in inventory.get('sdwan', {}).get('cedge_device_templates', {}).get('device_template', {}):
            device_template_features = {}
            for feature_template in device_template['parameters']['feature_templates']:
                if not feature_template['templateType'] in device_template_features:
                    device_template_features[feature_template['templateType']] = []
                device_template_features[feature_template['templateType']].append(feature_template['templateName'])
                if 'subTemplates' in feature_template:
                    for subtemplate in feature_template['subTemplates']:
                        if not subtemplate['templateType'] in device_template_features:
                            device_template_features[subtemplate['templateType']] = []
                        device_template_features[subtemplate['templateType']].append(subtemplate['templateName'])
            device_template_dict['device_templates'].append({
                "name": device_template['name'],
                "feature_templates": device_template_features
                })
        return device_template_dict

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
        device_template_dict = cls.build_device_template_dict(inventory)
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
                r = cls.match_path(device_template_dict, ref, ref, keys)
                results.extend(r)
        return results