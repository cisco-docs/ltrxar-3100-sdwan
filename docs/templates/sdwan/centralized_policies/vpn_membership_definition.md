# VPN Membership Definition

VPN Membership policies are used to control the distribution of routing information for specific VPNs to a list of sites.
A typical use-case is for creating guest networks that have Internet access but site-to-site communication is restricted.

{{ doc_gen }}

### Examples

Example-1: VPN Segmentation for Guest and Corporate Network Isolation

A company has multiple locations with distinct user groups, such as corporate offices and guest access points. To ensure that guest users do not have access to sensitive internal resources, the company decides to implement a VPN Membership Policy to segregate traffic. The policy will ensure that guest users can only access their designated guest VPN and are isolated from internal network resources. This segmentation improves security by limiting access to sensitive data and ensures compliance with organizational policies.

In this configuration, a VPN Membership Policy named Guest_VPN_Separation is defined under control_policy. The description clearly states that the policy is meant to isolate guest VPNs from corporate VPNs for enhanced security. Under the groups section, there are two entries: 1.	For Corporate_Offices, the vpn_lists include Corporate_VPN, meaning that only corporate VPN traffic is allowed at these sites. 2.	For Guest_Access_Points, the vpn_lists include Guest_VPN, meaning that only guest traffic is allowed at these sites.

This configuration effectively ensures that the guest network is isolated from the corporate network, providing secure traffic segmentation. It also allows network administrators to enforce strict access control policies across different user groups, ensuring both security and operational efficiency.

This YAML structure enables organizations to tailor VPN membership policies to specific site groups and VPNs, allowing for fine-grained control over network traffic distribution.

```yaml
sdwan:
  centralized_policies:
    definitions:
      control_policy:
        vpn_membership:
          - name: Guest_VPN_Separation
            description: Ensure isolation of guest VPNs from corporate VPNs
            groups:
              - site_list: Corporate_Offices
                vpn_lists:
                  - Corporate_VPN
              - site_list: Guest_Access_Points
                vpn_lists:
                  - Guest_VPN
```
