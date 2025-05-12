*** Settings ***
Documentation   Verify DHCP Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.dhcp_server_templates is defined%}

*** Test Cases ***
Get DHCP Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_dhcp_server")]
    Set Suite Variable    ${r}

{% for dhcp_template in sdwan.edge_feature_templates.dhcp_server_templates | default([]) %}

Verify Edge Feature Template DHCP Feature template {{ dhcp_template.name }}
    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ dhcp_template.name }}")]
    Should Be Equal Value Json String    ${template_id}    $..templateName    {{ dhcp_template.name }}    msg=name
    Should Be Equal Value Json Special_String    ${template_id}    $..templateDescription    {{ dhcp_template.description | normalize_special_string }}    msg=description

{% set test_list = [] %}
{% for item in dhcp_template.device_types | default(defaults.sdwan.edge_feature_templates.dhcp_server_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${template_id}    $..deviceType
    ${test_list}=   Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device types

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ dhcp_template.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["address-pool"]    {{ dhcp_template.address_pool_variable | default(dhcp_template.address_pool | default("not_defined")) }}    msg=address pool
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["default-gateway"]    {{ dhcp_template.default_gateway_variable | default(dhcp_template.default_gateway | default("not_defined")) }}    msg=default gateway
    
    ${dns_servers_value}=    Create List    {{ dhcp_template.dns_servers_variable | default(dhcp_template.dns_servers | default(["not_defined"]) | join('   ')) }}
    Should Be Equal Value Json List FT    ${r_id.json()}    $..["dns-servers"]    ${dns_servers_value}    msg=dns servers
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["domain-name"]    {{ dhcp_template.domain_name_variable | default(dhcp_template.domain_name | default("not_defined")) }}    msg=domain name

{% set exclude_addresses_range_list = [] %}
{% for item in dhcp_template.exclude_addresses_ranges | default([]) %}
{% set test_list = [] %}
{% set _ = test_list.append(item.from) %}
{% set _ = test_list.append(item.to) %}
{% set exclude_addresses_test = '-'.join(test_list | map('string')) %}
{% set _ = exclude_addresses_range_list.append(exclude_addresses_test) %}
{% endfor %}

{% if dhcp_template.exclude_addresses is defined and dhcp_template.exclude_addresses_ranges is defined%}
{% set req_addresses = dhcp_template.exclude_addresses  %}
{% set address_string = req_addresses | map('string') | join(',') %}
{% set new_addresses_list = address_string.split(',') %}
{% set exclude_addresses_list = new_addresses_list + exclude_addresses_range_list %}
    ${list}=   Create List   {{ exclude_addresses_list | join('   ') }}
    ${rec_exclude_addresses}=    Get Value From Json    ${r_id.json()}    $..exclude.vipValue
    Lists Should Be Equal    ${rec_exclude_addresses}[0]    ${list}    msg=exclude addresses and ranges
{% elif dhcp_template.exclude_addresses is defined %}
    ${list}=   Create List   {{ dhcp_template.exclude_addresses | join('   ') }}
    ${rec_exclude_addresses}=    Get Value From Json    ${r_id.json()}    $..exclude.vipValue
    Lists Should Be Equal    ${rec_exclude_addresses}[0]    ${list}    msg=exclude addresses
{% elif dhcp_template.exclude_addresses_ranges is defined %}
    ${list} =   Create List   {{ exclude_addresses_range_list | join('   ') }}
    ${rec_exclude_addresses}=    Get Value From Json    ${r_id.json()}    $..exclude.vipValue
    Lists Should Be Equal    ${rec_exclude_addresses}[0]    ${list}    msg=exclude addresses ranges
{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["exclude"].vipVariableName    {{ dhcp_template.exclude_addresses_variable | default("not_defined") }}    msg=exclude addresses variable
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["interface-mtu"]    {{ dhcp_template.interface_mtu_variable | default(dhcp_template.interface_mtu | default("not_defined")) }}    msg=interface mtu
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["lease-time"]    {{ dhcp_template.lease_time_variable | default(dhcp_template.lease_time | default("not_defined")) }}    msg=lease time

    Should Be Equal Value Json List Length    ${r_id.json()}   $..["options"]["option-code"].vipValue    {{ dhcp_template.options | length }}    msg=options

{% for option in dhcp_template.options | default([]) %}

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].code    {{ option.option_code_variable | default(option.option_code | default("not_defined")) }}    msg=option code
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].ascii    {{ option.ascii_variable | default(option.ascii | default("not_defined")) }}    msg=ascii
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].hex    {{ option.hex_variable | default(option.hex | default("not_defined")) }}    msg=hex
    ${option_ip_addresses_value}=    Create List    {{ option.ip_addresses_variable | default(option.ip_addresses | default(["not_defined"]) | join('   ')) }}
    Should Be Equal Value Json List FT    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].ip    ${option_ip_addresses_value}    msg=option ip addresses

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}   $..["static-lease"].vipValue    {{ dhcp_template.static_leases | length }}    msg=static lease

{% for static_lease in dhcp_template.static_leases | default([]) %}

    Should Be Equal Value Json String FT    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}].ip    {{ static_lease.ip_address_variable | default(static_lease.ip_address | default("not_defined")) }}    msg=ip address
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}]["mac-address"]    {{ static_lease.mac_address_variable | default(static_lease.mac_address | default("not_defined")) }}    msg=mac address
    Should Be Equal Value Json String FT    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}]["host-name"]    {{ static_lease.hostname_variable | default(static_lease.hostname | default("not_defined")) }}    msg=hostname
    Should Be Equal Value Json String    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}]["vipOptional"]    {{ static_lease.optional | default("not_defined") }}    msg=optional

{% endfor %}

    ${tftp_servers_value}=    Create List    {{ dhcp_template.tftp_servers_variable | default(dhcp_template.tftp_servers | default(["not_defined"]) | join('   ')) }}
    Should Be Equal Value Json List FT    ${r_id.json()}    $..["tftp-servers"]    ${tftp_servers_value}    msg=tftp servers

{% endfor %}

{% endif %}
