# ThousandEyes Feature Template

Configure the Cisco Thousandeyes Agent parameters to deploy on WAN Edge routers.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    thousandeyes_templates:
      - name: FT-CEDGE-THOUSANDEYES-01
        description: TE Agent, Service VPN, static proxy
        name_server_variable: thousandeyes_name_server
        proxy_host_variable: thousandeyes_proxy_host
        proxy_port: 8080
        proxy_type: static
        ip_variable: thousandeyes_agent_ip
        default_gateway_variable: thousandeyes_agent_default_gateway
        account_group_token_variable: thousandeyes_token
        vpn_id_variable: thousandeyes_vpn
```
