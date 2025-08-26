*** Settings ***
Documentation   Verify Service Feature Profile Configuration Object Tracker and Object Tracker Group
Name            Service Profiles Object Tracker and Object Tracker Group
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     service_profiles    object_trackers    object_tracker_groups
Resource        ../../../sdwan_common.resource


{% set profile_object_tracker_list = [] %}
{% for profile in sdwan.feature_profiles.service_profiles %}
 {% if profile.object_trackers is defined %}
  {% set _ = profile_object_tracker_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_object_tracker_list != [] %}

*** Test Cases ***
Get Service Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.service_profiles | default([]) %}
{% if profile.object_trackers is defined %}

Verify Feature Profiles Service Profiles {{ profile.name }} Object Tracker Feature
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    Set Suite Variable    ${profile}
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable    ${profile_id}
    ${service_object_tracker_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}/objecttracker
    Set Suite Variable    ${service_object_tracker_res}
    ${service_object_tracker}=    Get Value From Json    ${service_object_tracker_res.json()}    $..payload
    Run Keyword If    ${service_object_tracker} == []    Fail    Object tracker feature(s) expected to be configured within the service profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${service_object_tracker}

{% for tracker in profile.object_trackers | default([]) %}
    Log     === Tracker: {{ tracker.name }} ===
    
    # for each tracker find the corresponding one in the json and check parameters:
    ${service_trackers_raw}=    Get Value From Json    ${service_object_tracker}    $[?(@.name=='{{ tracker.name }}')]
    ${service_trackers}=    Set Variable If    ${service_trackers_raw} == []    not_defined    ${service_trackers_raw[0]}

    Should Be Equal Value Json String     ${service_trackers}   $.name    {{ tracker.name }}    msg=name
    Should Be Equal Value Json Special_String     ${service_trackers}     $..description    {{ tracker.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${service_trackers}    $..objectId    {{ tracker.id | default('not_defined') }}    {{ tracker.id_variable | default('not_defined') }}    msg=id    var_msg=id_variable
    Should Be Equal Value Json Yaml    ${service_trackers}    $..interface    {{ tracker.interface_name | default('not_defined') }}    {{ tracker.interface_name_variable | default('not_defined') }}    msg=interface_name    var_msg=interface_name_variable
    Should Be Equal Value Json Yaml    ${service_trackers}    $..routeIp    {{ tracker.route_ip | default('not_defined') }}    {{ tracker.route_ip_variable | default('not_defined') }}    msg=route_ip    var_msg=route_ip_variable
    Should Be Equal Value Json Yaml    ${service_trackers}    $..routeMask    {{ tracker.route_mask | default('not_defined') }}    {{ tracker.route_mask_variable | default('not_defined') }}    msg=route_mask    var_msg=route_mask_variable
    Should Be Equal Value Json Yaml    ${service_trackers}    $..vpn    {{ tracker.vpn_id | default('not_defined') }}    {{ tracker.vpn_id_variable | default('not_defined') }}    msg=vpn_id    var_msg=vpn_id_variable

    # ignore case for tracker type value
    ${type_value}=   Get Value From Json   ${service_trackers}   $..objectTrackerType.value
    ${type_value}=   Set Variable If    ${type_value} == []    not_defined    ${type_value[0]}
    Should Be Equal As Strings    ${type_value}    {{ tracker.type | default('not_defined') }}    values=False      ignore_case=True    msg=type

{% endfor %}

{% endif %}


{% if profile.object_tracker_groups is defined %}

Verify Feature Profiles Service Profiles {{ profile.name }} Object Tracker Group Feature
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${service_tracker_grp_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}/objecttrackergroup
    ${service_tracker_grp}=    Get Value From Json    ${service_tracker_grp_res.json()}    $..payload
    Run Keyword If    ${service_tracker_grp} == []    Fail    Object tracker group feature(s) expected to be configured within the service profile '{{profile.name}}' on the Manager
    
    Set Suite Variable    ${service_tracker_grp}

{% for tracker_grp in profile.object_tracker_groups | default([]) %}
    Log     === Tracker Group: {{ tracker_grp.name }} ===

    # for each tracker_grp find the corresponding one in the json and check parameters:
    ${json_tracker_grp_raw}=    Get Value From Json    ${service_tracker_grp}    $[?(@.name=='{{ tracker_grp.name }}')]
    ${json_tracker_grp}=    Set Variable If    ${json_tracker_grp_raw} == []    not_defined    ${json_tracker_grp_raw[0]}

    Should Be Equal Value Json String     ${json_tracker_grp}   $.name    {{ tracker_grp.name }}    msg=tracker_grp name
    Should Be Equal Value Json Special_String     ${json_tracker_grp}     $..description    {{ tracker_grp.description | default('not_defined') | normalize_special_string }}    msg=tracker_grp description

    Should Be Equal Value Json Yaml    ${json_tracker_grp}    $..criteria    {{ tracker_grp.tracker_boolean | default('not_defined') }}    not_defined   msg=tracker_boolean   var_msg=not_defined
    Should Be Equal Value Json Yaml    ${json_tracker_grp}    $..objectId          {{ tracker_grp.id | default('not_defined') }}    {{ tracker_grp.id_variable | default('not_defined') }}    msg=id    var_msg=id_variable

    # Configuration has tracker names, tracker_group in JSON returns UUIDs
    # Find UUID from tracker name in tracker group configuration inside trackers API call
    # Compare with refId coming from tracker group API call
    Should Be Equal Value Json List Length    ${json_tracker_grp}    $.data.trackerRefs    {{ tracker_grp.get('trackers', []) | length }}    msg=trackers_count

    ${service_tracker_data}=    Get Value From Json    ${service_object_tracker_res.json()}    $..data
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