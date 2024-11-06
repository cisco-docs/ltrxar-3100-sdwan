class Rule:
    id = "408"
    description = "Validate snmp configuration feature"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("system_profiles", []):
            snmp_feature = feature_profile.get("snmp", {})
            if snmp_feature:
                view_names = [view["name"] for view in snmp_feature.get("views", [])]
                for index, community in enumerate(snmp_feature.get("communities", [])):
                    if community["view"] not in view_names:
                        results.append(f"View {community['view']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.communities[{index}]")
                group_names = [group["name"] for group in snmp_feature.get("groups", [])]
                for index, group in enumerate(snmp_feature.get("groups", [])):
                    if group["view"] not in view_names:
                        results.append(f"View {group['view']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.groups[{group['name']}]")
                for index, user in enumerate(snmp_feature.get("users", [])):
                    if user["group"] not in group_names:
                        results.append(f"Group {user['group']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.users[{user['name']}]")
                user_names = [user["name"] for user in snmp_feature.get("users", [])]
                user_labels = [community["user_label"] for community in snmp_feature.get("communities", [])]
                for index, trap_server in enumerate(snmp_feature.get("trap_target_servers", [])):
                    if "user" in trap_server.keys() and "user_label" in trap_server.keys():
                        results.append(f"Both user and user_label are defined in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.trap_target_servers[{index}]")
                    elif "user" in trap_server.keys():
                        if trap_server["user"] not in user_names:
                            results.append(f"User {trap_server['user']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.trap_target_servers[{index}]")
                    elif "user_label" in trap_server.keys():
                        if trap_server["user_label"] not in user_labels:
                            results.append(f"User label {trap_server['user_label']} is not defined, but is referenced in the sdwan.feature_profiles.system_profiles[{feature_profile['name']}].snmp.trap_target_servers[{index}]")
        return results
