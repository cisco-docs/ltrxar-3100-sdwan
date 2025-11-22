# QoS Map Definition

For hardware, each interface has eight queues, numbered from 0 through 7. Queue 0 is reserved for low-latency queuing (LLQ), so any class that is mapped to queue 0 must be configured to use LLQ. The default scheduling method for all is weighted round-robin (WRR).

For Cisco vEdge devices, each interface has eight queues, numbered from 0 through 7. Queue 0 is reserved for control traffic and low-latency queuing (LLQ) traffic, and queues 1, 2, 3, 4, 5, 6 and 7 are available for data traffic. The scheduling method for all eight queues is WRR. LLQ is not supported. When QoS is not configured for data traffic, queue 2 is the default queue.

{{ doc_gen }}

### Examples
Example-1: Following example configures QoS policy consisting of LLQ for control and voice class and WRR for interactive video class, transactional data and default class. It limits priority traffic to 20 percent and assigns 20% of bandwidth to video, 30% to transactional data and 30% to remaining data.

```yaml
sdwan:
  localized_policies:
    definitions:
      qos_maps:
        - name: QOS-MAP-1P3Q
          description: "1-prio 3-red queue qos-map"
          qos_schedulers:
            - queue: 0
              bandwidth_percent: 20
              buffer_percent: 20
              burst_bytes: 200000
              scheduling_type: llq
              drop_type: tail-drop
              class_map: CLASS-REALTIME
            - queue: 1
              bandwidth_percent: 30
              buffer_percent: 30
              scheduling_type: wrr
              drop_type: red-drop
              class_map: CLASS-TRANSACTIONAL
            - queue: 2
              bandwidth_percent: 30
              buffer_percent: 30
              scheduling_type: wrr
              drop_type: red-drop
              class_map: DEFAULT
            - queue: 4
              bandwidth_percent: 20
              buffer_percent: 20
              scheduling_type: wrr
              drop_type: red-drop
              class_map: CLASS-VIDEO
```
