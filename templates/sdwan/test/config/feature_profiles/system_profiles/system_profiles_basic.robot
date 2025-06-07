*** Settings ***
Documentation   Verify System Feature Profile Configuration Basic
Name            System Profiles Basic
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_profiles   basic
Resource        ../../../sdwan_common.resource


{% set profile_basic_list = [] %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.basic is defined %}
  {% set _ = profile_basic_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_basic_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.basic is defined %}

Verify Feature Profiles System Profiles {{ profile.name }} Basic Feature {{ profile.basic.name | default(defaults.sdwan.feature_profiles.system_profiles.basic.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${system_basic_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id[0]}/basic
    ${system_basic}=    Get Value From Json    ${system_basic_res.json()}    $..payload
    Run Keyword If    ${system_basic} == []    Fail    Feature '{{profile.basic.name}}' expected to be configured within the system profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${system_basic}

    Should Be Equal Value Json String    ${system_basic[0]}    $..name    {{ profile.basic.name | default(defaults.sdwan.feature_profiles.system_profiles.basic.name) }}    msg=name
    Should Be Equal Value Json Special_String     ${system_basic[0]}     $.description    {{ profile.basic.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.adminTechOnFailure    {{ profile.basic.admin_tech_on_failure | default('not_defined') }}    {{ profile.basic.admin_tech_on_failure_variable | default('not_defined') }}    msg=basic admin tech on failure    var_msg=basic admin tech on failure variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.affinityGroupNumber    {{ profile.basic.affinity_group_number | default('not_defined') }}    {{ profile.basic.affinity_group_number_variable | default('not_defined') }}    msg=basic affinity group number    var_msg=basic affinity group number variable

    ${basic_affinity_group_preferences_list}=    Create List    {{ profile.basic.affinity_group_preferences | join('   ') }}
    ${basic_affinity_group_preferences_list}=    Set Variable If    ${basic_affinity_group_preferences_list} == []    not_defined    ${basic_affinity_group_preferences_list}
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.affinityGroupPreference    ${basic_affinity_group_preferences_list}    {{ profile.basic.affinity_group_preferences_variable | default('not_defined') }}    msg=basic affinity group preferences    var_msg=basic affinity group preferences variable

    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.affinityPreferenceAuto    {{ profile.basic.affinity_preference_auto | default('not_defined') }}    {{ profile.basic.affinity_preference_auto_variable | default('not_defined') }}    msg=basic affinity preference auto    var_msg=basic affinity preference auto variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.consoleBaudRate    {{ profile.basic.console_baud_rate | default('not_defined') }}    {{ profile.basic.console_baud_rate_variable | default('not_defined') }}    msg=basic console baud rate    var_msg=basic console baud rate variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.controlSessionPps    {{ profile.basic.control_session_pps | default('not_defined') }}    {{ profile.basic.control_session_pps_variable | default('not_defined') }}    msg=basic control session pps    var_msg=basic control session pps variable

    ${basic_controller_groups_list}=    Create List    {{ profile.basic.controller_groups | join('   ') }}
    ${basic_controller_groups_list}=    Set Variable If    ${basic_controller_groups_list} == []    not_defined    ${basic_controller_groups_list}
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.controllerGroupList    ${basic_controller_groups_list}    {{ profile.basic.controller_groups_variable | default('not_defined') }}    msg=basic controller groups    var_msg=basic controller groups variable

    ${basic_device_groups_list}=    Create List    {{ profile.basic.device_groups | join('   ') }}
    ${basic_device_groups_list}=    Set Variable If    ${basic_device_groups_list} == []    not_defined    ${basic_device_groups_list}
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.deviceGroups    ${basic_device_groups_list}    {{ profile.basic.device_groups_variable | default('not_defined') }}    msg=basic device groups    var_msg=basic device groups variable

    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.epfr    {{ profile.basic.enhanced_app_aware_routing | default('not_defined') }}    {{ profile.basic.enhanced_app_aware_routing_variable | default('not_defined') }}    msg=basic enhanced app aware routing    var_msg=basic enhanced app aware routing variable

    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.gpsLocation.geoFencing.enable    {{ profile.basic.geo_fencing_enable | default('not_defined') }}    not_defined    msg=basic geo fencing enable    var_msg=not_defined
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.gpsLocation.geoFencing.sms.enable    {{ profile.basic.geo_fencing_sms_enable | default('not_defined') }}    not_defined    msg=basic geo fencing sms enable    var_msg=not_defined

    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.gpsLocation.geoFencing.range    {{ profile.basic.geo_fencing_range | default('not_defined') }}    {{ profile.basic.geo_fencing_range_variable | default('not_defined') }}    msg=basic geo fencing range    var_msg=basic geo fencing range variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.idleTimeout    {{ profile.basic.idle_timeout | default('not_defined') }}    {{ profile.basic.idle_timeout_variable | default('not_defined') }}    msg=basic idle timeout    var_msg=basic idle timeout variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.gpsLocation.latitude    {{ profile.basic.latitude | default('not_defined') }}    {{ profile.basic.latitude_variable | default('not_defined') }}    msg=basic latitude    var_msg=basic latitude variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.location    {{ profile.basic.location | default('not_defined') }}    {{ profile.basic.location_variable | default('not_defined') }}    msg=basic location    var_msg=basic location variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.gpsLocation.longitude    {{ profile.basic.longitude | default('not_defined') }}    {{ profile.basic.longitude_variable | default('not_defined') }}    msg=basic longitude    var_msg=basic longitude variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.maxOmpSessions    {{ profile.basic.max_omp_sessions | default('not_defined') }}    {{ profile.basic.max_omp_sessions_variable | default('not_defined') }}    msg=basic max omp sessions    var_msg=basic max omp sessions variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.multiTenant    {{ profile.basic.multitenant | default('not_defined') }}    {{ profile.basic.multitenant_variable | default('not_defined') }}    msg=basic multitenant    var_msg=basic multitenant variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.onDemand.onDemandEnable    {{ profile.basic.on_demand_tunnel | default('not_defined') }}    {{ profile.basic.on_demand_tunnel_variable | default('not_defined') }}    msg=basic on demand tunnel    var_msg=basic on demand tunnel variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.onDemand.onDemandIdleTimeout    {{ profile.basic.on_demand_tunnel_idle_timeout | default('not_defined') }}    {{ profile.basic.on_demand_tunnel_idle_timeout_variable | default('not_defined') }}    msg=basic on demand tunnel idle timeout    var_msg=basic on demand tunnel idle timeout variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.overlayId    {{ profile.basic.overlay_id | default('not_defined') }}    {{ profile.basic.overlay_id_variable | default('not_defined') }}    msg=basic overlay id    var_msg=basic overlay id variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.portHop    {{ profile.basic.port_hopping | default('not_defined') }}    {{ profile.basic.port_hopping_variable | default('not_defined') }}    msg=basic port hopping    var_msg=basic port hopping variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.portOffset    {{ profile.basic.port_offset | default('not_defined') }}    {{ profile.basic.port_offset_variable | default('not_defined') }}    msg=basic port offset    var_msg=basic port offset variable

    ${basic_site_types_list}=    Create List    {{ profile.basic.site_types | join('   ') }}
    ${basic_site_types_list}=    Set Variable If    ${basic_site_types_list} == []    not_defined    ${basic_site_types_list}
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.siteType    ${basic_site_types_list}    {{ profile.basic.site_types_variable | default('not_defined') }}    msg=basic site types    var_msg=basic site types variable

    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.description    {{ profile.basic.system_description | default('not_defined') }}    {{ profile.basic.system_description_variable | default('not_defined') }}    msg=basic system description    var_msg=basic system description variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.clock.timezone    {{ profile.basic.timezone | default('not_defined') }}    {{ profile.basic.timezone_variable | default('not_defined') }}    msg=basic timezone    var_msg=basic timezone variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.trackDefaultGateway    {{ profile.basic.track_default_gateway | default('not_defined') }}    {{ profile.basic.track_default_gateway_variable | default('not_defined') }}    msg=basic track default gateway    var_msg=basic track default gateway variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.trackInterfaceTag    {{ profile.basic.track_interface_tag | default('not_defined') }}    {{ profile.basic.track_interface_tag_variable | default('not_defined') }}    msg=basic track interface tag    var_msg=basic track interface tag variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.trackTransport    {{ profile.basic.track_transport | default('not_defined') }}    {{ profile.basic.track_transport_variable | default('not_defined') }}    msg=basic track transport    var_msg=basic track transport variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.transportGateway    {{ profile.basic.transport_gateway | default('not_defined') }}    {{ profile.basic.transport_gateway_variable | default('not_defined') }}    msg=basic transport gateway    var_msg=basic transport gateway variable

    Should Be Equal Value Json List Length    ${system_basic[0]}    $.data.affinityPerVrf    {{ profile.basic.affinity_per_vrfs | length }}    msg=basic affinity per vrfs length
{% for basic_affinity_per_vrf in profile.basic.affinity_per_vrfs | default([]) %}

    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.affinityPerVrf[{{ loop.index0 }}].affinityGroupNumber    {{ basic_affinity_per_vrf.affinity_group_number | default('not_defined') }}    {{ basic_affinity_per_vrf.affinity_group_number_variable | default('not_defined') }}    msg=basic affinity per vrfs affinity group number    var_msg=basic affinity per vrfs affinity group number variable
    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.affinityPerVrf[{{ loop.index0 }}].vrfRange    {{ basic_affinity_per_vrf.vrf_range | default('not_defined') }}    {{ basic_affinity_per_vrf.vrf_range_variable | default('not_defined') }}    msg=basic affinity per vrfs vrf range    var_msg=basic affinity per vrfs vrf range variable
    
{% endfor %}

    Should Be Equal Value Json List Length    ${system_basic[0]}    $.data.gpsLocation.geoFencing.sms.mobileNumber    {{ profile.basic.geo_fencing_sms_mobile_numbers | length }}    msg=basic geo fencing sms mobile numbers length
{% for basic_geo_fencing_sms_mobile_number in profile.basic.geo_fencing_sms_mobile_numbers | default([]) %}

    Should Be Equal Value Json Yaml    ${system_basic[0]}    $.data.gpsLocation.geoFencing.sms.mobileNumber[{{ loop.index0 }}].number    {{ basic_geo_fencing_sms_mobile_number.number | default('not_defined') }}    {{ basic_geo_fencing_sms_mobile_number.number_variable | default('not_defined') }}    msg=basic geo fencing sms mobile number    var_msg=basic geo fencing sms mobile number variable

{% endfor %}


{% endif %}
{% endfor %}

{% endif %}
