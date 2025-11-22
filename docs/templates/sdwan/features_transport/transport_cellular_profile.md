# Transport Cellular Profile Feature

Configure Cellular Profile.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure the cellular_profile feature within a transport profile. It sets up a profile that the router uses to connect to cellular networks, which includes parameters: access point name, authentication type with relevant user and password, type of packet data matching used for APN access details.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        cellular_profiles:
          - name: cellular_profiles1
            access_point_name: apn.com
            authentication_enable: true
            authentication_type: pap
            profile_id: 2
            profile_username: username
            profile_password: pwd
            packet_data_network_type: ipv4
            
```
