# Extended Community List

Configure extended BGP community lists.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an extended community list matching the site of origin (SOO) community "1:1" and route target (RT) community "1:2".

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      name: policy_object
      description: basic policy object profile
      extended_community_lists:
        - name: ext_community_list
          extended_communities:
            - soo 1:1
            - rt 1:2
```

Example-2: Extended Community List for BGP Traffic Engineering

In an SD-WAN deployment, extended community lists allow for more granular control over BGP routing by tagging routes with extended communities. This use case defines a policy object profile named Traffic_Engineering_Community, which includes two extended community lists: PreferredRoutes and BackupRoutes. The PreferredRoutes list contains extended community values prefixed with "rt" (route target), ensuring these routes are preferred and used for primary traffic paths. The BackupRoutes list, tagged with "soo" (site of origin), is used to define backup routes that are only used in failover scenarios. By leveraging BGP extended communities, network administrators can influence route selection, optimize traffic flow, and enhance network resiliency.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      - name: Traffic_Engineering_Community
        description: Policy profile to manage traffic routing using extended community lists
        extended_community_lists:
          - name: PreferredRoutes
            description: High-priority routes for primary traffic paths
            extended_communities:
              - rt 65000:100
              - "rt 65000:200"
          - name: BackupRoutes
            description: Backup routes used for failover scenarios
            extended_communities:
              - soo 192.168.1.1:300
              - soo 192.168.1.2:400
```

