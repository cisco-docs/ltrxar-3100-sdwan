*** Settings ***
Documentation   Verify Color Lists
Suite Setup     Login SDWAN Manager
Default Tags    sdwan  config  color_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.color_lists is defined %}

*** Test Cases ***
Get Color List(s)
   ${r}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/color
   Set Suite Variable   ${r}

{% for obj_name in sdwan.policy_objects.color_lists | default([]) %}
{%- set color_obj_name= obj_name.name -%}

Verify Policy Objects Color List {{ color_obj_name }}
    ${color_obj_id}=  Get Value From Json   ${r.json()}   $..data[?(@..name=="{{ color_obj_name }}")].listId
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/color/${color_obj_id[0]}
    Should Be Equal Value Json String   ${r_id.json()}   $..name   {{ color_obj_name }}

{% if obj_name.colors is defined %}
{% set req_colors= obj_name.colors %}
    ${req_color_list}=   Create List   {{ req_colors | join('   ') }}
    ${color_entries}=   Get Value From Json   ${r_id.json()}   $..color
    Should Be Equal Value Json List   ${r_id.json()}   $..color   ${req_color_list}   msg=colors are
{% endif %}

{% endfor %}
{% endif %}
