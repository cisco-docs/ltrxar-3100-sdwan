*** Settings ***
Documentation   Verify Other Feature Profile Configuration UCSE
Name            Other Profiles UCSE
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles    other_profiles    ucse
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.other_profiles is defined %}
{% set profile_ucse_list = [] %}
{% for profile in sdwan.feature_profiles.other_profiles %}
 {% if profile.ucse is defined %}
  {% set _ = profile_ucse_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_ucse_list != [] %}

*** Test Cases ***
Get Other Profiles
    ${r}=    Get On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/other
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.other_profiles | default([]) %}

{% if profile.ucse is defined %}

Verify Feature Profiles Other Profiles {{ profile.name }} UCSE Feature {{ profile.ucse.name | default(defaults.sdwan.feature_profiles.other_profiles.ucse.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager   
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${other_ucse_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/other/${profile_id}[0]/ucse
    ${other_ucse}=    Get Value From Json    ${other_ucse_res.json()}    $..payload
    Run Keyword If    ${other_ucse} == []    Fail    Feature '{{ profile.ucse.name | default(defaults.sdwan.feature_profiles.other_profiles.ucse.name) }}' expected to be configured within the other profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${other_ucse}

    Should Be Equal Value Json String    ${other_ucse[0]}    $.name    {{ profile.ucse.name | default(defaults.sdwan.feature_profiles.other_profiles.ucse.name) }}    msg=name
    Should Be Equal Value Json Special_String    ${other_ucse[0]}    $.description    {{ profile.ucse.description | default('not_defined') | normalize_special_string }}    msg=description
    Should Be Equal Value Json String    ${other_ucse[0]}    $..bay.value    {{ profile.ucse.bay | default('not_defined') }}    msg=bay
    Should Be Equal Value Json String    ${other_ucse[0]}    $..slot.value    {{ profile.ucse.slot | default('not_defined') }}    msg=slot
    Should Be Equal Value Json String    ${other_ucse[0]}    $..imc.access-port.dedicated.value    {{ profile.ucse.cimc_access_port_dedicated | default('not_defined') }}    msg=access_port_dedicated
    Should Be Equal Value Json String    ${other_ucse[0]}    $..imc.access-port.sharedLom.lomType.value    {{ profile.ucse.cimc_access_port_shared_type | default('not_defined') }}    msg=cimc_access_port_shared_type
    Should Be Equal Value Json String    ${other_ucse[0]}    $..imc.access-port.sharedLom.failOverType.value   {{ profile.ucse.cimc_access_port_shared_failover_type | default('not_defined') }}    msg=cimc_access_port_shared_failover_type
    Should Be Equal Value Json Yaml    ${other_ucse[0]}    $..imc.ip.address   {{ profile.ucse.cimc_ipv4_address | default('not_defined') }}    {{ profile.ucse.cimc_ipv4_address_variable | default('not_defined') }}    msg=cimc_ipv4_address    var_msg=cimc_ipv4_address_variable
    Should Be Equal Value Json Yaml    ${other_ucse[0]}    $..imc.ip.defaultGateway   {{ profile.ucse.cimc_default_gateway | default('not_defined') }}    {{ profile.ucse.cimc_default_gateway_variable | default('not_defined') }}    msg=cimc_default_gateway    var_msg=cimc_default_gateway_variable
    Should Be Equal Value Json Yaml    ${other_ucse[0]}    $..vlanId    {{ profile.ucse.cimc_vlan_id | default('not_defined') }}    {{ profile.ucse.cimc_vlan_id_variable | default('not_defined') }}    msg=cimc_vlan_id    var_msg=cimc_vlan_id_variable
    Should Be Equal Value Json Yaml    ${other_ucse[0]}    $..priority   {{ profile.ucse.cimc_assign_priority | default('not_defined') }}    {{ profile.ucse.cimc_assign_priority_variable | default('not_defined') }}    msg=cimc_assign_priority    var_msg=cimc_assign_priority_variable
    
    Should Be Equal Value Json List Length    ${other_ucse[0]}   $..interface    {{ profile.ucse.get('interfaces', []) | length }}    msg=interfaces_count

{% if profile.ucse.interfaces is defined and profile.ucse.get('interfaces', [])|length > 0 %}
    Log  === UCSE Interfaces ===
{% for interfaces in profile.ucse.interfaces | default([]) %}
    Should Be Equal Value Json Yaml    ${other_ucse[0]}    $..interface[{{ loop.index0 }}].ifName    {{ interfaces.interface_name | default('not_defined') }}    {{ interfaces.interface_name_variable | default('not_defined') }}    msg=ucse_interface_name    var_msg=ucse_interface_name_variable    
    Should Be Equal Value Json Yaml    ${other_ucse[0]}    $..interface[{{ loop.index0 }}].ucseInterfaceVpn    {{ interfaces.vpn_id | default('not_defined') }}    {{ interfaces.vpn_id_variable | default('not_defined') }}    msg=ucse_vpn_id    var_msg=ucse_vpn_id_variable
    Should Be Equal Value Json Yaml    ${other_ucse[0]}    $..interface[{{ loop.index0 }}].address    {{ interfaces.ipv4_address | default('not_defined') }}    {{ interfaces.ipv4_address_variable | default('not_defined') }}    msg=ucse_ipv4_address    var_msg=ucse_ipv4_address_variable
{% endfor %}
{% endif %}
{% endif %}
{% endfor %}
{% endif %}

{% endif %}