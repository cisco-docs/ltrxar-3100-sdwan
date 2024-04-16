*** Settings ***
Documentation   Verify Policers List
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    policers
Resource        ../../sdwan_common.resource

{% if sdwan.policy_objects.policers is defined %}

*** Test Cases ***
Get Policers List
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/policer
    Set Suite Variable    ${r}

{% for policer in sdwan.policy_objects.policers | default([]) %}
{% set policer_name = policer.name %}
{% set policer_burst_bytes = policer.burst_bytes %}
{% set policer_exceed_action = policer.exceed_action %}
{% set policer_rate_bps = policer.rate_bps %}

Verify Policy Objects Policer list {{ policer_name }}
    ${policer_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{policer_name }}")].listId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/policer/${policer_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ policer_name }}    msg=policer name
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..burst    {{ policer_burst_bytes }}    msg=policer burst bytes
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..exceed    {{ policer_exceed_action }}    msg=policer exceed action
    Should Be Equal Value Json String    ${r_id.json()}    $..entries..rate    {{ policer_rate_bps }}    msg=policer rate bps

{% endfor %}

{% endif %}
