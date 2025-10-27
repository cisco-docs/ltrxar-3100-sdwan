# Application Priority QoS Policy

Configure QoS policies with traffic schedulers to prioritize application traffic and manage bandwidth allocation on interfaces.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure an application priority QoS policy with target interfaces and multiple QoS schedulers. The policy includes a voice scheduler with 30% bandwidth allocation and tail-drop behavior, and a video scheduler with 20% bandwidth allocation and RED drop behavior for queue management.

```yaml
sdwan:
  feature_profiles:
    application_priority_profiles:
      - name: app_priority_profile
        qos_policies:
          - name: lan_qos_policy
            target_interfaces:
              - GigabitEthernet0/0/0
              - GigabitEthernet0/0/1
            qos_schedulers:
              - bandwidth_percent: 30
                drops: tail-drop
                forwarding_class: voice_class
              - bandwidth_percent: 70
                drops: red-drop
                forwarding_class: video_class
```
