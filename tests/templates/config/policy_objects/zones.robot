*** Settings ***
Documentation     Verify Zones
Suite Setup       Login SDWAN Manager
Suite Teardown    Run On Last Process   Logout SDWAN Manager
Default Tags      sdwan   config   classic_policy_objects
Resource            ../../sdwan_common.resource

{% if sdwan.policy_objects.zones is defined %}

*** Test cases ***
Get Zones List(s)
    ${r}=   Get On Session   sdwan_manager   /dataservice/template/policy/list/zone
    Log   ${r}
    Set Suite Variable   ${r}

{% for zone in sdwan.policy_objects.zones | default([]) %}

Verify Zone Lists {{zone.name}}
    ${zone_list_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{zone.name }}")].listId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/zone/${zone_list_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{zone.name}}    msg=zone_name
    
    ${vpn_list}=   Create List   {{ zone.vpn_ids | default([]) | join('   ') }}
    Should Be Equal Value Json List    ${r_id.json()}    $..entries..vpn    ${vpn_list}    msg=vpn_ids
    ${interfaces}=   Create List   {{ zone.interfaces | default([]) | join('   ') }}
    Should Be Equal Value Json List    ${r_id.json()}    $..entries..interface    ${interfaces}    msg=interface


{% endfor %}

{% endif %}
