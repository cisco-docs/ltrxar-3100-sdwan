# Cisco SIG Credentials Feature Template

Configure Cisco Security Internet Gateway (SIG) credentials feature templates to automate tunnel provisioning.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_sig_credentials:
      - name: FT-CEDGE-SIG-CREDS-UMBRELLA-01
        description: "Global Umbrella SIG Credentials"
        parameters:
          umbrella:
            api-key: 7f33d6ee0d56402c83c503a669a80d22
            api-secret: $CRYPT_CLUSTER$5dYqYjx7vO3/77uFutA+Sg==$m0ROjLW4OiuqFNkDQUFwoSwjbFB3aYhTj2KL+/g2HKygHy/EgUInhDtHXCUuKrxq
            org-id: '1234567'
```
