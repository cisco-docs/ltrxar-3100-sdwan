# Application List

Application list specifies one or more NBAR applications.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      app:
        - name: amazon_aws_apps
          description: SaaS App List for Amazon AWS
          entries:
            - app: amazon
            - app: amazon-web-services
            - app: amazon-instant-video
            - app: amazon-cloudfront
            - app: amazon-ec2
            - app: amazon-s3
```
