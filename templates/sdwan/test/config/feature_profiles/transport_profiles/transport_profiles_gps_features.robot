*** Settings ***
Documentation   Verify Transport Feature Profile Configuration GPS Feature
Name            Transport Profiles GPS Feature
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     transport_profiles    gps_features
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.transport_profiles is defined %}
{% set profile_gps_feature_list = [] %}
{% for profile in sdwan.feature_profiles.transport_profiles %}
 {% if profile.gps_features is defined %}
  {% set _ = profile_gps_feature_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_gps_feature_list != [] %}

*** Test Cases ***
Get Transport Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.transport_profiles | default([]) %}
{% if profile.gps_features is defined %}

Verify Feature Profiles Transport Profiles {{ profile.name }} GPS Feature
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    Set Suite Variable    ${profile}
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}
    ${transport_gps_feature_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}/gps
    Set Suite Variable    ${transport_gps_feature_res}
    ${transport_gps_feature}=    Get Value From Json    ${transport_gps_feature_res.json()}    $..payload
    Run Keyword If    ${transport_gps_feature} == []    Fail    GPS feature(s) expected to be configured within the transport profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${transport_gps_feature}

{% for gps_feature in profile.gps_features | default([]) %}
    Log     === GPS: {{ gps_feature.name }} ===

     # for each gps feature find the corresponding one in the json and check parameters:
    ${transport_gps_features_raw}=    Get Value From Json    ${transport_gps_feature}    $[?(@.name=='{{ gps_feature.name }}')]
    ${transport_gps_features}=    Set Variable If    ${transport_gps_features_raw} == []    not_defined    ${transport_gps_features_raw[0]}

    Should Be Equal Value Json String             ${transport_gps_features}     $.name            {{ gps_feature.name }}    msg=name
    Should Be Equal Value Json Special_String     ${transport_gps_features}     $..description    {{ gps_feature.description | default('not_defined') | normalize_special_string }}    msg=description
    
    Should Be Equal Value Json Yaml               ${transport_gps_features}     $..enable    {{ gps_feature.gps_enable | default('not_defined') }}    {{ gps_feature.gps_enable_variable | default('not_defined') }}    msg=gps_enable    var_msg=gps_enable_variable
    Should Be Equal Value Json Yaml               ${transport_gps_features}     $..mode    {{ gps_feature.gps_mode | default('not_defined') }}    {{ gps_feature.gps_mode_variable | default('not_defined') }}    msg=gps_mode    var_msg=gps_mode_variable
    Should Be Equal Value Json Yaml               ${transport_gps_features}     $..nmea       {{ gps_feature.nmea_enable | default('not_defined') }}    not_defined    msg=nmea_enable    var_msg=not_defined
    Should Be Equal Value Json Yaml               ${transport_gps_features}     $..sourceAddress         {{ gps_feature.nmea_source_address | default('not_defined') }}         {{ gps_feature.nmea_source_address_variable | default('not_defined') }}    msg=nmea_source_address    var_msg=nmea_source_address_variable
    Should Be Equal Value Json Yaml               ${transport_gps_features}     $..destinationAddress    {{ gps_feature.nmea_destination_address | default('not_defined') }}    {{ gps_feature.nmea_destination_address_variable | default('not_defined') }}    msg=nmea_destination_address    var_msg=nmea_destination_address_variable
    Should Be Equal Value Json Yaml               ${transport_gps_features}     $..destinationPort       {{ gps_feature.nmea_destination_port | default('not_defined') }}       {{ gps_feature.nmea_destination_port_variable | default('not_defined') }}    msg=nmea_destination_port    var_msg=nmea_destination_port_variable

{% endfor %}


{% endif %}

{% endfor %}

{% endif %}

{% endif %}
