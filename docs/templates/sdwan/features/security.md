# Security Feature

Change the rekey time, anti-replay window, and authentication types for IPsec.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: this is test system profile
        security:
          name: security
          description: basic security
          anti_replay_window: 8192
          extended_anti_replay_window_variable: extended_arw
          integrity_types:
            - esp
            - ip-udp-esp
          key_chains:
            - name: CHAIN1
              key_id: 1
          keys:
            - accept_life_time_start_epoch: 1714125354
              accept_life_time_exact: 1774125354
              crypto_algorithm: hmac-sha-256
              id: 1
              key_chain_name: CHAIN1
              key_string: lpqBQBw92hQOkcsmT7pLZq
              receiver_id_variable: key_recv_id
              send_id: 10
              send_life_time_start_epoch: 1714125354
              send_life_time_infinite: true
          rekey_time: 172800
```
