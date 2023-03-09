# QoS Map Definition

For hardware, each interface has eight queues, numbered from 0 through 7. Queue 0 is reserved for low-latency queuing (LLQ), so any class that is mapped to queue 0 must be configured to use LLQ. The default scheduling method for all is weighted round-robin (WRR).

For Cisco vEdge devices, each interface has eight queues, numbered from 0 through 7. Queue 0 is reserved for control traffic, and queues 1, 2, 3, 4, 5, 6 and 7 are available for data traffic. The scheduling method for all eight queues is WRR. LLQ is not supported.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      qosMap:
        - name: QOS-MAP-1P4Q
          description: "1-prio 4-red queue qos-map"
          parameters:
            definition:
              qosSchedulers:
                - bandwidthPercent: "10"
                  bufferPercent: "10"
                  burst: "200000"
                  classMapRef: CLASS-REALTIME
                  drops: tail-drop
                  queue: "0"
                  scheduling: llq
                  tempKeyValues: Low Latency Queuing(LLQ) Tail CLASS-REALTIME
```
