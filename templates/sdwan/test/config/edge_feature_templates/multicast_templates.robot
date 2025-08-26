*** Settings ***
Documentation   Verify Multicast Feature Template Configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates multicast_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.multicast_templates is defined %}

*** Test Cases ***
Get Multicast Feature Template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    Set Suite Variable    ${r}

{% for multicast in sdwan.edge_feature_templates.multicast_templates | default([]) %}

Verify Edge Feature Multicast Configuration Template {{ multicast.name }}
    ${multicast_id}=  Get Value From Json   ${r.json()}   $..data[?(@..templateName=="{{ multicast.name }}")].templateId
    Should Not be Empty   ${multicast_id}   msg= {{ multicast.name }} not present
    Should Be Equal Value Json Special_String   ${r.json()}   $..data[?(@..templateName=="{{ multicast.name }}")].templateDescription   {{ multicast.description | normalize_special_string }}  msg=description
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/feature/definition/${multicast_id[0]}
    Set Suite Variable   ${r_id}

{% set dt_list_local = [] %}
{% for item in multicast.device_types | default(defaults.sdwan.edge_feature_templates.multicast_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = dt_list_local.append(test) %}
{% endfor %}

    ${dt_list}=  Get Value From Json   ${r.json()}   $..data[?(@..templateName=="{{ multicast.name }}")].deviceType
    ${dt_list_local}=   Create List   {{ dt_list_local | join('   ') }}
    Lists Should Be Equal    ${dt_list_local}    ${dt_list}[0]   ignore_order=True   msg={{ multicast.name }}: device type

    Log    ${r_id.json()}
    Should Be Equal Value Json String FT   ${r_id.json()}   $..["spt-only"]    {{ multicast.spt_only_variable | default(multicast.spt_only | default("not_defined") | lower())}}    msg=spt only multicast
    Should Be Equal Value Json String FT   ${r_id.json()}   $..local    {{ multicast.local_replicator_variable | default(multicast.local_replicator | default("not_defined") | lower())}}    msg=local replicator multicast
    Should Be Equal Value Json String FT   ${r_id.json()}   $..threshold    {{ multicast.threshold_variable | default(multicast.threshold | default("not_defined"))}}    msg=threshold multicast

{% endfor %}
{% endif %}
