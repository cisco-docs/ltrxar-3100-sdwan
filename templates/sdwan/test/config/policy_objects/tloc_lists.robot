*** Settings ***
Documentation   Verify Tloc Lists
Suite Setup     Login SDWAN Manager
Default Tags    sdwan    config    tloc_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.tloc_lists is defined %}

*** Test Cases ***
Get Tloc List(s)
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/tloc
    Set Suite Variable    ${r}

{% for tloc in sdwan.policy_objects.tloc_lists | default([]) %}
{% set tloc_name = tloc.name %}

Verify Policy Objects Tloc List {{ tloc_name }}
    ${tloc_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{tloc_name }}")].listId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/tloc/${tloc_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ tloc_name }}    msg=tloc name

{% for item in tloc.tlocs | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..entries[{{loop.index0}}].color    {{ item.color }}    msg=tloc color
    Should Be Equal Value Json String    ${r_id.json()}    $..entries[{{loop.index0}}].tloc    {{ item.tloc_ip }}    msg=tloc ip
    Should Be Equal Value Json String    ${r_id.json()}    $..entries[{{loop.index0}}].encap    {{ item.encapsulation }}    msg=tloc encapsulation

{% set item_preference = item.preference | default("not_defined")  %}
    Should Be Equal Value Json String    ${r_id.json()}    $..entries[{{loop.index0}}].preference    {{ item_preference }}    msg=tloc preference

{% endfor %}

{% endfor %}
{% endif %}
