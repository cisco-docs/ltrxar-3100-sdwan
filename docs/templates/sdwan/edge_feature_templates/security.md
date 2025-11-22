# Security Feature Template

Change the rekey time, anti-replay window, and authentication types for IPsec.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    security_templates:
      - name: FT-CEDGE-SECURITY-01
        description: "Base SD-WAN data-plane security"
        rekey_interval: 172800
        replay_window: 8192
        key_chains:
          - name: CHAIN1
            key_id: 1
        keys:
          - id: 1
            key_chain_name: CHAIN1
            crypto_algorithm: hmac-sha-256
            key_string: $CRYPT_CLUSTER$LWNAaNmLFvqA+58XSHEQHw==$h2ZTQ6rZdN3te+7M5QszqQ==
```
