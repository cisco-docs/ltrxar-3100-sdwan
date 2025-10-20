*** Settings ***
Documentation   Verify Transport Feature Profile Configuration Cellular Profile
Name            Transport Profiles Cellular Profile
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     transport_profiles    cellular_profiles
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.transport_profiles is defined %}
{% set profile_cellular_profile_list = [] %}
{% for profile in sdwan.feature_profiles.transport_profiles %}
 {% if profile.cellular_profiles is defined %}
  {% set _ = profile_cellular_profile_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_cellular_profile_list != [] %}

*** Test Cases ***
Get Transport Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.transport_profiles | default([]) %}
{% if profile.cellular_profiles is defined %}

Verify Feature Profiles Transport Profiles {{ profile.name }} Cellular Profile Feature
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    Set Suite Variable    ${profile}
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}
    ${transport_cellular_profile_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}/cellular-profile
    Set Suite Variable    ${transport_cellular_profile_res}
    ${transport_cellular_profile}=    Get Value From Json    ${transport_cellular_profile_res.json()}    $..payload
    Run Keyword If    ${transport_cellular_profile} == []    Fail    Cellular profile feature(s) expected to be configured within the transport profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${transport_cellular_profile}

{% for cellular in profile.cellular_profiles | default([]) %}
    Log     === Cellular: {{ cellular.name }} ===
    
    # for each cellular find the corresponding one in the json and check parameters:
    ${transport_cellular_profiles_raw}=    Get Value From Json    ${transport_cellular_profile}    $[?(@.name=='{{ cellular.name }}')]
    ${transport_cellular_profiles}=    Set Variable If    ${transport_cellular_profiles_raw} == []    not_defined    ${transport_cellular_profiles_raw[0]}

    Should Be Equal Value Json String             ${transport_cellular_profiles}     $.name            {{ cellular.name }}    msg=name
    Should Be Equal Value Json Special_String     ${transport_cellular_profiles}     $..description    {{ cellular.description | default('not_defined') | normalize_special_string }}    msg=description
    
    Should Be Equal Value Json Yaml               ${transport_cellular_profiles}     $..profileConfig.profileInfo.apn    {{ cellular.access_point_name | default('not_defined') }}    {{ cellular.access_point_name_variable | default('not_defined') }}    msg=access_point_name    var_msg=access_point_name_variable
    Should Be Equal Value Json Yaml               ${transport_cellular_profiles}     $..profileConfig.profileInfo.noOverwrite    {{ cellular.no_overwrite | default('not_defined') }}    {{ cellular.no_overwrite_variable | default('not_defined') }}    msg=no_overwrite    var_msg=no_overwrite_variable
    Should Be Equal Value Json Yaml               ${transport_cellular_profiles}     $..profileConfig.profileInfo.pdnType    {{ cellular.packet_data_network_type | default('not_defined') }}    {{ cellular.packet_data_network_type_variable | default('not_defined') }}    msg=packet_data_network_type    var_msg=packet_data_network_type_variable
    Should Be Equal Value Json Yaml               ${transport_cellular_profiles}     $..profileConfig.id    {{ cellular.profile_id | default('not_defined') }}    {{ cellular.profile_id_variable | default('not_defined') }}    msg=profile_id    var_msg=profile_id_variable

    # extract authentication_enable value from json
    ${authentication_enable_js}=                  Get Value From Json                ${transport_cellular_profiles}         $..profileConfig.profileInfo.authentication.needAuthentication
    ${authentication_enable_js}=                  Set Variable If                    ${authentication_enable_js} == []      False         True
    Should Be Equal                               ${authentication_enable_js}        {{ cellular.authentication_enable | default('False') }}

    Should Be Equal Value Json Yaml               ${transport_cellular_profiles}     $..profileConfig.profileInfo.authentication.needAuthentication.type        {{ cellular.authentication_type | default('not_defined') }}    {{ cellular.authentication_type_variable | default('not_defined') }}    msg=authentication_type    var_msg=authentication_type_variable
    Should Be Equal Value Json Yaml               ${transport_cellular_profiles}     $..profileConfig.profileInfo.authentication.needAuthentication.username    {{ cellular.profile_username | default('not_defined') }}       {{ cellular.profile_username_variable | default('not_defined') }}    msg=profile_username    var_msg=profile_username_variable
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! TODO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Should Be Equal Value Json Yaml               ${transport_cellular_profiles}     $..profileConfig.profileInfo.authentication.needAuthentication.password    {{ cellular.profile_password | default('not_defined') }}    {{ cellular.profile_password_variable | default('not_defined') }}    msg=profile_password    var_msg=profile_password_variable

{% endfor %}


{% endif %}

{% endfor %}

{% endif %}

{% endif %}