*** Settings ***
Documentation   Verify App Probe Classes Lists
Suite Setup     Login SDWAN Manager
Default Tags    sdwan    config    app_probe_classes_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.app_probe_classes is defined%}

*** Test Cases ***
Get App Probe Classes List(s)
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/appprobe
    Set Suite Variable    ${r}

{% for app_probe_class in sdwan.policy_objects.app_probe_classes | default([]) %}
{% set app_probe_class_name = app_probe_class.name %}
{% set app_probe_class_forwarding_class = app_probe_class.forwarding_class %}

Verify Policy Objects App Probe Classes List {{ app_probe_class_name }}
    ${app_probe_class_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{app_probe_class_name }}")].listId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/appprobe/${app_probe_class_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ app_probe_class_name }}    msg=app probe class name
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..forwardingClass    {{ app_probe_class_forwarding_class }}    msg=forwarding class

{% for item in app_probe_class.mappings | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..map[{{loop.index0}}].color    {{ item.color }}    msg=color
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..map[{{loop.index0}}].dscp    {{ item.dscp }}    msg=dscp
{% endfor %}

{% endfor %}

{% endif %}
