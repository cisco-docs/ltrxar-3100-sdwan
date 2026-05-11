# Service Multicast Feature

This feature enables Multicast routing within service VPN segments, multicast overlay routing allows the transport of multicast traffic across the SD-WAN fabric.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a service Multicast feature with local_replicator, threshold, igmp_interfaces, msdp_mesh_groups, pim_bsr_candidates, pim_bsr_rp_candidates, pim_interfaces, static_rp_addresses and so on.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        multicast_features:
          - name: service_multicast_full
            description: service multicast full feature
            pim_source_specific_multicast: true
            auto_rp: true
            igmp_interfaces:
              - interface_name: GigabitEthernet1
                version: 3
                join_groups:
                  - group_address: 224.0.0.0
                    source_address: 1.2.3.4
                  - group_address: 239.1.1.5
                    source_address: 10.0.0.2
            local_replicator: true
            threshold: 10
            msdp_connection_retry_interval: 30
            msdp_mesh_groups:
              - name: mesh_grp1
                peers:
                  - peer_ip: 1.2.3.4
                    connection_source_interface: GigabitEthernet1
                    default_peer: true
                    keepalive_hold_time: 50
                    keepalive_interval: 10
                    peer_authentication_password_variable: peer_auth_password
                    prefix_list: ipv4_pl_service
                    remote_as: 65001
                    sa_limit: 1000
            msdp_originator_id: GigabitEthernet1
            pim_bsr_candidates:
              - interface_name: GigabitEthernet1
                accept_candidate_access_list: 25
                hash_mask_length: 30
                priority: 120
            pim_bsr_rp_candidates:
              - interface_name: GigabitEthernet1
                access_list: 25
                interval: 30
                priority: 1
            pim_interfaces:
              - interface_name: GigabitEthernet1
                join_prune_interval: 60
                query_interval: 30
            pim_source_specific_multicast_access_list: 25
            pim_spt_threshold: infinity
            spt_only: false
            static_rp_addresses:
              - ip_address: 1.2.3.4
                access_list: 25
                override: false
```
