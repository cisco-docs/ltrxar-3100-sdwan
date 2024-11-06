# Application List

Application list specifies one or more NBAR applications or applications families.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    application_lists:
      - name: amazon_aws_apps
        applications:
          - amazon
          - amazon-web-services
          - amazon-instant-video
          - amazon-cloudfront
          - amazon-ec2
          - amazon-s3
      - name: scavenger_apps
        application_families:
          - game
          - instant-messaging
```
