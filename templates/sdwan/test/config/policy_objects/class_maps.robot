*** Settings ***
Documentation   Verify Class Map Lists
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    class_maps
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.class_maps is defined%}

*** Test Cases ***
Get Class Map List(s)
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/class
    Set Suite Variable    ${r}

{% for class_map in sdwan.policy_objects.class_maps | default([]) %}
{% set class_map_name = class_map.name %}
{% set class_map_queue = class_map.queue %}

Verify Policy Objects Class Map List {{ class_map_name }}
    ${class_map_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{class_map_name }}")].listId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/class/${class_map_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ class_map_name }}    msg=class map name
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..queue    {{ class_map_queue }}    msg=class map queue

{% endfor %}

{% endif %}
