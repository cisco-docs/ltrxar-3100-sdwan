*** Settings ***
Documentation   Verify Transport Feature Profile Configuration WAN VPN Ethernet Interfaces
Suite Setup     Login SDWAN Manager
Name            Transport Profiles WAN VPN Ethernet Interfaces
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles   transport_profiles  wan_vpn  ethernet_interfaces
Resource        ../../../sdwan_common.resource

{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.transport_profiles is defined %}
{% set profile_wan_vpn = [] %}
{% for profile in sdwan.feature_profiles.transport_profiles %}
 {% if profile.wan_vpn is defined %}
  {% set _ = profile_wan_vpn.append(profile.name) %}
 {% endif %}
{% endfor %}

{% if profile_wan_vpn != [] %}

*** Test Cases ***
Get Transport Profiles
    ${r}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport
    Set Suite Variable    ${r}


{% for profile in sdwan.feature_profiles.transport_profiles | default([]) %}
{% if profile.wan_vpn.ethernet_interfaces is defined and profile.wan_vpn.get('ethernet_interfaces' , [])|length > 0 %}

Verify Feature Profiles Transport Profiles {{ profile.name }} WAN VPN {{ profile.wan_vpn.name | default(defaults.sdwan.feature_profiles.transport_profiles.wan_vpn.name) }} Interfaces 

    ${profile}=    Get Value From Json    ${r.json()}    $[?(@.profileName=='{{ profile.name }}')]
    Run Keyword If    ${profile} == []    Fail    Feature Profile '{{profile.name}}' should be present on the Manager
    ${profile_id}=    Get Value From Json    ${profile}    $..profileId
    ${transport_wan_vpn_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}/wan/vpn
    ${transport_profile_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}
    ${transport_wan_vpn}=    Get Value From Json    ${transport_wan_vpn_res.json()}    $..payload
    Run Keyword If    ${transport_wan_vpn} == []    Fail    Feature '{{profile.wan_vpn.name | default(defaults.sdwan.feature_profiles.transport_profiles.wan_vpn.name)}}' expected to be configured within the transport profile '{{profile.name}}' on the Manager
    ${vpn_parcel_id}=    Get Value From Json   ${transport_wan_vpn_res.json()}    $.data[0].parcelId
    Set Suite Variable  ${vpn_parcel_id}

    ${trans_wan_vpn_intf_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/transport/${profile_id[0]}/wan/vpn/${vpn_parcel_id}[0]/interface/ethernet
    ${trans_wan_vpn_intf}=    Get Value From Json    ${trans_wan_vpn_intf_res.json()}    $..payload
    Set Suite Variable    ${trans_wan_vpn_intf}

    ${tracker_groups_ethernet_interfaces}=    Get Value From Json    ${transport_profile_res.json()}    $..subparcels[?(@.parcelType=='wan/vpn/interface/ethernet')]
    Set Suite Variable    ${tracker_groups_ethernet_interfaces}

    ${ipv4_acls}=    Get Value From Json    ${transport_profile_res.json()}    $..associatedProfileParcels[?(@.parcelType=='ipv4-acl')]
    Set Suite Variable    ${ipv4_acls}

    ${ipv6_acls}=    Get Value From Json    ${transport_profile_res.json()}    $..associatedProfileParcels[?(@.parcelType=='ipv6-acl')]
    Set Suite Variable    ${ipv6_acls}

    Should Be Equal Value Json List Length   ${trans_wan_vpn_intf}   $   {{ profile.wan_vpn.get('ethernet_interfaces' , []) | length }}    msg=transport_wan_vpn ethernet_interfaces length

{% for intf_entry in profile.wan_vpn.ethernet_interfaces | default([]) %}

    Log   ======Ethernet Interfaces {{ intf_entry.name }} =======

    ${r_interface_name}=  Get Value From Json    ${trans_wan_vpn_intf}      $[?(@.name=={{intf_entry.name}})]
    ${tracker_groups_ethernet_interface}=   Get Value From Json    ${tracker_groups_ethernet_interfaces}    $[?(@.payload.name=={{intf_entry.name}})]

    Log   ======Tracker Associations=======

    Should Be Equal Value Json String     ${tracker_groups_ethernet_interface[0]}   $.subparcels[?(@.parcelType=='trackergroup')].payload.name  {{ intf_entry.ipv4_tracker_group | default('not_defined') }}    msg=transport_wan_vpn ethernet_interfaces ipv4 tracker group name
    Should Be Equal Value Json String     ${tracker_groups_ethernet_interface[0]}   $.subparcels[?(@.parcelType=='ipv6-trackergroup')].payload.name  {{ intf_entry.ipv6_tracker_group | default('not_defined') }}    msg=transport_wan_vpn ethernet_interfaces ipv6 tracker group name
    Should Be Equal Value Json String     ${tracker_groups_ethernet_interface[0]}   $.subparcels[?(@.parcelType=='tracker')].payload.name        {{ intf_entry.ipv4_tracker | default('not_defined') }}    msg=transport_wan_vpn ethernet_interfaces tracker name
    Should Be Equal Value Json String     ${tracker_groups_ethernet_interface[0]}   $.subparcels[?(@.parcelType=='ipv6-tracker')].payload.name   {{ intf_entry.ipv6_tracker | default('not_defined') }}    msg=transport_wan_vpn ethernet_interfaces ipv6 tracker name

    Log   ======Basic Configuration========

    Should Be Equal Value Json String    ${r_interface_name[0]}    $..name    {{ intf_entry.name | default('not_defined') }}    msg=transport_wan_vpn wan_vpn interface name
    Should Be Equal Value Json Special_String    ${r_interface_name[0]}   $.description   {{ intf_entry.description | default('not_defined') | normalize_special_string }}   msg=transport_wan_vpn wan_vpn description
    
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..interfaceName    {{ intf_entry.interface_name | default('not_defined') }}    {{ intf_entry.interface_name_variable | default('not_defined') }}     msg=transport_wan_vpn wan_vpn interface interface_name   var_msg=transport_wan_vpn wan_vpn interface interface_name variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..data..description   {{ intf_entry.interface_description | default('not_defined') }}   {{ intf_entry.interface_description_variable | default('not_defined') }}   msg=transport_wan_vpn interface interface_description   var_msg=transport_wan_vpn interface interface_description variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..shutdown      {{ intf_entry.shutdown | default('not_defined') }}    {{ intf_entry.shutdown_variable | default('not_defined') }}    msg=transport_wan_vpn interface shutdown   var_msg=transport_wan_vpn interface shutdown variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..serviceProvider  {{ intf_entry.service_provider | default('not_defined') }}    {{ intf_entry.service_provider_variable | default("not_defined") }}   msg=transport_wan_vpn interface service provider   var_msg=transport_wan_vpn interface name service provider variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..bandwidthUpstream  {{ intf_entry.bandwidth_upstream | default('not_defined') }}    {{ intf_entry.bandwidth_upstream_variable | default("not_defined") }}   msg=transport_wan_vpn interface bandwidth_upstream   var_msg=transport_wan_vpn interface bandwidth_upstream variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..bandwidthDownstream  {{ intf_entry.bandwidth_downstream | default('not_defined') }}    {{ intf_entry.bandwidth_downstream_variable | default("not_defined") }}   msg=transport_wan_vpn interface bandwidth_downstream   var_msg=transport_wan_vpn interface bandwidth_downstream variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..autoDetectBandwidth  {{ intf_entry.auto_detect_bandwidth | default('not_defined') }}    {{ intf_entry.auto_detect_bandwidth_variable | default("not_defined") }}   msg=transport_wan_vpn interface auto_detect_bandwidth   var_msg=transport_wan_vpn interface auto_detect_bandwidth variable

    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..intfIpAddress.static.staticIpV4AddressPrimary.ipAddress   {{ intf_entry.ipv4_address| default('not_defined') }}     {{ intf_entry.ipv4_address_variable| default('not_defined') }}     msg=transport_wan_vpn interface ipv4_address     var_msg=transport_wan_vpn interface ipv4_address variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..intfIpAddress.static.staticIpV4AddressPrimary.subnetMask   {{ intf_entry.ipv4_subnet_mask| default('not_defined') }}     {{ intf_entry.ipv4_subnet_mask_variable| default('not_defined') }}     msg=transport_wan_vpn interface ipv4_subnet_mask     var_msg=transport_wan_vpn interface ipv4_subnet_mask variable  

    Should Be Equal Value Json List Length   ${r_interface_name[0]}  $..staticIpV4AddressSecondary  {{ intf_entry.get('ipv4_secondary_addresses' , [] ) | length }}    msg=ipv4 secondary addresses length
    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

{% for sec_addr in intf_entry.ipv4_secondary_addresses | default([]) %}

    Should Be Equal Value Json Yaml    ${r_interface_name}     $..staticIpV4AddressSecondary[{{ loop.index0 }}]..ipAddress   {{ sec_addr.address | default('not_defined') }}     {{ sec_addr.address_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv4_address     var_msg=transport_wan_vpn interface ipv4_address variable
    Should Be Equal Value Json Yaml    ${r_interface_name}     $..staticIpV4AddressSecondary[{{ loop.index0 }}]..subnetMask   {{ sec_addr.subnet_mask | default('not_defined') }}     {{ sec_addr.subnet_mask_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv4_address     var_msg=transport_wan_vpn interface ipv4_address variable

{% endfor %}
    
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..intfIpAddress.dynamic.dynamicDhcpDistance   {{ intf_entry.ipv4_dhcp_distance| default('not_defined') }}     {{ intf_entry.ipv4_dhcp_distance_variable| default('not_defined') }}     msg=transport_wan_vpn interface ipv4_dhcp_distance     var_msg=transport_wan_vpn interface ipv4_dhcp_distance variable

{% if intf_entry.ipv4_dhcp_helpers is defined and intf_entry.get('ipv4_dhcp_helpers' , []) | length > 0 %}

    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}
    ${dhcp_helpers_list}=    Create List    {{ intf_entry.ipv4_dhcp_helpers | join('   ') }}
    ${r_dhcp_helpers_list}=    Create List

    ${r_dhcp_helpers_list}=   Get Value From Json    ${r_interface_name[0]}     $..dhcpHelper..value
    
    Lists Should Be Equal   ${dhcp_helpers_list}    ${r_dhcp_helpers_list[0]}     msg:transport_wan_vpn_intf_dhcp_helpers_list      ignore_order=True

{% endif %}

    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..intfIpV6Address..primaryIpV6Address.address   {{ intf_entry.ipv6_address| default('not_defined') }}     {{ intf_entry.ipv6_address_variable| default('not_defined') }}     msg=transport_wan_vpn interface ipv6_address     var_msg=transport_wan_vpn interface ipv6_address variable
    Should Be Equal Value Json List Length      ${r_interface_name[0]}  $..intfIpV6Address..secondaryIpV6Address  {{ intf_entry.get('ipv6_secondary_addresses', []) | length }}    msg=ipv6 secondary addresses length

    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

{% for sec_addr in intf_entry.ipv6_secondary_addresses  | default([]) %}

    ${sec_addr_vt}=   Get Value From Json   ${r_interface_name}     $..secondaryIpV6Address[{{ loop.index0 }}]..value
    Should Be Equal Value Json Yaml    ${r_interface_name}     $..secondaryIpV6Address[{{ loop.index0 }}]..address   {{ sec_addr.address | default('not_defined') }}     {{ sec_addr.address_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv6_address     var_msg=transport_wan_vpn interface ipv6_address variable

{% endfor %}

    Log    ======Tunnel Configurations=======

    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..perTunnelQos    {{ intf_entry.tunnel_interface.per_tunnel_qos | default('not_defined') }}   {{ intf_entry.tunnel_interface.per_tunnel_qos_variable | default('not_defined') }}    msg=transport_wan_vpn interface per tunnel qos      var_msg=transport_wan_vpn interface per tunnel qos variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..bind      {{ intf_entry.tunnel_interface.bind_loopback_tunnel | default('not_defined') }}     {{ intf_entry.tunnel_interface.bind_loopback_tunnel_variable | default('not_defined') }}     msg=transport_wan_vpn interface bind loopback    var_msg=transport_wan_vpn interface bind loopback variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..carrier   {{ intf_entry.tunnel_interface.carrier | default('not_defined') }}     {{ intf_entry.tunnel_interface.carrier_variable| default('not_defined') }}     msg=transport_wan_vpn interface carrier     var_msg=transport_wan_vpn interface carrier variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..color   {{ intf_entry.tunnel_interface.color | default('not_defined') }}     {{ intf_entry.tunnel_interface.color_variable| default('not_defined') }}     msg=transport_wan_vpn interface color     var_msg=transport_wan_vpn interface color variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..helloInterval   {{ intf_entry.tunnel_interface.hello_interval | default('not_defined') }}     {{ intf_entry.tunnel_interface.hello_interval_variable| default('not_defined') }}     msg=transport_wan_vpn interface hello interval     var_msg=transport_wan_vpn interface hello interval variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..helloTolerance   {{ intf_entry.tunnel_interface.hello_tolerance | default('not_defined') }}     {{ intf_entry.tunnel_interface.hello_tolerance_variable| default('not_defined') }}     msg=transport_wan_vpn interface hello tolerance     var_msg=transport_wan_vpn interface hello tolerance variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..lastResortCircuit   {{ intf_entry.tunnel_interface.last_resort_circuit | default('not_defined') }}     {{ intf_entry.tunnel_interface.last_resort_circuit_variable| default('not_defined') }}     msg=transport_wan_vpn interface last_resort_circuit     var_msg=transport_wan_vpn last_resort_circuit variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..tlocExtensionGreTo   {{ intf_entry.tunnel_interface.gre_tunnel_destination_ip | default('not_defined') }}     {{ intf_entry.tunnel_interface.gre_tunnel_destination_ip_variable | default('not_defined') }}     msg=transport_wan_vpn interface gre_tunnel_destination_ip     var_msg=transport_wan_vpn gre_tunnel_destination_ip_variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..restrict   {{ intf_entry.tunnel_interface.restrict | default('not_defined') }}     {{ intf_entry.tunnel_interface.restrict_variable| default('not_defined') }}     msg=transport_wan_vpn interface restrict    var_msg=transport_wan_vpn restrict variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..group   {{ intf_entry.tunnel_interface.group | default('not_defined') }}     {{ intf_entry.tunnel_interface.group_variable| default('not_defined') }}     msg=transport_wan_vpn interface group     var_msg=transport_wan_vpn group variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..border   {{ intf_entry.tunnel_interface.border | default('not_defined') }}     {{ intf_entry.tunnel_interface.border_variable| default('not_defined') }}     msg=transport_wan_vpn interface border     var_msg=transport_wan_vpn border variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..maxControlConnections   {{ intf_entry.tunnel_interface.max_control_connections | default('not_defined') }}     {{ intf_entry.tunnel_interface.max_control_connections_variable| default('not_defined') }}     msg=transport_wan_vpn interface max_control_connections     var_msg=transport_wan_vpn max_control_connections variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..natRefreshInterval   {{ intf_entry.tunnel_interface.nat_refresh_interval | default('not_defined') }}     {{ intf_entry.tunnel_interface.nat_refresh_interval_variable| default('not_defined') }}     msg=transport_wan_vpn interface nat_refresh_interval     var_msg=transport_wan_vpn nat_refresh_interval variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..vBondAsStunServer   {{ intf_entry.tunnel_interface.vbond_as_stun_server | default('not_defined') }}     {{ intf_entry.tunnel_interface.vbond_as_stun_server_variable| default('not_defined') }}     msg=transport_wan_vpn interface vbond_as_stun_server     var_msg=transport_wan_vpn vbond_as_stun_server variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..excludeControllerGroupList   {{ intf_entry.tunnel_interface.exclude_controller_groups | default('not_defined') }}     {{ intf_entry.tunnel_interface.exclude_controller_groups | default('not_defined') }}     msg=transport_wan_vpn interface exclude_controller_groups     var_msg=transport_wan_vpn exclude_controller_groups variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..vManageConnectionPreference   {{ intf_entry.tunnel_interface.vmanage_connection_preference | default('not_defined') }}     {{ intf_entry.tunnel_interface.vmanage_connection_preference_variable| default('not_defined') }}     msg=transport_wan_vpn interface vmanage_connection_preference     var_msg=transport_wan_vpn vmanage_connection_preference variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..portHop   {{ intf_entry.tunnel_interface.port_hop | default('not_defined') }}     {{ intf_entry.tunnel_interface.port_hop_variable| default('not_defined') }}     msg=transport_wan_vpn interface port_hop     var_msg=transport_wan_vpn port_hop variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..lowBandwidthLink   {{ intf_entry.tunnel_interface.low_bandwidth_link | default('not_defined') }}     {{ intf_entry.tunnel_interface.low_bandwidth_link_variable| default('not_defined') }}     msg=transport_wan_vpn interface low_bandwidth_link     var_msg=transport_wan_vpn low_bandwidth_link variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..tunnelTcpMss   {{ intf_entry.tunnel_interface.tcp_mss | default('not_defined') }}     {{ intf_entry.tunnel_interface.tcp_mss_variable| default('not_defined') }}     msg=transport_wan_vpn interface tcp_mss     var_msg=transport_wan_vpn tcp_mss variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..clearDontFragment   {{ intf_entry.tunnel_interface.clear_dont_fragment | default('not_defined') }}     {{ intf_entry.tunnel_interface.clear_dont_fragment_variable| default('not_defined') }}     msg=transport_wan_vpn interface clear_dont_fragment     var_msg=transport_wan_vpn clear_dont_fragment variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..ctsSgtPropagation   {{ intf_entry.tunnel_interface.cts_sgt_propagation | default('not_defined') }}     {{ intf_entry.tunnel_interface.cts_sgt_propagation_variable| default('not_defined') }}     msg=transport_wan_vpn interface cts_sgt_propagation     var_msg=transport_wan_vpn cts_sgt_propagation variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..networkBroadcast   {{ intf_entry.tunnel_interface.network_broadcast | default('not_defined') }}     {{ intf_entry.tunnel_interface.network_broadcast_variable| default('not_defined') }}     msg=transport_wan_vpn interface network_broadcast     var_msg=transport_wan_vpn network_broadcast variable
    
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..all  {{ intf_entry.tunnel_interface.allow_service_all | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_all_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_all     var_msg=transport_wan_vpn allow_service_all variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..bgp  {{ intf_entry.tunnel_interface.allow_service_bgp | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_bgp_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_bgp     var_msg=transport_wan_vpn allow_service_bgp variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..dhcp  {{ intf_entry.tunnel_interface.allow_service_dhcp | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_dhcp_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_dhcp     var_msg=transport_wan_vpn allow_service_dhcp variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..ntp  {{ intf_entry.tunnel_interface.allow_service_ntp | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_ntp_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_ntp    var_msg=transport_wan_vpn allow_service_ntp variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..ssh  {{ intf_entry.tunnel_interface.allow_service_ssh | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_ssh_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_ssh     var_msg=transport_wan_vpn allow_service_ssh variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..dns  {{ intf_entry.tunnel_interface.allow_service_dns | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_dns_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_dns     var_msg=transport_wan_vpn allow_service_dns variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..icmp  {{ intf_entry.tunnel_interface.allow_service_icmp | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_icmp_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_icmp     var_msg=transport_wan_vpn allow_service_icmp variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..https  {{ intf_entry.tunnel_interface.allow_service_https | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_https_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_https     var_msg=transport_wan_vpn allow_service_https variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..ospf  {{ intf_entry.tunnel_interface.allow_service_ospf | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_ospf_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_ospf     var_msg=transport_wan_vpn allow_service_ospf variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..stun  {{ intf_entry.tunnel_interface.allow_service_stun | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_stun_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_stun     var_msg=transport_wan_vpn allow_service_stun variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..snmp  {{ intf_entry.tunnel_interface.allow_service_snmp | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_snmp_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_snmp     var_msg=transport_wan_vpn allow_service_snmp variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..netconf  {{ intf_entry.tunnel_interface.allow_service_netconf | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_netconf_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_netconf     var_msg=transport_wan_vpn allow_service_netconf variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..allowService..bfd  {{ intf_entry.tunnel_interface.allow_service_bfd | default('not_defined') }}     {{ intf_entry.tunnel_interface.allow_service_bfd_variable| default('not_defined') }}     msg=transport_wan_vpn interface allow_service_bfd     var_msg=transport_wan_vpn allow_service_bfd variable

    ${result_gre}=    Get Value From Json    ${r_interface_name[0]}   $..encapsulation
    ${gre_object}=    Get Value From Json    ${result_gre[0]}    $[?(@.encap.value=='gre')]
    Should Be Equal Value Json Yaml   ${gre_object}    $..preference   {{ intf_entry.tunnel_interface.gre_preference | default('not_defined') }}   {{ intf_entry.tunnel_interface.gre_preference_variable | default('not_defined') }}  msg=transport_wan_vpn interface gre encapsulation    var_msg=transport_wan_vpn interface gre encapsulation variable
    Should Be Equal Value Json Yaml   ${gre_object}    $..weight   {{ intf_entry.tunnel_interface.gre_weight | default('not_defined') }}   {{ intf_entry.tunnel_interface.gre_weight_variable | default('not_defined') }}  msg=transport_wan_vpn interface gre weight    var_msg=transport_wan_vpn interface gre weight variable

    ${result_ipsec}=    Get Value From Json    ${r_interface_name[0]}   $..encapsulation
    ${ipsec_object}=    Get Value From Json    ${result_ipsec[0]}    $[?(@.encap.value=='ipsec')]
    Should Be Equal Value Json Yaml   ${ipsec_object}    $..preference   {{ intf_entry.tunnel_interface.ipsec_preference | default('not_defined') }}   {{ intf_entry.tunnel_interface.ipsec_preference_variable | default('not_defined') }}  msg=transport_wan_vpn interface ipsec encapsulation    var_msg=transport_wan_vpn interface ipsec encapsulation variable
    Should Be Equal Value Json Yaml   ${ipsec_object}    $..weight   {{ intf_entry.tunnel_interface.ipsec_weight | default('not_defined') }}   {{ intf_entry.tunnel_interface.ipsec_weight_variable | default('not_defined') }}  msg=transport_wan_vpn interface ipsec weight    var_msg=transport_wan_vpn interface ipsec weight variable


    Should Be Equal Value Json Yaml     ${r_interface_name[0]}    $..nat   {{ intf_entry.ipv4_nat | default('not_defined') }}     {{ intf_entry.ipv4_nat_variable | default('not_defined') }}     msg=transport_wan_vpn interface nat     var_msg=transport_wan_vpn interface nat variable
    Should Be Equal Value Json Yaml     ${r_interface_name[0]}    $..natAttributesIpv4..natType   {{ intf_entry.ipv4_nat_type | default('not_defined') }}     {{ intf_entry.ipv4_nat_type_variable| default('not_defined') }}     msg=transport_wan_vpn interface nat_type     var_msg=transport_wan_vpn interface nat_type variable
    Should Be Equal Value Json Yaml     ${r_interface_name[0]}    $..natAttributesIpv4..udpTimeout   {{ intf_entry.ipv4_nat_udp_timeout | default('not_defined') }}     {{ intf_entry.ipv4_nat_udp_timeout_variable| default('not_defined') }}     msg=transport_wan_vpn interface nat_udp_timeout     var_msg=transport_wan_vpn interface nat_udp_timeout variable
    Should Be Equal Value Json Yaml     ${r_interface_name[0]}    $..natAttributesIpv4..tcpTimeout   {{ intf_entry.ipv4_nat_tcp_timeout | default('not_defined') }}     {{ intf_entry.ipv4_nat_tcp_timeout_variable| default('not_defined') }}     msg=transport_wan_vpn interface nat_tcp_timeout     var_msg=transport_wan_vpn interface nat_tcp_timeout variable

    Should Be Equal Value Json List Length    ${r_interface_name[0]}   $..newStaticNat    {{ intf_entry.get('ipv4_nat_static_entries', []) | length }}    msg=transport_wan_vpn interface ipv4_nat_static_entries length
    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

{% for nat_entry in intf_entry.ipv4_nat_static_entries | default([]) %}

    Should Be Equal Value Json Yaml   ${r_interface_name}   $..newStaticNat[{{ loop.index0 }}]..sourceIp     {{ nat_entry.source_ip | default('not_defined') }}     {{ nat_entry.source_ip_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv4_nat_static_entries source_ip     var_msg=transport_wan_vpn interface ipv4_nat_static_entries source_ip variable
    Should Be Equal Value Json Yaml   ${r_interface_name}   $..newStaticNat[{{ loop.index0 }}]..translateIp     {{ nat_entry.translate_ip | default('not_defined') }}     {{ nat_entry.translate_ip_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv4_nat_static_entries translate_ip     var_msg=transport_wan_vpn interface ipv4_nat_static_entries translate_ip variable
    Should Be Equal Value Json String   ${r_interface_name}   $..newStaticNat[{{ loop.index0 }}]..staticNatDirection..value   {{ nat_entry.direction | default('not_defined') }}    msg=transport_wan_vpn interface ipv4_nat_static_entries direction
    Should Be Equal Value Json Yaml     ${r_interface_name}   $..newStaticNat[{{ loop.index0 }}]..sourceVpn  {{ nat_entry.source_vpn_id | default('not_defined') }}     {{ nat_entry.source_vpn_id_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv4_nat_static_entries source_vpn_id     var_msg=transport_wan_vpn interface ipv4_nat_static_entries source_vpn_id variable

{% endfor %}

    Should Be Equal Value Json String     ${r_interface_name[0]}    $..natIpv6..value  {{ intf_entry.ipv6_nat | default('False') }}      msg=transport_wan_vpn interface ipv6_nat 
    Run Keyword If    '{{ intf_entry.get('ipv6_nat_type')  }}' == 'nat64' or '{{ intf_entry.get('ipv6_nat_type') }}' == 'nat66'    Should Be Equal Value Json String     ${r_interface_name[0]}    $..natAttributesIpv6..{{ intf_entry.get('ipv6_nat_type') }}..value   {{ intf_entry.ipv6_nat | default('False') }}    msg=transport_wan_vpn interface ipv6_nat_type
    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

    Should Be Equal Value Json List Length      ${r_interface_name[0]}   $..natAttributesIpv6..staticNat66  {{ intf_entry.get('ipv6_nat66_static_entries', []) | length }}    msg=transport_wan_vpn interface ipv6_nat66_static_entries length

{% for nat_entry in intf_entry.ipv6_nat66_static_entries | default([]) %}

    Should Be Equal Value Json Yaml     ${r_interface_name}    $..natAttributesIpv6..staticNat66[{{ loop.index0 }}]..sourcePrefix  {{ nat_entry.source_prefix | default('not_defined') }}     {{ nat_entry.source_prefix_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv6_nat66_static_entries source_prefix     var_msg=transport_wan_vpn interface ipv6_nat66_static_entries source_prefix variable
    Should Be Equal Value Json Yaml     ${r_interface_name}    $..natAttributesIpv6..staticNat66[{{ loop.index0 }}]..translatedSourcePrefix  {{ nat_entry.translate_prefix | default('not_defined') }}     {{ nat_entry.translate_prefix_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv6_nat66_static_entries translated_source_prefix     var_msg=transport_wan_vpn interface ipv6_nat66_static_entries translated_source_prefix variable
    Should Be Equal Value Json Yaml     ${r_interface_name}    $..natAttributesIpv6..staticNat66[{{ loop.index0 }}]..sourceVpnId  {{ nat_entry.source_vpn_id | default('not_defined') }}     {{ nat_entry.source_vpn_id_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv6_nat66_static_entries source_vpn_id     var_msg=transport_wan_vpn interface ipv6_nat66_static_entries source_vpn_id variable

{% endfor %}

    Should Be Equal Value Json List Length      ${r_interface_name[0]}   $..natAttributesIpv6..staticNat64  {{ intf_entry.get('ipv6_nat64_static_entries', []) | length }}    msg=transport_wan_vpn interface ipv6_nat64_static_entries length

{% for nat_entry in intf_entry.ipv6_nat64_static_entries | default([]) %}

    Should Be Equal Value Json Yaml     ${r_interface_name}    $..natAttributesIpv6..staticNat64[{{ loop.index0 }}]..sourcePrefix  {{ nat_entry.source_prefix | default('not_defined') }}     {{ nat_entry.source_prefix_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv6_nat64_static_entries source_prefix     var_msg=transport_wan_vpn interface ipv6_nat64_static_entries source_prefix variable
    Should Be Equal Value Json Yaml     ${r_interface_name}    $..natAttributesIpv6..staticNat64[{{ loop.index0 }}]..translatedSourcePrefix  {{ nat_entry.translate_prefix | default('not_defined') }}     {{ nat_entry.translate_prefix_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv6_nat64_static_entries translated_source_prefix     var_msg=transport_wan_vpn interface ipv6_nat64_static_entries translated_source_prefix variable
    Should Be Equal Value Json Yaml     ${r_interface_name}    $..natAttributesIpv6..staticNat64[{{ loop.index0 }}]..sourceVpnId  {{ nat_entry.source_vpn_id | default('not_defined') }}     {{ nat_entry.source_vpn_id_variable | default('not_defined') }}     msg=transport_wan_vpn interface ipv6_nat64_static_entries source_vpn_id     var_msg=transport_wan_vpn interface ipv6_nat64_static_entries source_vpn_id variable

{% endfor %}


    Should Be Equal Value Json List Length      ${r_interface_name[0]}   $..arp  {{ intf_entry.get('arp_entries', []) | length }}    msg=transport_wan_vpn interface arp_entries length
    
    Log    ======ARP Entries======

{% for arp_entry in intf_entry.arp_entries | default([]) %}

    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..arp..ipAddress   {{ arp_entry.ip_address| default('not_defined') }}     {{ arp_entry.ip_address_variable| default('not_defined') }}     msg=transport_wan_vpn intf arp_entry.ip_address  var_msg=transport_wan_vpn intf arp_entry.ip_address variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..arp..macAddress   {{ arp_entry.mac_address| default('not_defined') }}     {{ arp_entry.mac_address_variable| default('not_defined') }}     msg=transport_wan_vpn intf arp_entry.mac_address  var_msg=transport_wan_vpn intf arp_entry.mac_address variable

{% endfor %}

    Log    ======ACL/QoS======

    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..aclQos.adaptiveQoS   {{ intf_entry.adaptive_qos | default('False') }}     {{ intf_entry.adaptive_qos_variable| default('False') }}     msg=transport_wan_vpn adaptive_qos     var_msg=transport_wan_vpn adaptive_qos variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..aclQos.adaptPeriod   {{ intf_entry.adaptive_qos_period| default('not_defined') }}     {{ intf_entry.adaptive_qos_period_variable| default('not_defined') }}     msg=transport_wan_vpn adaptive_qos_period     var_msg=transport_wan_vpn adaptive_qos_period variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..aclQos.shapingRateUpstreamConfig.minShapingRateUpstream  {{ intf_entry.adaptive_qos_shaping_rate_upstream.minimum| default('not_defined') }}     {{ intf_entry.adaptive_qos_shaping_rate_upstream.minimum_variable| default('not_defined') }}     msg=transport_wan_vpn adaptive_qos_shaping_rate_upstream minimum     var_msg=transport_wan_vpn adaptive_qos_shaping_rate_upstream minimum variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..aclQos.shapingRateUpstreamConfig.maxShapingRateUpstream   {{ intf_entry.adaptive_qos_shaping_rate_upstream.maximum| default('not_defined') }}     {{ intf_entry.adaptive_qos_shaping_rate_upstream.maximum_variable| default('not_defined') }}     msg=transport_wan_vpn adaptive_qos_shaping_rate_upstream maximum    var_msg=transport_wan_vpn adaptive_qos_shaping_rate_upstream maximum variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..aclQos.shapingRateUpstreamConfig.defaultShapingRateUpstream   {{ intf_entry.adaptive_qos_shaping_rate_upstream.default| default('not_defined') }}     {{ intf_entry.adaptive_qos_shaping_rate_upstream.default| default('not_defined') }}     msg=transport_wan_vpn adaptive_qos_shaping_rate_upstream default     var_msg=transport_wan_vpn adaptive_qos_shaping_rate_upstream.default variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..aclQos.shapingRateDownstreamConfig.minShapingRateDownstream  {{ intf_entry.adaptive_qos_shaping_rate_downstream.minimum| default('not_defined') }}     {{ intf_entry.adaptive_qos_shaping_rate_downstream.minimum_variable| default('not_defined') }}     msg=transport_wan_vpn adaptive_qos_shaping_rate_downstream minimum     var_msg=transport_wan_vpn adaptive_qos_shaping_rate_downstream minimum variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..aclQos.shapingRateDownstreamConfig.maxShapingRateDownstream   {{ intf_entry.adaptive_qos_shaping_rate_downstream.maximum| default('not_defined') }}     {{ intf_entry.adaptive_qos_shaping_rate_downstream.maximum_variable| default('not_defined') }}     msg=transport_wan_vpn adaptive_qos_shaping_rate_downstream maximum    var_msg=transport_wan_vpn adaptive_qos_shaping_rate_downstream maximum variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..aclQos.shapingRateDownstreamConfig.defaultShapingRateDownstream   {{ intf_entry.adaptive_qos_shaping_rate_downstream.default| default('not_defined') }}     {{ intf_entry.adaptive_qos_shaping_rate_downstream.default| default('not_defined') }}     msg=transport_wan_vpn adaptive_qos_shaping_rate_downstream.default     var_msg=transport_wan_vpn adaptive_qos_shaping_rate_udownstream default variable

    ${configured_ipv4_egress_acl_refid_raw}=    Get Value From Json    ${r_interface_name[0]}    $..aclQos.ipv4AclEgress.refId.value
    ${configured_ipv4_egress_acl_refid}=    Set Variable If    ${configured_ipv4_egress_acl_refid_raw} == []    not_defined    ${configured_ipv4_egress_acl_refid_raw[0]}
    ${configured_ipv4_egress_acl}=    Get Value From Json    ${ipv4_acls}    $[?(@.parcelId=='${configured_ipv4_egress_acl_refid}')]
    Should Be Equal Value Json String    ${configured_ipv4_egress_acl}    $..name    {{ intf_entry.ipv4_egress_acl | default('not_defined') }}    msg=wan_vpn.ethernet_interfaces_ipv4_egress_acl
    ${configured_ipv4_ingress_acl_refid_raw}=    Get Value From Json    ${r_interface_name[0]}    $..aclQos.ipv4AclIngress.refId.value
    ${configured_ipv4_ingress_acl_refid}=    Set Variable If    ${configured_ipv4_ingress_acl_refid_raw} == []    not_defined    ${configured_ipv4_ingress_acl_refid_raw[0]}
    ${configured_ipv4_ingress_acl}=    Get Value From Json    ${ipv4_acls}    $[?(@.parcelId=='${configured_ipv4_ingress_acl_refid}')]
    Should Be Equal Value Json String    ${configured_ipv4_ingress_acl}    $..name    {{ intf_entry.ipv4_ingress_acl | default('not_defined') }}    msg=wan_vpn.ethernet_interfaces_ipv4_ingress_acl

    ${configured_ipv6_egress_acl_refid_raw}=    Get Value From Json    ${r_interface_name[0]}    $..aclQos.ipv6AclEgress.refId.value
    ${configured_ipv6_egress_acl_refid}=    Set Variable If    ${configured_ipv6_egress_acl_refid_raw} == []    not_defined    ${configured_ipv6_egress_acl_refid_raw[0]}
    ${configured_ipv6_egress_acl}=    Get Value From Json    ${ipv6_acls}    $[?(@.parcelId=='${configured_ipv6_egress_acl_refid}')]
    Should Be Equal Value Json String    ${configured_ipv6_egress_acl}    $..name    {{ intf_entry.ipv6_egress_acl | default('not_defined') }}    msg=wan_vpn.ethernet_interfaces_ipv6_egress_acl
    ${configured_ipv6_ingress_acl_refid_raw}=    Get Value From Json    ${r_interface_name[0]}    $..aclQos.ipv6AclIngress.refId.value
    ${configured_ipv6_ingress_acl_refid}=    Set Variable If    ${configured_ipv6_ingress_acl_refid_raw} == []    not_defined    ${configured_ipv6_ingress_acl_refid_raw[0]}
    ${configured_ipv6_ingress_acl}=    Get Value From Json    ${ipv6_acls}    $[?(@.parcelId=='${configured_ipv6_ingress_acl_refid}')]
    Should Be Equal Value Json String    ${configured_ipv6_ingress_acl}    $..name    {{ intf_entry.ipv6_ingress_acl | default('not_defined') }}    msg=wan_vpn.ethernet_interfaces_ipv6_ingress_acl

    Log    =====Advanced Features=====

    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.duplex   {{ intf_entry.duplex| default('not_defined') }}     {{ intf_entry.duplex_variable| default('not_defined') }}     msg=transport_wan_vpn interface duplex     var_msg=transport_wan_vpn interface duplex variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.macAddress   {{ intf_entry.mac_address| default('not_defined') }}     {{ intf_entry.mac_address_variable| default('not_defined') }}     msg=transport_wan_vpn interface mac_address     var_msg=transport_wan_vpn interface mac_address variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.ipMtu   {{ intf_entry.ip_mtu| default('not_defined') }}     {{ intf_entry.ip_mtu_variable| default('not_defined') }}     msg=transport_wan_vpn interface ip_mtu     var_msg=transport_wan_vpn interface ip_mtu variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.intrfMtu   {{ intf_entry.interface_mtu| default('not_defined') }}     {{ intf_entry.interface_mtu_variable| default('not_defined') }}     msg=transport_wan_vpn interface interface_mtu     var_msg=transport_wan_vpn interface interface_mtu variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.tcpMss   {{ intf_entry.tcp_mss| default('not_defined') }}     {{ intf_entry.tcp_mss_variable| default('not_defined') }}     msg=transport_wan_vpn interface tcp_mss     var_msg=transport_wan_vpn interface tcp_mss variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.speed   {{ intf_entry.speed| default('not_defined') }}     {{ intf_entry.speed_variable| default('not_defined') }}     msg=transport_wan_vpn interface speed     var_msg=transport_wan_vpn interface speed variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.arpTimeout   {{ intf_entry.arp_timeout| default('not_defined') }}     {{ intf_entry.arp_timeout_variable| default('not_defined') }}     msg=transport_wan_vpn interface arp_timeout     var_msg=transport_wan_vpn interface arp_timeout variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.autonegotiate   {{ intf_entry.autonegotiate| default('not_defined') }}     {{ intf_entry.autonegotiate_variable| default('not_defined') }}     msg=transport_wan_vpn interface autonegotiate     var_msg=transport_wan_vpn interface autonegotiate variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.mediaType   {{ intf_entry.media_type| default('not_defined') }}     {{ intf_entry.media_type_variable| default('not_defined') }}     msg=transport_wan_vpn interface media_type     var_msg=transport_wan_vpn interface media_type variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.loadInterval   {{ intf_entry.load_interval| default('not_defined') }}     {{ intf_entry.load_interval_variable| default('not_defined') }}     msg=transport_wan_vpn interface load_interval     var_msg=transport_wan_vpn interface load_interval variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.icmpRedirectDisable   {{ intf_entry.icmp_redirect_disable| default('not_defined') }}     {{ intf_entry.icmp_redirect_disable_variable| default('not_defined') }}     msg=transport_wan_vpn interface icmp_redirect_disable     var_msg=transport_wan_vpn interface icmp_redirect_disable variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.ipDirectedBroadcast   {{ intf_entry.ip_directed_broadcast| default('not_defined') }}     {{ intf_entry.ip_directed_broadcast_variable| default('not_defined') }}     msg=transport_wan_vpn interface ip_directed_broadcast     var_msg=transport_wan_vpn interface ip_directed_broadcast variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.tlocExtension   {{ intf_entry.tloc_extension| default('not_defined') }}     {{ intf_entry.tloc_extension_variable| default('not_defined') }}     msg=transport_wan_vpn interface tloc_extension     var_msg=transport_wan_vpn interface tloc_extension variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.tlocExtensionGreFrom.sourceIp   {{ intf_entry.gre_tloc_extension_source_ip| default('not_defined') }}     {{ intf_entry.gre_tloc_extension_source_ip_variable| default('not_defined') }}   msg=transport_wan_vpn interface gre_tloc_extension_source_ip  var_msg=transport_wan_vpn interface gre_tloc_extension_source_ip_variable variable
    Should Be Equal Value Json Yaml    ${r_interface_name[0]}    $..advanced.tlocExtensionGreFrom.xconnect   {{ intf_entry.gre_tloc_extension_xconnect| default('not_defined') }}     {{ intf_entry.gre_tloc_extension_xconnect_variable| default('not_defined') }}     msg=transport_wan_vpn interface gre_tloc_extension_xconnect    var_msg=transport_wan_vpn interface gre_tloc_extension_xconnect_variable variable

{% endfor %}

{% endif %}
    
{% endfor %}

{% endif %}

{% endif %}