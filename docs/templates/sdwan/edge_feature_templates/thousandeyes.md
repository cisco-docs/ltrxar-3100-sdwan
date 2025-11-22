# ThousandEyes Feature Template

Configure the Cisco Thousandeyes Agent parameters to deploy on WAN Edge routers.

{{ doc_gen }}

### Examples

Example-1: ThousandEyes Integration for Network Monitoring in SD-WAN

In an SD-WAN environment, ThousandEyes provides end-to-end visibility into network performance, enabling proactive troubleshooting, SLA monitoring, and security assessments. This use case defines an Edge Feature Template that integrates ThousandEyes agents on SD-WAN edge devices. The template is applied to different router models, ensuring automated deployment of ThousandEyes agents for real-time monitoring. The configuration includes key parameters such as default gateway, DNS settings, proxy settings, and VPN ID, allowing seamless connectivity and monitoring.

By leveraging ThousandEyes templates, network administrators can ensure optimal application performance, detect outages, and monitor internet/cloud connectivity for critical services.

```yaml
sdwan:
  edge_feature_templates:
    thousandeyes_templates:
      - name: BranchMonitoring
        description: ThousandEyes agent for branch offices monitoring cloud applications
        device_types:
          - C8200-1N-4T
          - ISR-4461
          - ASR-1002-X
        account_group_token: abcd1234efgh5678ijkl9012mnop3456
        default_gateway: 192.168.1.1
        name_server: 8.8.8.8
        proxy_host: proxy.branch.local
        proxy_port: 8080
        proxy_type: pac
        vpn_id: 10
      - name: DataCenterMonitoring
        description: ThousandEyes agent for data center monitoring and backbone link visibility
        device_types:
          - ASR-1001-X
          - C8500-12X
          - ISR-4451-X
        account_group_token: mnop3456ijkl9012efgh5678abcd1234
        default_gateway: 10.1.1.1
        name_server: 1.1.1.1
        proxy_host: proxy.dc.local
        proxy_port: 3128
        proxy_type: static
        vpn_id: 20
```
