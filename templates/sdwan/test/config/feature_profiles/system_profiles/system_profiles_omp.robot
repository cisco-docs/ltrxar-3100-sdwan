*** Settings ***
Documentation   Verify System Feature Profile Configuration OMP
Name            System Profiles OMP
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     system_profiles   omp
Resource        ../../../sdwan_common.resource


{% set profile_omp_list = [] %}
{% for profile in sdwan.feature_profiles.system_profiles %}
 {% if profile.omp is defined %}
  {% set _ = profile_omp_list.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_omp_list != [] %}

*** Test Cases ***
Get System Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.system_profiles | default([]) %}
{% if profile.omp is defined %}

Verify Feature Profiles System Profiles {{ profile.name }} OMP Feature {{ profile.omp.name | default(defaults.sdwan.feature_profiles.system_profiles.omp.name) }}
    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId

    ${system_omp_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/system/${profile_id[0]}/omp
    ${system_omp}=    Get Value From Json    ${system_omp_res.json()}    $..payload
    Run Keyword If    ${system_omp} == []    Fail    Feature '{{profile.omp.name}}' expected to be configured within the system profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${system_omp}

    Should Be Equal Value Json String    ${system_omp[0]}    $..name    {{ profile.omp.name | default(defaults.sdwan.feature_profiles.system_profiles.omp.name) }}    msg=name
    Should Be Equal Value Json Special_String    ${system_omp[0]}    $..description    {{ profile.omp.description | default('not_defined') | normalize_special_string }}    msg=description

    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.gracefulRestart   {{ profile.omp.graceful_restart | default("not_defined") }}    {{ profile.omp.graceful_restart_variable| default('not_defined') }}     msg=graceful_restart    var_msg=graceful_restart_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.overlayAs   {{ profile.omp.overlay_as | default("not_defined") }}    {{ profile.omp.overlay_as_variable| default('not_defined') }}     msg=overlay_as    var_msg=overlay_as_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.ecmpLimit    {{ profile.omp.ecmp_limit | default('not_defined')  }}    {{ profile.omp.ecmp_limit_variable| default('not_defined') }}     msg=ecmp_limit    var_msg=ecmp_limit_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.sendPathLimit    {{ profile.omp.send_path_limit | default('not_defined')  }}    {{ profile.omp.send_path_limit_variable| default('not_defined') }}     msg=send_path_limit    var_msg=send_path_limit_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.shutdown    {{ profile.omp.shutdown | default('not_defined')  }}    {{ profile.omp.shutdown_variable| default('not_defined') }}     msg=shutdown    var_msg=shutdown_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.ompAdminDistanceIpv4    {{ profile.omp.omp_admin_distance_ipv4 | default('not_defined')  }}    {{ profile.omp.omp_admin_distance_ipv4_variable| default('not_defined') }}     msg=omp_admin_distance_ipv4    var_msg=omp_admin_distance_ipv4_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.ompAdminDistanceIpv6    {{ profile.omp.omp_admin_distance_ipv6 | default('not_defined')  }}    {{ profile.omp.omp_admin_distance_ipv6_variable| default('not_defined') }}     msg=omp_admin_distance_ipv6    var_msg=omp_admin_distance_ipv6_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertisementInterval    {{ profile.omp.advertisement_interval | default('not_defined')  }}    {{ profile.omp.advertisement_interval_variable| default('not_defined') }}     msg=advertisement_interval    var_msg=advertisement_interval_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.gracefulRestartTimer    {{ profile.omp.graceful_restart_timer | default('not_defined')  }}    {{ profile.omp.graceful_restart_timer_variable| default('not_defined') }}     msg=graceful_restart_timer    var_msg=graceful_restart_timer_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.eorTimer    {{ profile.omp.eor_timer | default('not_defined')  }}    {{ profile.omp.eor_timer_variable| default('not_defined') }}     msg=eor_timer    var_msg=eor_timer_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.holdtime    {{ profile.omp.holdtime | default('not_defined')  }}    {{ profile.omp.holdtime_variable| default('not_defined') }}     msg=holdtime    var_msg=holdtime_variable

    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.ignoreRegionPathLength    {{ profile.omp.ignore_region_path_length | default('not_defined')  }}    {{ profile.omp.ignore_region_path_length_variable| default('not_defined') }}     msg=ignore_region_path_length    var_msg=ignore_region_path_length_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.transportGateway    {{ profile.omp.transport_gateway | default('not_defined')  }}    {{ profile.omp.transport_gateway_variable| default('not_defined') }}     msg=transport_gateway    var_msg=transport_gateway_variable

    ${site_types_list}=    Create List    {{ profile.omp.site_types | join('   ') }}
    ${site_types_list}=    Set Variable If    ${site_types_list} == []    not_defined    ${site_types_list}
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.siteTypes    ${site_types_list}    {{ profile.omp.site_types_variable| default('not_defined') }}     msg=site_types    var_msg=site_types_variable

# Check advertise IPv4
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv4.bgp    {{ profile.omp.advertise_ipv4_bgp | default('not_defined')  }}    {{ profile.omp.advertise_ipv4_bgp_variable| default('not_defined') }}     msg=advertise_ipv4_bgp    var_msg=advertise_ipv4_bgp_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv4.ospf    {{ profile.omp.advertise_ipv4_ospf | default('not_defined')  }}    {{ profile.omp.advertise_ipv4_ospf_variable| default('not_defined') }}     msg=advertise_ipv4_ospf    var_msg=advertise_ipv4_ospf_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv4.ospfv3    {{ profile.omp.advertise_ipv4_ospf_v3 | default('not_defined')  }}    {{ profile.omp.advertise_ipv4_ospf_v3_variable| default('not_defined') }}     msg=advertise_ipv4_ospf_v3    var_msg=advertise_ipv4_ospf_v3_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv4.connected    {{ profile.omp.advertise_ipv4_connected | default('not_defined')  }}    {{ profile.omp.advertise_ipv4_connected_variable| default('not_defined') }}     msg=advertise_ipv4_connected    var_msg=advertise_ipv4_connected_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv4.static    {{ profile.omp.advertise_ipv4_static | default('not_defined')  }}    {{ profile.omp.advertise_ipv4_static_variable| default('not_defined') }}     msg=advertise_ipv4_static    var_msg=advertise_ipv4_static_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv4.eigrp    {{ profile.omp.advertise_ipv4_eigrp | default('not_defined')  }}    {{ profile.omp.advertise_ipv4_eigrp_variable| default('not_defined') }}     msg=advertise_ipv4_eigrp    var_msg=advertise_ipv4_eigrp_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv4.lisp    {{ profile.omp.advertise_ipv4_lisp | default('not_defined')  }}    {{ profile.omp.advertise_ipv4_lisp_variable| default('not_defined') }}     msg=advertise_ipv4_lisp    var_msg=advertise_ipv4_lisp_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv4.isis    {{ profile.omp.advertise_ipv4_isis | default('not_defined')  }}    {{ profile.omp.advertise_ipv4_isis_variable| default('not_defined') }}     msg=advertise_ipv4_isis    var_msg=advertise_ipv4_isis_variable

# Loop over advertise IPv6
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv6.bgp    {{ profile.omp.advertise_ipv6_bgp | default('not_defined')  }}    {{ profile.omp.advertise_ipv6_bgp_variable| default('not_defined') }}     msg=advertise_ipv6_bgp    var_msg=advertise_ipv6_bgp_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv6.ospf    {{ profile.omp.advertise_ipv6_ospf | default('not_defined')  }}    {{ profile.omp.advertise_ipv6_ospf_variable| default('not_defined') }}     msg=advertise_ipv6_ospf    var_msg=advertise_ipv6_ospf_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv6.connected    {{ profile.omp.advertise_ipv6_connected | default('not_defined')  }}    {{ profile.omp.advertise_ipv6_connected_variable| default('not_defined') }}     msg=advertise_ipv6_connected    var_msg=advertise_ipv6_connected_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv6.static    {{ profile.omp.advertise_ipv6_static | default('not_defined')  }}    {{ profile.omp.advertise_ipv6_static_variable| default('not_defined') }}     msg=advertise_ipv6_static    var_msg=advertise_ipv6_static_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv6.eigrp    {{ profile.omp.advertise_ipv6_eigrp | default('not_defined')  }}    {{ profile.omp.advertise_ipv6_eigrp_variable| default('not_defined') }}     msg=advertise_ipv6_eigrp    var_msg=advertise_ipv6_eigrp_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv6.lisp    {{ profile.omp.advertise_ipv6_lisp | default('not_defined')  }}    {{ profile.omp.advertise_ipv6_lisp_variable| default('not_defined') }}     msg=advertise_ipv6_lisp    var_msg=advertise_ipv6_lisp_variable
    Should Be Equal Value Json Yaml    ${system_omp[0]}    $.data.advertiseIpv6.isis    {{ profile.omp.advertise_ipv6_isis | default('not_defined')  }}    {{ profile.omp.advertise_ipv6_isis_variable| default('not_defined') }}     msg=advertise_ipv6_isis    var_msg=advertise_ipv6_isis_variable


{% endif %}
{% endfor %}

{% endif %}
