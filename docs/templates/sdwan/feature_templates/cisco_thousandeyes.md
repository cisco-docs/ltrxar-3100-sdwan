# Cisco ThousandEyes Feature Template

Configure the Cisco Thousandeyes Agent parameters to deploy on WAN Edge routers.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_thousandeyes:
      - name: FT-CEDGE-THOUSANDEYES-01
        description: TE Agent, Service VPN, static proxy
        parameters:
          virtual-application:
          - application-type: te
            instance-id: d504ae0a-29f7-46a5-8466-7e6e283a8810
            te:
              name-server: DEVICE_VARIABLE;thousandeyes_name_server
              proxy_static:
                proxy_host: DEVICE_VARIABLE;thousandeyes_proxy_host
                proxy_port: DEVICE_VARIABLE;thousandeyes_proxy_port
              proxy_type: static
              te-mgmt-ip: DEVICE_VARIABLE;thousandeyes_agent_ip
              te-vpg-ip: DEVICE_VARIABLE;thousandeyes_agent_default_gateway
              token: DEVICE_VARIABLE;thousandeyes_token
              vpn: DEVICE_VARIABLE;thousandeyes_vpn
```
