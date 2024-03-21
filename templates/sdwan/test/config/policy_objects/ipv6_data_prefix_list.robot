*** Settings ***
Documentation   Verify IPv6 Data Prefix List Configuration
Suite Setup     Login SDWAN Manager
Default Tags    sdwan  config  ipv6_data_prefix_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.ipv6_data_prefix_lists is defined%}

*** Test Cases ***
Get IPv6 Data Prefix List(s)
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/dataipv6prefix
    Set Suite Variable    ${r}

{% for prefix in sdwan.policy_objects.ipv6_data_prefix_lists | default([]) %}
{% set ipv6_data_prefix_name = prefix.name %}

Verify Policy Objects IPv6 Data Prefix List {{ ipv6_data_prefix_name }}
    ${ipv6_data_prefix_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{ipv6_data_prefix_name}}")].listId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/dataipv6prefix/${ipv6_data_prefix_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ ipv6_data_prefix_name }}

{% set ipv6_data_prefix_list = prefix.prefixes %}
    ${ipv6_list}=    Create List    {{ ipv6_data_prefix_list | join('   ') }}
    Should Be Equal Value Json List    ${r_id.json()}    $..entries..ipv6Prefix    ${ipv6_list}    msg=ipv6 data prefix list is

{% endfor %}

{% endif %}
