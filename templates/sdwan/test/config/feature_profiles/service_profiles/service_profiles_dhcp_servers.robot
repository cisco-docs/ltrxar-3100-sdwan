*** Settings ***
Documentation   Verify Service Feature Profile Configuration DHCP Server
Name            Service Profiles DHCP Server
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     service_profiles    dhcp_servers
Resource        ../../../sdwan_common.resource


{% set profile_dhcp_server_list = [] %}
{% for profile in sdwan.feature_profiles.service_profiles %}
 {% if profile.dhcp_servers is defined %}
  {% set _ = profile_dhcp_server_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_dhcp_server_list != [] %}

*** Test Cases ***
Get Service Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service
    Set Suite Variable    ${r}


{% for profile in sdwan.feature_profiles.service_profiles | default([]) %}
{% if profile.dhcp_servers is defined %}

Verify Feature Profiles Service Profiles {{ profile.name }} DHCP Server Feature
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    Set Suite Variable    ${profile}
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    Set Suite Variable    ${profile_id}
    ${service_dhcp_server_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}/dhcp-server
    Set Suite Variable    ${service_dhcp_server_res}
    ${service_dhcp_server}=    Get Value From Json    ${service_dhcp_server_res.json()}    $..payload
    Run Keyword If    ${service_dhcp_server} == []    Fail    DHCP server feature(s) expected to be configured within the service profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${service_dhcp_server}

{% for dhcp_server in profile.dhcp_servers | default([]) %}
    Log     === DHCP Server: {{ dhcp_server.name }} ===

    # for each dhcp server find the corresponding one in the json and check parameters:
    ${service_dhcp_servers_raw}=    Get Value From Json    ${service_dhcp_server}    $[?(@.name=='{{ dhcp_server.name }}')]
    ${service_dhcp_servers}=    Set Variable If    ${service_dhcp_servers_raw} == []    not_defined    ${service_dhcp_servers_raw}[0]

    Should Be Equal Value Json String     ${service_dhcp_servers}             $.name            {{ dhcp_server.name }}    msg=name
    Should Be Equal Value Json Special_String     ${service_dhcp_servers}     $..description    {{ dhcp_server.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..addressPool.networkAddress    {{ dhcp_server.pool_network_address | default('not_defined') }}    {{ dhcp_server.pool_network_address_variable | default('not_defined') }}    msg=pool_network_address    var_msg=pool_network_address_variable
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..addressPool.subnetMask        {{ dhcp_server.pool_subnet_mask | default('not_defined') }}    {{ dhcp_server.pool_subnet_mask_variable | default('not_defined') }}    msg=pool_subnet_mask    var_msg=pool_subnet_mask_variable
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..defaultGateway                {{ dhcp_server.default_gateway | default('not_defined') }}    {{ dhcp_server.default_gateway_variable | default('not_defined') }}    msg=default_gateway    var_msg=default_gateway_variable

    ${dns_server_list}=    Create List    {{ dhcp_server.get('dns_servers', []) | join('   ') }}
    ${dns_server_list}=    Set Variable If    ${dns_server_list} == []    not_defined    ${dns_server_list}
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..dnsServers          ${dns_server_list}    {{ dhcp_server.dns_servers_variable | default('not_defined') }}    msg=dns_servers    var_msg=dns_servers_variable
    
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..domainName                {{ dhcp_server.domain_name | default('not_defined') }}    {{ dhcp_server.domain_name_variable | default('not_defined') }}    msg=domain_name    var_msg=domain_name_variable

    ${exclude_address_list}=    Create List    {{ dhcp_server.get('exclude_addresses', []) | join('   ') }}
    ${exclude_address_list}=    Set Variable If    ${exclude_address_list} == []    not_defined    ${exclude_address_list}
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..exclude          ${exclude_address_list}    {{ dhcp_server.exclude_addresses_variable | default('not_defined') }}    msg=exclude_addresses    var_msg=exclude_addresses_variable

    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..interfaceMtu                {{ dhcp_server.interface_mtu | default('not_defined') }}    {{ dhcp_server.interface_mtu_variable | default('not_defined') }}    msg=interface_mtu    var_msg=interface_mtu_variable
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..leaseTime                {{ dhcp_server.lease_time | default('not_defined') }}    {{ dhcp_server.lease_time_variable | default('not_defined') }}    msg=lease_time    var_msg=lease_time_variable

    Should Be Equal Value Json List Length    ${service_dhcp_servers}    $..optionCode    {{ dhcp_server.get('options', []) | length }}    msg=options length
{% if dhcp_server.get('options', []) | length > 0 %}
    Log     === Options List ===
{% for option in dhcp_server.options | default([]) %}

    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..optionCode[{{ loop.index0 }}].code      {{ option.code | default('not_defined') }}      {{ option.code_variable | default('not_defined') }}     msg=code        var_msg=code_variable
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..optionCode[{{ loop.index0 }}].ascii     {{ option.ascii | default('not_defined') }}     {{ option.ascii_variable | default('not_defined') }}    msg=ascii       var_msg=ascii_variable
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..optionCode[{{ loop.index0 }}].hex       {{ option.hex | default('not_defined') }}       {{ option.hex_variable | default('not_defined') }}      msg=hex         var_msg=hex_variable

    ${ip_address_list}=    Create List    {{ option.get('ip_addresses', []) | join('   ') }}
    ${ip_address_list}=    Set Variable If    ${ip_address_list} == []    not_defined    ${ip_address_list}
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..optionCode[{{ loop.index0 }}].ip          ${ip_address_list}    {{ option.ip_addresses_variable | default('not_defined') }}    msg=ip_addresses    var_msg=ip_addresses_variable

{% endfor %}
{% endif %}

    Should Be Equal Value Json List Length    ${service_dhcp_servers}    $..staticLease    {{ dhcp_server.get('static_leases', []) | length }}    msg=static_leases length
{% if dhcp_server.get('static_leases', []) | length > 0 %}
    Log     === Static Leases List ===
{% for static_lease in dhcp_server.static_leases | default([]) %}

    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..staticLease[{{ loop.index0 }}].ip              {{ static_lease.ip_address | default('not_defined') }}      {{ static_lease.ip_address_variable | default('not_defined') }}     msg=ip_address        var_msg=ip_address_variable
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..staticLease[{{ loop.index0 }}].macAddress      {{ static_lease.mac_address | default('not_defined') }}      {{ static_lease.mac_address_variable | default('not_defined') }}     msg=mac_address        var_msg=mac_address_variable

{% endfor %}
{% endif %}

    ${tftp_server_list}=    Create List    {{ dhcp_server.get('tftp_servers', []) | join('   ') }}
    ${tftp_server_list}=    Set Variable If    ${tftp_server_list} == []    not_defined    ${tftp_server_list}
    Should Be Equal Value Json Yaml    ${service_dhcp_servers}    $..tftpServers          ${tftp_server_list}    {{ dhcp_server.tftp_servers_variable | default('not_defined') }}    msg=tftp_servers    var_msg=tftp_servers_variable


{% endfor %}

{% endif %}

{% endfor %}

{% endif %}