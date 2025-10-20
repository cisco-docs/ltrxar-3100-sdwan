*** Settings ***
Documentation   Verify Service Feature Profile Configuration IPv4 Tracker and IPv4 Tracker Group
Name            Service Profiles IPv4 Tracker and IPv4 Tracker Group
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     service_profiles    ipv4_trackers    ipv4_tracker_groups
Resource        ../../../sdwan_common.resource


{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.service_profiles is defined %}
{% set profile_ipv4_tracker_list = [] %}
{% for profile in sdwan.feature_profiles.service_profiles %}
 {% if profile.ipv4_trackers is defined %}
  {% set _ = profile_ipv4_tracker_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_ipv4_tracker_list != [] %}

*** Test Cases ***
Get Service Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.service_profiles | default([]) %}
{% if profile.ipv4_trackers is defined %}

Verify Feature Profiles Service Profiles {{ profile.name }} IPv4 Tracker Feature
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    Set Suite Variable    ${profile}
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}
    ${service_ipv4_tracker_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}/tracker
    Set Suite Variable    ${service_ipv4_tracker_res}
    ${service_ipv4_tracker}=    Get Value From Json    ${service_ipv4_tracker_res.json()}    $..payload
    Run Keyword If    ${service_ipv4_tracker} == []    Fail    IPv4 tracker feature(s) expected to be configured within the service profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${service_ipv4_tracker}

{% for tracker in profile.ipv4_trackers | default([]) %}
    Log     === Tracker: {{ tracker.name }} ===
    
    # for each tracker find the corresponding one in the json and check parameters:
    ${service_trackers_{{ tracker.name }}_raw}=    Get Value From Json    ${service_ipv4_tracker}    $[?(@.name=='{{ tracker.name }}')]
    ${service_trackers_{{ tracker.name }}}=    Set Variable If    ${service_trackers_{{ tracker.name }}_raw} == []    not_defined    ${service_trackers_{{ tracker.name }}_raw[0]}

    Should Be Equal Value Json String     ${service_trackers_{{ tracker.name }}}   $.name    {{ tracker.name }}    msg=name
    Should Be Equal Value Json Special_String     ${service_trackers_{{ tracker.name }}}     $..description    {{ tracker.description | default('not_defined') | normalize_special_string }}    msg=description
    
    Should Be Equal Value Json Yaml    ${service_trackers_{{ tracker.name }}}    $..endpointIp    {{ tracker.endpoint_ip | default('not_defined') }}    {{ tracker.endpoint_ip_variable | default('not_defined') }}    msg=endpoint_ip    var_msg=endpoint_ip_variable
    Should Be Equal Value Json Yaml    ${service_trackers_{{ tracker.name }}}    $..endpointTcpUdp.port    {{ tracker.endpoint_port | default('not_defined') }}    {{ tracker.endpoint_port_variable | default('not_defined') }}    msg=endpoint_port    var_msg=endpoint_port_variable
    Should Be Equal Value Json Yaml    ${service_trackers_{{ tracker.name }}}    $..endpointTcpUdp.protocol    {{ tracker.endpoint_protocol | default('not_defined') }}    {{ tracker.endpoint_protocol_variable | default('not_defined') }}    msg=endpoint_protocol    var_msg=endpoint_protocol_variable
    Should Be Equal Value Json Yaml    ${service_trackers_{{ tracker.name }}}    $..endpointApiUrl    {{ tracker.endpoint_url | default('not_defined') }}    {{ tracker.endpoint_url_variable | default('not_defined') }}    msg=endpoint_url    var_msg=endpoint_url_variable  
    Should Be Equal Value Json Yaml    ${service_trackers_{{ tracker.name }}}    $..interval    {{ tracker.interval | default('not_defined') }}    {{ tracker.interval_variable | default('not_defined') }}    msg=interval    var_msg=interval_variable
    Should Be Equal Value Json Yaml    ${service_trackers_{{ tracker.name }}}    $..multiplier    {{ tracker.multiplier | default('not_defined') }}    {{ tracker.multiplier_variable | default('not_defined') }}    msg=multiplier    var_msg=multiplier_variable
    Should Be Equal Value Json Yaml    ${service_trackers_{{ tracker.name }}}    $..threshold    {{ tracker.threshold | default('not_defined') }}    {{ tracker.threshold_variable | default('not_defined') }}    msg=threshold    var_msg=threshold_variable
    Should Be Equal Value Json Yaml    ${service_trackers_{{ tracker.name }}}    $..trackerName    {{ tracker.tracker_name | default('not_defined') }}    {{ tracker.tracker_name_variable | default('not_defined') }}    msg=tracker_name    var_msg=tracker_name_variable

{% endfor %}

{% endif %}


{% if profile.ipv4_tracker_groups is defined %}

Verify Feature Profiles Service Profiles {{ profile.name }} IPv4 Tracker Group Feature
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${service_tracker_grp_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}/trackergroup
    ${service_tracker_grp}=    Get Value From Json    ${service_tracker_grp_res.json()}    $..payload
    Run Keyword If    ${service_tracker_grp} == []    Fail    IPv4 tracker group feature(s) expected to be configured within the service profile '{{profile.name}}' on the Manager
    
    Set Suite Variable    ${service_tracker_grp}

{% for tracker_grp in profile.ipv4_tracker_groups | default([]) %}
    Log     === Tracker Group: {{ tracker_grp.name }} ===

    # for each tracker_grp find the corresponding one in the json and check parameters:
    ${json_tracker_grp_raw}=    Get Value From Json    ${service_tracker_grp}    $[?(@.name=='{{ tracker_grp.name }}')]
    ${json_tracker_grp}=    Set Variable If    ${json_tracker_grp_raw} == []    not_defined    ${json_tracker_grp_raw[0]}

    Should Be Equal Value Json String     ${json_tracker_grp}   $.name    {{ tracker_grp.name }}    msg=tracker_grp name
    Should Be Equal Value Json Special_String     ${json_tracker_grp}     $..description    {{ tracker_grp.description | default('not_defined') | normalize_special_string }}    msg=tracker_grp description

    Should Be Equal Value Json Yaml    ${json_tracker_grp}    $..combineBoolean    {{ tracker_grp.tracker_boolean | default('not_defined') }}    not_defined   msg=tracker_boolean   var_msg=not_defined

    # Configuration has tracker names, tracker_group in JSON returns UUIDs
    # Find UUID from tracker name in tracker group configuration inside trackers API call
    # Compare with refId coming from tracker group API call
    Should Be Equal Value Json List Length    ${json_tracker_grp}    $.data.trackerRefs    {{ tracker_grp.get('trackers', []) | length }}    msg=trackers_count

    ${service_tracker_data}=    Get Value From Json    ${service_ipv4_tracker_res.json()}    $..data
    ${service_tracker_data}     Set Variable     ${service_tracker_data}[0]
{% for tracker_name in tracker_grp.trackers | default([]) %}
    Log     === Tracker: {{ tracker_name }} ===

    # Find correct tracker details from tracker JSON based on name inside tracker group configuration
    ${tracker_json}=    Get Value From Json    ${service_tracker_data}    $[?(@.payload.name=='{{ tracker_name }}')]
    Run Keyword If    ${tracker_json} == []    Fail    Tracker '{{ tracker_name }}' not found in the service profile '{{profile.name}}' on the Manager

    ${tracker_uuid}=    Get Value From Json    ${tracker_json}[0]    $.parcelId
    ${tracker_uuid}    Set Variable    ${tracker_uuid}[0]
    
    # Extract refIDs from the trackerGroup JSON
    ${refid_values}=    Evaluate    [p["trackerRef"]["refId"]["value"] for p in ${json_tracker_grp["data"]["trackerRefs"]}]
    Should Contain    ${refid_values}    ${tracker_uuid}

{% endfor %}

{% endfor %}

{% endif %}


{% endfor %}

{% endif %}

{% endif %}