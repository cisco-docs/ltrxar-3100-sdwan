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
    Should Be Equal Value Json String    ${template_id}    $..templateDescription    {{ dhcp_template.description }}    msg=description

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

    Should Be Equal Value Json String    ${r_id.json()}    $..["address-pool"].vipValue    {{ dhcp_template.address_pool | default("not_defined") }}    msg=address pool
    Should Be Equal Value Json String    ${r_id.json()}    $..["address-pool"].vipVariableName    {{ dhcp_template.address_pool_variable | default("not_defined") }}    msg=address pool variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["default-gateway"].vipValue    {{ dhcp_template.default_gateway | default("not_defined") }}    msg=default gateway
    Should Be Equal Value Json String    ${r_id.json()}    $..["default-gateway"].vipVariableName    {{ dhcp_template.default_gateway_variable | default("not_defined") }}    msg=default gateway variable

{% if dhcp_template.dns_servers | default("not_defined") == 'not_defined' %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["dns-servers"].vipValue    {{ dhcp_template.dns_servers | default("not_defined") }}    msg=dns servers
{% else %}
    ${rec_dns_servers}=    Get Value From Json    ${r_id.json()}    $..["dns-servers"].vipValue
    ${dns_servers_list}=    Create List    {{ dhcp_template.dns_servers | default(["not_defined"]) | join('   ') }}
    Lists Should Be Equal    ${rec_dns_servers}    ${dns_servers_list}    ignore_order=True    msg=dns servers
{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["dns-servers"].vipVariableName    {{ dhcp_template.dns_servers_variable | default("not_defined") }}    msg=dns servers variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["domain-name"].vipValue    {{ dhcp_template.domain_name | default("not_defined") }}    msg=domain name
    Should Be Equal Value Json String    ${r_id.json()}    $..["domain-name"].vipVariableName    {{ dhcp_template.domain_name_variable | default("not_defined") }}    msg=domain name variable

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
    Should Be Equal Value Json String    ${r_id.json()}    $..["interface-mtu"].vipValue    {{ dhcp_template.interface_mtu | default("not_defined") }}    msg=interface mtu
    Should Be Equal Value Json String    ${r_id.json()}    $..["interface-mtu"].vipVariableName    {{ dhcp_template.interface_mtu_variable | default("not_defined") }}    msg=interface mtu variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["lease-time"].vipValue    {{ dhcp_template.lease_time | default("not_defined") }}    msg=lease time
    Should Be Equal Value Json String    ${r_id.json()}    $..["lease-time"].vipVariableName    {{ dhcp_template.lease_time_variable | default("not_defined") }}    msg=lease time variable

    Should Be Equal Value Json List Length    ${r_id.json()}   $..["options"]["option-code"].vipValue    {{ dhcp_template.options | length }}    msg=options

{% for option in dhcp_template.options | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].code.vipValue    {{ option.option_code | default("not_defined") }}    msg=option code
    Should Be Equal Value Json String    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].code.vipVariableName    {{ option.option_code_variable | default("not_defined") }}    msg=option code variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].ascii.vipValue    {{ option.ascii | default("not_defined") }}    msg=ascii
    Should Be Equal Value Json String    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].ascii.vipVariableName    {{ option.ascii_variable | default("not_defined") }}    msg=ascii variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].hex.vipValue    {{ option.hex | default("not_defined") }}    msg=hex
    Should Be Equal Value Json String    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].hex.vipVariableName    {{ option.hex_variable | default("not_defined") }}    msg=hex variable

{% if option.ip_addresses | default("not_defined") == 'not_defined' %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].ip.vipValue    {{ option.ip_addresses | default("not_defined") }}    msg=ip addresses
{% else %}
    ${rec_ip_addresses}=    Get Value From Json    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].ip.vipValue
    ${exp_ip_addresses}=   Create List    {{ option.ip_addresses | default(["not_defined"]) | join('   ') }}
    Lists Should Be Equal   ${rec_ip_addresses}   ${exp_ip_addresses}   ignore_order=True   msg=ip addresses
{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["options"]["option-code"].vipValue[{{loop.index0}}].ip.vipVariableName    {{ option.ip_addresses_variable | default("not_defined") }}    msg=ip addresses variable

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}   $..["static-lease"].vipValue    {{ dhcp_template.static_leases | length }}    msg=static lease

{% for static_lease in dhcp_template.static_leases | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}].ip.vipValue    {{ static_lease.ip_address | default("not_defined") }}    msg=ip address
    Should Be Equal Value Json String    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}].ip.vipVariableName    {{ static_lease.ip_address_variable | default("not_defined") }}    msg=ip address variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}]["mac-address"].vipValue    {{ static_lease.mac_address | default("not_defined") }}    msg=mac address
    Should Be Equal Value Json String    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}]["mac-address"].vipVariableName    {{ static_lease.mac_address_variable | default("not_defined") }}    msg=mac address variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}]["host-name"].vipValue    {{ static_lease.hostname | default("not_defined") }}    msg=hostname
    Should Be Equal Value Json String    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}]["host-name"].vipVariableName    {{ static_lease.hostname_variable | default("not_defined") }}    msg=hostname variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["static-lease"].vipValue[{{loop.index0}}]["vipOptional"]    {{ static_lease.optional | default("not_defined") }}    msg=optional

{% endfor %}

{% if dhcp_template.tftp_servers | default("not_defined") == 'not_defined' %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["tftp-servers"].vipValue    {{ dhcp_template.tftp_servers | default("not_defined") }}    msg=tftp servers
{% else %}
    ${tftp_servers}=    Get Value From Json    ${r_id.json()}    $..["tftp-servers"].vipValue
    ${exp_tftp_servers}=   Create List    {{ dhcp_template.tftp_servers | default(["not_defined"]) | join('   ') }}
    Lists Should Be Equal   ${tftp_servers[0]}   ${exp_tftp_servers}   ignore_order=True   msg=tftp servers
{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["tftp-servers"].vipVariableName    {{ dhcp_template.tftp_servers_variable | default("not_defined") }}    msg=tftp servers variable

{% endfor %}

{% endif %}
