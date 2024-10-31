*** Settings ***
Documentation   Verify Mirror Lists
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan   config   classic_policy_objects
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.mirror_lists is defined%}

*** Test Cases ***
Get Mirror Lists
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/mirror
    Set Suite Variable    ${r}

{% for mirror_lists in sdwan.policy_objects.mirror_lists | default([]) %}

Verify Policy Objects Mirror List {{ mirror_lists.name  }}
    ${mirror_lists_id}=   Get Value From Json   ${r.json()}   $..data[?(@..name=="{{mirror_lists.name }}")].listId
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/mirror/${mirror_lists_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ mirror_lists_name }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $..remoteDest    {{ mirror_lists.remote_destination_ip }}    msg=remote destination ip
    Should Be Equal Value Json String    ${r_id.json()}    $..source    {{ mirror_lists.default_action_type }}    msg=source ip

{% endfor %}

{% endif %}
