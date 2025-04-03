# CLI Feature Profile

Using a CLI add-on profile, you can specify CLI commands to execute on devices. You can execute device configurations that are not available through other feature profiles and features.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a CLI feature profile with a name (which is mandatory) and a description (which is optional).

```yaml
sdwan:
  feature_profiles:
    cli_profiles:
      - name: cli
        description: basic cli profile
```
