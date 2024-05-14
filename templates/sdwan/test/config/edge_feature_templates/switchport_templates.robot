*** Settings ***
Documentation   Verify Switchport Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown    Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    switchport_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.switchport_templates is defined %}

*** Test Cases ***
Get Switchport Feature Template
    ${r}=    Get On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="switchport")]
    Set Suite Variable    ${r}

{% for switch_port in sdwan.edge_feature_templates.switchport_templates | default([]) %}

Verify Edge Feature Template Switchport Feature Template {{ switch_port.name }}
    ${switchport_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ switch_port.name }}")]
    Should Be Equal Value Json String    ${switchport_id}    $..templateName    {{ switch_port.name }}    msg=switchport template name
    Should Be Equal Value Json String    ${switchport_id}    $..templateDescription    {{ switch_port.description }}    msg=switchport template description

{% set test_list = [] %}
{% for item in switch_port.device_types | default(defaults.sdwan.edge_feature_templates.switchport_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${r}    $[?(@..templateName=="{{ switch_port.name }}")].deviceType
    ${test_list}=    Create List    {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list}[0]    ${test_list}    ignore_order=True    msg= {{ switch_port.name }} template device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ switch_port.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}
    Set Suite Variable    ${r_id}

    Should Be Equal Value Json String    ${r_id.json()}    $..["age-time"].vipValue    {{ switch_port.age_out_time | default("not_defined") }}    msg=age out time
    Should Be Equal Value Json String    ${r_id.json()}    $..["age-time"].vipVariableName    {{ switch_port.age_out_time_variable | default("not_defined") }}    msg=age out time variable

    Should Be Equal Value Json String    ${r_id.json()}    $.slot.vipValue    {{ switch_port.slot }}    msg=slot
    Should Be Equal Value Json String    ${r_id.json()}    $.subslot.vipValue    {{ switch_port.subslot }}    msg=subslot
    Should Be Equal Value Json String    ${r_id.json()}    $.module.vipValue    {{ switch_port.module_type }}    msg=module type

    ${interfaces}=    Get Value From Json    ${r_id.json()}   $..vipVariableName
    ${length}=    Get Length    ${interfaces}
    Should Be Equal As Integers    ${length}    {{ switch_port.interfaces | length }}    msg=interfaces group
    
{% for interface in switch_port.interfaces | default([])  %}

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..access.vlan.vlan.vipValue    {{ interface.access_vlan | default("not_defined") }}    msg=access vlan
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..access.vlan.vlan.vipVariableName    {{ interface.access_vlan_variable | default("not_defined") }}    msg=access vlan variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..duplex.vipValue    {{ interface.duplex | default("not_defined") }}    msg=duplex
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..duplex.vipVariableName    {{ interface.duplex_variable | default("not_defined")}}    msg=duplex variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..mode.vipValue    {{ interface.mode | default("not_defined") }}    msg=mode

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["if-name"].vipValue    {{ interface.if_name | default("not_defined") }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..["if-name"].vipVariableName    {{ interface.name_variable | default("not_defined") }}    msg=name variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..vipOptional    {{ interface.optional | default("not_defined") }}    msg=optional

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].shutdown.vipValue    {{ interface.shutdown | default("not_defined") | lower }}    msg=shutdown
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].shutdown.VariableName    {{ interface.shutdown_variable | default("not_defined") }}    msg=shutdown variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].speed.vipValue    {{ interface.speed | default("not_defined") }}    msg=speed
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}].speed.vipVariableName    {{ interface.speed_variable | default("not_defined") }}    msg=speed variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..trunk.native.vlan.vipValue    {{ interface.trunk_native_vlan | default("not_defined") }}    msg=trunk native vlans
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..trunk.native.vlan.vipVariableName    {{ interface.trunk_native_vlan_variable | default("not_defined") }}    msg=trunk native vlans variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["voice-vlan"].vipValue    {{ interface.voice_vlan | default("not_defined") }}    msg=voice vlans value
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["voice-vlan"].vipVariableName    {{ interface.voice_vlan_variable | default("not_defined") }}    msg=voice vlan variable

    Should Be Equal Value Json String    ${r_id.json()}    $..interface.vipValue[{{loop.index0}}]..dot1x..["control-direction"].vipValue    {{ interface.dot1x.control_direction | default("not_defined") }}    msg=control direction value
    Should Be Equal Value Json String    ${r_id.json()}    $..interface.vipValue[{{loop.index0}}]..dot1x..["control-direction"].vipVariableName    {{ interface.dot1x.control_direction_variable | default("not_defined") }}    msg=control direction variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["critical-vlan"].vipValue    {{ interface.dot1x.critical_vlan | default("not_defined") }}    msg=critical vlan value
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["critical-vlan"].vipVariableName    {{ interface.dot1x.critical_vlan_variable | default("not_defined") }}    msg=critical vlan variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["dot1x-enable"].vipValue    {{ interface.dot1x.enable | default("not_defined") | lower }}    msg=dot1x enable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["enable-voice"].vipValue    {{ interface.dot1x.enable_criticial_voice_vlan | default("not_defined") | lower }}    msg=critical voice vlan enable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["enable-voice"].vipVariableName    {{ interface.dot1x.enable_criticial_voice_vlan_variable | default("not_defined") }}    msg=critical voice vlan variable enable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["pae-enable"].vipValue    {{ interface.dot1x.enable_pae | default("not_defined") | lower }}    msg=pae enable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["pae-enable"].vipVariableName    {{ interface.dot1x.enable_pae_variable | default("not_defined") }}    msg=pae enable variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["enable-periodic-reauth"].vipValue    {{ interface.dot1x.enable_periodic_reauth | default("not_defined") | lower }}    msg=reauth periodic enable
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["enable-periodic-reauth"].vipVariableName    {{ interface.dot1x.enable_periodic_reauth_variable | default("not_defined") }}    msg=reauth periodic enable variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["guest-vlan"].vipValue    {{ interface.dot1x.guest_vlan | default("not_defined") }}    msg=guest vlan
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["guest-vlan"].vipVariableName    {{ interface.dot1x.guest_vlan_variable | default("not_defined") }}    msg=guest vlan variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["host-mode"].vipValue    {{ interface.dot1x.host_mode | default("not_defined") }}    msg=host mode
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["host-mode"].vipVariableName    {{ interface.dot1x.host_mode_variable | default("not_defined") }}    msg=host mode variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["mac-authentication-bypass"].vipValue    {{ interface.dot1x.mac_authentication_bypass | default("not_defined") | lower }}    msg=mac authentication pypass
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["mac-authentication-bypass"].vipVariableName    {{ interface.dot1x.mac_authentication_bypass_variable | default("not_defined") }}    msg=mac authentication pypass variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["periodic-reauthentication"].inactivity.vipValue    {{ interface.dot1x.periodic_reauth_inactivity_timeout | default("not_defined") }}    msg=reauth inactivity timeout
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["periodic-reauthentication"].inactivity.vipVariableName    {{ interface.dot1x.periodic_reauth_inactivity_timeout_variable | default("not_defined") }}    msg=reauth inactivity timeout variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["periodic-reauthentication"].reauthentication.vipValue    {{ interface.dot1x.periodic_reauth_interval | default("not_defined") }}    msg=reauth interval 
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["periodic-reauthentication"].reauthentication.vipVariableName    {{ interface.dot1x.periodic_reauth_interval_variable | default("not_defined") }}    msg=reauth interval variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["port-control"].vipValue    {{ interface.dot1x.port_control_mode | default("not_defined") }}    msg=port control mode
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["port-control"].vipVariableName    {{ interface.dot1x.port_control_mode_variable | default("not_defined") }}    msg=port control mode variable

    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["restricted-vlan"].vipValue    {{ interface.dot1x.restricted_vlan | default("not_defined") }}    msg=restricted vlan
    Should Be Equal Value Json String    ${r_id.json()}    $.interface.vipValue[{{loop.index0}}]..dot1x..["restricted-vlan"].vipVariableName    {{ interface.dot1x.restricted_vlan_variable | default("not_defined") }}    msg=restricted vlan variable 

{% for allowed_vlan in interface.trunk_allowed_vlans | default([]) %}
    ${allowed_vlans}=    Get Value From Json    ${r_id.json()}    $..trunk.allowed.vlan.vlans.vipValue
    ${vlans}=    Split String    ${allowed_vlans[0]}    ,
    List Should Contain Value    ${vlans}    {{ allowed_vlan }}    msg=trunk allowed vlans
{% endfor %} 

{%set allowed_vlan_range_list = [] %}
{% for item in interface.trunk_allowed_vlans_ranges | default([]) %}
{% set test_list = [] %}
{% set _ = test_list.append(item.from) %}
{% set _ = test_list.append(item.to) %}
{% set vlan_range = '-'.join(test_list | map('string')) %}
{% set _ = allowed_vlan_range_list.append(vlan_range) %}
{% endfor %}

{% for range in allowed_vlan_range_list %}
    ${rec_vlan_ranges}=    Get Value From Json    ${r_id.json()}    $..trunk.allowed.vlan.vlans.vipValue
    ${vlan_ranges}=    Split String    ${rec_vlan_ranges[0]}    ,
    List Should Contain Value    ${vlan_ranges}     {{ range }}    msg=allowed vlan ranges
{% endfor %}

    Should Be Equal Value Json String    ${r_id.json()}    $..trunk.allowed.vlan.vlans.vipVariableName    {{ interface.trunk_allowed_vlans_variable | default("not_defined") }}    msg=trunk allowed vlan variable
   
{% endfor %}

    ${static_mac_addresses}=    Get Value From Json    ${r_id.json()}   $..macaddr.vipValue
    ${mac_length}=    Get Length    ${static_mac_addresses}
    Should Be Equal As Integers    ${mac_length}    {{ switch_port.static_mac_addresses | length }}    msg=static mac address group

{% for address in switch_port.static_mac_addresses | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $["static-mac-address"].vipValue[{{loop.index0}}]..["if-name"].vipValue    {{ address.interface_name | default("not_defined") }}    msg=interface name
    Should Be Equal Value Json String    ${r_id.json()}    $["static-mac-address"].vipValue[{{loop.index0}}]..["if-name"].vipVariableName    {{ address.interface_name_variable | default("not_defined") }}    msg=interface name variable

    ${rec_mac_addresses}=    Get Value From Json    ${r_id.json()}   $["static-mac-address"].vipValue[{{loop.index0}}].macaddr.vipValue
    ${status}=    Remove String    ${rec_mac_addresses[0]}    .
    ${length}=    Get Length    ${status}
    ${set_mac}=    Set Variable
    FOR    ${index}    IN RANGE    0    ${length}    2
        ${mac_add}=    Evaluate    "${status}[${index}:${index+2}]"
        IF    ${index}==0
            ${set_mac}=    Catenate    SEPARATOR=    ${set_mac}    ${mac_add}
        ELSE IF    ${index}<= ${length} - 2
            ${set_mac}=    Catenate    SEPARATOR=:    ${set_mac}    ${mac_add}
        END
        ${rec_mac}=    Create List    ${set_mac}
    END

    List Should Contain Value    ${rec_mac}    {{ address.mac_address }}    msg=mac address

    Should Be Equal Value Json String    ${r_id.json()}    $["static-mac-address"].vipValue[{{loop.index0}}].macaddr.vipVariableName    {{ address.mac_address_variable | default("not_defined") }}    msg=mac address variable  

    Should be Equal Value Json String    ${r_id.json()}    $["static-mac-address"].vipValue[{{loop.index0}}].vipOptional    {{ address.optional | default("not_defined") }}    msg=mac address optional

    Should Be Equal Value Json String    ${r_id.json()}    $["static-mac-address"].vipValue[{{loop.index0}}].vlan.vipValue    {{ address.vlan | default("not_defined") }}    msg=mac address vlan
    Should Be Equal Value Json String    ${r_id.json()}    $["static-mac-address"].vipValue[{{loop.index0}}].vlan.vipVariableName    {{ address.vlan_variable | default("not_defined") }}    msg=mac address vlan variable  

{% endfor %}

{% endfor %}

{% endif %}
