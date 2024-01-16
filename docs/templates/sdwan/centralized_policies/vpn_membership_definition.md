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
          - name: VPN_DEFINITION_TEST1
            description: VPN_DEFINITION_TEST1
            groups:
              - site_list: DELHI-VPNM-TEST
                vpn_lists:
                  - VPN-LIST-VPNM-TEST1
                  - VPN-LIST-VPNM-TEST2
              - site_list: MUMBAI-VPNM-TEST
                vpn_lists:
                  - VPN-LIST-VPNM-TEST3
```
