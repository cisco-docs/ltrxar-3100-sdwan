# Traffic Data - QOS Definition

QOS Definition define the matching conditions and Actions to configure QOS policy for Traffic data

{{ doc_gen }}

### Examples

Example-1: Prioritizing VoIP Traffic with DSCP Tagging and Forwarding Class Assignment.

A healthcare organization uses cloud-based VoIP applications for internal and patient-related communications. To ensure voice traffic always receives the highest quality of service (QoS), the organization wants to implement a centralized data policy that matches VoIP traffic based on DSCP marking and forwards it using a high-priority forwarding class.This is done by defining a traffic data policy that includes a sequence matching DSCP-marked packets for VoIP (e.g., EF = DSCP 46), and taking actions to assign a high-priority forwarding class (voice), along with enabling flow logging for troubleshooting and analytics.

The YAML defines a centralized data policy named Voice_Traffic_QoS, aimed at prioritizing voice traffic. It includes a description highlighting its QoS intent and sets the default action to drop to strictly filter unmatched traffic. Within the policy, a single sequence with ID 100 is defined, specifically targeting QoS handling. The match criteria focus on packets marked with DSCP value 46, typically used for VoIP. Upon a match, the policy triggers actions to enable logging, preserve the DSCP marking, and assign the traffic to the “voice” forwarding class, ensuring it receives low-latency, high-priority treatment across the network.

By deploying this configuration, the healthcare provider guarantees reliable VoIP performance, even during high network utilization, ensuring critical communication isn’t delayed or dropped.

```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        traffic_data:
          - name: Voice_Traffic_QoS
            description: "Ensure high priority treatment for VoIP traffic"
            default_action_type: drop
            sequences:
              - id: 100
                name: "Match_DSCP_EF_VoIP"
                base_action: accept
                ip_type: ipv4
                type: qos
                match_criterias:
                  dscp: 46
                actions:
                  log: true
                  dscp: 46
                  forwarding_class: "voice"
```
