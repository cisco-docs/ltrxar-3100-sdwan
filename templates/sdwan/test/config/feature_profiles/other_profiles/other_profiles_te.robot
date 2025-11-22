*** Settings ***
Documentation   Verify Other Feature Profile Configuration TE
Name            Other Profiles Thousandeyes
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles    other_profiles   thousandeyes
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.other_profiles is defined %}
{% set profile_te_list = [] %}
{% for profile in sdwan.feature_profiles.other_profiles %}
 {% if profile.thousandeyes is defined %}
  {% set _ = profile_te_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_te_list != [] %}

*** Test Cases ***
Get Other Profiles
    ${r}=    Get On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/other
    Set Suite Variable   ${r}

{% for profile in sdwan.feature_profiles.other_profiles | default([]) %}
{% if profile.thousandeyes is defined %}

Verify Feature Profiles Other Profiles {{ profile.name }} Thousandeyes Feature {{ profile.thousandeyes.name | default(defaults.sdwan.feature_profiles.other_profiles.thousandeyes.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${other_thousandeyes_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/other/${profile_id}[0]/thousandeyes
    ${other_thousandeyes}=    Get Value From Json    ${other_thousandeyes_res.json()}    $..payload
    Run Keyword If    ${other_thousandeyes} == []    Fail    Feature '{{ profile.thousandeyes.name | default(defaults.sdwan.feature_profiles.other_profiles.thousandeyes.name) }}' expected to be configured within the other profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${other_thousandeyes}
    Should Be Equal Value Json String    ${other_thousandeyes[0]}    $.name    {{ profile.thousandeyes.name | default(defaults.sdwan.feature_profiles.other_profiles.thousandeyes.name) }}    msg=name
    Should Be Equal Value Json Special_String    ${other_thousandeyes[0]}    $.description    {{ profile.thousandeyes.description | default('not_defined') | normalize_special_string }}    msg=description
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..token    {{ profile.thousandeyes.account_group_token | default('not_defined') }}    {{ profile.thousandeyes.account_group_token_variable | default('not_defined') }}    msg=account_group_token    var_msg=account_group_token_variable
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..vpn    {{ profile.thousandeyes.vpn_id | default('not_defined') }}    {{ profile.thousandeyes.vpn_id_variable | default('not_defined') }}    msg=vpn    var_msg=vpn_variable
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..teMgmtIp   {{ profile.thousandeyes.management_ip | default('not_defined') }}    {{ profile.thousandeyes.management_ip_variable | default('not_defined') }}    msg=management_ip    var_msg=management_ip_variable
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..teMgmtSubnetMask   {{ profile.thousandeyes.management_subnet_mask | default('not_defined') }}    {{ profile.thousandeyes.management_subnet_mask_variable | default('not_defined') }}    msg=management_subnet_mask    var_msg=management_subnet_mask_variable
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..teVpgIp    {{ profile.thousandeyes.agent_default_gateway | default('not_defined') }}    {{ profile.thousandeyes.agent_default_gateway_variable | default('not_defined') }}    msg=agent_default_gateway    var_msg=agent_default_gateway_variable
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..nameServer    {{ profile.thousandeyes.name_server_ip | default('not_defined') }}    {{ profile.thousandeyes.name_server_ip_variable | default('not_defined') }}    msg=name_server_ip   var_msg=name_server_ip_variable
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..hostname    {{ profile.thousandeyes.hostname | default('not_defined') }}    {{ profile.thousandeyes.hostname_variable | default('not_defined') }}    msg=hostname   var_msg=hostname_variable
    Should Be Equal Value Json String    ${other_thousandeyes[0]}    $..proxyType.value    {{ profile.thousandeyes.proxy_type | default('not_defined') }}    msg=proxy_type
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..proxyHost    {{ profile.thousandeyes.static_proxy_host | default('not_defined') }}    {{ profile.thousandeyes.static_proxy_host_variable | default('not_defined') }}    msg=static_proxy_host   var_msg=static_proxy_host_variable
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..proxyPort    {{ profile.thousandeyes.static_proxy_port | default('not_defined') }}    {{ profile.thousandeyes.static_proxy_port_variable | default('not_defined') }}    msg=static_proxy_port  var_msg=static_proxy_port_variable
    Should Be Equal Value Json Yaml    ${other_thousandeyes[0]}    $..pacUrl    {{ profile.thousandeyes.pac_proxy_url | default('not_defined') }}    {{ profile.thousandeyes.pac_proxy_url_variable | default('not_defined') }}    msg=pac_proxy_url  var_msg=pac_proxy_url_variable

{% endif %}
{% endfor %}
{% endif %}

{% endif %}