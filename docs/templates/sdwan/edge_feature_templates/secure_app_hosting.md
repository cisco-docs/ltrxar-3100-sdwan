# Secure App Hosting Template

This feature lets you customize the amount of resources that Unified Threat Defense features use on a router.

{{ doc_gen }}

### Examples

Example-1: Edge Application Hosting for Retail Branch Optimization 

The customer is a nationwide retail chain aiming to enhance operational efficiency at its branch locations by deploying Cisco SD-WAN routers with Secure App Hosting capabilities. Each branch uses the C8300-2N2S-6T platform to host containerized applications directly on the router. These applications include localized inventory management tools, in-store analytics, and point-of-sale integrations that require consistent performance and security at the network edge. To support these workloads, the customer configures the system with a medium resource profile, ensuring optimal CPU and memory allocation without overprovisioning. NAT is enabled to allow outbound connectivity for the hosted applications, such as accessing cloud APIs or uploading analytics data. Additionally, the routers are set to download a URL filtering database to enforce security policies directly at the edge. By parameterizing these configurations (e.g., NAT, resource profile, and URL DB download) with variables, the customer ensures scalable and consistent deployments across all retail branches while maintaining central control through Netascode templates.

```yaml
sdwan:
  edge_feature_templates:
    secure_app_hosting_templates:
      - name: SAH-TEMPLATE-RETAIL
        description: "Secure App Hosting for Branch Retail Routers"
        device_types:
          - C8300-2N2S-6T
        nat: true
        nat_variable: sah_nat_enable
        download_url_database_on_device: true
        download_url_database_on_device_variable: sah_url_db_download
        resource_profile: medium
        resource_profile_variable: sah_resource_profile
```
