class Rule:
    id = "204"
    description = "Validate cisco_vpn_interface_ipsec feature templates"
    severity = "HIGH"

    # Verify that either the tunnel-source or the tunnel-source-interface is set
    @classmethod
    def verify_tunnel_source(cls, inventory):
        results = []
        if "cisco_vpn_interface_ipsec" in inventory.get('sdwan', {}).get('cedge_feature_templates', {}):
            for template in inventory['sdwan']['cedge_feature_templates']['cisco_vpn_interface_ipsec']:
                if "tunnel-source" in template['parameters'] and "tunnel-source-interface" in template['parameters']:
                    results.append("sdwan.cedge_feature_templates.cisco_vpn_interface_ipsec." + template['name'] + " - duplicate tunnel source parameters")                        
                elif "tunnel-source" in template['parameters'] or "tunnel-source-interface" in template['parameters']:
                    pass
                else:
                    results.append("sdwan.cedge_feature_templates.cisco_vpn_interface_ipsec." + template['name'] + " - missing tunnel source parameter")                        
        return results
    
    @classmethod
    def match(cls, inventory):
        results = []
        results = cls.verify_tunnel_source(inventory)
        return results
