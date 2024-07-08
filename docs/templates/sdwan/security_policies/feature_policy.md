# Policy

Policy combines one or more Security policy definitions to create a Policy based on use-case. These policies can then be attached to device templates.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  security_policies:
    feature_policies:
      - name: Security_policy_generic
        description: Security Policy Generic
        use_case: custom
        firewall_policies:
          - allow_http_internal
          - allow_critical_apps
        intrusion_prevention_policy: inspect_web_apps
        additional_settings:
          firewall:
            direct_internet_applications: true
            tcp_syn_flood_limit: 1239
            high_speed_logging:
              vpn_id: 1
              server_ip: 1.1.1.1
              server_port: 2055
            audit_trail: true
            match_stats_per_filter: true
          ips_url_amp:
            external_syslog_server:
              vpn_id: 2
              server_ip: 2.2.2.2
            failure_mode: open
```