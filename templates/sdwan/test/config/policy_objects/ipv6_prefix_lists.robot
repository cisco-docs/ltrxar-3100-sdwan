*** Settings ***
Documentation   Verify IPv6 Prefix Lists
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan  config  ipv6_prefix_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.ipv6_prefix_lists is defined%}

*** Test Cases ***
Get IPv6 Prefix List(s)
    ${r}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/ipv6prefix
    Set Suite Variable   ${r}

{% for prefix in sdwan.policy_objects.ipv6_prefix_lists | default([]) %}
{% set ipv6_prefix_name = prefix.name %}

Verify Policy Objects IPv6 Prefix List {{ ipv6_prefix_name }}
    ${ipv6_prefix_id}=   Get Value From Json   ${r.json()}  $..data[?(@..name=="{{ipv6_prefix_name }}")].listId
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/ipv6prefix/${ipv6_prefix_id[0]}
    Should Be Equal Value Json String   ${r_id.json()}   $..name   {{ ipv6_prefix_name }}

{% for item in prefix.entries | default([]) %}
    Should Be Equal Value Json String   ${r_id.json()}    $..entries[{{loop.index0}}].ipv6Prefix    {{ item.prefix }}    msg=prefix is
{% set prefix_le = item.le | default("not_defined")  %}
    Should Be Equal Value Json String   ${r_id.json()}    $..entries[{{loop.index0}}].le    {{ prefix_le }}    msg=prefix le is
{% set prefix_ge = item.ge | default("not_defined")  %}
    Should Be Equal Value Json String   ${r_id.json()}    $..entries[{{loop.index0}}].ge    {{ prefix_ge }}    msg=prefix ge is
{% endfor %}

{% endfor %}

{% endif %}
