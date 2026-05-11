# SIG Credentials Feature Template

Configure Cisco Security Internet Gateway (SIG) credentials feature templates to automate tunnel provisioning.

{{ doc_gen }}

### Examples

Example-1: This example shows how to configure a SIG credentials feature template for Cisco Umbrella. The template includes the global credentials required for Umbrella integration, such as the API key, API secret, and organization ID. 
These parameters enable automated provisioning and secure connectivity to Cisco Umbrella services within the SD-WAN environment.

```yaml
sdwan:
  edge_feature_templates:
    sig_credentials_templates:
      - name: Cisco-Umbrella-Global-Credentials
        umbrella_api_key_variable: umbrella_api_key_var
        umbrella_api_secret_variable: umbrella_api_secret_var
        umbrella_organization_id: 1000001
```

Example-2: This example demonstrates how to configure a SIG credentials feature template for Cisco Zscaler. The template includes the required global credentials for Zscaler integration, such as the partner API key, username, password, base URI, and organization name. 
These parameters enable secure authentication and automated connectivity to Cisco Zscaler services within the SD-WAN environment.

```yaml
sdwan:
  edge_feature_templates:
    sig_credentials_templates:
      - name: Cisco-Zscaler-Global-Credentials
        zscaler_organization: ciscozscalerorganization
        zscaler_partner_base_uri: https://ciscozscalerpartnerbaseuri
        zscaler_username: ciscozscalerusername
        zscaler_password_variable: zscaler_password_var
        zscaler_partner_api_key_variable: zscaler_partner_api_key_var
```