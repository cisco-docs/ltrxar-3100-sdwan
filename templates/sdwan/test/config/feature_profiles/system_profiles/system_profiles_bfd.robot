*** Settings ***
Documentation   Verify System Feature Profile Configuration BFD
Name            System Profiles BFD
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_feature_profiles   bfd
Resource        ../../../sdwan_common.resource


{% set profile_bfd_list = [] %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.bfd is defined %}
  {% set _ = profile_bfd_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_bfd_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.bfd is defined %}

Verify Feature Profiles System Profiles {{ profile.name }} BFD Feature {{ profile.bfd.name | default(defaults.sdwan.feature_profiles.system_profiles.bfd.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${system_bfd_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id}[0]/bfd
    ${system_bfd}=    Get Value From Json    ${system_bfd_res.json()}    $..payload
    Set Suite Variable    ${system_bfd}
    Should Be Equal Value Json String    ${system_bfd[0]}    $..name    {{ profile.bfd.name | default(defaults.sdwan.feature_profiles.system_profiles.bfd.name) }}    msg=name
    Should Be Equal Value Json String    ${system_bfd[0]}    $..description    {{ profile.bfd.description | default(defaults.sdwan.feature_profiles.system_profiles.bfd.description) }}    msg=description

    Should Be Equal Value Json Yaml    ${system_bfd[0]}    $.data.multiplier    {{ profile.bfd.multiplier | default('not_defined')  }}    {{ profile.bfd.multiplier_variable| default('not_defined') }}     msg=multiplier    var_msg=multiplier_variable
    Should Be Equal Value Json Yaml    ${system_bfd[0]}    $.data.defaultDscp   {{ profile.bfd.default_dscp | default("not_defined") }}    {{ profile.bfd.default_dscp_variable| default('not_defined') }}     msg=default_dscp    var_msg=default_dscp_variable
    Should Be Equal Value Json Yaml    ${system_bfd[0]}    $.data.pollInterval   {{ profile.bfd.poll_interval | default("not_defined") }}    {{ profile.bfd.poll_interval_variable| default('not_defined') }}     msg=poll_interval    var_msg=poll_interval_variable

# Loop over color lists
{% if profile.bfd.colors is defined and profile.bfd.colors|length > 0 %}
Verify Feature Profiles System Profiles {{ profile.name }} BFD Feature {{ profile.bfd.name | default("not_defined") }} Color List
{% for color_entry in profile.bfd.colors | default([]) %}

    Should Be Equal Value Json Yaml    ${system_bfd[0]}    $.data.colors[{{ loop.index0 }}].color    {{ color_entry.color | default('not_defined') }}    {{ color_entry.color_variable | default('not_defined') }}    msg=color_entry_color    var_msg=color_entry_color_variable
    Should Be Equal Value Json Yaml    ${system_bfd[0]}    $.data.colors[{{ loop.index0 }}].helloInterval    {{ color_entry.hello_interval | default('not_defined') }}    {{ color_entry.hello_interval_variable | default('not_defined') }}    msg=color_entry_hello_interval    var_msg=color_entry_hello_interval_variable
    Should Be Equal Value Json Yaml    ${system_bfd[0]}    $.data.colors[{{ loop.index0 }}].multiplier    {{ color_entry.multiplier | default('not_defined') }}    {{ color_entry.multiplier_variable | default('not_defined') }}    msg=color_entry_multiplier    var_msg=color_entry_multiplier_variable
    Should Be Equal Value Json Yaml    ${system_bfd[0]}    $.data.colors[{{ loop.index0 }}].pmtuDiscovery    {{ color_entry.path_mtu_discovery | default('not_defined') }}    {{ color_entry.path_mtu_discovery_variable | default('not_defined') }}    msg=color_entry_path_mtu_discovery    var_msg=color_entry_path_mtu_discovery_variable
    Should Be Equal Value Json Yaml    ${system_bfd[0]}    $.data.colors[{{ loop.index0 }}].dscp    {{ color_entry.default_dscp | default('not_defined') }}    {{ color_entry.default_dscp_variable | default('not_defined') }}    msg=color_entry_default_dscp    var_msg=color_entry_default_dscp_variable

{% endfor %}
{% endif %}


{% endif %}
{% endfor %}

{% endif %}
