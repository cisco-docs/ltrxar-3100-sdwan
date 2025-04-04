# Traffic Data - Service Chaining Definition

Service Chaining Definition define the matching conditions and Actions to configure Service Chaining. Example usage is traffic between branch sides is force via FW that is connected to hub or regional firewall. It requires that service chaining is defined in respective VPN template for device that connect to external entity (firewall or IDS). 

{{ doc_gen }}

### Examples
 
Example-1: A simple data policy that matches all traffic from VPN 20 and forces it via FW service insertion.
```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        traffic_data:
          - name: NAC-DATA-POLICY-BRANCH-VPN20-v1
            description: Data policy for branch VPN 20
            default_action_type: accept
            sequences:
              - base_action: accept
                id: 11
                name: Default
                ip_type: ipv4
                type: service_chaining
                actions:
                  counter_name: ServiceInsertion
                  service:
                    type: FW
                    vpn: 20
```
