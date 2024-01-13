# QoS Map Definition

For hardware, each interface has eight queues, numbered from 0 through 7. Queue 0 is reserved for low-latency queuing (LLQ), so any class that is mapped to queue 0 must be configured to use LLQ. The default scheduling method for all is weighted round-robin (WRR).

For Cisco vEdge devices, each interface has eight queues, numbered from 0 through 7. Queue 0 is reserved for control traffic, and queues 1, 2, 3, 4, 5, 6 and 7 are available for data traffic. The scheduling method for all eight queues is WRR. LLQ is not supported.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      qos_maps:
        - name: QOS-MAP-1P2Q
          description: "1-prio 2-red queue qos-map"
          qos_schedulers:
            - queue: 0
              bandwidth_percent: 30
              buffer_percent: 30
              burst_bytes: 200000
              scheduling_type: llq
              drop_type: tail-drop
              class_map: REALTIME
            - queue: 1
              bandwidth_percent: 30
              buffer_percent: 30
              scheduling_type: wrr
              drop_type: red-drop
              class_map: TRANSACTIONAL
            - queue: 2
              bandwidth_percent: 40
              buffer_percent: 40
              scheduling_type: wrr
              drop_type: red-drop
              class_map: DEFAULT
```
