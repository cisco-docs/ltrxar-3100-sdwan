class Rule:
    id = "307"
    description = "Verify Security Policy object references"
    severity = "HIGH"
    
    # # Verify Policy Definition have the referenced policy objects available
    policy_definition_type = [
        'zone_based_firewall', 
    ]

    policy_definition_sub_branches = [
        'match_criterias', 'actions'
    ]

    policy_object_reference = {
        'source_data_prefix_lists': 'ipv4_data_prefix_lists',
        'destination_data_prefix_lists': 'ipv4_data_prefix_lists',
        'source_fqdn_lists': 'fqdn_lists',
        'destination_fqdn_lists': 'fqdn_lists',
        'local_application_list': 'local_application_lists',
        'source_zone': 'zones',
        'destination_zone': 'zones',
    }

    # Extract the Policy Object Names defined in the Policy Objects at ['sdwan']['policy_objects'][.]
    @classmethod
    def policy_objects(cls, inventory):
        results = {}
        for pot in cls.policy_object_reference:
            results[pot] = []
            try:
                for pobjs in inventory.get('sdwan', {}).get('policy_objects', {}).get(cls.policy_object_reference[pot], {}):
                    results[pot].append(pobjs['name'])
            except KeyError:
                continue
        return results

    # Create a standardized dictionary for the results
    @classmethod
    def make_dict(cls, name, rule, objtype, policy_objects_name, pdtype, obj, objname):
        result_dict = {}
        result_dict['name'] = name
        result_dict['rule'] = rule
        result_dict['type'] = objtype
        result_dict['policy_objects_name'] = policy_objects_name
        result_dict['pdtype'] = pdtype
        # result_dict['pdsubtype'] = pdsubtype
        result_dict[str(obj)] = objname
        return result_dict

    # Extract the Policy Definition Names defined in the Security Policies at the following paths
    # ['sdwan']['centralized_policies']['definitions'][.]
    @classmethod
    def definitions(cls, inventory):
        results = []
        # Loop through each of the Policy objects relevant for Security Policies
        for pot in cls.policy_object_reference:
            # Loop through each of the Policy Definition types
            for w in cls.policy_definition_type:
                # Policy objects in policy definition
                try:
                    for ds in inventory.get('sdwan', {}).get('security_policies', {}).get('definitions', {}).get(w ,{}):
                        # Policy objects under paths in policy_definition_sub_branches
                        if "rules" in ds:
                            for seq in ds['rules']:
                                for y in cls.policy_definition_sub_branches:
                                    if y in seq:                                        
                                        if pot in seq[y]:
                                            results.append(cls.make_dict(ds['name'], seq['name'], pot, cls.policy_object_reference[pot], w, pot, seq[y][pot]))
                except KeyError:
                    continue
        return results  

    # Compare the Policy objects referenced in the Security Policies at ['sdwan']['security_policies']['definitions'][.] 
    # to the Policy objects defined in the Policy Objects at ['sdwan']['policy_objects'][.] and find the missing Policy Objects
    @classmethod
    def match(cls, inventory):
        definitions = cls.definitions(inventory)
        policy_objects = cls.policy_objects(inventory)
        missing_policy_objects = []
        for x in definitions:
            if isinstance(x[str(x['type'])], list): 
                z = x[str(x['type'])]
            else: 
                z = [x[str(x['type'])]]
            for y in z:
                if y not in policy_objects[x['type']]:
                    missing_policy_objects.append(str("Missing Policy object " + str(y) + " of type " + str(cls.policy_object_reference[x['type']]) + " referenced under " + str(x['pdtype']) + " " + str(x['name'])))
        return missing_policy_objects