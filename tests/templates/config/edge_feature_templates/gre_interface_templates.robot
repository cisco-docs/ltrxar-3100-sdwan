*** Settings ***
Documentation   Verify GRE Interface Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.gre_interface_templates is defined %}

*** Test Cases ***
Get GRE Interface Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_vpn_interface_gre")]
    Set Suite Variable    ${r}

{% for gre in sdwan.edge_feature_templates.gre_interface_templates | default([]) %}

Verify Edge Feature Template GRE Interface Feature template {{ gre.name }}
    ${gre_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{gre.name }}")]
    Should Be Equal Value Json String    ${gre_id}    $..templateName    {{ gre.name }}    msg=name
    Should Be Equal Value Json Special_String    ${gre_id}    $..templateDescription    {{ gre.description | normalize_special_string }}    msg=description

    {% set dt_list_local = [] %}
    {% for item in gre.device_types | default(defaults.sdwan.edge_feature_templates.gre_interface_templates.device_types) %}
    {% set test = "vedge-" ~ item %}
    {% set _ = dt_list_local.append(test) %}
    {% endfor %}

    ${dt_list_remote}=    Get Value From Json    ${gre_id}    $..deviceType
    ${dt_list_local}=    Create List    {{ dt_list_local | join('   ') }}
    Lists Should Be Equal    ${dt_list_remote[0]}    ${dt_list_local}    ignore_order=True    msg=device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{gre.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["if-name"]    {{ gre.interface_name_variable | default(gre.interface_name | default("not_defined")) }}    msg=interface name
    Should Be Equal Value Json String FT    ${r_id.json()}    $..description    {{ gre.interface_description_variable | default(gre.interface_description | default("not_defined")) }}    msg=interface description
    Should Be Equal Value Json String FT    ${r_id.json()}    $..shutdown    {{ gre.shutdown_variable | default(gre.shutdown | default("not_defined") | lower()) }}    msg=shutdown
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["tunnel-destination"]    {{ gre.tunnel_destination_variable | default(gre.tunnel_destination | default("not_defined")) }}    msg=tunnel destination
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["tunnel-source-interface"]    {{ gre.tunnel_source_interface_variable | default(gre.tunnel_source_interface | default("not_defined")) }}    msg=tunnel source interface
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["tunnel-source"]    {{ gre.tunnel_source_ip_variable | default(gre.tunnel_source_ip | default("not_defined")) }}    msg=tunnel source ip
    Should Be Equal Value Json String FT    ${r_id.json()}    $..ip.address    {{ gre.ip_address_variable | default(gre.ip_address | default("not_defined")) }}    msg=ip address
    Should Be Equal Value Json String FT    ${r_id.json()}    $..mtu    {{ gre.ip_mtu_variable | default(gre.ip_mtu | default("not_defined")) }}    msg=mtu
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["tcp-mss-adjust"]    {{ gre.tcp_mss_variable | default(gre.tcp_mss | default("not_defined")) }}    msg=tcp mss
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["clear-dont-fragment"]    {{ gre.clear_dont_fragment_variable | default(gre.clear_dont_fragment | default("not_defined") | lower()) }}    msg=clear dont fragment
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["rewrite-rule"]["rule-name"]    {{ gre.rewrite_rule_variable | default(gre.rewrite_rule | default("not_defined")) }}    msg=rewrite rule
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["access-list"].vipValue[?(@.direction.vipValue=="in")]..["acl-name"]    {{ gre.ipv4_ingress_access_list_variable | default(gre.ipv4_ingress_access_list | default("not_defined")) }}    msg=ipv4 ingress access list
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["access-list"].vipValue[?(@.direction.vipValue=="out")]..["acl-name"]    {{ gre.ipv4_egress_access_list_variable | default(gre.ipv4_egress_access_list | default("not_defined")) }}    msg=ipv4 egress access list
    Should Be Equal Value Json String FT    ${r_id.json()}    $..application    {{ gre.application_variable | default(gre.application | default("not_defined")) }}    msg=application

    ${rec_tracker_viptype}=    Get Value From Json    ${r_id.json()}    $.["tracker"].vipType
    IF    ${rec_tracker_viptype} != []
       ${rec_tracker}=    Get Value From Json    ${r_id.json()}    $.["tracker"].vipValue
       ${rec_tracker_variable}=    Get Value From Json    ${r_id.json()}    $.["tracker"].vipVariableName
       IF    "${rec_tracker_viptype}[0]"=="constant"
            Should Be Equal As Strings    ${rec_tracker[0][0]}    {{ gre.tracker | default("not_defined") }}    msg=tracker
       ELSE IF    "${rec_tracker_viptype}[0]"=="variableName"
            Should Be Equal As Strings    ${rec_tracker_variable[0]}    {{ gre.tracker_variable | default("not_defined") }}    msg=tracker variable
       ELSE
            Should Be Equal As Strings    not_defined    {{ gre.tracker_variable | default(g.treracker | default("not_defined")) }}    msg=tracker
       END
    ELSE
       Should Be Equal As Strings    not_defined    {{ gre.tracker_variable | default(gre.tracker | default("not_defined")) }}    msg=tracker
    END

{% endfor %}

{% endif %}