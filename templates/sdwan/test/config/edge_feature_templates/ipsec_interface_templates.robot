*** Settings ***
Documentation   Verify IPsec Interface Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    ipsec_interface_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.ipsec_interface_templates is defined %}

*** Test Cases ***
Get IPsec Interface Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_vpn_interface_ipsec")]
    Set Suite Variable    ${r}

{% for ipsec in sdwan.edge_feature_templates.ipsec_interface_templates | default([]) %}

Verify Edge Feature Template IPsec Interface Feature template {{ ipsec.name }}
    ${ipsec_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ipsec.name }}")]
    Should Be Equal Value Json String    ${ipsec_id}    $..templateName    {{ ipsec.name }}    msg=name
    Should Be Equal Value Json String    ${ipsec_id}    $..templateDescription    {{ ipsec.description }}    msg=description

{% set test_list = [] %}
{% for item in ipsec.device_types | default(defaults.sdwan.edge_feature_templates.ipsec_interface_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${ipsec_id}    $..deviceType
    ${test_list}=    Create List    {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device types

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ipsec.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $..application.vipValue    {{ ipsec.application | default("not_defined") }}    msg=application
    Should Be Equal Value Json String    ${r_id.json()}    $..application.vipVariableName    {{ ipsec.application_variable | default("not_defined") }}    msg=application variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["clear-dont-fragment"].vipValue    {{ ipsec.clear_dont_fragment | default("not_defined") | lower() }}    msg=clear dont fragment
    Should Be Equal Value Json String    ${r_id.json()}    $..["clear-dont-fragment"].vipVariableName    {{ ipsec.clear_dont_fragment_variable | default("not_defined") }}    msg=clear dont fragment variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["dead-peer-detection"]..["dpd-interval"].vipValue    {{ ipsec.dead_peer_detection_interval | default("not_defined") }}    msg=dead peer detection interval
    Should Be Equal Value Json String    ${r_id.json()}    $..["dead-peer-detection"]..["dpd-interval"].vipVariableName    {{ ipsec.dead_peer_detection_interval_variable | default("not_defined") }}    msg=dead peer detection interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["dead-peer-detection"]..["dpd-retries"].vipValue    {{ ipsec.dead_peer_detection_retries | default("not_defined") }}    msg=dead peer detection retries
    Should Be Equal Value Json String    ${r_id.json()}    $..["dead-peer-detection"]..["dpd-retries"].vipVariableName    {{ ipsec.dead_peer_detection_retries_variable | default("not_defined") }}    msg=dead peer detection retries variable
    Should Be Equal Value Json String    ${r_id.json()}    $..description.vipValue    {{ ipsec.interface_description | default("not_defined") }}    msg=interface description
    Should Be Equal Value Json String    ${r_id.json()}    $..description.vipVariableName    {{ ipsec.interface_description_variable | default("not_defined") }}    msg=interface description variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["if-name"].vipValue    {{ ipsec.interface_name | default("not_defined") }}    msg=interface name
    Should Be Equal Value Json String    ${r_id.json()}    $..["if-name"].vipVariableName    {{ ipsec.interface_name_variable | default("not_defined") }}    msg=interface name variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ip.address.vipValue    {{ ipsec.ip_address | default("not_defined") }}    msg=ip address
    Should Be Equal Value Json String    ${r_id.json()}    $..ip.address.vipVariableName    {{ ipsec.ip_address_variable | default("not_defined") }}    msg=ip address variable
    Should Be Equal Value Json String    ${r_id.json()}    $..mtu.vipValue    {{ ipsec.mtu | default("not_defined") }}    msg=mtu
    Should Be Equal Value Json String    ${r_id.json()}    $..mtu.vipVariableName    {{ ipsec.mtu_variable | default("not_defined") }}    msg=mtu variable
    Should Be Equal Value Json String    ${r_id.json()}    $..shutdown.vipValue    {{ ipsec.shutdown | default("not_defined") | lower() }}    msg=shutdown
    Should Be Equal Value Json String    ${r_id.json()}    $..shutdown.vipVariableName    {{ ipsec.shutdown_variable | default("not_defined") }}    msg=shutdown variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tcp-mss-adjust"].vipValue    {{ ipsec.tcp_mss | default("not_defined") }}    msg=tcp mss
    Should Be Equal Value Json String    ${r_id.json()}    $..["tcp-mss-adjust"].vipVariableName    {{ ipsec.tcp_mss_variable | default("not_defined") }}    msg=tcp mss variable
    Should Be Equal Value Json String    ${r_id.json()}    $..tracker.vipValue    {{ ipsec.tracker | default("not_defined") }}    msg=tracker
    Should Be Equal Value Json String    ${r_id.json()}    $..tracker.vipVariableName    {{ ipsec.tracker_variable | default("not_defined") }}    msg=tracker variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tunnel-destination"].vipValue    {{ ipsec.tunnel_destination | default("not_defined") }}    msg=tunnel destination
    Should Be Equal Value Json String    ${r_id.json()}    $..["tunnel-destination"].vipVariableName    {{ ipsec.tunnel_destination_variable | default("not_defined") }}    msg=tunnel destination variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tunnel-source-interface"].vipValue    {{ ipsec.tunnel_source_interface | default("not_defined") }}    msg=tunnel source interface
    Should Be Equal Value Json String    ${r_id.json()}    $..["tunnel-source-interface"].vipVariableName    {{ ipsec.tunnel_source_interface_variable | default("not_defined") }}    msg=tunnel source interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tunnel-source"].vipValue    {{ ipsec.tunnel_source_ip | default("not_defined") }}    msg=tunnel source ip
    Should Be Equal Value Json String    ${r_id.json()}    $..["tunnel-source"].vipVariableName    {{ ipsec.tunnel_source_ip_variable | default("not_defined") }}    msg=tunnel source ip variable

    Should Be Equal Value Json String    ${r_id.json()}    $..ike["ike-ciphersuite"].vipValue    {{ ipsec.ike.ciphersuite | default("not_defined") }}    msg=ike ciphersuite
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["ike-ciphersuite"].vipVariableName    {{ ipsec.ike.ciphersuite_variable | default("not_defined") }}    msg=ike ciphersuite variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["ike-group"].vipValue    {{ ipsec.ike.group | default("not_defined") }}    msg=ike group
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["ike-group"].vipVariableName    {{ ipsec.ike.group_variable | default("not_defined") }}    msg=ike group variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["ike-mode"].vipValue    {{ ipsec.ike.mode | default("not_defined") }}    msg=ike mode
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["ike-mode"].vipVariableName    {{ ipsec.ike.mode_variable | default("not_defined") }}    msg=ike mode variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["authentication-type"]["pre-shared-key"]["pre-shared-secret"].vipValue    {{ ipsec.ike.pre_shared_key | default("not_defined") }}    msg=ike pre shared key
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["authentication-type"]["pre-shared-key"]["pre-shared-secret"].vipVariableName    {{ ipsec.ike.pre_shared_key_variable | default("not_defined") }}    msg=ike pre shared key variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["authentication-type"]["pre-shared-key"]["ike-local-id"].vipValue    {{ ipsec.ike.pre_shared_key_local_id | default("not_defined") }}    msg=ike pre shared key local id
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["authentication-type"]["pre-shared-key"]["ike-local-id"].vipVariableName    {{ ipsec.ike.pre_shared_key_local_id_variable | default("not_defined") }}    msg=ike pre shared key local id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["authentication-type"]["pre-shared-key"]["ike-remote-id"].vipValue    {{ ipsec.ike.pre_shared_key_remote_id | default("not_defined") }}    msg=ike pre shared key remote id
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["authentication-type"]["pre-shared-key"]["ike-remote-id"].vipVariableName    {{ ipsec.ike.pre_shared_key_remote_id_variable | default("not_defined") }}    msg=ike pre shared key remote id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["ike-rekey-interval"].vipValue    {{ ipsec.ike.rekey_interval | default("not_defined") }}    msg=ike rekey interval
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["ike-rekey-interval"].vipVariableName    {{ ipsec.ike.rekey_interval_variable | default("not_defined") }}    msg=ike rekey interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ike["ike-version"].vipValue    {{ ipsec.ike.version | default("not_defined") }}    msg=ike version

    Should Be Equal Value Json String    ${r_id.json()}    $..ipsec["ipsec-ciphersuite"].vipValue    {{ ipsec.ipsec.ciphersuite | default("not_defined") }}    msg=ipsec ciphersuite
    Should Be Equal Value Json String    ${r_id.json()}    $..ipsec["ipsec-ciphersuite"].vipVariableName    {{ ipsec.ipsec.ciphersuite_variable | default("not_defined") }}    msg=ipsec ciphersuite variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ipsec["perfect-forward-secrecy"].vipValue    {{ ipsec.ipsec.perfect_forward_secrecy | default("not_defined") }}    msg=ipsec perfect forward secrecy
    Should Be Equal Value Json String    ${r_id.json()}    $..ipsec["perfect-forward-secrecy"].vipVariableName    {{ ipsec.ipsec.perfect_forward_secrecy_variable | default("not_defined") }}    msg=ipsec perfect forward secrecy variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ipsec["ipsec-rekey-interval"].vipValue    {{ ipsec.ipsec.rekey_interval | default("not_defined") }}    msg=ipsec rekey interval
    Should Be Equal Value Json String    ${r_id.json()}    $..ipsec["ipsec-rekey-interval"].vipVariableName    {{ ipsec.ipsec.rekey_interval_variable | default("not_defined") }}    msg=ipsec rekey interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $..ipsec["ipsec-replay-window"].vipValue    {{ ipsec.ipsec.replay_window | default("not_defined") }}    msg=ipsec replay window
    Should Be Equal Value Json String    ${r_id.json()}    $..ipsec["ipsec-replay-window"].vipVariableName    {{ ipsec.ipsec.replay_window_variable | default("not_defined") }}    msg=ipsec replay window variable

{% endfor %}

{% endif %}
