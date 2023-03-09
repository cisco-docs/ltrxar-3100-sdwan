class Rule:
    id = "203"
    description = "Verify AAA server groups"
    severity = "HIGH"

    # Verify AAA server groups referenced in the server-auth-order field


    @classmethod
    def verify_aaa_groups(cls, inventory):
        server_groups = ['local']
        results = []
        for template in inventory['sdwan']['cedge_feature_templates']['cedge_aaa']:
            if "radius" in template['parameters']:
                for group in template['parameters']['radius']:
                    server_groups.append(group['group-name'])
            if "tacacs" in template['parameters']:
                for group in template['parameters']['tacacs']:
                    server_groups.append(group['group-name'])
            server_auth_group_list = template['parameters']['server-auth-order'].split(",")
            for group in server_auth_group_list:
                if group not in server_groups:
                    results.append("sdwan.cedge_feature_templates.cedge_aaa." + template['name'] + " - " + str(group))
        return results
    
    @classmethod
    def match(cls, inventory):
        results = []
        results = cls.verify_aaa_groups(inventory)
        return results
