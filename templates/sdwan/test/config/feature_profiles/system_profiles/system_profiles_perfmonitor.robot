*** Settings ***
Documentation   Verify System Feature Profile Configuration Performance Monitoring
Name            System Profiles Performance Monitoring
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_feature_profiles   performance_monitoring
Resource        ../../../sdwan_common.resource


{% set profile_perfmonitor_list = [] %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.performance_monitoring is defined %}
  {% set _ = profile_perfmonitor_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_perfmonitor_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.performance_monitoring is defined %}

Verify Feature Profiles System Profiles {{ profile.name }} Performance Monitoring Feature {{ profile.performance_monitoring.name | default(defaults.sdwan.feature_profiles.system_profiles.performance_monitoring.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${system_perfmonitor_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id}[0]/perfmonitor
    ${system_perfmonitor}=    Get Value From Json    ${system_perfmonitor_res.json()}    $..payload
    Run Keyword If    ${system_perfmonitor} == []    Fail    Feature '{{profile.performance_monitoring.name}}' expected to be configured within the system profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${system_perfmonitor}

    Should Be Equal Value Json String    ${system_perfmonitor[0]}    $..name    {{ profile.performance_monitoring.name | default(defaults.sdwan.feature_profiles.system_profiles.performance_monitoring.name) }}    msg=name
    Should Be Equal Value Json Special_String    ${system_perfmonitor[0]}    $..description    {{ profile.performance_monitoring.description | default('not_defined') | normalize_special_string }}    msg=description
    
    ${perfmonitor_app_groups_list}=    Create List    {{ profile.performance_monitoring.app_perf_monitor_app_groups | join('   ') }}
    ${perfmonitor_app_groups_list}=    Set Variable If    ${perfmonitor_app_groups_list} == []    not_defined    ${perfmonitor_app_groups_list}
    Should Be Equal Value Json Yaml     ${system_perfmonitor[0]}    $..policyFilters.appGroups   ${perfmonitor_app_groups_list}   not_defined   msg=performance_monitoring app_perf_monitor_app_groups  var_msg=none

    Should Be Equal Value Json String    ${system_perfmonitor[0]}    $..appPerfMonitorConfig.enabled.value    {{ profile.performance_monitoring.app_perf_monitor_enabled | default('False') }}    msg=performance_monitoring app_perf_monitor_enabled
    Should Be Equal Value Json String    ${system_perfmonitor[0]}    $..umtsConfig.eventDrivenConfig.enabled.value    {{ profile.performance_monitoring.event_driven_config_enabled | default('False') }}    msg=performance_monitoring event_driven_config_enabled
  
    ${perfmonitor_event_driven_events_list}=    Create List    {{ profile.performance_monitoring.event_driven_events | join('   ') }}
    ${perfmonitor_event_driven_events_list}=    Set Variable If    ${perfmonitor_event_driven_events_list} == []    not_defined    ${perfmonitor_event_driven_events_list}
    Should Be Equal Value Json Yaml    ${system_perfmonitor[0]}    $..umtsConfig.eventDrivenConfig.events    ${perfmonitor_event_driven_events_list}  not_defined    msg=performance_monitoring event_driven_events     var_msg=none
  
    Should Be Equal Value Json String    ${system_perfmonitor[0]}    $..umtsConfig.monitoringConfig.enabled.value    {{ profile.performance_monitoring.monitoring_config_enabled | default('False') }}    msg=performance_monitoring monitoring_config_enabled
    Should Be Equal Value Json String    ${system_perfmonitor[0]}    $..umtsConfig.monitoringConfig.interval.value    {{ profile.performance_monitoring.monitoring_config_interval | default('not_defined') }}    msg=performance_monitoring monitoring_config_interval


{% endif %}
{% endfor %}

{% endif %}