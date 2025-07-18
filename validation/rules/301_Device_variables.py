import re

class Rule:
    id = "301"
    description = "Verify Device Variables"
    severity = "HIGH"
    
    # Verify Device Variables
    # Get Feature Tempate Variables
    # Get Security Policy Definition Variables
    @classmethod
    def get_feature_vars(cls, key, object):
        results = []
        if isinstance(object, dict):
            for key, obj in object.items():
                explore_obj = cls.get_feature_vars(key, obj)
                for entry in explore_obj:
                    if not entry in results:
                        results.append(entry)
        elif isinstance(object, list):
            for obj in object:
                explore_obj = cls.get_feature_vars("", obj)
                for entry in explore_obj:
                    if not entry in results:
                        results.append(entry)
        elif isinstance(object, (str, int)):
            if key.endswith("_variable"):
                results.append(object)
            # Find vars in CLI templates
            elif isinstance(object, str) and "{{" in object:
                vars = re.findall(r"{{.*?}}", object)
                for var in vars:
                    var_name = re.sub(r"{{|}}|\s", "", var)
                    results.append(var_name)
        return(results)

    @classmethod
    def get_device_feature_templates_policies(cls, object, inventory='none'):
        feature_template_types_in_device_template = ["aaa_template", "banner_template", "bfd_template", "bgp_template", "cli_template", "dhcp_server_template", "ethernet_interface_templates", "global_settings_template", "ipsec_interface_templates", "logging_template", "ntp_template", "omp_template", "ospf_template", "secure_internet_gateway_template", "security_template", "sig_credentials_template", "snmp_template", "svi_interface_templates", "switchport_templates", "system_template", "thousandeyes_template", "vpn_0_template", "vpn_512_template", "vpn_service_templates", "gre_interface_templates", "cellular_interface_templates", "cellular_controller_templates", "cellular_profile_templates"]
        feature_policy_types_in_device_template = ["security_policy"]
        definitions_in_feature_policy = ["firewall_policies"]
        results = []
        if isinstance(object, dict):
            if "name" in object and "description" not in object:
                results.append(object['name'])
            for key, obj in object.items():
                if key in feature_template_types_in_device_template:
                    if isinstance(obj, str):
                        results.append(obj)
                    elif isinstance(obj, dict):
                        explore_obj = cls.get_device_feature_templates_policies(obj)
                        if isinstance(explore_obj, list):
                            for entry in explore_obj:
                                if not entry in results:
                                    results.append(entry)
                    elif isinstance(obj, list):
                        for obj_entry in obj:
                            explore_obj = cls.get_device_feature_templates_policies(obj_entry)
                            if isinstance(explore_obj, list):
                                for entry in explore_obj:
                                    if not entry in results:
                                        results.append(entry)
                elif key in feature_policy_types_in_device_template:
                    for fp in inventory.get('sdwan', {}).get('security_policies', {}).get('feature_policies', {}):
                       for key, obj in fp.items():
                            if key in definitions_in_feature_policy:
                                if isinstance(obj, str):
                                    if not obj in results:
                                        results.append(obj)
                                elif isinstance(obj, list):
                                    for obj_entry in obj:
                                        if not obj_entry in results:
                                            results.append(obj_entry)
        return(results)

    @classmethod
    def verify_device_vars(cls, inventory):
        feature_var_dict = {}
        device_template_var_dict = {}
        results = []
        # Get the list of variables per feature template
        for type in inventory.get('sdwan', {}).get('edge_feature_templates', {}):
            for template in inventory['sdwan']['edge_feature_templates'][type]:
                template_vars = cls.get_feature_vars("", template)
                feature_var_dict[template['name']] = template_vars
        # Get the list of variables per security policy definition
        for type in inventory.get('sdwan', {}).get('security_policies', {}).get('definitions', {}):
            for template in inventory['sdwan']['security_policies']['definitions'][type]:
                template_vars = cls.get_feature_vars("", template)
                feature_var_dict[template['name']] = template_vars
        # Determine the list of variables for each device template
        for deviceTemplate in inventory.get('sdwan', {}).get('edge_device_templates', {}):
            device_template_vars = []
            # Retrieve the list of feature templates in the device template
            feature_template_list = cls.get_device_feature_templates_policies(deviceTemplate, inventory)
            for feature_template in feature_template_list:
                if feature_template in feature_var_dict:
                    for var in feature_var_dict[feature_template]:
                        device_template_vars.append(var)
                else:
                    results.append("Feature template/policy not found: " + feature_template)
            device_template_var_dict[deviceTemplate['name']] = device_template_vars
        # Verify the presence of the required device variables in each site and router
        for site in inventory.get('sdwan', {}).get('sites', {}):
            for router in site['routers']:
                # Verify missing vars in the router
                if 'device_template' in router:
                    if "model" not in router:
                        results.append(router['chassis_id'] + " - missing model")
                    if router['device_template'] in device_template_var_dict:
                        for var in device_template_var_dict[router['device_template']]:
                            if var not in router['device_variables']:
                                results.append(router['chassis_id'] + " - " + router['device_template'] + " - missing variable: " + var)
                            # Verify empty vars in the router
                            elif router['device_variables'].get(var) is None or str(router['device_variables'].get(var)).strip() == '':
                                results.append(router['chassis_id'] + " - " + router['device_template'] + " - empty variable value: " + var)
                        # Verify if the router has unnecessary vars - can the severity be set to warning or minor?
                        for var in router['device_variables']:
                            if var not in device_template_var_dict[router['device_template']]:
                                results.append(router['chassis_id'] + " - " + router['device_template'] + " - unnecessary variable: " + var)
                    else:
                        results.append("Router device template not found: " + router['device_template'])
        return results

    @classmethod
    def match(cls, inventory):
        results = []
        results = cls.verify_device_vars(inventory)
        return results
