# System AAA Feature

Specify the authentication method and order and configure Radius, TACACs, or local authentication, including local user groups with different read/write permissions.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system
        aaa:
          name: aaa
          description: basic aaa
          auth_order:
            - tacacs-511
            - local
          tacacs_groups:
            - vpn: 511
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
              privilege: 15
            - name: failsafe
              password: $6$v0UN8x4fkvZd0Lnj$hq13MC.W5ElstGlolO38fshGEYxSechW4K5zEdrJD1trSH30AaNKvL4VUlOtxersGmIDNefPwyrSqbJpCpXGJ.
              privilege: 15
          authorization_rules:
            - id: rule1
              method: commands
              level: 15
              groups:
                - tacacs-511
              authenticated: true
```
