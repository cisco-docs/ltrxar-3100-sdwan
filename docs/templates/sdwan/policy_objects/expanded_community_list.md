# Expanded Community List

Configure expanded BGP community lists.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an expanded community list with three communities.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      name: policy_object
      description: basic policy object profile
      expanded_community_lists:
        - name: community_legacy_wan
          expanded_communities:
            - 65001:101
            - 65002:102
            - 65003:103
```
Example-2: Expanded Community List for Traffic Engineering

In an SD-WAN deployment, network administrators can use expanded community lists to influence BGP routing decisions based on predefined community tags. This use case defines a policy object profile called Traffic_Engineering_Community, which categorizes routes into two expanded community lists: HighPriorityRoutes and LowPriorityRoutes. The HighPriorityRoutes list includes community values "65000:100" and "65000:200", ensuring these routes receive preferential treatment for lower latency and higher reliability paths. Meanwhile, the LowPriorityRoutes list, containing community values "65000:300" and "65000:400", is designed for routes that can be deprioritized, typically favoring cost-effective but potentially higher-latency paths. This approach enables intelligent traffic engineering, ensuring business-critical applications take precedence while optimizing network performance and resource utilization.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      - name: Traffic_Engineering_Community
        expanded_community_lists:
          - name: HighPriorityRoutes
            description: Routes with high-priority community tags for preferential treatment
            expanded_communities:
              - 65000:100"
              - 65000:200
          - name: LowPriorityRoutes
            description: Routes with low-priority community tags for de-prioritization
            expanded_communities:
              - 65000:300
              - 65000:400
 ```
