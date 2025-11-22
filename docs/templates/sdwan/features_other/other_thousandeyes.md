# Other ThousandEyes Feature

Configure the Cisco ThousandEyes Agent parameters to deploy on WAN Edge routers.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a ThousandEyes feature under the other feature profile. The account group token is configured as a variable, while the agent default gateway, management IP, subnet mask, and VPN ID are configured as global values. The proxy type is set to static, and the static proxy host and port are specified.

```yaml
sdwan:
  feature_profiles:
    other_profiles:
      - name: basic_other
        thousandeyes:
          name: thousandeyes
          description: TE Agent, static proxy
          account_group_token_variable: te_token
          agent_default_gateway: 10.0.0.254
          management_ip: 10.0.0.1
          management_subnet_mask: 255.255.255.0
          proxy_type: static
          static_proxy_host: proxy.host.local
          static_proxy_port: 8443
          vpn_id: 0
```
