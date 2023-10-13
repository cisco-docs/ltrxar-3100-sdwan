# VPN Membership Definition

VPN Membership policies are used to control the distribution of routing information for specific VPNs to a list of sites.
A typical use-case is for creating guest networks that have Internet access but site-to-site communication is restricted.

{{ doc_gen }}

### Examples
```yaml
sdwan:
  centralized_policies:
    definitions:
      control_policy:
        vpn_membership:
          - name: Test_vpn_mem_number1
            description: Test_vpn_mem_number1
            groups:
              - site_list: texas
                vpn_lists:
                  - datacenter
                  - branches
              - site_list: texas
                vpn_lists:
                  - retail_branches
```
