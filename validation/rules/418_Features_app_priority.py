class Rule:
    id = "418"
    description = "Validate application priority profile features"
    severity = "HIGH"

    @classmethod
    def match(cls, inventory):
        results = []
        # Create dict with forwarding class name as key and queue as value
        forwarding_classes = {fc["name"]: fc["queue"] for fc in inventory.get("sdwan", {}).get("feature_profiles", {}).get("policy_object_profile", {}).get("forwarding_classes", [])}
        for feature_profile in inventory.get("sdwan", {}).get("feature_profiles", {}).get("application_priority_profiles", []):
            for qos_policy in feature_profile.get("qos_policies", []):
                # Get queue numbers for all forwarding classes used in this QoS policy
                used_queues = {}
                bandwidth_sum = 0
                for index, scheduler in enumerate(qos_policy.get("qos_schedulers", [])):
                    fc_name = scheduler.get("forwarding_class")
                    queue = forwarding_classes.get(fc_name)
                    bandwidth_sum += scheduler.get("bandwidth_percent", 0)
                    if fc_name in forwarding_classes:
                        used_queues.setdefault(queue, []).append(fc_name)
                    if queue == 0:
                        # queue 0 can only use drops type tail-drop
                        if scheduler.get("drops") != "tail-drop":
                            results.append(f"Forwarding class {fc_name} uses queue 0 but drops type is not tail-drop in the sdwan.feature_profiles.application_priority_profiles[{feature_profile['name']}].qos_policies[{qos_policy['name']}].qos_schedulers[{index}]")
                # Check if any queue number is used by more than one forwarding class
                for queue, classes in used_queues.items():
                    if len(classes) > 1:
                        results.append(f"Forwarding classes {classes} share the same queue number in the sdwan.feature_profiles.application_priority_profiles[{feature_profile['name']}].qos_policies[{qos_policy['name']}].qos_schedulers")
                if bandwidth_sum != 100:
                    results.append(f"The sum of bandwidth_percent for all qos_schedulers must equal 100, but it is {bandwidth_sum} in the sdwan.feature_profiles.application_priority_profiles[{feature_profile['name']}].qos_policies[{qos_policy['name']}].qos_schedulers")
        return results
