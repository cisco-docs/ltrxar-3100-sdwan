# CLI Feature Profile

Using a CLI add-on profile, you can specify CLI commands to execute on devices. You can execute device configurations that are not available through other feature profiles and parcels.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    cli_profiles:
      - name: cli
        description: basic cli profile
```
