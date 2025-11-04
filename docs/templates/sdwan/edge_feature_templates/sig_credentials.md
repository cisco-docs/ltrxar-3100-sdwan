# SIG Credentials Feature Template

Configure Cisco Security Internet Gateway (SIG) credentials feature templates to automate tunnel provisioning.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    sig_credentials_templates:
      - name: Cisco-Umbrella-Global-Credentials
        umbrella_api_key: 7f33d6ee0d56402c83c503a669a80d22
        umbrella_api_secret: $CRYPT_CLUSTER$5dYqYjx7vO3/77uFutA+Sg==$m0ROjLW4OiuqFNkDQUFwoSwjbFB3aYhTj2KL+/g2HKygHy/EgUInhDtHXCUuKrxq
        umbrella_organization_id: 1234567
```
