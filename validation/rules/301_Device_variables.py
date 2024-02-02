import re

class Rule:
    id = "301"
    description = "Verify Device Variables"
    severity = "HIGH"

    @classmethod
    def get_feature_template_vars(cls, key, object):
        results = []
        if isinstance(object, dict):
            for key, obj in object.items():
                explore_obj = cls.get_feature_template_vars(key, obj)
                for entry in explore_obj:
                    if not entry in results:
                        results.append(entry)
        elif isinstance(object, list):
            for obj in object:
                explore_obj = cls.get_feature_template_vars("", obj)
                for entry in explore_obj:
                    if not entry in results:
                        results.append(entry)
        elif isinstance(object, (str, int)):
            if key.endswith("_variable"):
                results.append(object)
            # Find vars in CLI templates
            elif isinstance(object, str) and "{{" in object:
                vars = re.findall(r'{{.*?}}', object)
                for var in vars:
                    var_name = re.sub("{{|}}|\s", "", var)
                    results.append(var_name)
        return(results)

    @classmethod
    def get_device_feature_templates(cls, object):
        feature_template_types_in_device_template = ["aaa_template", "banner_template", "bfd_template", "bgp_template", "cli_template", "dhcp_server_template", "ethernet_interface_templates", "global_settings_template", "ipsec_interface_templates", "logging_template", "ntp_template", "omp_template", "ospf_template", "secure_internet_gateway_template", "security_template", "sig_credentials_template", "snmp_template", "svi_interface_templates", "switchport_templates", "system_template", "thousandeyes_template", "vpn_0_template", "vpn_512_template", "vpn_service_templates"]
        results = []
        if isinstance(object, dict):
            if "name" in object and "description" not in object:
                results.append(object['name'])
            for key, obj in object.items():
                if key in feature_template_types_in_device_template:
                    if isinstance(obj, str):
                        results.append(obj)
                    elif isinstance(obj, dict):
                        explore_obj = cls.get_device_feature_templates(obj)
                        if isinstance(explore_obj, list):
                            for entry in explore_obj:
                                if not entry in results:
                                    results.append(entry)
                    elif isinstance(obj, list):
                        for obj_entry in obj:
                            explore_obj = cls.get_device_feature_templates(obj_entry)
                            if isinstance(explore_obj, list):
                                for entry in explore_obj:
                                    if not entry in results:
                                        results.append(entry)

        return(results)

    @classmethod
    def verify_device_vars(cls, inventory):
        feature_template_var_dict = {}
        device_template_var_dict = {}
        results = []
        # Get the list of variables per feature template
        for type in inventory.get('sdwan', {}).get('edge_feature_templates', {}):
            for template in inventory['sdwan']['edge_feature_templates'][type]:
                template_vars = cls.get_feature_template_vars("", template)
                feature_template_var_dict[template['name']] = template_vars
        # Determine the list of variables for each device template
        for deviceTemplate in inventory.get('sdwan', {}).get('edge_device_templates', {}):
            device_template_vars = []
            # Retrieve the list of feature templates in the device template
            feature_template_list = cls.get_device_feature_templates(deviceTemplate)
            for feature_template in feature_template_list:
                if feature_template in feature_template_var_dict:
                    for var in feature_template_var_dict[feature_template]:
                        device_template_vars.append(var)
                else:
                    results.append("Feature template not found: " + feature_template)
            device_template_var_dict[deviceTemplate['name']] = device_template_vars
        # Verify the presence of the required device variables in each site and router
        for site in inventory.get('sdwan', {}).get('sites', {}):
            for router in site['routers']:
                # Verify missing vars in the router
                if router['device_template'] in device_template_var_dict:
                    for var in device_template_var_dict[router['device_template']]:
                        if var not in router['device_variables']:
                            results.append(router['chassis_id'] + " - " + router['device_template'] + " - missing variable: " + var)
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