# cEdge AAA Feature Template

Specify the authentication method and order and configure Radius, TACACs, or local authentication, including local user groups with different read/write permissions.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cedge_aaa:
      - name: FT-CEDGE-AAA-01
        description: TACACS, Local auth
        parameters:
          server-auth-order: TACACS-GROUP1,local
          tacacs:
            - group-name: TACACS-GROUP1
              server:
                - address: 10.1.1.1
                  key: $CRYPT_CLUSTER$jq34CKAzT5KGdEjIpYarKg==$MZkY/AdOWzm/kiLHOsKHJg==
                  key-enum: 6
                  port: 49
                  secret-key: 070c285f4d06485744
                - address: 10.1.1.2
                  key: $CRYPT_CLUSTER$jq34CKAzT5KGdEjIpYarKg==$MZkY/AdOWzm/kiLHOsKHJg==
                  key-enum: 6
                  port: 49
                  secret-key: 070c285f4d06485744
              source-interface: Loopback511
              vpn: 511
          user:
            - name: admin
              password: $6$Oz2ydqNXLLDIsPSG$LhogoactFVb9eJgqgv/O/Zb.FHg74drK4maijc.Q9q/KhyDcPfwrHx9Vy6G9hY7oKWbyas4XKms7f7Znl/ndF.
              privilege: "15"
              secret: $9$dU74jedMCjuogb$tt5nj1PRM1sTfPVHdfng/skm5F5SVmZh8kdqskY4T9I
              optional: false
            - name: failsafe
              password: $6$v0UN8x4fkvZd0Lnj$hq13MC.W5ElstGlolO38fshGEYxSechW4K5zEdrJD1trSH30AaNKvL4VUlOtxersGmIDNefPwyrSqbJpCpXGJ.
              privilege: "15"
              secret: $9$g1yhfB7cvGL5R8$8lUWXWGnaLHosXIcJ/eYr1C26nJyFNXkXHhDKILO4YQ
              optional: false
```
