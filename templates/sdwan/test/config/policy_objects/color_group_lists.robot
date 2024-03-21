*** Settings ***
Documentation   Verify Preferred Color Group Lists
Suite Setup     Login SDWAN Manager
Default Tags    sdwan  config  preferred_color_groups
Resource        ../../sdwan_common.resource
Library         String

{% if sdwan.policy_objects.preferred_color_groups is defined %}

*** Test Cases ***
Get Preferred Color Group List(s)
   ${r}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/preferredcolorgroup
   Set Suite Variable   ${r}

{% for color_group in sdwan.policy_objects.preferred_color_groups | default([]) %}
{%- set color_group_name= color_group.name -%}

Verify Policy Objects Preferred Color Group List {{ color_group_name }}
   ${color_group_id}=   Get Value From Json   ${r.json()}   $..data[?(@..name=="{{ color_group_name }}")].listId
   ${cg_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/preferredcolorgroup/${color_group_id[0]}
   Set Suite Variable   ${cg_id}
   Should Be Equal Value Json String   ${cg_id.json()}   $..name   {{ color_group_name }}   msg=color group name

{% set primary_colors= color_group.primary_colors %}
   ${color_group}=   Get Value From Json   ${cg_id.json()}   $..primaryPreference.colorPreference
   ${color_group_list}=  Split String    ${color_group[0]}
   ${primary_colors}=    Create List    {{ primary_colors | join('   ') }}
   Lists Should Be Equal   ${primary_colors}   ${color_group_list}   ignore_order=True   msg={{ color_group_name }}: Primary Colors mismatch

{% set primary_path= color_group.primary_path | default("not_defined") %}
   Should Be Equal Value Json String   ${cg_id.json()}   $..primaryPreference.pathPreference   {{ primary_path }}   msg={{ color_group_name }}: Primary Path Preference

{% if color_group.secondary_colors is defined %}
{% set secondary_colors= color_group.secondary_colors %}
   ${color_group}=   Get Value From Json   ${cg_id.json()}   $..secondaryPreference.colorPreference
   ${color_group_list}=  Split String    ${color_group[0]}
   ${secondary_colors}=    Create List    {{ secondary_colors | join('   ') }}
   Lists Should Be Equal   ${secondary_colors}   ${color_group_list}   ignore_order=True   msg={{ color_group_name }}: Secondary Colors mismatch
{% else %}
{% set secondary_colors= "not_defined" %}
   Should Be Equal Value Json String   ${cg_id.json()}   $..secondaryPreference.colorPreference   {{ secondary_colors }}   msg={{ color_group_name }}: Secondary Colors
{% endif %}

{% set secondary_path= color_group.secondary_path | default("not_defined") %}
   Should Be Equal Value Json String   ${cg_id.json()}   $..secondaryPreference.pathPreference   {{ secondary_path }}   msg={{ color_group_name }}: Secondary Path Preference

{% if color_group.tertiary_colors is defined %}
{% set tertiary_colors= color_group.tertiary_colors %}
   ${color_group}=   Get Value From Json   ${cg_id.json()}   $..tertiaryPreference.colorPreference
   ${color_group_list}=  Split String    ${color_group[0]}
   ${tertiary_colors}=    Create List    {{ tertiary_colors | join('   ') }}
   Lists Should Be Equal   ${tertiary_colors}   ${color_group_list}   ignore_order=True   msg={{ color_group_name }}: Tertiary Colors mismatch
{% else %}
{% set teritiary_color= "not_defined" %}
   Should Be Equal Value Json String   ${cg_id.json()}   $..tertiaryPreference.colorPreference   {{ teritiary_color }}   msg={{ color_group_name }}: Tertiary Colors
{% endif %}

{% set tertiary_path= color_group.tertiary_path | default("not_defined") %}
   Should Be Equal Value Json String   ${cg_id.json()}   $..tertiaryPreference.pathPreference   {{ tertiary_path }}   msg={{ color_group_name }}: Teritiary Path preference

{% endfor %}
{% endif %}
