*** Settings ***
Documentation   Verify Secure Internet Gateway (SIG) Feature Template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.secure_internet_gateway_templates is defined %}

*** Test Cases ***
Get Secure Internet Gateway Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_secure_internet_gateway")]
    Set Suite Variable    ${r}

{% for sig in sdwan.edge_feature_templates.secure_internet_gateway_templates | default([]) %}

Verify Edge Feature Template Secure Internet Gateway Feature template {{ sig.name }}
    ${sig_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{sig.name }}")]
    Should Be Equal Value Json String    ${sig_id}    $..templateName    {{ sig.name }}    msg=name
    Should Be Equal Value Json Special_String    ${sig_id}    $..templateDescription    {{ sig.description | normalize_special_string }}    msg=description

{% set test_list = [] %}
{% for item in sig.device_types | default(defaults.sdwan.edge_feature_templates.secure_internet_gateway_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${sig_id}    $..deviceType
    ${test_list}=    Create List    {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device type

{% if sig.sig_provider == "umbrella" %}
{% set sig_value = "secure-internet-gateway-umbrella" %}
{% elif sig.sig_provider == "zscaler" %}
{% set sig_value = "secure-internet-gateway-zscaler" %}
{% elif sig.sig_provider == "other" %}
{% set sig_value = "secure-internet-gateway-other" %}
{% endif %}

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{sig.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[0]..["tunnel-set"].vipValue    {{ sig_value }}    msg=sig provider
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker-src-ip"].vipValue    {{ sig.tracker_source_ip | default("not_defined") }}    msg=tracker source ip
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker-src-ip"].vipVariableName    {{ sig.tracker_source_ip_variable | default("not_defined") }}    msg=tracker source ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["umbrella-data-center"]..["data-center-primary"].vipValue    {{ sig.umbrella_primary_data_center | default("not_defined") }}    msg=umbrella primary data center
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["umbrella-data-center"]..["data-center-primary"].vipVariableName    {{ sig.umbrella_primary_data_center_variable | default("not_defined") }}    msg=umbrella primary data center variable
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["umbrella-data-center"]..["data-center-secondary"].vipValue    {{ sig.umbrella_secondary_data_center | default("not_defined") }}    msg=umbrella secondary data center
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["umbrella-data-center"]..["data-center-secondary"].vipVariableName    {{ sig.umbrella_secondary_data_center_variable | default("not_defined") }}    msg=umbrella secondary data center variable
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].aup..["block-internet-until-accepted"].vipValue    {{ sig.zscaler_aup_block_internet_until_accepted | default("not_defined") | lower() }}    msg=zscaler aup block internet until accepted
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].aup.enabled.vipValue    {{ sig.zscaler_aup_enabled | default("not_defined") | lower() }}    msg=zscaler aup enabled
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].aup..["force-ssl-inspection"].vipValue    {{ sig.zscaler_aup_force_ssl_inspection | default("not_defined") | lower() }}    msg=zscaler aup force ssl inspection
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].aup.timeout.vipValue    {{ sig.zscaler_aup_timeout | default("not_defined") }}    msg=zscaler aup timeout
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"]..["auth-required"].vipValue    {{ sig.zscaler_authentication_required | default("not_defined") | lower() }}    msg=zscaler authentication required
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"]..["caution-enabled"].vipValue    {{ sig.zscaler_caution_enabled | default("not_defined") | lower() }}    msg=zscaler caution enabled
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"]..["ips-control"].vipValue    {{ sig.zscaler_ips_control_enabled | default("not_defined") | lower() }}    msg=zscaler ips control enabled
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"]..["ofw-enabled"].vipValue    {{ sig.zscaler_firewall_enabled | default("not_defined") | lower() }}    msg=zscaler firewall enabled
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"]..["location-name"].vipVariableName    {{ sig.zscaler_location_name_variable | default("not_defined") }}    msg=zscaler location name variable
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].datacenters..["primary-data-center"].vipValue    {{ sig.zscaler_primary_data_center | default("not_defined") }}    msg=zscaler primary data center
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].datacenters..["primary-data-center"].vipVariableName    {{ sig.zscaler_primary_data_center_variable | default("not_defined") }}    msg=zscaler primary data center variable
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].datacenters..["secondary-data-center"].vipValue    {{ sig.zscaler_secondary_data_center | default("not_defined") }}    msg=zscaler secondary data center
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].datacenters..["secondary-data-center"].vipVariableName    {{ sig.zscaler_secondary_data_center_variable | default("not_defined") }}    msg=zscaler secondary data center variable
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].surrogate..["display-time-unit"].vipValue    {{ sig.zscaler_surrogate_display_time_unit | upper() | default("not_defined") }}    msg=zscaler surrogate display time unit
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].surrogate..["idle-time"].vipValue    {{ sig.zscaler_surrogate_idle_time | default("not_defined") }}    msg=zscaler surrogate idle time
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].surrogate.ip.vipValue    {{ sig.zscaler_surrogate_ip | default("not_defined") | lower() }}    msg=zscaler surrogate ip
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].surrogate..["ip-enforced-for-known-browsers"].vipValue    {{ sig.zscaler_surrogate_ip_enforce_for_known_browsers | default("not_defined") | lower() }}    msg=zscaler surrogate ip enforce for known browsers
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].surrogate..["refresh-time"].vipValue    {{ sig.zscaler_surrogate_refresh_time | default("not_defined") }}    msg=zscaler surrogate refresh time
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"].surrogate..["refresh-time-unit"].vipValue    {{ sig.zscaler_surrogate_refresh_time_unit | upper() | default("not_defined") }}    msg=zscaler surrogate refresh time unit
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["zscaler-location-settings"]..["xff-forward-enabled"].vipValue    {{ sig.zscaler_xff_forward | default("not_defined") | lower() }}    msg=zscaler xff forward

    ${ha_pair_items}=    Get Value From Json    ${r_id.json()}    $.service.vipValue..["ha-pairs"]..["interface-pair"].vipValue
    ${ha_pairs_length}=    Get Length    ${ha_pair_items[0]}
    Should Be Equal As Integers    ${ha_pairs_length}    {{ sig.high_availability_interface_pairs | length }}    msg=high availability interface pairs

{% for ha_pairs in sig.high_availability_interface_pairs | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["ha-pairs"]..["interface-pair"].vipValue[{{loop.index0}}]..["active-interface"].vipValue    {{ ha_pairs.active_interface }}    msg=active interface
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["ha-pairs"]..["interface-pair"].vipValue[{{loop.index0}}]..["active-interface-weight"].vipValue    {{ ha_pairs.active_interface_weight }}    msg=active interface weight
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["ha-pairs"]..["interface-pair"].vipValue[{{loop.index0}}]..["backup-interface"].vipValue    {{ ha_pairs.backup_interface }}    msg=backup interface
    Should Be Equal Value Json String    ${r_id.json()}    $.service.vipValue..["ha-pairs"]..["interface-pair"].vipValue[{{loop.index0}}]..["backup-interface-weight"].vipValue    {{ ha_pairs.backup_interface_weight }}    msg=backup interface weight

{% endfor %}

    ${interface_items}=    Get Value From Json    ${r_id.json()}    $.interface.vipValue
    ${interfaces_length}=    Get Length    ${interface_items[0]}
    Should Be Equal As Integers    ${interfaces_length}    {{ sig.interfaces | length }}    msg=interfaces

{% for interface in sig.interfaces | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].description.vipValue    {{ interface.description | default("not_defined") }}    msg=interface description
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].description.vipVariableName    {{ interface.description_variable | default("not_defined") }}    msg=interface description variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["dead-peer-detection"]..["dpd-interval"].vipValue    {{ interface.dpd_interval | default("not_defined") }}    msg=dpd interval
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["dead-peer-detection"]..["dpd-interval"].vipVariableName    {{ interface.dpd_interval_variable | default("not_defined") }}    msg=dpd interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["dead-peer-detection"]..["dpd-retries"].vipValue    {{ interface.dpd_retries | default("not_defined") }}    msg=dpd retries
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["dead-peer-detection"]..["dpd-retries"].vipVariableName    {{ interface.dpd_retries_variable | default("not_defined") }}    msg=dpd retries variable

{% if interface.tunnel_type == "ipsec" %}

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["ike-ciphersuite"].vipValue    {{ interface.ike_ciphersuite | default(defaults.sdwan.edge_feature_templates.secure_internet_gateway_templates.interfaces.ike_ciphersuite) }}    msg=ike ciphersuite
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["ike-ciphersuite"].vipVariableName    {{ interface.ike_ciphersuite_variable | default("not_defined") }}    msg=ike ciphersuite variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["ike-group"].vipValue    {{ interface.ike_group | default(defaults.sdwan.edge_feature_templates.secure_internet_gateway_templates.interfaces.ike_group) }}    msg=ike group
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["ike-group"].vipVariableName    {{ interface.ike_group_variable | default("not_defined") }}    msg=ike group variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["authentication-type"]..["pre-shared-key"]..["pre-shared-secret"].vipValue    {{ interface.ike_pre_shared_key | default("not_defined") }}    msg=ike pre shared key
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["authentication-type"]..["pre-shared-key"]..["pre-shared-secret"].vipVariableName    {{ interface.ike_pre_shared_key_variable | default("not_defined") }}    msg=ike pre shared key variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["authentication-type"]..["pre-shared-key"]..["ike-local-id"].vipValue    {{ interface.ike_pre_shared_key_local_id | default("not_defined") }}    msg=ike pre shared key local id
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["authentication-type"]..["pre-shared-key"]..["ike-local-id"].vipVariableName    {{ interface.ike_pre_shared_key_local_id_variable | default("not_defined") }}    msg=ike pre shared key local id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["authentication-type"]..["pre-shared-key"]..["ike-remote-id"].vipValue    {{ interface.ike_pre_shared_key_remote_id | default("not_defined") }}    msg=ike pre shared key remote id
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["authentication-type"]..["pre-shared-key"]..["ike-remote-id"].vipVariableName    {{ interface.ike_pre_shared_key_remote_id_variable | default("not_defined") }}    msg=ike pre shared key remote id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["ike-rekey-interval"].vipValue    {{ interface.ike_rekey_interval | default(defaults.sdwan.edge_feature_templates.secure_internet_gateway_templates.interfaces.ike_rekey_interval) }}    msg=ike rekey interval
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ike..["ike-rekey-interval"].vipVariableName    {{ interface.ike_rekey_interval_variable | default("not_defined") }}    msg=ike rekey interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ipsec..["ipsec-ciphersuite"].vipValue    {{ interface.ipsec_ciphersuite | default(defaults.sdwan.edge_feature_templates.secure_internet_gateway_templates.interfaces.ipsec_ciphersuite) }}    msg=ipsec ciphersuite
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ipsec..["ipsec-ciphersuite"].vipVariableName    {{ interface.ipsec_ciphersuite_variable | default("not_defined") }}    msg=ipsec ciphersuite variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ipsec..["perfect-forward-secrecy"].vipValue    {{ interface.ipsec_perfect_forward_secrecy | default(defaults.sdwan.edge_feature_templates.secure_internet_gateway_templates.interfaces.ipsec_perfect_forward_secrecy) }}    msg=ipsec perfect forward secrecy
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ipsec..["perfect-forward-secrecy"].vipVariableName    {{ interface.ipsec_perfect_forward_secrecy_variable | default("not_defined") }}    msg=ipsec perfect forward secrecy variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ipsec..["ipsec-rekey-interval"].vipValue    {{ interface.ipsec_rekey_interval | default(defaults.sdwan.edge_feature_templates.secure_internet_gateway_templates.interfaces.ipsec_rekey_interval) }}    msg=ipsec rekey interval
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ipsec..["ipsec-rekey-interval"].vipVariableName    {{ interface.ipsec_rekey_interval_variable | default("not_defined") }}    msg=ipsec rekey interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ipsec..["ipsec-replay-window"].vipValue    {{ interface.ipsec_replay_window | default(defaults.sdwan.edge_feature_templates.secure_internet_gateway_templates.interfaces.ipsec_replay_window) }}    msg=ipsec replay window
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].ipsec..["ipsec-replay-window"].vipVariableName    {{ interface.ipsec_replay_window_variable | default("not_defined") }}    msg=ipsec replay window variable

{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].mtu.vipValue    {{ interface.mtu | default("not_defined") }}    msg=mtu
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].mtu.vipVariableName    {{ interface.mtu_variable | default("not_defined") }}    msg=mtu variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["if-name"].vipValue    {{ interface.name | default("not_defined") }}    msg=interface name
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["if-name"].vipVariableName    {{ interface.name_variable | default("not_defined") }}    msg=interface name variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].shutdown.vipValue    {{ interface.shutdown | default("not_defined") | lower() }}    msg=shutdown
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["tcp-mss-adjust"].vipValue    {{ interface.tcp_mss | default("not_defined") }}    msg=tcp mss
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["tcp-mss-adjust"].vipVariableName    {{ interface.tcp_mss_variable | default("not_defined") }}    msg=tcp mss variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["track-enable"].vipValue    {{ interface.track | default("not_defined") | lower() }}    msg=track
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].tracker.vipValue    {{ interface.tracker | default("not_defined") }}    msg=tracker
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].tracker.vipVariableName    {{ interface.tracker_variable | default("not_defined") }}    msg=tracker variable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["tunnel-dc-preference"].vipValue    {{ interface.tunnel_dc_preference }}    msg=tunnel dc preference

{% if sig.sig_provider == "other" %}

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["tunnel-destination"].vipValue    {{ interface.tunnel_destination | default("not_defined") }}    msg=tunnel destination
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["tunnel-destination"].vipVariableName    {{ interface.tunnel_destination_variable | default("not_defined") }}    msg=tunnel destination variable

{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["tunnel-source-interface"].vipValue    {{ interface.tunnel_source_interface | default("not_defined") }}    msg=tunnel source interface
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["tunnel-source-interface"].vipVariableName    {{ interface.tunnel_source_interface_variable | default("not_defined") }}    msg=tunnel source interface variable

{% endfor %}

    ${tracker_items}=    Get Value From Json    ${r_id.json()}    $.tracker.vipValue
    ${trackers_length}=    Get Length    ${tracker_items[0]}
    Should Be Equal As Integers    ${trackers_length}    {{ sig.trackers | length }}     msg=trackers

{% for tracker in sig.trackers | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}]..["endpoint-api-url"].vipValue    {{ tracker.endpoint_api_url | default("not_defined") }}    msg=endpoint api url
    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}]..["endpoint-api-url"].vipVariableName    {{ tracker.endpoint_api_url_variable | default("not_defined") }}    msg=endpoint api url variable
    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}].interval.vipValue    {{ tracker.interval | default("not_defined") }}    msg=interval
    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}].interval.vipVariableName    {{ tracker.interval_variable | default("not_defined") }}    msg=interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}].multiplier.vipValue    {{ tracker.multiplier | default("not_defined") }}    msg=multiplier
    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}].multiplier.vipVariableName    {{ tracker.multiplier_variable | default("not_defined") }}    msg=multiplier variable
    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}].name.vipValue    {{ tracker.name | default("not_defined") }}    msg=tracker name
    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}].name.vipVariableName    {{ tracker.name_variable | default("not_defined") }}    msg=tracker name variable
    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}].threshold.vipValue    {{ tracker.threshold | default("not_defined") }}    msg=threshold
    Should Be Equal Value Json String    ${r_id.json()}    $.tracker.vipValue[{{loop.index0}}].threshold.vipVariableName    {{ tracker.threshold_variable | default("not_defined") }}    msg=threshold variable

{% endfor %}

{% endfor %}

{% endif %}
