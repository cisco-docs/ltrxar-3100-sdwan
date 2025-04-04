# AAA Feature Template

Specify the authentication method and order and configure Radius, TACACs, or local authentication, including local user groups with different read/write permissions.

{{ doc_gen }}

### Examples

Example-1: Centralized AAA Policy Enforcement for Secure SD-WAN Edge Access

A large enterprise with multiple branch offices connected via Cisco SD-WAN is looking to standardize and secure administrative access across all its edge routers. To achieve this, they deploy a centralized AAA (Authentication, Authorization, and Accounting) configuration template using Netascode. The AAA template enables consistent user authentication via TACACS+ server groups, sets up RADIUS for accounting, and defines authorization rules for command execution with privilege-level enforcement. A set of local fallback users with encrypted passwords and SSH keys is also configured for redundancy. This setup ensures secure, traceable, and policy-driven access to all network devices, enhancing operational efficiency and compliance.

```yaml
sdwan:
  edge_feature_templates:
    aaa_templates:
      - name: FT-CEDGE-AAA-01
        description: AAA Template for centralized admin access control
        authentication_and_authorization_order:
          - tacacs+
          - local
        tacacs_server_groups:
          - name: TACACS-GRP-01
            vpn_id: 0
            servers:
              - address: 192.168.10.10
                port: 49
                key: $CRYPT_CLUSTER$ENCRYPTED_TACACS_KEY
                secret_key: tacacssecret
              - address: 192.168.10.11
                port: 49
                key: $CRYPT_CLUSTER$ENCRYPTED_TACACS_KEY2
                secret_key: tacacssecret2
        radius_server_groups:
          - name: RADIUS-GRP-01
            vpn_id: 0
            servers:
              - address: 192.168.20.20
                authentication_port: 1812
                accounting_port: 1813
                key: $CRYPT_CLUSTER$ENCRYPTED_RADIUS_KEY
                secret_key: radiussecret
        accounting_rules:
          - method: exec
            start_stop: true
            groups:
              - RADIUS-GRP-01
        authorization_rules:
          - method: commands
            privilege_level: 15
            authenticated: true
            groups:
              - TACACS-GRP-01
        users:
          - name: admin
            password: $6$ENCRYPTED_PASSWORD
            secret: $9$ENCRYPTED_SECRET
            privilege_level: 15
            ssh_rsa_keys:
              - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD...
```
