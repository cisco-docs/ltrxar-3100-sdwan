*** Settings ***
Documentation   Verify QoS Map
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    qos_maps
Resource        ../../../sdwan_common.resource

{% if sdwan.localized_policies.definitions.qos_maps is defined %}

*** Test Cases ***
Get QoS Map
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/qosmap
    Set Suite Variable    ${r}

{% for qos_map in sdwan.localized_policies.definitions.qos_maps | default([]) %}

Verify Localized Policies QoS Map {{ qos_map.name }}
    ${def_id}=    Get Value From Json    ${r.json()}    $..data[?(@.name=="{{qos_map.name }}")].definitionId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/qosmap/${def_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $.name    {{ qos_map.name }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $.description    {{ qos_map.description }}    msg=description

    ${qos_scheduler_items}=    Get Value From Json    ${r_id.json()}    $.definition.qosSchedulers
    ${qos_schedulers_length}=    Get Length    ${qos_scheduler_items[0]}
    Should Be Equal As Integers    ${qos_schedulers_length}    {{ qos_map.qos_schedulers | length }}    msg=qos schedulers

{% for qos in qos_map.qos_schedulers | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.definition.qosSchedulers[{{ loop.index0 }}].queue    {{ qos.queue }}    msg=queue

    ${qos_class_id}=    Get Value From Json    ${r_id.json()}    $.definition.qosSchedulers[{{ loop.index0 }}].classMapRef
    IF    ${qos_class_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $.definition.qosSchedulers[{{ loop.index0 }}].classMapRef    {{ qos.class_map }}    msg=class map
    ELSE
        ${qos_class_details}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/class/${qos_class_id[0]}
        Should Be Equal Value Json String    ${qos_class_details.json()}    $.name    {{ qos.class_map }}    msg=class map
    END

    Should Be Equal Value Json String    ${r_id.json()}    $.definition.qosSchedulers[{{ loop.index0 }}].bandwidthPercent    {{ qos.bandwidth_percent }}    msg=bandwidth percent
    Should Be Equal Value Json String    ${r_id.json()}    $.definition.qosSchedulers[{{ loop.index0 }}].bufferPercent    {{ qos.buffer_percent }}    msg=buffer percent
    Should Be Equal Value Json String    ${r_id.json()}    $.definition.qosSchedulers[{{ loop.index0 }}].burst    {{ qos.burst_bytes | default("not_defined") }}    msg=burst bytes
    Should Be Equal Value Json String    ${r_id.json()}    $.definition.qosSchedulers[{{ loop.index0 }}].scheduling    {{ qos.scheduling_type }}    msg=scheduling type
    Should Be Equal Value Json String    ${r_id.json()}    $.definition.qosSchedulers[{{ loop.index0 }}].drops    {{ qos.drop_type }}    msg=drop type

{% endfor %}

{% endfor %}

{% endif %}
