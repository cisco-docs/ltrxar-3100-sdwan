*** Settings ***
Documentation   Verify Region Lists
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan   config   classic_policy_objects
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.region_lists is defined %}

*** Test Cases ***
Get Region List(s)
    ${r}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/region
    Set Suite Variable   ${r}

{% for region in sdwan.policy_objects.region_lists | default([]) %}

Verify Policy Objects Region List {{ region.name }}
    ${region_id}=   Get Value From Json   ${r.json()}   $..data[?(@..name=="{{ region.name }}")].listId
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/region/${region_id[0]}
    Should Be Equal Value Json String   ${r_id.json()}   $..name   {{ region.name }}   msg=Region name
{% if region.region_ids is defined and region.region_id_ranges is defined %}
{%- set req_region_ids= region.region_ids -%}
{%- set region_string= req_region_ids | map('string') | join(',') -%}
{%- set region_list= region_string.split(',') -%}
{%- for region_range in region.region_id_ranges | default([]) -%}
{%- set test_list= [] -%}
{%- set _ = test_list.append(region_range.from) -%}
{%- set _ = test_list.append(region_range.to) -%}
{%- set region_ranges= '-'.join( test_list | map('string')) -%}
{%- set _ = region_list.append(region_ranges) -%}

{% endfor %}
    ${region_range_list}=   Create List   {{ region_list | join('   ') }}
    Should Be Equal Value Json List   ${r_id.json()}   $..regionId   ${region_range_list}   msg=Region Id or Region range are
{% elif region.region_id_ranges is defined %}
{%- set region_ranges= [] -%}
{% for region_range in region.region_id_ranges | default([]) %}
{%- set test_list= [] -%}
{%- set _ = test_list.append(region_range.from) -%}
{%- set _ = test_list.append(region_range.to) -%}
{%- set ranges= '-'.join( test_list | map('string')) -%}
{%- set _ = region_ranges.append(ranges) -%}

{% endfor %}
    ${region_range_list}=   Create List   {{ region_ranges | join('   ') }}
    Should Be Equal Value Json List   ${r_id.json()}   $..regionId   ${region_range_list}   msg=Region ranges are
{% elif region.region_ids is defined %}
    ${reg_ids}=   Create List   {{ region.region_ids | join('   ') }}
    Should Be Equal Value Json List   ${r_id.json()}   $..regionId   ${reg_ids}   msg=Region Ids are
{% endif %}

{% endfor %}
{% endif %}
