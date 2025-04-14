*** Settings ***
Documentation   Verify OSPF Feature Template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.ospf_templates is defined %}

*** Test Cases ***
Get OSPF Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_ospf")]
    Set Suite Variable    ${r}

{% for ospf in sdwan.edge_feature_templates.ospf_templates | default([]) %}

Verify Edge Feature Template OSPF Feature template {{ ospf.name }}
    ${ospf_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ospf.name }}")]
    Should Be Equal Value Json String    ${ospf_id}    $..templateName    {{ ospf.name }}    msg=name
    Should Be Equal Value Json Special_String    ${ospf_id}    $..templateDescription    {{ ospf.description | normalize_special_string }}    msg=description

{% set test_list = [] %}
{% for item in ospf.device_types | default(defaults.sdwan.edge_feature_templates.ospf_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=    Get Value From Json    ${ospf_id}    $..deviceType
    ${test_list}=    Create List    {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list[0]}    ${test_list}    ignore_order=True    msg=device types

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{ospf.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["auto-cost"]..["reference-bandwidth"].vipValue    {{ ospf.auto_cost_reference_bandwidth | default("not_defined") }}    msg=auto cost reference bandwidth
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["auto-cost"]..["reference-bandwidth"].vipVariableName    {{ ospf.auto_cost_reference_bandwidth_variable | default("not_defined") }}    msg=auto cost reference bandwidth variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.compatible.rfc1583.vipValue    {{ ospf.compatible_rfc1583 | default("not_defined") | lower() }}    msg=compatible rfc1583
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.compatible.rfc1583.vipVariableName    {{ ospf.compatible_rfc1583_variable | default("not_defined") }}    msg=compatible rfc1583 variable

{% if ospf.default_information_originate | default("not_defined") | lower() == "true" %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["default-information"].originate.always.vipValue    {{ ospf.default_information_originate_always | default("not_defined") | lower() }}    msg=default information originate always
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["default-information"].originate.always.vipVariableName    {{ ospf.default_information_originate_always_variable | default("not_defined") }}    msg=default information originate always variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["default-information"].originate.metric.vipValue    {{ ospf.default_information_originate_metric | default("not_defined") }}    msg=default information originate metric
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["default-information"].originate.metric.vipVariableName    {{ ospf.default_information_originate_metric_variable | default("not_defined") }}    msg=default information originate metric variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["default-information"].originate..["metric-type"].vipValue    {{ ospf.default_information_originate_metric_type | default("not_defined") }}    msg=default information originate metric type
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["default-information"].originate..["metric-type"].vipVariableName    {{ ospf.default_information_originate_metric_type_variable | default("not_defined") }}    msg=default information originate metric type variable

{% elif ospf.default_information_originate | default("not_defined") | lower() == "false" %}

    ${res_value}=    Get Value From Json    ${r_id.json()}    $.ospf..["default-information"].originate.vipType
    ${r_value}=    Set Variable If    "${res_value[0]}" == "ignore"    false
    Should Be Equal As Strings    ${r_value}    {{ ospf.default_information_originate | default("not_defined") | lower() }}    msg=default information originate

{% elif ospf.default_information_originate | default("not_defined") | lower() == "not_defined" %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["default-information"].originate.vipType    {{ ospf.default_information_originate | default("not_defined") | lower() }}    msg=default information originate

{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.distance..["inter-area"].vipValue    {{ ospf.distance_inter_area | default("not_defined") }}    msg=distance inter area
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.distance..["inter-area"].vipVariableName    {{ ospf.distance_inter_area_variable | default("not_defined") }}    msg=distance inter area variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.distance..["intra-area"].vipValue    {{ ospf.distance_intra_area | default("not_defined") }}    msg=distance intra area
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.distance..["intra-area"].vipVariableName    {{ ospf.distance_intra_area_variable | default("not_defined") }}    msg=distance intra area variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.distance.external.vipValue    {{ ospf.distance_external | default("not_defined") }}    msg=distance external
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.distance.external.vipVariableName    {{ ospf.distance_external_variable | default("not_defined") }}    msg=distance external variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["route-policy"].vipValue..["pol-name"].vipValue    {{ ospf.route_policy | default("not_defined") }}    msg=route policy
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["route-policy"].vipValue..["pol-name"].vipVariableName    {{ ospf.route_policy_variable | default("not_defined") }}    msg=route policy variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["router-id"].vipValue    {{ ospf.router_id | default("not_defined") }}    msg=router id
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf..["router-id"].vipVariableName    {{ ospf.router_id_variable | default("not_defined") }}    msg=router id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.timers.spf.delay.vipValue    {{ ospf.timers_spf_delay | default("not_defined") }}    msg=timers spf delay
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.timers.spf.delay.vipVariableName    {{ ospf.timers_spf_delay_variable | default("not_defined") }}    msg=timers spf delay variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.timers.spf..["initial-hold"].vipValue    {{ ospf.timers_spf_initial_hold | default("not_defined") }}    msg=timers spf initial hold
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.timers.spf..["initial-hold"].vipVariableName    {{ ospf.timers_spf_initial_hold_variable | default("not_defined") }}    msg=timers spf initial hold variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.timers.spf..["max-hold"].vipValue    {{ ospf.timers_spf_max_hold | default("not_defined") }}    msg=timers spf max hold
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.timers.spf..["max-hold"].vipVariableName    {{ ospf.timers_spf_max_hold_variable | default("not_defined") }}    msg=timers spf max hold variable

    ${area_items}=    Get Value From Json    ${r_id.json()}    $.ospf.area.vipValue
    ${areas_length}=    Get Length    ${area_items[0]}
    Should Be Equal As Integers    ${areas_length}    {{ ospf.areas | length }}    msg=areas

{% for area_index in range(ospf.areas | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}]..["a-num"].vipValue    {{ ospf.areas[area_index].area_number | default("not_defined") }}    msg=area number
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}]..["a-num"].vipVariableName    {{ ospf.areas[area_index].area_number_variable | default("not_defined") }}    msg=area number variable

    ${rec_area_type}=    Get Value From Json    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}]
    ${res_area_keys}=    Get Dictionary Keys    ${rec_area_type[0]}

{% if ospf.areas[area_index].area_type | default("not_defined") != "not_defined" %}

    List Should Contain Value    ${res_area_keys}    {{ ospf.areas[area_index].area_type | default("not_defined") }}    msg=area type

{% else %}

    ${status}=    Evaluate    'stub' not in ${res_area_keys} and 'nssa' not in ${res_area_keys}
    IF    ${status} == ${False}
        Fail   msg=area type
    END

{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].{{ ospf.areas[area_index].area_type | default("not_defined") }}..["no-summary"].vipValue    {{ ospf.areas[area_index].no_summary | default("not_defined") | lower() }}    msg=no summary
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].{{ ospf.areas[area_index].area_type | default("not_defined") }}..["no-summary"].vipVariableName    {{ ospf.areas[area_index].no_summary_variable | default("not_defined") }}    msg=no summary variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].vipOptional    {{ ospf.areas[area_index].optional | default("not_defined") }}    msg=area optional

    ${interface_items}=    Get Value From Json    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue
    ${interfaces_length}=    Get Length    ${interface_items[0]}
    Should Be Equal As Integers    ${interfaces_length}    {{ ospf.areas[area_index].interfaces | length }}    msg=interfaces

{% for int_index in range(ospf.areas[area_index].interfaces | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].authentication..["message-digest"].md5.vipValue    {{ ospf.areas[area_index].interfaces[int_index].authentication_message_digest_key | default("not_defined") }}    msg=authentication message digest key
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].authentication..["message-digest"].md5.vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].authentication_message_digest_key_variable | default("not_defined") }}    msg=authentication message digest key variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].authentication..["message-digest"]..["message-digest-key"].vipValue    {{ ospf.areas[area_index].interfaces[int_index].authentication_message_digest_key_id | default("not_defined") }}    msg=authentication message digest key id
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].authentication..["message-digest"]..["message-digest-key"].vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].authentication_message_digest_key_id_variable | default("not_defined") }}    msg=authentication message digest key id variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].authentication.type.vipValue    {{ ospf.areas[area_index].interfaces[int_index].authentication_type | default("not_defined") }}    msg=authentication type
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].authentication.type.vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].authentication_type_variable | default("not_defined") }}    msg=authentication type variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].cost.vipValue    {{ ospf.areas[area_index].interfaces[int_index].cost | default("not_defined") }}    msg=interface cost
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].cost.vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].cost_variable | default("not_defined") }}    msg=interface cost variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}]..["dead-interval"].vipValue    {{ ospf.areas[area_index].interfaces[int_index].dead_interval | default("not_defined") }}    msg=dead interval
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}]..["dead-interval"].vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].dead_interval_variable | default("not_defined") }}    msg=dead interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}]..["hello-interval"].vipValue    {{ ospf.areas[area_index].interfaces[int_index].hello_interval | default("not_defined") }}    msg=hello interval
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}]..["hello-interval"].vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].hello_interval_variable | default("not_defined") }}    msg=hello interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].name.vipValue    {{ ospf.areas[area_index].interfaces[int_index].name | default("not_defined") }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].name.vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].name_variable | default("not_defined") }}    msg=name variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].network.vipValue    {{ ospf.areas[area_index].interfaces[int_index].network_type | default("not_defined") }}    msg=network type
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].network.vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].network_type_variable | default("not_defined") }}    msg=network type variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}]..["passive-interface"].vipValue    {{ ospf.areas[area_index].interfaces[int_index].passive_interface | default("not_defined") | lower() }}    msg=passive interface
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}]..["passive-interface"].vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].passive_interface_variable | default("not_defined") }}    msg=passive interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].priority.vipValue    {{ ospf.areas[area_index].interfaces[int_index].priority | default("not_defined") }}    msg=priority
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}].priority.vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].priority_variable | default("not_defined") }}    msg=priority variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}]..["retransmit-interval"].vipValue    {{ ospf.areas[area_index].interfaces[int_index].retransmit_interval | default("not_defined") }}    msg=retransmit interval
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].interface.vipValue[{{ int_index }}]..["retransmit-interval"].vipVariableName    {{ ospf.areas[area_index].interfaces[int_index].retransmit_interval_variable | default("not_defined") }}    msg=retransmit interval variable

{% endfor %}

    ${range_items}=    Get Value From Json    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].range.vipValue
    ${ranges_length}=    Get Length    ${range_items[0]}
    Should Be Equal As Integers    ${ranges_length}    {{ ospf.areas[area_index].ranges | length }}    msg=ranges

{% for range_index in range(ospf.areas[area_index].ranges | default([]) | length) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].range.vipValue[{{ range_index }}].address.vipValue    {{ ospf.areas[area_index].ranges[range_index].address | default("not_defined") }}    msg=address
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].range.vipValue[{{ range_index }}].address.vipVariableName    {{ ospf.areas[area_index].ranges[range_index].address_variable | default("not_defined") }}    msg=address variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].range.vipValue[{{ range_index }}].cost.vipValue    {{ ospf.areas[area_index].ranges[range_index].cost | default("not_defined") }}    msg=range cost
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].range.vipValue[{{ range_index }}].cost.vipVariableName    {{ ospf.areas[area_index].ranges[range_index].cost_variable | default("not_defined") }}    msg=range cost variable
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].range.vipValue[{{ range_index }}]..["no-advertise"].vipValue    {{ ospf.areas[area_index].ranges[range_index].no_advertise | default("not_defined") | lower() }}    msg=no advertise
    Should Be Equal Value Json String    ${r_id.json()}    $.ospf.area.vipValue[{{ area_index }}].range.vipValue[{{ range_index }}]..["no-advertise"].vipVariableName    {{ ospf.areas[area_index].ranges[range_index].no_advertise_variable | default("not_defined") }}    msg=no advertise variable

{% endfor %}

{% endfor %}

    ${lsa_items}=    Get Value From Json    ${r_id.json()}    $.ospf..["max-metric"]..["router-lsa"].vipValue
    ${lsas_length}=    Get Length    ${lsa_items[0]}
    Should Be Equal As Integers    ${lsas_length}    {{ ospf.max_metric_router_lsas | length }}    msg=max metric router lsas

{% for lsa in ospf.max_metric_router_lsas | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..["max-metric"]..["router-lsa"].vipValue[{{loop.index0}}].time.vipValue    {{ lsa.time | default("not_defined") }}    msg=time
    Should Be Equal Value Json String    ${r_id.json()}    $..["max-metric"]..["router-lsa"].vipValue[{{loop.index0}}].time.vipVariableName    {{ lsa.time_variable | default("not_defined") }}    msg=time variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["max-metric"]..["router-lsa"].vipValue[{{loop.index0}}]..["ad-type"].vipValue    {{ lsa.type | default("not_defined") }}    msg=type

{% endfor %}

    ${redistribute_items}=    Get Value From Json    ${r_id.json()}    $.ospf.redistribute.vipValue
    ${redistributes_length}=    Get Length    ${redistribute_items[0]}
    Should Be Equal As Integers    ${redistributes_length}    {{ ospf.redistributes | length }}    msg=redistributes

{% for redistribute in ospf.redistributes | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..redistribute.vipValue[{{loop.index0}}].dia.vipValue    {{ redistribute.nat_dia | default("not_defined") | lower() }}    msg=nat dia
    Should Be Equal Value Json String    ${r_id.json()}    $..redistribute.vipValue[{{loop.index0}}].dia.vipVariableName    {{ redistribute.nat_dia_variable | default("not_defined") }}    msg=nat dia variable
    Should Be Equal Value Json String    ${r_id.json()}    $..redistribute.vipValue[{{loop.index0}}].vipOptional    {{ redistribute.optional | default("not_defined") }}    msg=redistribute optional
    Should Be Equal Value Json String    ${r_id.json()}    $..redistribute.vipValue[{{loop.index0}}].protocol.vipValue    {{ redistribute.protocol | default("not_defined") }}    msg=protocol
    Should Be Equal Value Json String    ${r_id.json()}    $..redistribute.vipValue[{{loop.index0}}].protocol.vipVariableName    {{ redistribute.protocol_variable | default("not_defined") }}    msg=protocol variable
    Should Be Equal Value Json String    ${r_id.json()}    $..redistribute.vipValue[{{loop.index0}}]..["route-policy"].vipValue    {{ redistribute.route_policy | default("not_defined") }}    msg=route policy
    Should Be Equal Value Json String    ${r_id.json()}    $..redistribute.vipValue[{{loop.index0}}]..["route-policy"].vipVariableName    {{ redistribute.route_policy_variable | default("not_defined") }}    msg=route policy variable

{% endfor %}

{% endfor %}

{% endif %}
