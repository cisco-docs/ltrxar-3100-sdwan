# Transport GPS Feature

Configure GPS.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure the gps feature within a transport profile. It sets up the LTE cellular modem for GPS in Standalone mode and enabling GPS NMEA data streaming, udp socket details: source IP, destination IP and port.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        gps_features:
          - name: gps1
            gps_enable: true
            gps_mode: standalone
            nmea_enable: true
            nmea_source_address: 192.168.1.100
            nmea_destination_address: 192.168.1.22
            nmea_destination_port: 12345
```
