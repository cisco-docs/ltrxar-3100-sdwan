*** Settings ***
Documentation   Verify Policers List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan   config   classic_policy_objects
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.policers is defined %}

*** Test Cases ***
Get Policers List
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/policer
    Set Suite Variable    ${r}

{% for policer in sdwan.policy_objects.policers | default([]) %}

Verify Policy Objects Policer list {{ policer.name }}
    ${policer_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{policer.name }}")].listId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/policer/${policer_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ policer.name }}    msg=policer name
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..burst    {{ policer.burst_bytes }}    msg=policer burst bytes
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..exceed    {{ policer.exceed_action }}    msg=policer exceed action
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..rate    {{ policer.rate_bps }}    msg=policer rate bps

{% endfor %}

{% endif %}
