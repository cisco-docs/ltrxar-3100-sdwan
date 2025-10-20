*** Settings ***
Documentation   Verify Transport Profile Management VPN Profiles
Name            Transport Management VPN Profiles
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles     transport_profiles    management_vpn  
Resource        ../../../sdwan_common.resource

{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.transport_profiles is defined %}
{% set profile_management_vpn = [] %}
{% for profile in sdwan.feature_profiles.transport_profiles %}
 {% if profile.management_vpn is defined %}
  {% set _ = profile_management_vpn.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_management_vpn != [] %}

*** Test Cases ***
Get Transport Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport
    Set Suite Variable    ${r}

{% for profile in sdwan.feature_profiles.transport_profiles | default([]) %}
{% if profile.management_vpn is defined %}

Verify Feature Profiles Transport Profiles {{ profile.name }} Management VPN {{ profile.management_vpn.name | default(defaults.sdwan.feature_profiles.transport_profiles.management_vpn.name) }}

    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    Set Suite Variable  ${profile_id}

    ${transport_mngt_vpn_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}/management/vpn
    ${transport_mngt_vpn}=    Get Value From Json    ${transport_mngt_vpn_res.json()}    $..payload
    Run Keyword If    ${transport_mngt_vpn} == []    Fail    Feature '{{ profile.management_vpn.name | default(defaults.sdwan.feature_profiles.transport_profiles.management_vpn.name) }}' expected to be configured within the transport profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${transport_mngt_vpn}
    log   ${transport_mngt_vpn}
    ${vpn_parcel_id}=    Get Value From Json   ${transport_mngt_vpn_res.json()}    $.data[0].parcelId
    Set Suite Variable  ${vpn_parcel_id}

    Should Be Equal Value Json String    ${transport_mngt_vpn[0]}    $..name    {{ profile.management_vpn.name | default(defaults.sdwan.feature_profiles.transport_profiles.management_vpn.name) }}    msg=transport_mngt_vpn name
    Should Be Equal Value Json Special_String    ${transport_mngt_vpn[0]}    $..description    {{ profile.management_vpn.description | default('not_defined') | normalize_special_string }}    msg=transport_mngt_vpn description

    Log   ======DNS Addresses=======

    Should Be Equal Value Json Yaml   ${transport_mngt_vpn}   $..data..dnsIpv4..primaryDnsAddressIpv4   {{profile.management_vpn.ipv4_primary_dns_address| default('not_defined')}}    {{profile.management_vpn.ipv4_primary_dns_address_variable| default('not_defined')}}   msg=management_vpn.ipv4_primary_dns_address  var_msg=management_vpn.ipv4_primary_dns_address_variable
    Should Be Equal Value Json Yaml   ${transport_mngt_vpn}    $..data.dnsIpv4.secondaryDnsAddressIpv4  {{profile.management_vpn.ipv4_secondary_dns_address| default('not_defined')}}    {{profile.management_vpn.ipv4_secondary_dns_address_variable| default('not_defined')}}   msg=management_vpn.ipv4_secondary_dns_address  var_msg=management_vpn.ipv4_secondary_dns_address_variable
    Should Be Equal Value Json Yaml   ${transport_mngt_vpn}     $..data.dnsIpv6.primaryDnsAddressIpv6   {{profile.management_vpn.ipv6_primary_dns_address| default('not_defined')}}    {{profile.management_vpn.ipv6_primary_dns_address| default('not_defined')}}   msg=management_vpn.ipv6_primary_dns_address  var_msg=management_vpn.ipv6_primary_dns_address_variable
    Should Be Equal Value Json Yaml   ${transport_mngt_vpn}    $..data.dnsIpv6.secondaryDnsAddressIpv6   {{profile.management_vpn.ipv6_secondary_dns_address| default('not_defined')}}    {{profile.management_vpn.ipv6_secondary_dns_address_variable| default('not_defined')}}   msg=management_vpn.ipv6_secondary_dns_address  var_msg=management_vpn.ipv6_secondary_dns_address_variable

    Should Be Equal Value Json List Length   ${transport_mngt_vpn}  $..newHostMapping  {{ profile.management_vpn.get('host_mappings', []) | length }}    msg=host mappings length

{% if profile.management_vpn.host_mappings is defined and profile.management_vpn.get('host_mappings', [])|length > 0 %}
    
    Log   ======Host Mappings=======
        
{% for host_entry in profile.management_vpn.host_mappings | default([]) %}

    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..newHostMapping[{{ loop.index0 }}]..hostName   {{ host_entry.hostname | default('not_defined') }}     {{ host_entry.hostname_variable | default('not_defined') }}     msg=transport_mngt_vpn host_entry.hostname     var_msg=transport_mngt_vpn host_entry.hostname variable
    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..newHostMapping[{{ loop.index0 }}]..listOfIp   {{ host_entry.ips | default('not_defined') }}     {{ host_entry.ips_variable | default('not_defined') }}     msg=transport_mngt_vpn host_entry.ips     var_msg=transport_mngt_vpn host_entry.ips variable

{% endfor %}

{% endif %}

    Should Be Equal Value Json List Length   ${transport_mngt_vpn}  $..[ipv4Route]  {{ profile.management_vpn.get('ipv4_static_routes', []) | length }}    msg=ipv4 static routes length

{% if profile.management_vpn.ipv4_static_routes is defined and profile.management_vpn.get('ipv4_static_routes', [])|length > 0 %}

    Log   ======IPv4 Static Routes=======

{% for route_entry in profile.management_vpn.ipv4_static_routes | default([]) %}
    
    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..ipv4Route[{{ loop.index0 }}].prefix.ipAddress   {{ route_entry.network_address| default('not_defined') }}     {{ route_entry.network_address_variable| default('not_defined') }}     msg=transport_mngt_vpn route_entry.network_address     var_msg=transport_mngt_vpn route_entry.network_address variable
    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..ipv4Route[{{ loop.index0 }}].prefix.subnetMask   {{ route_entry.subnet_mask| default('not_defined') }}     {{ route_entry.subnet_mask_variable| default('not_defined') }}     msg=transport_mngt_vpn route_entry.subnet_mask     var_msg=transport_mngt_vpn route_entry.subnet_mask variable
    ${gateway_raw}=    Evaluate    "{{ route_entry.gateway | default(defaults.sdwan.feature_profiles.transport_profiles.management_vpn.ipv4_static_routes.gateway) }}"
    ${gateway}=    Run Keyword If    '${gateway_raw}' == 'nexthop'    Set Variable    nextHop    ELSE    Set Variable    ${gateway_raw}
    Should Be Equal Value Json String    ${transport_mngt_vpn[0]}    $..ipv4Route[{{ loop.index0 }}].gateway.value   ${gateway}     msg=transport_mngt_vpn route_entry.gateway
    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..ipv4Route[{{ loop.index0 }}].distance  {{ route_entry.administrative_distance | default('not_defined') }}     {{ route_entry.administrative_distance_variable | default('not_defined') }}     msg=transport_mngt_vpn route_entry.admin_distance     var_msg=transport_mngt_vpn route_entry.admin_distance variable

    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

    Should Be Equal Value Json List Length   ${transport_mngt_vpn[0]}  $..ipv4Route[${outer_loop_index}].nextHop  {{ route_entry.get('next_hops', []) | length }}    msg=transport_mngt_vpn wan_vpn next_hops length
    
{% if route_entry.next_hops is defined and route_entry.get('next_hops', []) | length > 0 %}
    
    Log   ======Next Hops=======
    
{% for nh_entry in route_entry.next_hops | default([]) %}
    
    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..ipv4Route[${outer_loop_index}].nextHop[{{ loop.index0 }}].address    {{ nh_entry.address | default('not_defined') }}   {{ nh_entry.address_variable | default('not_defined') }}    msg=transport_mngt_vpn mngt_vpn nh_entry.address  var_msg=transport_mngt_vpn mngt_vpn nh_entry.address variable
    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..ipv4Route[${outer_loop_index}].nextHop[{{ loop.index0 }}].distance    {{ nh_entry.administrative_distance | default('not_defined') }}    {{ nh_entry.administrative_distance_variable| default('not_defined') }}    msg=transport_mngt_vpn mngt_vpn nh_entry.admin_distance   var_msg=transport_mngt_vpn nh_entry.admin_distance_variable
    
{% endfor %}
    
{% endif %}
    
{% endfor %}
    
{% endif %}  

    Should Be Equal Value Json List Length   ${transport_mngt_vpn}  $..[ipv6Route]  {{ profile.management_vpn.get('ipv6_static_routes', []) | length }}    msg=ipv6 static routes length
    
{% if profile.management_vpn.ipv6_static_routes is defined and profile.management_vpn.get('ipv6_static_routes', [])|length > 0 %}

    Log   ======IPv6 Static Routes=======

{% for ipv6_route in profile.management_vpn.ipv6_static_routes | default([]) %}

    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..ipv6Route[{{ loop.index0 }}].prefix   {{ ipv6_route.prefix| default('not_defined') }}     {{ ipv6_route.prefix_variable| default('not_defined') }}     msg=transport_mgnt_vpn route_entry.prefix     var_msg=transport_mngt_vpn route_entry.prefix variable
    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

    Should Be Equal Value Json List Length   ${transport_mngt_vpn[0]}  $..ipv6Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHop  {{ ipv6_route.get('next_hops', []) | length }}    msg=transport_mngt_vpn ipv6 route next_hops length

{% for hop in ipv6_route.next_hops | default([]) %}

    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..ipv6Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHop[{{ loop.index0 }}].address    {{ hop.address | default('not_defined') }}     {{ hop.address_variable | default('not_defined') }}    msg=transport_mngt_vpn wan_vpn nh6_entry.address     var_msg=transport_mngt_vpn nh6_entry.address variable
    Should Be Equal Value Json Yaml    ${transport_mngt_vpn[0]}    $..ipv6Route[${outer_loop_index}].oneOfIpRoute.nextHopContainer.nextHop[{{ loop.index0 }}].distance    {{ hop.administrative_distance | default('not_defined') }}    {{ hop.administrative_distance_variable| default('not_defined') }}    msg=transport_mngt_vpn nh6_entry.admin_distance   var_msg=transport_mngt_vpn nh6_entry.admin_distance_variable

{% endfor %}

    Should Be Equal Value Json String    ${transport_mngt_vpn[0]}    $..ipv6Route[{{ loop.index0 }}].oneOfIpRoute.null0.value    {{ true if ipv6_route.get("gateway", defaults.sdwan.feature_profiles.transport_profiles.management_vpn.ipv4_static_routes.gateway) == 'null0' else 'not_defined' }}    msg=transport_mgnt_vpn nh6_entry.null0
    ${nat_value}=    Set Variable    {{ ipv6_route.nat | default('not_defined') }}
    Run Keyword If    '${nat_value}' != 'not_defined'    Set Suite Variable    ${nat_value}    ${nat_value.upper()}
    Should Be Equal Value Json String    ${transport_mngt_vpn[0]}    $..ipv6Route[{{ loop.index0 }}].oneOfIpRoute.nat.value    ${nat_value}    msg=transport_mgnt_vpn nh6_entry.nat

{% endfor %}

{% endif %} 

    ${trans_mngt_vpn_intf_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}/management/vpn/${vpn_parcel_id}[0]/interface/ethernet
    ${trans_mngt_vpn_intf}=    Get Value From Json    ${trans_mngt_vpn_intf_res.json()}    $..payload
    Set Suite Variable    ${trans_mngt_vpn_intf}
    Should Be Equal Value Json List Length   ${trans_mngt_vpn_intf}   $   {{ profile.management_vpn.get('ethernet_interfaces', []) | length }}    msg=transport_mngt_vpn ethernet interfaces length

{% if profile.management_vpn.ethernet_interfaces is defined and profile.management_vpn.get('ethernet_interfaces', [])|length > 0 %}

    Log   ======Ethernet Interfaces=======

{% for intf_entry in profile.management_vpn.ethernet_interfaces | default([]) %}

    ${current_json_item}=   Set Variable    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}
    Set Suite Variable     ${current_json_item}

    Should Be Equal Value Json String   ${trans_mngt_vpn_intf[{{ loop.index0 }}]}  $..name  {{ intf_entry.name | default('not_defined') }}  msg=transport_mngt_vpn_interface name
    Should Be Equal Value Json Special_String   ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $.description   {{ intf_entry.description | default('not_defined') | normalize_special_string }}    msg=transport_mngt_vpn interface feature description

    Should Be Equal Value Json Yaml   ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..interfaceName    {{ intf_entry.interface_name | default('not_defined') }}    {{ intf_entry.interface_name_variable | default('not_defined') }}   msg=transport_mngt_vpn wan_vpn interface interface_name   var_msg=transport_mngt_vpn wan_vpn interface interface_name variable
    Should Be Equal Value Json Special_String    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $.data.description.value  {{ intf_entry.interface_description | default('not_defined') | normalize_special_string }}   msg=transport_mngt_vpn interface interface_description   

    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..intfIpAddress.static.staticIpV4AddressPrimary.ipAddress   {{ intf_entry.ipv4_address| default('not_defined') }}     {{ intf_entry.ipv4_address_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface ipv4_address     var_msg=transport_mngt_vpn wan_vpn interface ipv4_address variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..intfIpAddress.static.staticIpV4AddressPrimary.subnetMask   {{ intf_entry.ipv4_subnet_mask| default('not_defined') }}     {{ intf_entry.ipv4_subnet_mask_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface ipv4_subnet_mask     var_msg=transport_mngt_vpn wan_vpn interface ipv4_subnet_mask variable

    Should Be Equal Value Json List Length   ${trans_mngt_vpn_intf[{{ loop.index0 }}]}  $..staticIpV4AddressSecondary  {{ intf_entry.get('ipv4_secondary_addresses', []) | length }}    msg=transport_mngt_vpn wan_vpn interface ipv4_secondary_addresses length

    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

{% for sec_addr in intf_entry.ipv4_secondary_addresses | default([]) %}

    Should Be Equal Value Json Yaml     ${trans_mngt_vpn_intf[${outer_loop_index}]}    $..staticIpV4AddressSecondary[{{ loop.index0 }}].ipAddress   {{ sec_addr.address | default('not_defined') }}     {{ sec_addr.address_variable | default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface ipv4_secondary_address     var_msg=transport_mngt_vpn wan_vpn interface ipv4_secondary_address variable
    Should Be Equal Value Json Yaml     ${trans_mngt_vpn_intf[${outer_loop_index}]}   $..staticIpV4AddressSecondary[{{ loop.index0 }}].subnetMask   {{ sec_addr.subnet_mask | default('not_defined') }}     {{ sec_addr.subnet_mask_variable | default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface ipv4_secondary_subnet_mask     var_msg=transport_mngt_vpn wan_vpn interface ipv4_secondary_subnet_mask variable

{% endfor %}
        
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..intfIpAddress.dynamic.dynamicDhcpDistance   {{ intf_entry.ipv4_dhcp_distance| default('not_defined') }}     {{ intf_entry.ipv4_dhcp_distance_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface ipv4_dhcp_distance     var_msg=transport_mngt_vpn wan_vpn interface ipv4_dhcp_distance variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..dhcpHelper   {{ intf_entry.ipv4_dhcp_helpers| default('not_defined') }}     {{ intf_entry.ipv4_dhcp_helpers_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface ipv4_dhcp_helpers     var_msg=transport_mngt_vpn wan_vpn interface ipv4_dhcp_helpers variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..iperfServer   {{ intf_entry.iperf_server| default('not_defined') }}     {{ intf_entry.iperf_server_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface iperf_server     var_msg=transport_mngt_vpn wan_vpn interface iperf_server variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..autoDetectBandwidth   {{ intf_entry.auto_detect_bandwidth| default('not_defined') }}     {{ intf_entry.auto_detect_bandwidth_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface auto_detect_bandwidth     var_msg=transport_mngt_vpn wan_vpn interface auto_detect_bandwidth variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..intfIpV6Address.static.primaryIpV6Address.address   {{ intf_entry.ipv6_address| default('not_defined') }}     {{ intf_entry.ipv6_address_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface ipv6_address     var_msg=transport_mngt_vpn wan_vpn interface ipv6_address variable
    
    Should Be Equal Value Json List Length   ${trans_mngt_vpn_intf}    $..arp   {{ intf_entry.get('arp_entries', []) | length }}    msg=transport_mngt_vpn wan_vpn interface arp entries length
  
{% if intf_entry.arp_entries is defined and intf_entry.get('arp_entries', [])|length > 0 %}

    Log      === Arp Entries ===

{% for arp_entry in intf_entry.arp_entries | default([]) %}

    Should Be Equal Value Json Yaml    ${current_json_item}    $..arp[{{ loop.index0 }}].ipAddress   {{ arp_entry.ip_address| default('not_defined') }}     {{ arp_entry.ip_address_variable| default('not_defined') }}     msg=transport_mngt_vpn intf arp_entry.ip_address     var_msg=transport_mngt_vpn intf arp_entry.ip_address variable
    Should Be Equal Value Json Yaml    ${current_json_item}    $..arp[{{ loop.index0 }}].macAddress   {{ arp_entry.mac_address| default('not_defined') }}     {{ arp_entry.mac_address_variable| default('not_defined') }}     msg=transport_mngt_vpn intf arp_entry.mac_address     var_msg=transport_mngt_vpn intf arp_entry.mac_address variable


{% endfor %}

{% endif %}

    Log      === Advanced Features ===

    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.duplex   {{ intf_entry.duplex| default('not_defined') }}     {{ intf_entry.duplex_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface duplex     var_msg=transport_mngt_vpn wan_vpn interface duplex variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.macAddress   {{ intf_entry.mac_address| default('not_defined') }}     {{ intf_entry.mac_address_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface mac_address     var_msg=transport_mngt_vpn wan_vpn interface mac_address variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.ipMtu   {{ intf_entry.ip_mtu| default('not_defined') }}     {{ intf_entry.ip_mtu_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface ip_mtu     var_msg=transport_mngt_vpn wan_vpn interface ip_mtu variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.intrfMtu   {{ intf_entry.interface_mtu| default('not_defined') }}     {{ intf_entry.interface_mtu_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface interface_mtu     var_msg=transport_mngt_vpn wan_vpn interface interface_mtu variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.tcpMss   {{ intf_entry.tcp_mss| default('not_defined') }}     {{ intf_entry.tcp_mss_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface tcp_mss     var_msg=transport_mngt_vpn wan_vpn interface tcp_mss variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.speed   {{ intf_entry.speed| default('not_defined') }}     {{ intf_entry.speed_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface speed     var_msg=transport_mngt_vpn wan_vpn interface speed variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.arpTimeout   {{ intf_entry.arp_timeout| default('not_defined') }}     {{ intf_entry.arp_timeout_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface arp_timeout     var_msg=transport_mngt_vpn wan_vpn interface arp_timeout variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.autonegotiate   {{ intf_entry.autonegotiate| default('not_defined') }}     {{ intf_entry.autonegotiate_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface autonegotiate     var_msg=transport_mngt_vpn wan_vpn interface autonegotiate variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.mediaType   {{ intf_entry.media_type| default('not_defined') }}     {{ intf_entry.media_type_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface media_type     var_msg=transport_mngt_vpn wan_vpn interface media_type variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.loadInterval   {{ intf_entry.load_interval| default('not_defined') }}     {{ intf_entry.load_interval_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface load_interval     var_msg=transport_mngt_vpn wan_vpn interface load_interval variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.icmpRedirectDisable   {{ intf_entry.icmp_redirect_disable| default('not_defined') }}     {{ intf_entry.icmp_redirect_disable_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface icmp_redirect_disable     var_msg=transport_mngt_vpn wan_vpn interface icmp_redirect_disable variable
    Should Be Equal Value Json Yaml    ${trans_mngt_vpn_intf[{{ loop.index0 }}]}    $..advanced.ipDirectedBroadcast   {{ intf_entry.ip_directed_broadcast| default('not_defined') }}     {{ intf_entry.ip_directed_broadcast_variable| default('not_defined') }}     msg=transport_mngt_vpn wan_vpn interface ip_directed_broadcast     var_msg=transport_mngt_vpn wan_vpn interface ip_directed_broadcast variable

{% endfor %}

{% endif %}

{% endif %}
    
{% endfor %}

{% endif %}

{% endif %}