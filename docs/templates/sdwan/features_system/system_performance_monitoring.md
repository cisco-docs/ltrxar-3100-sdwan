# System Performance Monitoring Feature

Configure performance monitoring to view real-time, end-to-end application performance filtered by client segments, network segments, and server segments.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: this is test system profile
        performance_monitor:
          name: pfr_monitor
          description: basic performance monitor
          app_perf_monitor_enabled: true
          app_perf_monitor_app_groups:
            - amazon-group
            - box-group
          event_driven_config_enabled: true
          event_driven_events:
            - sla_change
          monitoring_config_enabled: true
          monitoring_config_interval: 60
```
