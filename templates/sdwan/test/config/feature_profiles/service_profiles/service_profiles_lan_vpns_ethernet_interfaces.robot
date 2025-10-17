*** Settings ***
Documentation   Verify Service Feature Profile Configuration LAN VPNs Ethernet Interfaces
Suite Setup     Login SDWAN Manager
Name            Service Profiles LAN VPNs Ethernet Interfaces
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_profiles   service_profiles  lan_vpns  ethernet_interfaces
Resource        ../../../sdwan_common.resource

{% if sdwan.feature_profiles is defined and sdwan.feature_profiles.service_profiles is defined %}

{% set profile_lan_vpns = [] %}
{% for profile in sdwan.get('feature_profiles', {}).get('service_profiles', {}) %}
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
    Set Suite Variable   ${profile_id}
    ${service_profile_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}
    Set Suite Variable   ${service_profile_res}
    ${service_profile_features}=    Get Value From Json    ${service_profile_res.json()}    $..associatedProfileParcels
    Set Suite Variable    ${service_profile_features}
    ${tracker_objs_object}=    Get Value From Json    ${service_profile_features[0]}    $[?(@.parcelType=='objecttracker')]
    ${tracker_objs_group}=    Get Value From Json    ${service_profile_features[0]}   $[?(@.parcelType=='objecttrackergroup')]
    ${tracker_objs}=    Evaluate    ${tracker_objs_object} + ${tracker_objs_group}
    Set Suite Variable    ${tracker_objs}
    ${ipv4_acls}=    Get Value From Json    ${service_profile_features[0]}  $[?(@.parcelType=='ipv4-acl')]
    Set Suite Variable    ${ipv4_acls}
    ${dhcp_server}=    Get Value From Json    ${service_profile_features[0]}  $[?(@.parcelType=='dhcp-server')]
    Set Suite Variable    ${ipv4_acls}    
    ${service_lan_vpn_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}/lan/vpn
    ${service_lan_vpn}=    Get Value From Json    ${service_lan_vpn_res.json()}    $.data
    Run Keyword If    ${service_lan_vpn} == []    Fail    Feature lan vpn expected to be configured within the service profile '{{profile.name}}' on the Manager
    Set Suite Variable    ${service_lan_vpn}

{% for lan_vpn in profile.lan_vpns | default([]) %}

Verify Feature Profiles Service Profiles {{ profile.name }} {{lan_vpn.name}} Ethernet Interfaces 
    ${lan_vpn_profile}=    Get Value From Json    ${service_lan_vpn[0]}    $[?(@.payload.name=='{{ lan_vpn.name }}')]
    Run Keyword If    ${lan_vpn_profile} == []    Fail    Feature lan vpn '{{lan_vpn.name}}' expected to be configured within the service profile '{{profile.name}}' on the Manager
    ${lan_vpn_profile_id}=    Get Value From Json    ${lan_vpn_profile}    $..parcelId
    ${trackers_lan_ethernet_interface}=   Get Value From Json    ${service_profile_res.json()}    $..subparcels[?(@.parcelType=='lan/vpn/interface/ethernet')]
    Set Suite Variable    ${trackers_lan_ethernet_interface}
    ${service_lan_vpn_intf_res}=    GET On Session    sdwan_manager    /dataservice/v1/feature-profile/sdwan/service/${profile_id[0]}/lan/vpn/${lan_vpn_profile_id[0]}/interface/ethernet
    ${service_lan_vpn_intf}=    Get Value From Json    ${service_lan_vpn_intf_res.json()}    $..payload

    Should Be Equal Value Json List Length   ${service_lan_vpn_intf}  $  {{ lan_vpn.get('ethernet_interfaces' , []) | length }}    msg=service_lan_vpn ethernet_interfaces length

{% for intf_entry in lan_vpn.ethernet_interfaces | default([]) %}

    Log   ======Ethernet Interface {{ intf_entry.name }} =======

    ${r_interface_name}=  Get Value From Json    ${service_lan_vpn_intf}      $[?(@.name=={{intf_entry.name}})]

    Log   ============Tracker Associations=============

    ${lan_ethernet_interface_target}=    Get Value From Json    ${trackers_lan_ethernet_interface}    $[?(@.payload.name=='{{ intf_entry.name }}')]

    Should Be Equal Value Json String
    ...    ${lan_ethernet_interface_target[0]}    $.subparcels[?(@.parcelType=='trackergroup')].payload.name
    ...    {{ intf_entry.ipv4_tracker_group | default('not_defined') }}
    ...    msg=service_lan_vpn ethernet_interfaces ipv4 tracker group name
    Should Be Equal Value Json String
    ...    ${lan_ethernet_interface_target[0]}    $.subparcels[?(@.parcelType=='tracker')].payload.name
    ...    {{ intf_entry.ipv4_tracker | default('not_defined') }}
    ...    msg=service_lan_vpn ethernet_interfaces tracker name

    Log   ============ DHCP Associations=============
    Should Be Equal Value Json String
    ...    ${lan_ethernet_interface_target[0]}    $.subparcels[?(@.parcelType=='dhcp-server')].payload.name
    ...    {{ intf_entry.dhcp_server | default('not_defined') }}
    ...    msg=service_lan_vpn ethernet_interfaces dhcp server name


    Log   ============Basic Configuration==============

    Should Be Equal Value Json String
    ...    ${r_interface_name[0]}    $..name
    ...    {{ intf_entry.name | default('not_defined') }}
    ...    msg=service_lan_vpn lan_vpn interface name
    Should Be Equal Value Json Special_String    ${r_interface_name[0]}   $.description   {{ intf_entry.description | default('not_defined') | normalize_special_string }}   msg=service_lan_vpn lan_vpn description
    
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.interfaceName
    ...    {{ intf_entry.interface_name | default('not_defined') }}    {{ intf_entry.interface_name_variable | default('not_defined') }}
    ...    msg=service_lan_vpn lan_vpn interface interface_name    var_msg=service_lan_vpn lan_vpn interface interface_name variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.description
    ...    {{ intf_entry.interface_description | default('not_defined') }}    {{ intf_entry.interface_description_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface interface_description    var_msg=service_lan_vpn interface interface_description variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.shutdown
    ...    {{ intf_entry.shutdown | default('not_defined') }}    {{ intf_entry.shutdown_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface shutdown    var_msg=service_lan_vpn interface shutdown variable

    ${ipv4_static_check}=    Get Value From Json    ${r_interface_name[0]}     $.data.intfIpAddress.static
    ${ipv4_dynamic_check}=    Get Value From Json    ${r_interface_name[0]}     $.data.intfIpAddress.dynamic
    ${detected_ipv4_type}=    Set Variable If    ${ipv4_static_check} != []    static    ${ipv4_dynamic_check} != []    dynamic    not_defined
    Should Be Equal As Strings    ${detected_ipv4_type}    {{ intf_entry.ipv4_configuration_type | default(defaults.sdwan.feature_profiles.service_profiles.lan_vpns.ethernet_interfaces.ipv4_configuration_type) }}    msg=service_lan_vpn interface ipv4_configuration_type detected from JSON structure
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.intfIpAddress.static.staticIpV4AddressPrimary.ipAddress
    ...    {{ intf_entry.ipv4_address| default('not_defined') }}    {{ intf_entry.ipv4_address_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv4_address    var_msg=service_lan_vpn interface ipv4_address variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.intfIpAddress.static.staticIpV4AddressPrimary.subnetMask
    ...    {{ intf_entry.ipv4_subnet_mask| default('not_defined') }}    {{ intf_entry.ipv4_subnet_mask_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv4_subnet_mask    var_msg=service_lan_vpn interface ipv4_subnet_mask variable  

    Should Be Equal Value Json List Length   ${r_interface_name[0]}  $.data.intfIpAddress.static.staticIpV4AddressSecondary  {{ intf_entry.get('ipv4_secondary_addresses' , [] ) | length }}    msg=ipv4 secondary addresses length

{% for sec_addr in intf_entry.ipv4_secondary_addresses | default([]) %}

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.intfIpAddress.static.staticIpV4AddressSecondary[{{ loop.index0 }}].ipAddress
    ...    {{ sec_addr.address | default('not_defined') }}    {{ sec_addr.address_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv4_address    var_msg=service_lan_vpn interface ipv4_address variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.intfIpAddress.static.staticIpV4AddressSecondary[{{ loop.index0 }}].subnetMask
    ...    {{ sec_addr.subnet_mask | default('not_defined') }}    {{ sec_addr.subnet_mask_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv4_address    var_msg=service_lan_vpn interface ipv4_address variable

{% endfor %}
    
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.intfIpAddress.dynamic.dynamicDhcpDistance
    ...    {{ intf_entry.ipv4_dhcp_distance| default('not_defined') }}    {{ intf_entry.ipv4_dhcp_distance_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv4_dhcp_distance    var_msg=service_lan_vpn interface ipv4_dhcp_distance variable

    ${dhcp_helpers_list}=    Set Variable If    "{{ intf_entry.get('ipv4_dhcp_helpers', []) | length }}" == "0"    not_defined    {{ intf_entry.get('ipv4_dhcp_helpers', []) }}
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.dhcpHelper
    ...    ${dhcp_helpers_list}    {{ intf_entry.ipv4_dhcp_helpers_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv4_dhcp_helpers    var_msg=service_lan_vpn interface ipv4_dhcp_helpers variable

    ${ipv6_static_check}=    Get Value From Json    ${r_interface_name[0]}     $.data.intfIpV6Address.static
    ${ipv6_dynamic_check}=    Get Value From Json    ${r_interface_name[0]}     $.data.intfIpV6Address.dynamic
    ${detected_ipv6_type}=    Set Variable If    ${ipv6_static_check} != []    static    ${ipv6_dynamic_check} != []    dynamic    none
    Should Be Equal As Strings    ${detected_ipv6_type}    {{ intf_entry.ipv6_configuration_type | default(defaults.sdwan.feature_profiles.service_profiles.lan_vpns.ethernet_interfaces.ipv6_configuration_type) }}    msg=service_lan_vpn interface ipv6_configuration_type detected from JSON structure
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.intfIpV6Address.static.primaryIpV6Address.address
    ...    {{ intf_entry.ipv6_address| default('not_defined') }}    {{ intf_entry.ipv6_address_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv6_address    var_msg=service_lan_vpn interface ipv6_address variable
    
    Should Be Equal Value Json List Length      ${r_interface_name[0]}  $.data.intfIpV6Address.static.secondaryIpV6Address  {{ intf_entry.get('ipv6_secondary_addresses', []) | length }}    msg=ipv6 secondary addresses length

{% for sec_addr in intf_entry.ipv6_secondary_addresses  | default([]) %}

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.intfIpV6Address.static.secondaryIpV6Address[{{ loop.index0 }}].address
    ...    {{ sec_addr.address | default('not_defined') }}    {{ sec_addr.address_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface secondary ipv6_address    var_msg=service_lan_vpn interface secondary ipv6_address variable

{% endfor %}

    Should Be Equal Value Json List Length      ${r_interface_name[0]}  $.data.intfIpV6Address.static.secondaryIpV6Address  {{ intf_entry.get('ipv6_secondary_addresses', []) | length }}    msg=ipv6 secondary addresses length

{% for dhcp_sec_addr in intf_entry.ipv6_dhcp_secondary_addresses  | default([]) %}

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.intfIpV6Address.dynamic.secondaryIpV6Address[{{ loop.index0 }}].address
    ...    {{ dhcp_sec_addr.address | default('not_defined') }}    {{ dhcp_sec_addr.address_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface dhcp secondary ipv6_address    var_msg=service_lan_vpn interface dhcp secondaryipv6_address variable

{% endfor %}
    
    Log    ============ARP Entries============

    Should Be Equal Value Json List Length      ${r_interface_name[0]}   $.data.arp  {{ intf_entry.get('arp_entries', []) | length }}    msg=service_lan_vpn interface arp_entries length

{% for arp_entry in intf_entry.arp_entries | default([]) %}

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.arp[{{ loop.index0 }}].ipAddress
    ...    {{ arp_entry.ip_address| default('not_defined') }}    {{ arp_entry.ip_address_variable| default('not_defined') }}
    ...    msg=service_lan_vpn intf arp_entry.ip_address    var_msg=service_lan_vpn intf arp_entry.ip_address variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.arp[{{ loop.index0 }}].macAddress
    ...    {{ arp_entry.mac_address| default('not_defined') }}    {{ arp_entry.mac_address_variable| default('not_defined') }}
    ...    msg=service_lan_vpn intf arp_entry.mac_address    var_msg=service_lan_vpn intf arp_entry.mac_address variable

{% endfor %}

    Log    ============IPv4 VRRP Groups==============

    Should Be Equal Value Json List Length      ${r_interface_name[0]}   $.data.vrrp  {{ intf_entry.get('ipv4_vrrp_groups', []) | length }}    msg=service_lan_vpn interface ipv4_vrrp_groups length

{% for vrrp_group in intf_entry.ipv4_vrrp_groups | default([]) %}

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[{{ loop.index0 }}].group_id
    ...    {{ vrrp_group.id | default('not_defined') }}    {{ vrrp_group.id_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface vrrp_group id    var_msg=service_lan_vpn interface vrrp_group id variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[{{ loop.index0 }}].ipAddress
    ...    {{ vrrp_group.address | default('not_defined') }}    {{ vrrp_group.address_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface vrrp_group address    var_msg=service_lan_vpn interface vrrp_group address variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[{{ loop.index0 }}].priority
    ...    {{ vrrp_group.priority | default('not_defined') }}    {{ vrrp_group.priority_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface vrrp_group priority    var_msg=service_lan_vpn interface vrrp_group priority variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[{{ loop.index0 }}].timer
    ...    {{ vrrp_group.timer | default('not_defined') }}    {{ vrrp_group.timer_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface vrrp_group timer    var_msg=service_lan_vpn interface vrrp_group timer variable
    Should Be Equal Value Json String
    ...    ${r_interface_name[0]}    $.data.vrrp[{{ loop.index0 }}].tlocPrefChange.value
    ...    {{ vrrp_group.tloc_preference_change | default('False') }}
    ...    msg=service_lan_vpn interface vrrp_group tloc_preference_change
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[{{ loop.index0 }}].tlocPrefChangeValue
    ...    {{ vrrp_group.tloc_preference_change_value | default('not_defined') }}    {{ vrrp_group.tloc_preference_change_value_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface vrrp_group tloc_preference_change_value    var_msg=service_lan_vpn interface vrrp_group tloc_preference_change_value variable
    Should Be Equal Value Json String
    ...    ${r_interface_name[0]}    $.data.vrrp[{{ loop.index0 }}].trackOmp.value
    ...    {{ vrrp_group.track_omp | default('False') }}
    ...    msg=service_lan_vpn interface vrrp_group track_omp

    Should Be Equal Value Json List Length      ${r_interface_name[0]}   $.data.vrrp[{{ loop.index0 }}].ipAddressSecondary  {{ vrrp_group.get('secondary_addresses', []) | length }}    msg=service_lan_vpn interface vrrp_group secondary_addresses length

    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

{% for sec_addr in vrrp_group.secondary_addresses | default([]) %}

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[${outer_loop_index}].ipAddressSecondary[{{ loop.index0 }}].ipAddress
    ...    {{ sec_addr.address | default('not_defined') }}    {{ sec_addr.address_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface vrrp_group secondary_address    var_msg=service_lan_vpn interface vrrp_group secondary_address variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[${outer_loop_index}].ipAddressSecondary[{{ loop.index0 }}].subnetMask
    ...    {{ sec_addr.subnet_mask | default('not_defined') }}    {{ sec_addr.subnet_mask_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface vrrp_group secondary_subnet_mask    var_msg=service_lan_vpn interface vrrp_group secondary_subnet_mask variable

{% endfor %}

    Should Be Equal Value Json List Length      ${r_interface_name[0]}   $.data.vrrp[{{ loop.index0 }}].trackingObject  {{ vrrp_group.get('tracking_objects', []) | length }}    msg=service_lan_vpn interface vrrp_group tracking_objects length

    ${outer_loop_index}=    Set Variable    {{ loop.index0 }}

{% for track_obj in vrrp_group.tracking_objects | default([]) %}
{% set action_map = {'decrement': 'Decrement','shutdown': 'Shutdown'} %}
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[${outer_loop_index}].trackingObject[{{ loop.index0 }}].trackerAction
    ...    {{ action_map.get(track_obj.action, track_obj.action|default('not_defined')) }}    {{ track_obj.action_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface vrrp_group tracking_object action    var_msg=service_lan_vpn interface vrrp_group tracking_object action variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[${outer_loop_index}].trackingObject[{{ loop.index0 }}].decrementValue
    ...    {{ track_obj.decrement_value | default('not_defined') }}    {{ track_obj.decrement_value_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface vrrp_group tracking_object decrement_value    var_msg=service_lan_vpn interface vrrp_group tracking_object decrement_value variable
    # --- Tracker Object RefId Check ---
{% if track_obj.tracker_object is defined %}
    ${tracker_obj}=    Evaluate    [x for x in ${tracker_objs} if x['payload']['name']=='{{ track_obj.tracker_object }}']
    ${tracker_obj_id}=     Get Value From Json    ${tracker_obj}    $..parcelId
    Run Keyword If    ${tracker_obj_id} == []    Fail    Tracker object '{{ track_obj.tracker_object }}' not found in Manager for profile '{{ profile.name }}'
    ${tracker_obj_id}=     Set Variable    ${tracker_obj_id[0]}
{% else %}
    ${tracker_obj_id}=     Set Variable    not_defined
{% endif %}
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $.data.vrrp[${outer_loop_index}].trackingObject[{{ loop.index0 }}].trackerId.refId
    ...    ${tracker_obj_id}    not_defined
    ...    msg=service_lan_vpn interface vrrp_group tracking_object tracker_object    var_msg=service_lan_vpn interface vrrp_group tracking_object tracker_object variable

{% endfor %}

{% endfor %}

    Log    ============IPv6 VRRP Groups==============

    Should Be Equal Value Json List Length      ${r_interface_name[0]}   $..vrrpIpv6  {{ intf_entry.get('ipv6_vrrp_groups', []) | length }}    msg=service_lan_vpn interface ipv6_vrrp_groups length

{% for vrrp_group in intf_entry.ipv6_vrrp_groups | default([]) %}

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..vrrpIpv6[{{ loop.index0 }}]..groupId
    ...    {{ vrrp_group.id | default('not_defined') }}    {{ vrrp_group.id_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv6_vrrp_group id    var_msg=service_lan_vpn interface ipv6_vrrp_group id variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..vrrpIpv6[{{ loop.index0 }}].ipv6[0].prefix
    ...    {{ vrrp_group.global_prefix | default('not_defined') }}    {{ vrrp_group.global_prefix_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv6_vrrp_group global_prefix    var_msg=service_lan_vpn interface ipv6_vrrp_group global_prefix variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..vrrpIpv6[{{ loop.index0 }}].ipv6[0].ipv6LinkLocal
    ...    {{ vrrp_group.link_local_address | default('not_defined') }}    {{ vrrp_group.link_local_address_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv6_vrrp_group link_local_address    var_msg=service_lan_vpn interface ipv6_vrrp_group link_local_address variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..vrrpIpv6[{{ loop.index0 }}].priority
    ...    {{ vrrp_group.priority | default('not_defined') }}    {{ vrrp_group.priority_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv6_vrrp_group priority    var_msg=service_lan_vpn interface ipv6_vrrp_group priority variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..vrrpIpv6[{{ loop.index0 }}].timer
    ...    {{ vrrp_group.timer | default('not_defined') }}    {{ vrrp_group.timer_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv6_vrrp_group timer    var_msg=service_lan_vpn interface ipv6_vrrp_group timer variable
    Should Be Equal Value Json String
    ...    ${r_interface_name[0]}    $..vrrpIpv6[{{ loop.index0 }}].trackOmp.value
    ...    {{ vrrp_group.track_omp | default('False') }}
    ...    msg=service_lan_vpn interface ipv6_vrrp_group track_omp

{% endfor %}

    Log    ===========IPv6 DHCP Helpers===========
 
    Should Be Equal Value Json List Length      ${r_interface_name[0]}   $..dhcpHelperV6  {{ intf_entry.get('ipv6_dhcp_helpers', []) | length }}    msg=service_lan_vpn interface ipv6_dhcp_helpers length

{% for dhcp_helper in intf_entry.ipv6_dhcp_helpers | default([]) %}

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..dhcpHelperV6[{{ loop.index0 }}]..ipAddress
    ...    {{ dhcp_helper.address | default('not_defined') }}    {{ dhcp_helper.address_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv6_dhcp_helper address    var_msg=service_lan_vpn interface ipv6_dhcp_helper address variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..dhcpHelperV6[{{ loop.index0 }}]..vpn
    ...    {{ dhcp_helper.vpn_id | default('not_defined') }}    {{ dhcp_helper.vpn_id_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface ipv6_dhcp_helper vpn_id    var_msg=service_lan_vpn interface ipv6_dhcp_helper vpn_id variable

{% endfor %}

    Log    ===========Advanced Features===========

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.duplex
    ...    {{ intf_entry.duplex| default('not_defined') }}    {{ intf_entry.duplex_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface duplex    var_msg=service_lan_vpn interface duplex variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.macAddress
    ...    {{ intf_entry.mac_address| default('not_defined') }}    {{ intf_entry.mac_address_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface mac_address    var_msg=service_lan_vpn interface mac_address variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.ipMtu
    ...    {{ intf_entry.ip_mtu| default('not_defined') }}    {{ intf_entry.ip_mtu_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface ip_mtu    var_msg=service_lan_vpn interface ip_mtu variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.intrfMtu
    ...    {{ intf_entry.interface_mtu| default('not_defined') }}    {{ intf_entry.interface_mtu_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface interface_mtu    var_msg=service_lan_vpn interface interface_mtu variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.tcpMss
    ...    {{ intf_entry.tcp_mss| default('not_defined') }}    {{ intf_entry.tcp_mss_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface tcp_mss    var_msg=service_lan_vpn interface tcp_mss variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.speed
    ...    {{ intf_entry.speed| default('not_defined') }}    {{ intf_entry.speed_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface speed    var_msg=service_lan_vpn interface speed variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.arpTimeout
    ...    {{ intf_entry.arp_timeout| default('not_defined') }}    {{ intf_entry.arp_timeout_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface arp_timeout    var_msg=service_lan_vpn interface arp_timeout variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.autonegotiate
    ...    {{ intf_entry.autonegotiate| default('not_defined') }}    {{ intf_entry.autonegotiate_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface autonegotiate    var_msg=service_lan_vpn interface autonegotiate variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.mediaType
    ...    {{ intf_entry.media_type| default('not_defined') }}    {{ intf_entry.media_type_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface media_type    var_msg=service_lan_vpn interface media_type variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.loadInterval
    ...    {{ intf_entry.load_interval| default('not_defined') }}    {{ intf_entry.load_interval_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface load_interval    var_msg=service_lan_vpn interface load_interval variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.icmpRedirectDisable
    ...    {{ intf_entry.icmp_redirect_disable| default('not_defined') }}    {{ intf_entry.icmp_redirect_disable_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface icmp_redirect_disable    var_msg=service_lan_vpn interface icmp_redirect_disable variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.ipDirectedBroadcast
    ...    {{ intf_entry.ip_directed_broadcast| default('not_defined') }}    {{ intf_entry.ip_directed_broadcast_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface ip_directed_broadcast    var_msg=service_lan_vpn interface ip_directed_broadcast variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..aclQos.shapingRate
    ...    {{ intf_entry.shaping_rate| default('not_defined') }}    {{ intf_entry.shaping_rate_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface shaping_rate    var_msg=service_lan_vpn interface shaping_rate variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..advanced.xconnect
    ...    {{ intf_entry.xconnect| default('not_defined') }}    {{ intf_entry.xconnect_variable| default('not_defined') }}
    ...    msg=service_lan_vpn interface xconnect    var_msg=service_lan_vpn interface xconnect variable

    Log    ===========Access Control Lists===========

    ${configured_ipv4_egress_acl_refid_raw}=    Get Value From Json    ${r_interface_name[0]}    $..aclQos.ipv4AclEgress.refId.value
    ${configured_ipv4_egress_acl_refid}=    Set Variable If    ${configured_ipv4_egress_acl_refid_raw} == []    not_defined    ${configured_ipv4_egress_acl_refid_raw[0]}
    ${configured_ipv4_egress_acl}=    Get Value From Json    ${ipv4_acls}    $[?(@.parcelId=='${configured_ipv4_egress_acl_refid}')]
    Should Be Equal Value Json String
    ...    ${configured_ipv4_egress_acl}    $..name
    ...    {{ intf_entry.ipv4_egress_acl | default('not_defined') }}
    ...    msg=wan_vpn.ethernet_interfaces_ipv4_egress_acl
    ${configured_ipv4_ingress_acl_refid_raw}=    Get Value From Json    ${r_interface_name[0]}    $..aclQos.ipv4AclIngress.refId.value
    ${configured_ipv4_ingress_acl_refid}=    Set Variable If    ${configured_ipv4_ingress_acl_refid_raw} == []    not_defined    ${configured_ipv4_ingress_acl_refid_raw[0]}
    ${configured_ipv4_ingress_acl}=    Get Value From Json    ${ipv4_acls}    $[?(@.parcelId=='${configured_ipv4_ingress_acl_refid}')]
    Should Be Equal Value Json String
    ...    ${configured_ipv4_ingress_acl}    $..name
    ...    {{ intf_entry.ipv4_ingress_acl | default('not_defined') }}
    ...    msg=wan_vpn.ethernet_interfaces_ipv4_ingress_acl

    Log    ===========TrustSec Features===========

    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..trustsec.enableSGTPropogation
    ...    {{ intf_entry.trustsec_enable_sgt_propogation | default('not_defined') }}    not_defined
    ...    msg=service_lan_vpn interface trustsec_enforced_sgt    var_msg=service_lan_vpn interface trustsec_enforced_sgt variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..trustsec.securityGroupTag
    ...    {{ intf_entry.trustsec_sgt | default('not_defined') }}    {{ intf_entry.trustsec_sgt_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface trustsec_sgt    var_msg=service_lan_vpn interface trustsec_sgt variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..trustsec.enableEnforcedPropogation
    ...    {{ intf_entry.trustsec_enable_enforced_propogation | default('not_defined') }}    not_defined
    ...    msg=service_lan_vpn interface trustsec_enforced_sgt    var_msg=service_lan_vpn interface trustsec_enforced_sgt variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..trustsec.enforcedSecurityGroupTag
    ...    {{ intf_entry.trustsec_enforced_sgt | default('not_defined') }}    {{ intf_entry.trustsec_enforced_sgt_variable | default('not_defined') }}
    ...    msg=service_lan_vpn interface trustsec_enforced_sgt    var_msg=service_lan_vpn interface trustsec_enforced_sgt variable
    Should Be Equal Value Json Yaml
    ...    ${r_interface_name[0]}    $..trustsec.propogate
    ...    {{ intf_entry.trustsec_propogate | default('not_defined')}}    not_defined
    ...    msg=service_lan_vpn interface trustsec_propogate    var_msg=service_lan_vpn interface trustsec_propogate variable


{% endfor %}

{% endfor %}

{% endif %}

{% endfor %}

{% endif %}

{% endif %}
