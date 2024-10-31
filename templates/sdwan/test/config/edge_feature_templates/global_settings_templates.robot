*** Settings ***
Documentation   Verify Global Settings Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.global_settings_templates is defined %}

*** Test Cases ***
Get Global Settings Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cedge_global")]
    Set Suite Variable    ${r}

{% for gs_template in sdwan.edge_feature_templates.global_settings_templates | default([]) %}

Verify Edge Feature Template Global Settings Feature template {{ gs_template.name }}
    ${gs_template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{gs_template.name }}")]
    Should Be Equal Value Json String    ${gs_template_id}    $..templateName    {{ gs_template.name }}    msg=name
    Should Be Equal Value Json String    ${gs_template_id}    $..templateDescription    {{ gs_template.description }}    msg=description

{% set test_list = [] %}
{% for item in gs_template.device_types | default(defaults.sdwan.edge_feature_templates.global_settings_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${gs_template_id}    $..deviceType
    ${test_lists}=   Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_lists}    ignore_order=True    msg=device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{gs_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["arp-proxy"].vipValue    {{ gs_template.arp_proxy | default("not_defined") | lower }}    msg=arp proxy
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["arp-proxy"].vipVariableName    {{ gs_template.arp_proxy_variable | default("not_defined") }}    msg=arp proxy variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"].cdp.vipValue    {{ gs_template.cdp | default("not_defined") | lower }}    msg=cdp
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"].cdp.vipVariableName    {{ gs_template.cdp_variable | default("not_defined") }}    msg=cdp variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["console-logging"].vipValue    {{ gs_template.console_logging | default("not_defined") | lower }}    msg=console logging
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["console-logging"].vipVariableName    {{ gs_template.console_logging_variable | default("not_defined") }}    msg=console logging variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["domain-lookup"].vipValue    {{ gs_template.domain_lookup | default("not_defined") | lower }}    msg=domain lookup
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["domain-lookup"].vipVariableName    {{ gs_template.domain_lookup_variable | default("not_defined") }}    msg=domain lookup variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["ftp-passive"].vipValue    {{ gs_template.ftp_passive | default("not_defined") | lower }}    msg=ftp passive
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["ftp-passive"].vipVariableName    {{ gs_template.ftp_passive_variable | default("not_defined") }}    msg=ftp passive variable
    Should Be Equal Value Json String    ${r_id.json()}    $["http-global"]..["http-authentication"].vipValue    {{ gs_template.http_authentication | default("not_defined") }}    msg=http authentication
    Should Be Equal Value Json String    ${r_id.json()}    $["http-global"]..["http-authentication"].vipVariableName    {{ gs_template.http_authentication_variable | default("not_defined") }}    msg=http authentication variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["http-server"].vipValue    {{ gs_template.http_server | default("not_defined") | lower }}    msg=http server
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["http-server"].vipVariableName    {{ gs_template.http_server_variable | default("not_defined") }}    msg=http server variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["https-server"].vipValue    {{ gs_template.https_server | default("not_defined") | lower }}    msg=https server
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["https-server"].vipVariableName    {{ gs_template.https_server_variable | default("not_defined") }}    msg=https server variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"].bootp.vipValue    {{ gs_template.ignore_bootp | default("not_defined") | lower }}    msg=ignore bootp
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"].bootp.vipVariableName    {{ gs_template.ignore_bootp_variable | default("not_defined") }}    msg=ignore bootp variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["source-route"].vipValue    {{ gs_template.ip_source_routing | default("not_defined") | lower }}    msg=ip source routing
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["source-route"].vipVariableName    {{ gs_template.ip_source_routing_variable | default("not_defined") }}    msg=ip source routing variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"].lldp.vipValue    {{ gs_template.lldp | default("not_defined") | lower }}    msg=lldp
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"].lldp.vipVariableName    {{ gs_template.lldp_variable | default("not_defined") }}    msg=lldp variable
    Should Be Equal Value Json String    ${r_id.json()}    $["nat64-global"]..["nat64-timeout"]..["udp-timeout"].vipValue    {{ gs_template.nat64_udp_timeout | default("not_defined") }}    msg=nat64 udp timeout
    Should Be Equal Value Json String    ${r_id.json()}    $["nat64-global"]..["nat64-timeout"]..["udp-timeout"].vipVariableName    {{ gs_template.nat64_udp_timeout_variable | default("not_defined") }}    msg=nat64 udp timeout variable
    Should Be Equal Value Json String    ${r_id.json()}    $["nat64-global"]..["nat64-timeout"]..["tcp-timeout"].vipValue    {{ gs_template.nat64_tcp_timeout | default("not_defined") }}    msg=nat64 tcp timeout
    Should Be Equal Value Json String    ${r_id.json()}    $["nat64-global"]..["nat64-timeout"]..["tcp-timeout"].vipVariableName    {{ gs_template.nat64_tcp_timeout_variable | default("not_defined") }}    msg=nat64 tcp timeout variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"].rcmd.vipValue    {{ gs_template.rsh_rcp | default("not_defined") | lower }}    msg=rsh rcp
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"].rcmd.vipVariableName    {{ gs_template.rsh_rcp_variable | default("not_defined") }}    msg=rsh rcp variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["snmp-ifindex-persist"].vipValue    {{ gs_template.snmp_ifindex_persist | default("not_defined") | lower }}    msg=snmp ifindex persist
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["snmp-ifindex-persist"].vipVariableName    {{ gs_template.snmp_ifindex_persist_variable | default("not_defined") }}    msg=snmp ifindex persist variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["source-intrf"].vipValue    {{ gs_template.source_interface | default("not_defined") }}    msg=source interface
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["source-intrf"].vipVariableName    {{ gs_template.source_interface_variable | default("not_defined") }}    msg=source interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ssh.version.vipValue    {{ gs_template.ssh_version | default("not_defined") }}    msg=ssh version
    Should Be Equal Value Json String    ${r_id.json()}    $.ssh.version.vipVariableName    {{ gs_template.ssh_version_variable | default("not_defined") }}    msg=ssh version variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["tcp-keepalives-in"].vipValue    {{ gs_template.tcp_keepalives_in | default("not_defined") | lower }}    msg=tcp keepalives in
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["tcp-keepalives-in"].vipVariableName    {{ gs_template.tcp_keepalives_in_variable | default("not_defined") }}    msg=tcp keepalives in variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["tcp-keepalives-out"].vipValue    {{ gs_template.tcp_keepalives_out | default("not_defined") | lower }}    msg=tcp keepalives out
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["tcp-keepalives-out"].vipVariableName    {{ gs_template.tcp_keepalives_out_variable | default("not_defined") }}    msg=tcp keepalives out variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["tcp-small-servers"].vipValue    {{ gs_template.tcp_small_servers | default("not_defined") | lower }}    msg=tcp small servers
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["tcp-small-servers"].vipVariableName    {{ gs_template.tcp_small_servers_variable | default("not_defined") }}    msg=tcp small servers variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["line-vty"].vipValue    {{ gs_template.telnet_outbound | default("not_defined") | lower }}    msg=telnet outbound
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-ip"]..["line-vty"].vipVariableName    {{ gs_template.telnet_outbound_variable | default("not_defined") }}    msg=telnet outbound variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["udp-small-servers"].vipValue    {{ gs_template.udp_small_servers | default("not_defined") | lower }}    msg=udp small servers
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["udp-small-servers"].vipVariableName    {{ gs_template.udp_small_servers_variable | default("not_defined") }}    msg=udp small servers variable
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["vty-logging"].vipValue    {{ gs_template.vty_logging | default("not_defined") | lower }}    msg=vty logging
    Should Be Equal Value Json String    ${r_id.json()}    $["services-global"]..["services-other"]..["vty-logging"].vipVariableName    {{ gs_template.vty_logging_variable | default("not_defined") }}    msg=vty logging variable

{% endfor %}

{% endif %}
