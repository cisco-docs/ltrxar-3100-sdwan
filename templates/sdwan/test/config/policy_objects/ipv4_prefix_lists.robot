*** Settings ***
Documentation   Verify IPv4 Prefix Lists
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan  config  ipv4_prefix_lists
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.ipv4_prefix_lists is defined%}

*** Test Cases ***
Get IPv4 Prefix List(s)
    ${r}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/prefix
    Set Suite Variable   ${r}

{% for prefix in sdwan.policy_objects.ipv4_prefix_lists | default([]) %}

Verify Policy Objects IPv4 Prefix List {{ prefix.name }}
    ${ipv4_prefix_id}=   Get Value From Json   ${r.json()}  $..data[?(@..name=="{{prefix.name }}")].listId
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/prefix/${ipv4_prefix_id[0]}
    Should Be Equal Value Json String   ${r_id.json()}   $..name   {{ prefix.name }}
    ${ipv4_data}=   Get Value From Json    ${r_id.json()}    $..entries
    ${ipv4_len}=    Get Length     ${ipv4_data[0]}
    Should Be Equal As Integers    ${ipv4_len}    {{ prefix.entries | length }}    msg=Ipv4 entries
{% for item in prefix.entries | default([]) %}
    Should Be Equal Value Json String   ${r_id.json()}    $..entries[{{loop.index0}}].ipPrefix    {{ item.prefix }}    msg=prefix is
    Should Be Equal Value Json String   ${r_id.json()}    $..entries[{{loop.index0}}].le    {{ item.le | default("not_defined") }}    msg=prefix le is
    Should Be Equal Value Json String   ${r_id.json()}    $..entries[{{loop.index0}}].ge    {{ item.ge | default("not_defined")  }}    msg=prefix ge is
{% endfor %}

{% endfor %}

{% endif %}
