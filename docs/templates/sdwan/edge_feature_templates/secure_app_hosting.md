# Secure App Hosting Template

This feature lets you customize the amount of resources that Unified Threat Defense features use on a router.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    secure_app_hosting_templates:
      - name: utd-prod-01
        description: utd production profile 1
        nat: true
        download_url_database_on_device: false
        resource_profile: low
```
