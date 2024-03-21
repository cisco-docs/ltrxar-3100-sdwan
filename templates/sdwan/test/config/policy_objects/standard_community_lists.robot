*** Settings ***
Documentation   Verify Standard Community Lists
Suite Setup     Login SDWAN Manager
Default Tags    sdwan    config    standard_community_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.standard_community_lists is defined%}

*** Test Cases ***
Get Standard Community List(s)
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/community
    Set Suite Variable    ${r}

{% for standard_community in sdwan.policy_objects.standard_community_lists | default([]) %}
{% set standard_community_name = standard_community.name %}

Verify Policy Objects Standard Community List {{ standard_community_name }}
    ${standard_community_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{standard_community_name }}")].listId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/community/${standard_community_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ standard_community_name }}

{% if standard_community.standard_communities is defined %}
    ${community_list}=    Create List   {{ standard_community.standard_communities | join('   ') }}
    Should Be Equal Value Json List    ${r_id.json()}    $..entries..community    ${community_list}    msg=standard communities are
{% endif %}

{% endfor %}

{% endif %}
