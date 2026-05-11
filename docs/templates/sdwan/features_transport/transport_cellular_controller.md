# Transport Cellular Controller Feature

Configure Cellular Controller.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure the cellular_controller feature within a transport profile. The controller is configured with cellular_id, firmware_auto_sim, primary_sim_slot, sim_failover_retries and sim_failover_timeout.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        cellular_controllers:
          - name: cellular_controller1
            description: transport cellular controller
            cellular_id: '1'
            firmware_auto_sim: true
            primary_sim_slot: 1
            sim_failover_retries: 5
            sim_failover_timeout: 6 
```
