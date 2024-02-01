# AAA Feature Template

Specify the authentication method and order and configure Radius, TACACs, or local authentication, including local user groups with different read/write permissions.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    aaa_templates:
      - name: FT-CEDGE-AAA-01
        description: TACACS, Local auth
        device_types:
          - C8000V
        authentication_and_authorization_order:
          - TACACS-GROUP1
          - local
        tacacs_server_groups:
          - name: TACACS-GROUP1
            vpn: 511
            source_interface_variable: tacacs_source_interface
            servers:
              - address: 10.1.1.1
                port: 49
                key: $CRYPT_CLUSTER$jq34CKAzT5KGdEjIpYarKg==$MZkY/AdOWzm/kiLHOsKHJg==
                secret_key: 070c285f4d06485744
              - address: 10.1.1.2
                key: $CRYPT_CLUSTER$jq34CKAzT5KGdEjIpYarKg==$MZkY/AdOWzm/kiLHOsKHJg==
                secret_key: 070c285f4d06485744
        users:
          - name: admin
            password: $6$Oz2ydqNXLLDIsPSG$LhogoactFVb9eJgqgv/O/Zb.FHg74drK4maijc.Q9q/KhyDcPfwrHx9Vy6G9hY7oKWbyas4XKms7f7Znl/ndF.
            privilege_level: 15
            secret: $9$dU74jedMCjuogb$tt5nj1PRM1sTfPVHdfng/skm5F5SVmZh8kdqskY4T9I
          - name: failsafe
            password: $6$v0UN8x4fkvZd0Lnj$hq13MC.W5ElstGlolO38fshGEYxSechW4K5zEdrJD1trSH30AaNKvL4VUlOtxersGmIDNefPwyrSqbJpCpXGJ.
            privilege_level: 15
            secret: $9$g1yhfB7cvGL5R8$8lUWXWGnaLHosXIcJ/eYr1C26nJyFNXkXHhDKILO4YQ
            optional: false
        authorization_rules:
          - method: commands
            privilege_level: 15
            groups:
              - TACACS-GROUP1
            authenticated: true
```
