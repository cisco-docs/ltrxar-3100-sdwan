*** Settings ***
Documentation   Verify Device Access IPv4 ACL
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    ipv4_device_access_policies
Resource        ../../../sdwan_common.resource

{% if sdwan.localized_policies.definitions.ipv4_device_access_policies is defined %}

*** Test Cases ***
Get Device Access IPv4 ACL
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/deviceaccesspolicy
    Set Suite Variable    ${r}

{% for ipv4_device in sdwan.localized_policies.definitions.ipv4_device_access_policies | default([]) %}

Verify Localized Policies Device Access IPv4 ACL {{ ipv4_device.name }}
    ${def_id}=    Get Value From Json    ${r.json()}    $..data[?(@.name=="{{ipv4_device.name }}")].definitionId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/deviceaccesspolicy/${def_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $.name    {{ ipv4_device.name }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $.description    {{ ipv4_device.description }}    msg=description
    Should Be Equal Value Json String    ${r_id.json()}    $.defaultAction.type    {{ ipv4_device.default_action }}    msg=default action

    ${sequence_items}=    Get Value From Json    ${r_id.json()}    $.sequences
    ${sequence_length}=    Get Length    ${sequence_items[0]}
    Should Be Equal As Integers    ${sequence_length}    {{ ipv4_device.sequences | length }}    msg=sequences

{% for sequence_index in range(ipv4_device.sequences | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].sequenceId    {{ ipv4_device.sequences[sequence_index].id }}    msg=id
    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].sequenceName    {{ ipv4_device.sequences[sequence_index].name | default("Device Access Control List") }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].baseAction    {{ ipv4_device.sequences[sequence_index].base_action }}    msg=base action
    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].actions[?(@.type=="count")].parameter    {{ ipv4_device.sequences[sequence_index].counter_name | default("not_defined") }}    msg=counter name

    ${dst_data_prefix_id}=    Get Value From Json    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="destinationDataPrefixList")].ref
    IF    ${dst_data_prefix_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="destinationDataPrefixList")].ref    {{ ipv4_device.sequences[sequence_index].match_criterias.destination_data_prefix_list | default("not_defined") }}    msg=destination data prefix list
    ELSE
        ${dst_data_prefix_details}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/dataprefix/${dst_data_prefix_id[0]}
        Should Be Equal Value Json String    ${dst_data_prefix_details.json()}    $.name    {{ ipv4_device.sequences[sequence_index].match_criterias.destination_data_prefix_list | default("not_defined") }}    msg=destination data prefix list
    END

    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="destinationIp")].value    {{ ipv4_device.sequences[sequence_index].match_criterias.destination_ip_prefix | default("not_defined") }}    msg=destination ip prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="destinationPort")].value    {{ ipv4_device.sequences[sequence_index].match_criterias.destination_port }}    msg=destination port

    ${src_data_prefix_id}=    Get Value From Json    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourceDataPrefixList")].ref
    IF    ${src_data_prefix_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourceDataPrefixList")].ref    {{ ipv4_device.sequences[sequence_index].match_criterias.source_data_prefix_list | default("not_defined") }}    msg=source data prefix list
    ELSE
        ${src_data_prefix_details}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/dataprefix/${src_data_prefix_id[0]}
        Should Be Equal Value Json String    ${src_data_prefix_details.json()}    $.name    {{ ipv4_device.sequences[sequence_index].match_criterias.source_data_prefix_list | default("not_defined") }}    msg=source data prefix list
    END

    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourceIp")].value    {{ ipv4_device.sequences[sequence_index].match_criterias.source_ip_prefix | default("not_defined") }}    msg=source ip prefix

{% set test_list = [] %}
{% for item in ipv4_device.sequences[sequence_index].match_criterias.source_ports | default("not_defined") %}
{% set _ = test_list.append(item) %}
{% endfor %}

    ${exp_src_port}=    Create List    {{ test_list | join('   ') }}
    ${rec_src_port}=    Get Value From Json    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourcePort")].value
    IF    ${rec_src_port} == []
        Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourcePort")].value    {{ ipv4_device.sequences[sequence_index].match_criterias.source_ports | default("not_defined") }}    msg=source ports
    ELSE
        ${rec_src_port}=    Split string    ${rec_src_port[0]}
        Lists Should Be Equal    ${rec_src_port}    ${exp_src_port}    ignore_order=True    msg=source ports
    END

{% endfor %}

{% endfor %}

{% endif %}
