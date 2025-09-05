*** Settings ***
Documentation   Verify Service Profile Configuration LAN VPNs
Name            Service Profiles LAN VPNs
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles    service_profiles    lan_vpns
Resource        ../../../sdwan_common.resource

{% set profile_lan_vpns = [] %}
{% for profile in sdwan.feature_profiles.service_profiles %}
 {% if profile.lan_vpns is defined %}
  {% set _ = profile_lan_vpns.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_lan_vpns != [] %}

*** Test Cases ***

Get Service Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.service_profiles | default([]) %}
{% if profile.lan_vpns is defined %}

    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${service_profile_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}
    ${service_profile_features}=    Get Value From Json    ${service_profile_res.json()}    $..associatedProfileParcels
    Set Suite Variable    ${service_profile_features}
    ${tracker_objs_object}=    Get Value From Json    ${service_profile_features}[0]    $[?(@.parcelType=='objecttracker')]
    ${tracker_objs_group}=    Get Value From Json    ${service_profile_features}[0]    $[?(@.parcelType=='objecttrackergroup')]
    ${tracker_objs}=    Evaluate    ${tracker_objs_object} + ${tracker_objs_group}
    Set Suite Variable    ${tracker_objs}
    ${trackers}=    Get Value From Json    ${service_profile_features}[0]    $[?(@.parcelType=='tracker')]
    ${tracker_groups}=    Get Value From Json    ${service_profile_features}[0]    $[?(@.parcelType=='trackergroup')]
    ${trackers_for_next_hop}=    Evaluate    ${trackers} + ${tracker_groups}
    Set Suite Variable    ${trackers_for_next_hop}
    ${route_policy_objs}=    Get Value From Json    ${service_profile_features}[0]    $[?(@.parcelType=='route-policy')]
    Set Suite Variable    ${route_policy_objs}
    ${service_lan_vpn_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}/lan/vpn
    ${service_lan_vpn}=    Get Value From Json    ${service_lan_vpn_res.json()}    $..payload
    Run Keyword If    ${service_lan_vpn} == []    Fail    Feature lan vpn expected to be configured within the service profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${service_lan_vpn}
    
{% for lan_vpn in profile.lan_vpns | default([]) %}
Verify Feature Profiles Service Profiles {{ profile.name }} LAN VPN {{ lan_vpn.name }}
    ${service_lan_vpn_data_raw}=    Get Value From Json    ${service_lan_vpn}   $[?(@.name=='{{ lan_vpn.name }}')]
    ${service_lan_vpn_data}=    Set Variable If     ${service_lan_vpn_data_raw} == []   not_defined    ${service_lan_vpn_data_raw[0]}

    Should Be Equal Value Json String    ${service_lan_vpn_data}    $.name    {{ lan_vpn.name }}    msg=service_lan_vpn lan_vpn name
    Should Be Equal Value Json Special_String    ${service_lan_vpn_data}   $..description   {{ lan_vpn.description | default('not_defined') | normalize_special_string }}   msg=service_lan_vpn lan_vpn description
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..vpnId   {{ lan_vpn.vpn_id| default('not_defined') }}     {{ lan_vpn.vpn_id_variable| default('not_defined') }}     msg=service_lan_vpn vpn_id     var_msg=service_lan_vpn vpn_id variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $.data.name   {{ lan_vpn.vpn_name| default('not_defined') }}     {{ lan_vpn.vpn_name_variable| default('not_defined') }}     msg=service_lan_vpn vpn_name     var_msg=service_lan_vpn vpn_name variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..dnsIpv4.primaryDnsAddressIpv4   {{ lan_vpn.ipv4_primary_dns_address| default('not_defined') }}     {{ lan_vpn.ipv4_primary_dns_address_variable| default('not_defined') }}     msg=service_lan_vpn ipv4_primary_dns_address     var_msg=service_lan_vpn ipv4_primary_dns_address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..dnsIpv4.secondaryDnsAddressIpv4   {{ lan_vpn.ipv4_secondary_dns_address| default('not_defined') }}     {{ lan_vpn.ipv4_secondary_dns_address_variable| default('not_defined') }}     msg=service_lan_vpn ipv4_secondary_dns_address     var_msg=service_lan_vpn ipv4_secondary_dns_address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdminDistance      {{ lan_vpn.ipv4_omp_admin_distance| default('not_defined') }}     {{ lan_vpn.ipv4_omp_admin_distance_variable| default('not_defined') }}     msg=service_lan_vpn ipv4_omp_admin_distance     var_msg=service_lan_vpn ipv4_omp_admin_distance variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..dnsIpv6.primaryDnsAddressIpv6   {{ lan_vpn.ipv6_primary_dns_address| default('not_defined') }}     {{ lan_vpn.ipv6_primary_dns_address_variable| default('not_defined') }}     msg=service_lan_vpn ipv6_primary_dns_address     var_msg=service_lan_vpn ipv6_primary_dns_address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..dnsIpv6.secondaryDnsAddressIpv6   {{ lan_vpn.ipv6_secondary_dns_address| default('not_defined') }}     {{ lan_vpn.ipv6_secondary_dns_address_variable| default('not_defined') }}     msg=service_lan_vpn ipv6_secondary_dns_address     var_msg=service_lan_vpn ipv6_secondary_dns_address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdminDistanceIpv6   {{ lan_vpn.ipv6_omp_admin_distance| default('not_defined') }}     {{ lan_vpn.ipv6_omp_admin_distance_variable| default('not_defined') }}     msg=service_lan_vpn ipv6_omp_admin_distance     var_msg=service_lan_vpn ipv6_omp_admin_distance variable

    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..[newHostMapping]  {{ lan_vpn.get('host_mappings', []) | length }}    msg=host mappings length
{% if lan_vpn.host_mappings is defined and lan_vpn.get('host_mappings', [])|length > 0 %}
    Log    =====Host Mappings=====
{% for host_entry in lan_vpn.host_mappings | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..newHostMapping[{{ loop.index0 }}].hostName   {{ host_entry.hostname| default('not_defined') }}     {{ host_entry.hostname_variable| default('not_defined') }}     msg=service_lan_vpn host_entry.hostname     var_msg=service_lan_vpn host_entry.hostname variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..newHostMapping[{{ loop.index0 }}].listOfIp   {{ host_entry.ips| default('not_defined') }}     {{ host_entry.ips_variable| default('not_defined') }}     msg=service_lan_vpn host_entry.ips     var_msg=service_lan_vpn host_entry.ips variable
{% endfor %}
{% endif %}
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..greRoute  {{ lan_vpn.get('gre_routes', []) | length }}    msg=gre routes length
{% if lan_vpn.gre_routes is defined and lan_vpn.get('gre_routes', [])|length > 0 %}
    Log    =====GRE Routes=====
{% for gre_entry in lan_vpn.gre_routes | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..greRoute[{{ loop.index0 }}].prefix.ipAddress    {{ gre_entry.network_address|default('not_defined') }}   {{ gre_entry.network_address_variable|default('not_defined') }}   msg=gre_route network_address   var_msg=gre_route network_address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..greRoute[{{ loop.index0 }}].interface   {{ gre_entry.interfaces|default('not_defined') }}   {{ gre_entry.interfaces_variable|default('not_defined') }}   msg=gre_route interfaces   var_msg=gre_route interfaces variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..greRoute[{{ loop.index0 }}].prefix.subnetMask    {{ gre_entry.subnet_mask|default('not_defined') }}   {{ gre_entry.subnet_mask_variable|default('not_defined') }}   msg=gre_route subnet_mask   var_msg=gre_route subnet_mask variable
{% endfor %}
{% endif %}
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..ipsecRoute  {{ lan_vpn.get('ipsec_routes', []) | length }}    msg=ipsec routes length
{% if lan_vpn.ipsec_routes is defined and lan_vpn.get('ipsec_routes', [])|length > 0 %}
    Log    =====IPSEC Routes=====
{% for ipsec_entry in lan_vpn.ipsec_routes | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipsecRoute[{{ loop.index0 }}].prefix.ipAddress   {{ ipsec_entry.network_address|default('not_defined') }}   {{ ipsec_entry.network_address_variable|default('not_defined') }}   msg=ipsec_route network_address   var_msg=ipsec_route network_address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipsecRoute[{{ loop.index0 }}].interface   {{ ipsec_entry.interfaces|default('not_defined') }}   {{ ipsec_entry.interfaces_variable|default('not_defined') }}   msg=ipsec_route interfaces   var_msg=ipsec_route interfaces variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipsecRoute[{{ loop.index0 }}].prefix.subnetMask   {{ ipsec_entry.subnet_mask|default('not_defined') }}   {{ ipsec_entry.subnet_mask_variable|default('not_defined') }}   msg=ipsec_route subnet_mask   var_msg=ipsec_route subnet_mask variable
{% endfor %}
{% endif %}

    # ===== OMP Advertise IPv4 Routes =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..ompAdvertiseIp4  {{ lan_vpn.get('ipv4_omp_advertise_routes', []) | length }}    msg=omp advertise ipv4 routes length
{% if lan_vpn.ipv4_omp_advertise_routes is defined and lan_vpn.get('ipv4_omp_advertise_routes', [])|length > 0 %}
    Log    =====OMP Advertise IPv4 Routes=====
{% for omp4_entry in lan_vpn.ipv4_omp_advertise_routes | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIp4[{{ loop.index0 }}].ompProtocol  {{ omp4_entry.protocol|default('not_defined') }}   {{ omp4_entry.protocol_variable|default('not_defined') }}   msg=ipv4_omp_advertise_routes protocol   var_msg=ipv4_omp_advertise_routes protocol variable   
{% if omp4_entry.route_policy is defined %}
    ${route_policy_obj}=    Evaluate    [x for x in ${route_policy_objs} if x['payload']['name']=='{{ omp4_entry.route_policy }}']
    ${route_policy_id}=     Get Value From Json    ${route_policy_obj}    $..parcelId
    Run Keyword If    ${route_policy_id} == []    Fail    Route-policy '{{ omp4_entry.route_policy }}' not found in Manager for profile '{{ profile.name }}'
    ${route_policy_id}=     Set Variable    ${route_policy_id[0]}
{% else %}
    ${route_policy_id}=     Set Variable    not_defined
{% endif %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIp4[{{ loop.index0 }}].routePolicy.refId    ${route_policy_id}    not_defined    msg=route_policy refId    var_msg=route_policy refId variable
    
{% if omp4_entry.protocol == 'network' and omp4_entry.networks is defined %}
    Should Be Equal Value Json List Length    ${service_lan_vpn_data}    $..ompAdvertiseIp4[{{ loop.index0 }}].prefixList    {{ omp4_entry.networks | length }}    msg=ipv4_omp_advertise_routes networks length    
    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}
    {% for net in omp4_entry.networks %}
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIp4[${outer_loop_index}].prefixList[{{ loop.index0 }}].prefix.address   {{ net.network_address|default('not_defined') }}   {{ net.network_address_variable|default('not_defined') }}    msg=ipv4_omp_advertise_routes network_address    var_msg=ipv4_omp_advertise_routes network_address variable   
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIp4[${outer_loop_index}].prefixList[{{ loop.index0 }}].prefix.mask    {{ net.subnet_mask|default('not_defined') }}    {{ net.subnet_mask_variable|default('not_defined') }}    msg=ipv4_omp_advertise_routes subnet_mask  var_msg=ipv4_omp_advertise_routes subnet_mask variable
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIp4[${outer_loop_index}].prefixList[{{ loop.index0 }}].region   {{ net.region|default('not_defined') }}   {{ net.region_variable|default('not_defined') }}    msg=ipv4_omp_advertise_routes region   var_msg=ipv4_omp_advertise_routes region variable
    {% endfor %}
{% elif omp4_entry.protocol == 'aggregate' and omp4_entry.aggregates is defined %}
    Should Be Equal Value Json List Length    ${service_lan_vpn_data}    $..ompAdvertiseIp4[{{ loop.index0 }}].prefixList    {{ omp4_entry.aggregates | length }}    msg=ipv4_omp_advertise_routes aggregates length
    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}
    {% for agg in omp4_entry.aggregates %}
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIp4[${outer_loop_index}].prefixList[{{ loop.index0 }}].prefix.address   {{ agg.aggregate_address|default('not_defined') }}   {{ agg.aggregate_address_variable|default('not_defined') }}    msg=ipv4_omp_advertise_routes aggregate_address   var_msg=ipv4_omp_advertise_routes aggregate_address variable
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIp4[${outer_loop_index}].prefixList[{{ loop.index0 }}].prefix.mask    {{ agg.subnet_mask|default('not_defined') }}   {{ agg.subnet_mask_variable|default('not_defined') }}    msg=ipv4_omp_advertise_routes aggregate_subnet_mask   var_msg=ipv4_omp_advertise_routes aggregate_subnet_mask variable
        Should Be Equal Value Json String    ${service_lan_vpn_data}    $..ompAdvertiseIp4[${outer_loop_index}].prefixList[{{ loop.index0 }}].aggregateOnly.value    {{ agg.aggregate_only|default('not_defined') }}    msg=ipv4_omp_advertise_routes aggregate_only  
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIp4[${outer_loop_index}].prefixList[{{ loop.index0 }}].region   {{ agg.region|default('not_defined') }}   {{ agg.region_variable|default('not_defined') }}    msg=ipv4_omp_advertise_routes region   var_msg=ipv4_omp_advertise_routes region variable
    {% endfor %}
{% endif %}
{% endfor %}
{% endif %}
    # ===== OMP Advertise IPv6 Routes =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..ompAdvertiseIpv6  {{ lan_vpn.get('ipv6_omp_advertise_routes', []) | length }}    msg=omp advertise ipv6 routes length
{% if lan_vpn.ipv6_omp_advertise_routes is defined and lan_vpn.get('ipv6_omp_advertise_routes', [])|length > 0 %}
    Log    =====OMP Advertise IPv6 Routes=====
{% for omp6_entry in lan_vpn.ipv6_omp_advertise_routes | default([]) %}

{% set protocol_map = {'bgp': 'BGP','ospf': 'OSPF','connected': 'Connected','static': 'Static','network': 'Network','aggregate': 'Aggregate'} %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIpv6[{{ loop.index0 }}].ompProtocol   {{ protocol_map.get(omp6_entry.protocol, omp6_entry.protocol|default('not_defined')) }}   {{ omp6_entry.protocol_variable|default('not_defined') }}   msg=ipv6_omp_advertise_routes protocol   var_msg=ipv6_omp_advertise_routes protocol variable
{% if omp6_entry.route_policy is defined %}
    ${route_policy_obj}=    Evaluate    [x for x in ${route_policy_objs} if x['payload']['name']=='{{ omp6_entry.route_policy }}']
    ${route_policy_id}=     Get Value From Json    ${route_policy_obj}    $..parcelId
    Run Keyword If    ${route_policy_id} == []    Fail    Route-policy '{{ omp6_entry.route_policy }}' not found in Manager for profile '{{ profile.name }}'
    ${route_policy_id}=     Set Variable    ${route_policy_id[0]}
{% else %}
    ${route_policy_id}=     Set Variable    not_defined
{% endif %}
    Should Be Equal Value Json Yaml   ${service_lan_vpn_data}    $..ompAdvertiseIpv6[{{ loop.index0 }}].routePolicy.refId   ${route_policy_id}  not_defined  msg=ipv6_omp_advertise_routes route_policy  var_msg=route_policy refId variable
{% if omp6_entry.protocol == 'network' and omp6_entry.networks is defined %}
    Should Be Equal Value Json List Length    ${service_lan_vpn_data}    $..ompAdvertiseIpv6[{{ loop.index0 }}].prefixList    {{ omp6_entry.networks | length }}    msg=ipv6_omp_advertise_routes networks length    
        ${outer_loop_index}=    Set Variable    {{ loop.index0 }}
        {% for net in omp6_entry.networks %}
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIpv6[${outer_loop_index}].prefixList[{{ loop.index0 }}].prefix   {{ net.prefix|default('not_defined') }}   {{ net.prefix_variable|default('not_defined') }}    msg==ipv6_omp_advertise_routes prefix    var_msg=ipv6_omp_advertise_routes prefix variable
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIpv6[${outer_loop_index}].prefixList[{{ loop.index0 }}].region   {{ net.region|default('not_defined') }}   {{ net.region_variable|default('not_defined') }}    msg=ipv6_omp_advertise_routes region   var_msg=ipv6_omp_advertise_routes region variable
        {% endfor %}
{% elif omp6_entry.protocol == 'aggregate' and omp6_entry.aggregates is defined %}
        Should Be Equal Value Json List Length    ${service_lan_vpn_data}    $..ompAdvertiseIpv6[{{ loop.index0 }}].prefixList    {{ omp6_entry.aggregates | length }}    msg=ipv6_omp_advertise_routes aggregates length
        ${outer_loop_index}=    Set Variable    {{ loop.index0 }}
        {% for agg in omp6_entry.aggregates %}
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIpv6[${outer_loop_index}].prefixList[{{ loop.index0 }}].prefix   {{ agg.aggregate_prefix|default('not_defined') }}   {{ agg.aggregate_prefix_variable|default('not_defined') }}    msg=ipv6_omp_advertise_routes aggregate_prefix   var_msg=ipv6_omp_advertise_routes aggregate_prefix variable
            Should Be Equal Value Json String    ${service_lan_vpn_data}    $..ompAdvertiseIpv6[${outer_loop_index}].prefixList[{{ loop.index0 }}].aggregateOnly.value   {{ agg.aggregate_only|default('not_defined') }}    msg=ipv6_omp_advertise_routes aggregate_only
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ompAdvertiseIpv6[${outer_loop_index}].prefixList[{{ loop.index0 }}].region   {{ agg.region|default('not_defined') }}   {{ agg.region_variable|default('not_defined') }}    msg=ipv6_omp_advertise_routes region   var_msg=ipv6_omp_advertise_routes region variable
       {% endfor %} 
{% endif %}
{% endfor %}
{% endif %}
    # ===== LAN VPN IPv4 Static Routes =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}    $..ipv4Route    {{ lan_vpn.get('ipv4_static_routes', []) | length }}    msg=ipv4 static routes length
{% if lan_vpn.ipv4_static_routes is defined and lan_vpn.get('ipv4_static_routes', [])|length > 0 %}
    Log    =====IPv4 Static Routes=====
{% for route_entry in lan_vpn.ipv4_static_routes | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipv4Route[{{ loop.index0 }}].prefix.ipAddress   {{ route_entry.network_address|default('not_defined') }}   {{ route_entry.network_address_variable|default('not_defined') }}   msg=lan_vpn_ipv4_route network_address   var_msg=lan_vpn_ipv4_route network_address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipv4Route[{{ loop.index0 }}].prefix.subnetMask   {{ route_entry.subnet_mask|default('not_defined') }}   {{ route_entry.subnet_mask_variable|default('not_defined') }}   msg=lan_vpn_ipv4_route subnet_mask   var_msg=lan_vpn_ipv4_route subnet_mask variable
    
    Should Be Equal Value Json String    ${service_lan_vpn_data}    $..ipv4Route[{{ loop.index0 }}].oneOfIpRoute.null0.value    {{ 'True' if route_entry.get('gateway', 'nexthop') == 'null0' else 'not_defined' }}   msg=lan_vpn_ipv4_route gateway null0 
    Should Be Equal Value Json String    ${service_lan_vpn_data}    $..ipv4Route[{{ loop.index0 }}].oneOfIpRoute.dhcp.value   {{ 'True' if route_entry.get('gateway', 'nexthop') == 'dhcp' else 'not_defined' }}   msg=lan_vpn_ipv4_route gateway dhcp 
    Should Be Equal Value Json String    ${service_lan_vpn_data}    $..ipv4Route[{{ loop.index0 }}].oneOfIpRoute.vpn.value  {{ 'True' if route_entry.get('gateway', 'nexthop') == 'vpn' else 'not_defined' }}   msg=lan_vpn_ipv4_route gateway vpn 
    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}
{% if route_entry.get('gateway', defaults.sdwan.feature_profiles.service_profiles.lan_vpns.ipv4_static_routes.gateway) == 'nexthop' %}
    ${nexthop_json}=    Get Value From Json    ${service_lan_vpn_data}    $..ipv4Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer
    ${gateway_value}=    Set Variable If    ${nexthop_json} != []    nexthop    not_defined
    Should Be Equal    ${gateway_value}    nexthop    msg=lan_vpn_ipv4_route gateway nexthop
{% endif %}
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..ipv4Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHop   {{ route_entry.get('next_hops', []) | length }}    msg=lan_vpn_ipv4_route next_hops length
{% if route_entry.next_hops is defined and route_entry.get('next_hops', []) | length > 0 %}
    Log    =====Next Hops=====
{% for nh_entry in route_entry.next_hops | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipv4Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHop[{{ loop.index0 }}].address   {{ nh_entry.address|default('not_defined') }}   {{ nh_entry.address_variable|default('not_defined') }}   msg=lan_vpn_ipv4_route nh_entry.address   var_msg=lan_vpn_ipv4_route nh_entry.address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipv4Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHop[{{ loop.index0 }}].distance   {{ nh_entry.administrative_distance|default('not_defined') }}   {{ nh_entry.administrative_distance_variable|default('not_defined') }}   msg=lan_vpn_ipv4_route nh_entry.admin_distance   var_msg=lan_vpn_ipv4_route nh_entry.admin_distance variable
{% endfor %}
{% endif %}
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..ipv4Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHopWithTracker  {{ route_entry.get('next_hops_with_tracker', []) | length }}    msg=lan_vpn_ipv4_route next_hops with tracker length
{% if route_entry.next_hops_with_tracker is defined and route_entry.get('next_hops_with_tracker', []) | length > 0 %}
    Log    =====Next Hops With Tracker=====
{% for nh_entry in route_entry.next_hops_with_tracker | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipv4Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHopWithTracker[{{ loop.index0 }}].address   {{ nh_entry.address|default('not_defined') }}   {{ nh_entry.address_variable|default('not_defined') }}   msg=lan_vpn_ipv4_route nh_entry.address   var_msg=lan_vpn_ipv4_route nh_entry.address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipv4Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHopWithTracker[{{ loop.index0 }}].distance   {{ nh_entry.administrative_distance|default('not_defined') }}   {{ nh_entry.administrative_distance_variable|default('not_defined') }}   msg=lan_vpn_ipv4_route nh_entry.admin_distance   var_msg=lan_vpn_ipv4_route nh_entry.admin_distance variable
    # --- Tracker RefId Check for nextHopWithTracker ---
{% if nh_entry.tracker is defined %}
    ${tracker_nh}=    Evaluate    [x for x in ${trackers_for_next_hop} if x['payload']['name']=='{{ nh_entry.tracker }}']
    ${tracker_nh_id}=     Get Value From Json    ${tracker_nh}    $..parcelId
    Run Keyword If    ${tracker_nh_id} == []    Fail    Tracker '{{ nh_entry.tracker }}' not found in Manager for profile '{{ profile.name }}'
    ${tracker_nh_id}=     Set Variable    ${tracker_nh_id[0]}
{% else %}
    ${tracker_nh_id}=     Set Variable    not_defined
{% endif %}
    Should Be Equal Value Json Yaml   ${service_lan_vpn_data}    $..ipv4Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHopWithTracker[{{ loop.index0 }}].tracker.refId   ${tracker_nh_id}  not_defined  msg=lan_vpn_ipv4_route tracker  var_msg=lan_vpn_ipv4_route tracker variable
{% endfor %}
{% endif %}
{% endfor %}
{% endif %}
    # ===== LAN VPN IPv6 Static Routes =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..ipv6Route  {{ lan_vpn.get('ipv6_static_routes', []) | length }}    msg=ipv6 static routes length
{% if lan_vpn.ipv6_static_routes is defined and lan_vpn.get('ipv6_static_routes', [])|length > 0 %}
    Log    =====IPv6 Static Routes=====
{% for route_entry in lan_vpn.ipv6_static_routes | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipv6Route[{{ loop.index0 }}].prefix   {{ route_entry.prefix|default('not_defined') }}   {{ route_entry.prefix_variable|default('not_defined') }}   msg=lan_vpn_ipv6_route prefix   var_msg=lan_vpn_ipv6_route prefix variable
    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}
{% if route_entry.get('gateway', defaults.sdwan.feature_profiles.service_profiles.lan_vpns.ipv6_static_routes.gateway) == 'nexthop' %}
    ${nexthop_json}=    Get Value From Json    ${service_lan_vpn_data}    $..ipv6Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer
    ${gateway_value}=    Set Variable If    ${nexthop_json} != []    nexthop    not_defined
    Should Be Equal    ${gateway_value}    nexthop    msg=lan_vpn_ipv6_route gateway nexthop
{% endif %}    
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..ipv6Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHop   {{ route_entry.get('next_hops', []) | length }}    msg=lan_vpn_ipv6_route next_hops length
{% if route_entry.next_hops is defined and route_entry.get('next_hops', []) | length > 0 %}
    Log    =====Next Hops=====
{% for nh_entry in route_entry.next_hops | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipv6Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHop[{{ loop.index0 }}].address   {{ nh_entry.address|default('not_defined') }}   {{ nh_entry.address_variable|default('not_defined') }}   msg=lan_vpn_ipv6_route nh6_entry.address   var_msg=lan_vpn_ipv6_route nh6_entry.address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..ipv6Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHop[{{ loop.index0 }}].distance   {{ nh_entry.administrative_distance|default('not_defined') }}   {{ nh_entry.administrative_distance_variable|default('not_defined') }}   msg=lan_vpn_ipv6_route nh6_entry.admin_distance   var_msg=lan_vpn_ipv6_route nh6_entry.admin_distance variable
{% endfor %}
{% endif %}
    Should Be Equal Value Json String    ${service_lan_vpn_data}    $..ipv6Route[{{ loop.index0 }}].oneOfIpRoute.null0.value   {{ 'True' if route_entry.get('gateway', 'nexthop') == 'null0' else 'not_defined' }}   msg=lan_vpn_ipv6_route null0_gateway
    Should Be Equal Value Json Yaml   ${service_lan_vpn_data}    $..ipv6Route[{{ loop.index0 }}].oneOfIpRoute.nat  {{ route_entry.nat|upper if route_entry.nat is defined else 'not_defined' }}   {{ route_entry.nat_variable|default('not_defined') }}   msg=lan_vpn_ipv6_route nat   var_msg=lan_vpn_ipv6_route nat variable
{% endfor %}
{% endif %}
    # ===== NAT Pools =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..natPool  {{ lan_vpn.get('nat_pools', []) | length }}    msg=nat pools length
{% if lan_vpn.nat_pools is defined and lan_vpn.get('nat_pools', [])|length > 0 %}
    Log    =====NAT Pools=====
{% for nat_entry in lan_vpn.nat_pools | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPool[{{ loop.index0 }}].natPoolName   {{ nat_entry.id|default('not_defined') }}   {{ nat_entry.id_variable|default('not_defined') }}   msg=nat_pool id   var_msg=nat_pool id variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPool[{{ loop.index0 }}].rangeStart   {{ nat_entry.range_start|default('not_defined') }}   {{ nat_entry.range_start_variable|default('not_defined') }}   msg=nat_pool range_start   var_msg=nat_pool range_start variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPool[{{ loop.index0 }}].rangeEnd   {{ nat_entry.range_end|default('not_defined') }}   {{ nat_entry.range_end_variable|default('not_defined') }}   msg=nat_pool range_end   var_msg=nat_pool range_end variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPool[{{ loop.index0 }}].overload   {{ nat_entry.overload|default('not_defined') }}   {{ nat_entry.overload_variable|default('not_defined') }}   msg=nat_pool overload   var_msg=nat_pool overload variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPool[{{ loop.index0 }}].direction   {{ nat_entry.direction|default('not_defined') }}   {{ nat_entry.direction_variable|default('not_defined') }}   msg=nat_pool direction   var_msg=nat_pool direction variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPool[{{ loop.index0 }}].prefixLength  {{ nat_entry.prefix_length|default('not_defined') }}   {{ nat_entry.prefix_length_variable|default('not_defined') }}   msg=nat_pool prefix_length   var_msg=nat_pool prefix_length variable
    # --- Tracker Object RefId Check ---
{% if nat_entry.tracker_object is defined %}
    ${tracker_obj}=    Evaluate    [x for x in ${tracker_objs} if x['payload']['name']=='{{ nat_entry.tracker_object }}']
    ${tracker_obj_id}=     Get Value From Json    ${tracker_obj}    $..parcelId
    Run Keyword If    ${tracker_obj_id} == []    Fail    Tracker object '{{ nat_entry.tracker_object }}' not found in Manager for profile '{{ profile.name }}'
    ${tracker_obj_id}=     Set Variable    ${tracker_obj_id[0]}
{% else %}
    ${tracker_obj_id}=     Set Variable    not_defined
{% endif %}
    Should Be Equal Value Json Yaml   ${service_lan_vpn_data}    $..natPool[{{ loop.index0 }}].trackingObject.trackerId.refId   ${tracker_obj_id}  not_defined  msg=nat_pool tracker_object  var_msg=nat_pool tracker_object variable

{% endfor %}
{% endif %}
    # ===== NAT Port Forward =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..natPortForward  {{ lan_vpn.get('nat_port_forwards', []) | length }}    msg=nat port forward length
{% if lan_vpn.nat_port_forwards is defined and lan_vpn.get('nat_port_forwards', [])|length > 0 %}
    Log    =====NAT Port Forward=====
{% for natpf_entry in lan_vpn.nat_port_forwards | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPortForward[{{ loop.index0 }}].natPoolName   {{ natpf_entry.nat_pool_id|default('not_defined') }}   {{ natpf_entry.nat_pool_id_variable|default('not_defined') }}   msg=nat_port_forward nat_pool_id   var_msg=nat_port_forward nat_pool_id variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPortForward[{{ loop.index0 }}].sourcePort   {{ natpf_entry.source_port|default('not_defined') }}   {{ natpf_entry.source_port_variable|default('not_defined') }}   msg=nat_port_forward source_port   var_msg=nat_port_forward source_port variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPortForward[{{ loop.index0 }}].translatePort   {{ natpf_entry.translate_port|default('not_defined') }}   {{ natpf_entry.translate_port_variable|default('not_defined') }}   msg=nat_port_forward translate_port   var_msg=nat_port_forward translate_port variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPortForward[{{ loop.index0 }}].sourceIp   {{ natpf_entry.source_ip|default('not_defined') }}   {{ natpf_entry.source_ip_variable|default('not_defined') }}   msg=nat_port_forward source_ip   var_msg=nat_port_forward source_ip variable
    ${translatedSourceIp}=     Get Value From Json    ${service_lan_vpn_data}    $..natPortForward[{{ loop.index0 }}].TranslatedSourceIp
    Run Keyword If    ${translatedSourceIp} != []    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPortForward[{{ loop.index0 }}].TranslatedSourceIp   {{ natpf_entry.translate_ip|default('not_defined') }}   {{ natpf_entry.translate_ip_variable|default('not_defined') }}   msg=nat_port_forward translate_ip   var_msg=nat_port_forward translate_ip variable
    ...    ELSE    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPortForward[{{ loop.index0 }}].translatedSourceIp   {{ natpf_entry.translate_ip|default('not_defined') }}   {{ natpf_entry.translate_ip_variable|default('not_defined') }}   msg=nat_port_forward translate_ip   var_msg=nat_port_forward translate_ip variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..natPortForward[{{ loop.index0 }}].protocol   {{ natpf_entry.protocol|upper if natpf_entry.protocol is defined else not_defined }}   {{ natpf_entry.protocol_variable|default('not_defined') }}   msg=nat_port_forward protocol   var_msg=nat_port_forward protocol variable
{% endfor %}
{% endif %}

    # ===== Static NAT =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..staticNat  {{ lan_vpn.get('static_nat_entries', []) | length }}    msg=static nat length
{% if lan_vpn.static_nat_entries is defined and lan_vpn.get('static_nat_entries', [])|length > 0 %}
    Log    =====Static NAT=====
{% for snat_entry in lan_vpn.static_nat_entries | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..staticNat[{{ loop.index0 }}].natPoolName   {{ snat_entry.nat_pool_id|default('not_defined') }}   {{ snat_entry.nat_pool_id_variable|default('not_defined') }}   msg=static_nat nat_pool_id   var_msg=static_nat nat_pool_id variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..staticNat[{{ loop.index0 }}].sourceIp   {{ snat_entry.source_ip|default('not_defined') }}   {{ snat_entry.source_ip_variable|default('not_defined') }}   msg=static_nat source_ip   var_msg=static_nat source_ip variable
    ${translatedSourceIp}=     Get Value From Json    ${service_lan_vpn_data}    $..staticNat[{{ loop.index0 }}].TranslatedSourceIp
    Run Keyword If    ${translatedSourceIp} != []    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..staticNat[{{ loop.index0 }}].TranslatedSourceIp   {{ snat_entry.translate_ip|default('not_defined') }}   {{ snat_entry.translate_ip_variable|default('not_defined') }}   msg=static_nat translate_ip   var_msg=static_nat translate_ip variable
    ...    ELSE    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..staticNat[{{ loop.index0 }}].translatedSourceIp   {{ snat_entry.translate_ip|default('not_defined') }}   {{ snat_entry.translate_ip_variable|default('not_defined') }}   msg=static_nat translate_ip   var_msg=static_nat translate_ip variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..staticNat[{{ loop.index0 }}].staticNatDirection   {{ snat_entry.direction|default('not_defined') }}   {{ snat_entry.direction_variable|default('not_defined') }}   msg=static_nat direction   var_msg=static_nat direction variable
    # --- Tracker Object RefId Check ---
{% if snat_entry.tracker_object is defined %}
    ${tracker_obj}=    Evaluate    [x for x in ${tracker_objs} if x['payload']['name']=='{{ snat_entry.tracker_object }}']
    ${tracker_obj_id}=     Get Value From Json    ${tracker_obj}    $..parcelId
    Run Keyword If    ${tracker_obj_id} == []    Fail    Tracker object '{{ snat_entry.tracker_object }}' not found in Manager for profile '{{ profile.name }}'
    ${tracker_obj_id}=     Set Variable    ${tracker_obj_id[0]}
{% else %}
    ${tracker_obj_id}=     Set Variable    not_defined
{% endif %}
    Should Be Equal Value Json Yaml   ${service_lan_vpn_data}    $..staticNat[{{ loop.index0 }}].trackingObject.trackerId.refId     ${tracker_obj_id}  not_defined  msg=static_nat tracker_object  var_msg=static_nat tracker_object variable
{% endfor %}
{% endif %}
    # ===== NAT64 Pools =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..nat64V4Pool  {{ lan_vpn.get('nat64_pools', []) | length }}    msg=nat64 pools length
{% if lan_vpn.nat64_pools is defined and lan_vpn.get('nat64_pools', [])|length > 0 %}
    Log    =====NAT64 Pools=====
{% for nat64_entry in lan_vpn.nat64_pools | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..nat64V4Pool[{{ loop.index0 }}].nat64V4PoolName   {{ nat64_entry.name|default('not_defined') }}   {{ nat64_entry.name_variable|default('not_defined') }}   msg=nat64_pool name   var_msg=nat64_pool name variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..nat64V4Pool[{{ loop.index0 }}].nat64V4PoolRangeStart   {{ nat64_entry.range_start|default('not_defined') }}   {{ nat64_entry.range_start_variable|default('not_defined') }}   msg=nat64_pool range_start   var_msg=nat64_pool range_start variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..nat64V4Pool[{{ loop.index0 }}].nat64V4PoolRangeEnd   {{ nat64_entry.range_end|default('not_defined') }}   {{ nat64_entry.range_end_variable|default('not_defined') }}   msg=nat64_pool range_end   var_msg=nat64_pool range_end variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..nat64V4Pool[{{ loop.index0 }}].nat64V4PoolOverload   {{ nat64_entry.overload|default('not_defined') }}   {{ nat64_entry.overload_variable|default('not_defined') }}   msg=nat64_pool overload   var_msg=nat64_pool overload variable
{% endfor %}
{% endif %}
    # ===== Services =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..service  {{ lan_vpn.get('services', []) | length }}    msg=services length
{% if lan_vpn.services is defined and lan_vpn.get('services', [])|length > 0 %}
{% set service_type_map = {"fw": "FW", "ids": "IDS", "idp": "IDP", "netsvc1": "netsvc1", "netsvc2": "netsvc2", "netsvc3": "netsvc3", "netsvc4": "netsvc4", "te": "TE", "appqoe": "appqoe"} %}
    Log    =====Services=====
{% for svc_entry in lan_vpn.services | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $.data.service[{{ loop.index0 }}].serviceType   {{ service_type_map.get(svc_entry.service_type, svc_entry.service_type|default('not_defined')) }}   {{ svc_entry.service_type_variable|default('not_defined') }}   msg=service service_type   var_msg=service service_type variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $.data.service[{{ loop.index0 }}].ipv4Addresses   {{ svc_entry.ipv4_addresses|default('not_defined') }}   {{ svc_entry.ipv4_addresses_variable|default('not_defined') }}   msg=service ipv4_addresses   var_msg=service ipv4_addresses variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $.data.service[{{ loop.index0 }}].tracking   {{ svc_entry.track_enable|default('not_defined') }}   {{ svc_entry.track_enable_variable|default('not_defined') }}   msg=service tracking   var_msg=service tracking variable
{% endfor %}
{% endif %}
    # ===== Service Routes =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..serviceRoute  {{ lan_vpn.get('service_routes', []) | length }}    msg=service routes length
{% if lan_vpn.service_routes is defined and lan_vpn.get('service_routes', [])|length > 0 %}
    Log    =====Service Routes=====
{% for sr_entry in lan_vpn.service_routes | default([]) %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $.data.serviceRoute[{{ loop.index0 }}].prefix.ipAddress   {{ sr_entry.network_address|default('not_defined') }}   {{ sr_entry.network_address_variable|default('not_defined') }}   msg=service_route network_address   var_msg=service_route network_address variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $.data.serviceRoute[{{ loop.index0 }}].prefix.subnetMask   {{ sr_entry.subnet_mask|default('not_defined') }}   {{ sr_entry.subnet_mask_variable|default('not_defined') }}   msg=service_route subnet_mask   var_msg=service_route subnet_mask variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $.data.serviceRoute[{{ loop.index0 }}].service   {{ sr_entry.service|upper if sr_entry.service is defined else 'not_defined' }}   not_defined   msg=service_route service   var_msg=service_route service variable not_defined
{% endfor %}
{% endif %}
    # ===== Route Leak From Global =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..routeLeakFromGlobal  {{ lan_vpn.get('route_leaks_from_global', []) | length }}    msg=route leak from global length
{% if lan_vpn.route_leaks_from_global is defined and lan_vpn.get('route_leaks_from_global', [])|length > 0 %}
    Log    =====Route Leak From Global=====
{% for rlfg_entry in lan_vpn.route_leaks_from_global | default([]) %}
    {% set outer_loop_index = loop.index0 %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakFromGlobal[{{ outer_loop_index }}].routeProtocol   {{ rlfg_entry.protocol|default('not_defined') }}   {{ rlfg_entry.protocol_variable|default('not_defined') }}   msg=route_leak_from_global protocol   var_msg=route_leak_from_global protocol variable
    {% if rlfg_entry.route_policy is defined %}
        ${route_policy_obj}=    Evaluate    [x for x in ${route_policy_objs} if x['payload']['name']=='{{ rlfg_entry.route_policy }}']
        ${route_policy_id}=     Get Value From Json    ${route_policy_obj}    $..parcelId
        Run Keyword If    ${route_policy_id} == []    Fail    Route-policy '{{ rlfg_entry.route_policy }}' not found in Manager for profile '{{ profile.name }}'
        ${route_policy_id}=     Set Variable    ${route_policy_id[0]}
    {% else %}
        ${route_policy_id}=     Set Variable    not_defined
    {% endif %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakFromGlobal[{{ outer_loop_index }}].routePolicy.refId   ${route_policy_id}  not_defined  msg=route_leak_from_global route_policy refId   var_msg=not_defined
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..routeLeakFromGlobal[{{ outer_loop_index }}].redistributeToProtocol  {{ rlfg_entry.get('redistributions', []) | length }}    msg=route_leak_from_global redistributions length
    {% if rlfg_entry.redistributions is defined and rlfg_entry.get('redistributions', [])|length > 0 %}
        {% for redist in rlfg_entry.redistributions %}
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakFromGlobal[{{ outer_loop_index }}].redistributeToProtocol[{{ loop.index0 }}].protocol   {{ redist.protocol|default('not_defined') }}   {{ redist.protocol_variable|default('not_defined') }}   msg=route_leak_from_global redistribution protocol   var_msg=route_leak_from_global redistribution protocol variable
            {% if redist.route_policy is defined %}
                ${route_policy_obj}=    Evaluate    [x for x in ${route_policy_objs} if x['payload']['name']=='{{ redist.route_policy }}']
                ${route_policy_id}=     Get Value From Json    ${route_policy_obj}    $..parcelId
                Run Keyword If    ${route_policy_id} == []    Fail    Redistribution route-policy '{{ redist.route_policy }}' not found in Manager for profile '{{ profile.name }}'
                ${route_policy_id}=     Set Variable    ${route_policy_id[0]}
            {% else %}
                ${route_policy_id}=     Set Variable    not_defined
            {% endif %}
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakFromGlobal[{{ outer_loop_index }}].redistributeToProtocol[{{ loop.index0 }}].policy.refId   ${route_policy_id}  not_defined  msg=route_leak_from_global redistribution route_policy refId   var_msg=not_defined
        {% endfor %}
    {% endif %}
{% endfor %}
{% endif %}
    # ===== Route Leak To Global =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..routeLeakFromService  {{ lan_vpn.get('route_leaks_to_global', []) | length }}    msg=route_leak_to_global length
{% if lan_vpn.route_leaks_to_global is defined and lan_vpn.get('route_leaks_to_global', [])|length > 0 %}
    Log    =====Route Leak From Service=====
{% for rlfs_entry in lan_vpn.route_leaks_to_global | default([]) %}
    {% set outer_loop_index = loop.index0 %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakFromService[{{ outer_loop_index }}].routeProtocol   {{ rlfs_entry.protocol|default('not_defined') }}   {{ rlfs_entry.protocol_variable|default('not_defined') }}   msg=route_leak_to_global protocol   var_msg=route_leak_to_global protocol variable
    {% if rlfs_entry.route_policy is defined %}
        ${route_policy_obj}=    Evaluate    [x for x in ${route_policy_objs} if x['payload']['name']=='{{ rlfs_entry.route_policy }}']
        ${route_policy_id}=     Get Value From Json    ${route_policy_obj}    $..parcelId
        Run Keyword If    ${route_policy_id} == []    Fail    Route-policy '{{ rlfs_entry.route_policy }}' not found in Manager for profile '{{ profile.name }}'
        ${route_policy_id}=     Set Variable    ${route_policy_id[0]}
    {% else %}
        ${route_policy_id}=     Set Variable    not_defined
    {% endif %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakFromService[{{ outer_loop_index }}].routePolicy.refId   ${route_policy_id}  not_defined  msg=route_leak_to_global route_policy refId   var_msg=not_defined
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..routeLeakFromService[{{ outer_loop_index }}].redistributeToProtocol  {{ rlfs_entry.get('redistributions', []) | length }}    msg=route_leak_to_global redistributions length
    {% if rlfs_entry.redistributions is defined and rlfs_entry.get('redistributions', [])|length > 0 %}
        {% for redist in rlfs_entry.redistributions %}
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakFromService[{{ outer_loop_index }}].redistributeToProtocol[{{ loop.index0 }}].protocol   {{ redist.protocol|default('not_defined') }}   {{ redist.protocol_variable|default('not_defined') }}   msg=route_leak_to_global redistribution protocol   var_msg=route_leak_to_global redistribution protocol variable
            {% if redist.route_policy is defined %}
                ${route_policy_obj}=    Evaluate    [x for x in ${route_policy_objs} if x['payload']['name']=='{{ redist.route_policy }}']
                ${route_policy_id}=     Get Value From Json    ${route_policy_obj}    $..parcelId
                Run Keyword If    ${route_policy_id} == []    Fail    Redistribution route-policy '{{ redist.route_policy }}' not found in Manager for profile '{{ profile.name }}'
                ${route_policy_id}=     Set Variable    ${route_policy_id[0]}
            {% else %}
                ${route_policy_id}=     Set Variable    not_defined
            {% endif %}
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakFromService[{{ outer_loop_index }}].redistributeToProtocol[{{ loop.index0 }}].policy.refId   ${route_policy_id}  not_defined  msg=route_leak_to_global redistribution route_policy refId    var_msg=not_defined
        {% endfor %}
    {% endif %}
{% endfor %}
{% endif %}
    # ===== Route Leak from another Service =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..routeLeakBetweenServices  {{ lan_vpn.get('route_leaks_from_service', []) | length }}    msg=route leak from service length
{% if lan_vpn.route_leaks_from_service is defined and lan_vpn.get('route_leaks_from_service', [])|length > 0 %}
    Log    =====Route Leak from another Service=====
{% for rlbs_entry in lan_vpn.route_leaks_from_service | default([]) %}
    {% set outer_loop_index = loop.index0 %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakBetweenServices[{{ outer_loop_index }}].sourceVpn   {{ rlbs_entry.source_vpn|default('not_defined') }}   {{ rlbs_entry.source_vpn_variable|default('not_defined') }}   msg=route_leak_between_services source_vpn   var_msg=route_leak_between_services source_vpn variable
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakBetweenServices[{{ outer_loop_index }}].routeProtocol   {{ rlbs_entry.protocol|default('not_defined') }}   {{ rlbs_entry.protocol_variable|default('not_defined') }}   msg=route_leak_between_services protocol   var_msg=route_leak_between_services protocol variable
    {% if rlbs_entry.route_policy is defined %}
        ${route_policy_obj}=    Evaluate    [x for x in ${route_policy_objs} if x['payload']['name']=='{{ rlbs_entry.route_policy }}']
        ${route_policy_id}=     Get Value From Json    ${route_policy_obj}    $..parcelId
        Run Keyword If    ${route_policy_id} == []    Fail    Route-policy '{{ rlbs_entry.route_policy }}' not found in Manager for profile '{{ profile.name }}'
        ${route_policy_id}=     Set Variable    ${route_policy_id[0]}
    {% else %}
        ${route_policy_id}=     Set Variable    not_defined
    {% endif %}
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakBetweenServices[{{ outer_loop_index }}].routePolicy.refId   ${route_policy_id}  not_defined  msg=route_leak_between_services route_policy refId    var_msg=not_defined
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..routeLeakBetweenServices[{{ outer_loop_index }}].redistributeToProtocol  {{ rlbs_entry.get('redistributions', []) | length }}    msg=route_leak_between_services redistributions length
    {% if rlbs_entry.redistributions is defined and rlbs_entry.get('redistributions', [])|length > 0 %}
        {% for redist in rlbs_entry.redistributions %}
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakBetweenServices[{{ outer_loop_index }}].redistributeToProtocol[{{ loop.index0 }}].protocol   {{ redist.protocol|default('not_defined') }}   {{ redist.protocol_variable|default('not_defined') }}   msg=route_leak_between_services redistribution protocol   var_msg=route_leak_between_services redistribution protocol variable
            {% if redist.route_policy is defined %}
                ${route_policy_obj}=    Evaluate    [x for x in ${route_policy_objs} if x['payload']['name']=='{{ redist.route_policy }}']
                ${route_policy_id}=     Get Value From Json    ${route_policy_obj}    $..parcelId
                Run Keyword If    ${route_policy_id} == []    Fail    Redistribution route-policy '{{ redist.route_policy }}' not found in Manager for profile '{{ profile.name }}'
                ${route_policy_id}=     Set Variable    ${route_policy_id[0]}
            {% else %}
                ${route_policy_id}=     Set Variable    not_defined
            {% endif %}
            Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..routeLeakBetweenServices[{{ outer_loop_index }}].redistributeToProtocol[{{ loop.index0 }}].policy.refId   ${route_policy_id}  not_defined  msg=route_leak_between_services redistribution route_policy refId   var_msg=not_defined
        {% endfor %}
    {% endif %}
{% endfor %}
{% endif %}
    # ===== MPLS VPN IPv4 Route Targets =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..mplsVpnIpv4RouteTarget.importRtList  {{ lan_vpn.get('ipv4_import_route_targets', []) | length }}    msg= importRtList length
    {% for rt_entry in lan_vpn.ipv4_import_route_targets | default([]) %}
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..mplsVpnIpv4RouteTarget.importRtList[{{ loop.index0 }}].rt   {{ rt_entry.route_target|default('not_defined') }}   {{ rt_entry.route_target_variable|default('not_defined') }}   msg=importRtList value   var_msg=importRtList variable
    {% endfor %}
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..mplsVpnIpv4RouteTarget.exportRtList  {{ lan_vpn.get('ipv4_export_route_targets', []) | length }}    msg=mplsVpnIpv4RouteTarget exportRtList length
    {% for rt_entry in lan_vpn.ipv4_export_route_targets | default([]) %}
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..mplsVpnIpv4RouteTarget.exportRtList[{{ loop.index0 }}].rt   {{ rt_entry.route_target|default('not_defined') }}   {{ rt_entry.route_target_variable|default('not_defined') }}   msg=mplsVpnIpv4RouteTarget exportRtList value   var_msg=mplsVpnIpv4RouteTarget exportRtList variable
    {% endfor %}
    # ===== MPLS VPN IPv6 Route Targets =====
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..mplsVpnIpv6RouteTarget.importRtList  {{ lan_vpn.get('ipv6_import_route_targets', []) | length }}    msg=mplsVpnIpv6RouteTarget importRtList length
    {% for rt_entry in lan_vpn.ipv6_import_route_targets | default([]) %}
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..mplsVpnIpv6RouteTarget.importRtList[{{ loop.index0 }}].rt   {{ rt_entry.route_target|default('not_defined') }}   {{ rt_entry.route_target_variable|default('not_defined') }}   msg=mplsVpnIpv6RouteTarget importRtList value   var_msg=mplsVpnIpv6RouteTarget importRtList variable
    {% endfor %}
    Should Be Equal Value Json List Length   ${service_lan_vpn_data}  $..mplsVpnIpv6RouteTarget.exportRtList  {{ lan_vpn.get('ipv6_export_route_targets', []) | length }}    msg=mplsVpnIpv6RouteTarget exportRtList length
    {% for rt_entry in lan_vpn.ipv6_export_route_targets | default([]) %}
        Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..mplsVpnIpv6RouteTarget.exportRtList[{{ loop.index0 }}].rt   {{ rt_entry.route_target|default('not_defined') }}   {{ rt_entry.route_target_variable|default('not_defined') }}   msg=mplsVpnIpv6RouteTarget exportRtList value   var_msg=mplsVpnIpv6RouteTarget exportRtList variable
    {% endfor %}
   
    Should Be Equal Value Json Yaml    ${service_lan_vpn_data}    $..enableSdra    {{ lan_vpn.sdwan_remote_access|default('not_defined') }}   not_defined   msg= sdwan remote access  var_msg=variable not_defined

    Log    ======Routing Associations=======
    ${bgp_raw}=    Get Value From Json    ${service_profile_features[0]}    $[?(@.payload.name=='${service_lan_vpn_data['name']}')].subparcels[?(@.parcelType=='routing/bgp')]
    ${bgp}=    Set Variable If    ${bgp_raw} == []    not_defined    ${bgp_raw[0]}
    Should Be Equal Value Json String    ${bgp}    $.payload.name   {{ lan_vpn.bgp | default('not_defined') }}     msg=service lan vpn bgp

{% endfor %}
{% endif %}
{% endfor %}
{% endif %}
