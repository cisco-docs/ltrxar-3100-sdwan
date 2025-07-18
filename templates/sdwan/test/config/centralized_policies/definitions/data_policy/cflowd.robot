*** Settings ***
Documentation   Verify Cflowd Policy
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    centralized_policies    data_policies
Resource        ../../../../sdwan_common.resource

{% if sdwan.centralized_policies.definitions.data_policy.cflowd is defined %}

*** Test Cases ***
Get Cflowd Policy
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/cflowd
    Set Suite Variable    ${r}

{% for cflowd in sdwan.centralized_policies.definitions.data_policy.cflowd | default([]) %}
{% set cflowd_name = cflowd.name %}
{% set cflowd_description = cflowd.description %}
{% set cflowd_active_flow_timeout = cflowd.active_flow_timeout %}
{% set cflowd_inactive_flow_timeout = cflowd.inactive_flow_timeout %}
{% set cflowd_sampling_interval = cflowd.sampling_interval %}
{% set cflowd_flow_refresh = cflowd.flow_refresh %}
{% set cflowd_protocol = cflowd.protocol %}
{% set cflowd_tos = cflowd.tos %}
{% set cflowd_remarked_dscp = cflowd.remarked_dscp %}
{% set cflowd_collectors = cflowd.collectors | default([]) %}

Verify Centralized Policies Data Policy Cflowd {{ cflowd_name }}
    ${cflowd_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{cflowd_name }}")].definitionId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/cflowd/${cflowd_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ cflowd_name }}    msg=cflowd name
    Should Be Equal Value Json Special_String    ${r_id.json()}    $..description    {{ cflowd_description | normalize_special_string }}    msg=description
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.flowActiveTimeout    {{ cflowd_active_flow_timeout }}    msg=cflowd active flow timeout
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.flowInactiveTimeout    {{ cflowd_inactive_flow_timeout }}    msg=cflowd inactive flow timeout
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.flowSamplingInterval    {{ cflowd_sampling_interval }}    msg=cflowd sampling interval
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.templateRefresh    {{ cflowd_flow_refresh }}    msg=cflowd flow refresh
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.protocol    {{ cflowd_protocol | default(defaults.sdwan.centralized_policies.definitions.data_policy.cflowd.protocol) }}    msg=cflowd protocol
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.customizedIpv4RecordFields.collectTos    {{ cflowd_tos | default(defaults.sdwan.centralized_policies.definitions.data_policy.cflowd.tos) }}    msg=cflowd tos
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.customizedIpv4RecordFields.collectDscpOutput    {{ cflowd_remarked_dscp | default(defaults.sdwan.centralized_policies.definitions.data_policy.cflowd.remarked_dscp) }}    msg=cflowd remarked dscp

{% for collector in cflowd_collectors %}
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.collectors[{{loop.index0}}].vpn    {{ collector.vpn }}    msg=cflowd collector vpn
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.collectors[{{loop.index0}}].address    {{ collector.ip_address }}    msg=cflowd collector ip address
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.collectors[{{loop.index0}}].port    {{ collector.port }}    msg=cflowd collector port
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.collectors[{{loop.index0}}].transport    {{ collector.transport }}    msg=cflowd collector transport
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.collectors[{{loop.index0}}].sourceInterface    {{ collector.source_interface }}    msg=cflowd collector source interface
    Should Be Equal Value Json String    ${r_id.json()}    $..definition.collectors[{{loop.index0}}].exportSpread    {{ collector.export_spreading }}    msg=cflowd collector export spreading
{% endfor %}

{% endfor %}

{% endif %}
