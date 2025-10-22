class Rule:
    id = "206"
    description = "Verify Centralized Policy Definition references"
    severity = "HIGH"
    
    # # Verify Policy Definition Names referenced in the Centralized Policies


    policy_definition_type = [
        'control_policy', 'data_policy'
    ]
    policy_definition_sub_type = [
        'hub_and_spoke_topology', 'mesh_topology', 'vpn_membership', 'custom_control_topology', 'traffic_data', 'cflowd', 'application_aware_routing'
    ] 

    # Extract the Policy Name and Definition Names referenced in the Centralized Policies at ['sdwan']['centralized_policies']['feature_policies']
    @classmethod
    def feature_policies(cls, inventory):
        results = {}
        for fpds in inventory.get('sdwan', {}).get('centralized_policies', {}).get('feature_policies', {}):
            fpdsname = fpds['name']
            fpdsdict = {}
            for x in cls.policy_definition_sub_type:
                try:
                    if x in fpds:
                        fp_definitions = []
                        for pd in fpds[x]:
                            fp_definitions.append(pd['policy_definition'])
                        fpdsdict[x] = fp_definitions
                except KeyError:
                    continue
            results[fpdsname] = fpdsdict
        return results  

    # Extract the Policy Definition Names defined in the Centralized Policies at ['sdwan']['centralized_policies']['definitions'][.][.]
    @classmethod
    def definitions(cls, inventory):
        results = {}
        for w in cls.policy_definition_type:
            for x in cls.policy_definition_sub_type:
                try:
                    definitions = []
                    for ds in inventory['sdwan']['centralized_policies']['definitions'][w][x]:
                        definitions.append(ds['name'])
                        results[x] = definitions
                except KeyError:
                    continue
        return results  

    # Compare the Policy Definition Names referenced in the Centralized Policies at ['sdwan']['centralized_policies']['feature_policies'] 
    # to the Policy Definition Names defined in the Centralized Policies at ['sdwan']['centralized_policies']['definitions'][.][.]
    # and find the missing definitions
    # Compare the activated policy name at ['sdwan']['centralized_policies']['activated_policy'] 
    # to the Policy Names defined in the Centralized Policies at ['sdwan']['centralized_policies']['feature_policies']
    # and find the missing policy name
    @classmethod
    def match(cls, inventory):
        feature_policies = cls.feature_policies(inventory)
        definitions = cls.definitions(inventory)
        missing_definitions = []
        try:
            for z in feature_policies:
                for x in feature_policies[z]:
                    for y in feature_policies[z][x]:
                        if y not in definitions[x]:
                            missing_definitions.append(str("Missing " + x + " definition: '" + y + "' at ['sdwan']['centralized_policies']['definitions'][.]['"+ x + "'] referenced under ['sdwan']['centralized_policies']['feature_policies']['" + z +"']"))
        except KeyError:
            pass
        try:
            if inventory['sdwan']['centralized_policies']['activated_policy']:
                if inventory['sdwan']['centralized_policies']['activated_policy'] not in feature_policies:
                    missing_definitions.append(str("Missing feature policy: '" + inventory['sdwan']['centralized_policies']['activated_policy'] + "' at ['sdwan']['centralized_policies']['feature_policies'] referenced under ['sdwan']['centralized_policies']['activated_policy']" ))
        except KeyError:
            pass
        return missing_definitions
    