*** Settings ***
Documentation   Verify Tloc Lists
Suite Setup     Login SDWAN Manager
Default Tags    sdwan  config  tloc_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.tloc_lists is defined%}

*** Test Cases ***
Get Tloc List(s)
    ${r}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/tloc
    Set Suite Variable   ${r}

{% for tloc in sdwan.policy_objects.tloc_lists | default([]) %}
{% set tloc_name = tloc.name %}

Verify Policy Objects Tloc List {{ tloc_name }}
    ${tloc_id}=   Get Value From Json   ${r.json()}   $..data[?(@..name=="{{tloc_name }}")].listId
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/tloc/${tloc_id[0]}
    Should Be Equal Value Json String   ${r_id.json()}   $..name   {{ tloc_name }}

{% if tloc.tlocs is defined %}
{% for item in tloc.tlocs | default([]) %}
    Should Be Equal Value Json String   ${r_id.json()}   $..entries[{{loop.index0}}].color   {{ item.color }}
    Should Be Equal Value Json String   ${r_id.json()}   $..entries[{{loop.index0}}].tloc   {{ item.tloc_ip }}
    Should Be Equal Value Json String   ${r_id.json()}   $..entries[{{loop.index0}}].encap   {{ item.encapsulation }}
{% if item.preference is defined %}
    Should Be Equal Value Json String   ${r_id.json()}   $..entries[{{loop.index0}}].preference   {{ item.preference }}
{% endif %}

{% endfor %}
{% endif %}

{% endfor %}
{% endif %}
