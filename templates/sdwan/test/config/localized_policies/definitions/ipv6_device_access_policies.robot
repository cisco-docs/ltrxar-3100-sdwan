*** Settings ***
Documentation   Verify Device Access IPv6 ACL
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    localized_policies
Resource        ../../../sdwan_common.resource

{% if sdwan.localized_policies.definitions.ipv6_device_access_policies is defined %}

*** Test Cases ***
Get Device Access IPv6 ACL
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/deviceaccesspolicyv6
    Set Suite Variable    ${r}

{% for ipv6_device in sdwan.localized_policies.definitions.ipv6_device_access_policies | default([]) %}

Verify Localized Policies Device Access IPv6 ACL {{ ipv6_device.name }}
    ${def_id}=    Get Value From Json    ${r.json()}    $..data[?(@.name=="{{ipv6_device.name }}")].definitionId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/deviceaccesspolicyv6/${def_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $.name    {{ ipv6_device.name }}    msg=name
    Should Be Equal Value Json Special_String    ${r_id.json()}    $.description    {{ ipv6_device.description | normalize_special_string }}    msg=description
    Should Be Equal Value Json String    ${r_id.json()}    $.defaultAction.type    {{ ipv6_device.default_action }}     msg=default action

    ${sequence_items}=    Get Value From Json    ${r_id.json()}    $.sequences
    ${sequence_length}=    Get Length    ${sequence_items[0]}
    Should Be Equal As Integers    ${sequence_length}    {{ ipv6_device.sequences | length }}    msg=sequences

{% for sequence_index in range(ipv6_device.sequences | default([]) | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].sequenceId    {{ ipv6_device.sequences[sequence_index].id }}    msg=id
    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].sequenceName    {{ ipv6_device.sequences[sequence_index].name | default("Device Access Control List") }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].baseAction    {{ ipv6_device.sequences[sequence_index].base_action }}    msg=base action
    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].actions[?(@.type=="count")].parameter    {{ ipv6_device.sequences[sequence_index].counter_name | default("not_defined") }}    msg=counter name

    ${dst_data_prefix_id}=    Get Value From Json    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="destinationDataIpv6PrefixList")].ref
    IF    ${dst_data_prefix_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="destinationDataIpv6PrefixList")].ref    {{ ipv6_device.sequences[sequence_index].match_criterias.destination_data_prefix_list | default("not_defined") }}    msg=destination data prefix list
    ELSE
        ${dst_data_prefix_details}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/dataipv6prefix/${dst_data_prefix_id[0]}
        Should Be Equal Value Json String    ${dst_data_prefix_details.json()}    $.name    {{ ipv6_device.sequences[sequence_index].match_criterias.destination_data_prefix_list | default("not_defined") }}    msg=destination data prefix list
    END

    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="destinationIpv6")].value    {{ ipv6_device.sequences[sequence_index].match_criterias.destination_ip_prefix | default("not_defined") }}    msg=destination ip prefix
    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="destinationPort")].value    {{ ipv6_device.sequences[sequence_index].match_criterias.destination_port }}    msg=destination port

    ${src_data_prefix_id}=    Get Value From Json    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourceDataIpv6PrefixList")].ref
    IF    ${src_data_prefix_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourceDataIpv6PrefixList")].ref    {{ ipv6_device.sequences[sequence_index].match_criterias.source_data_prefix_list | default("not_defined") }}    msg=source data prefix list
    ELSE
        ${src_data_prefix_details}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/dataipv6prefix/${src_data_prefix_id[0]}
        Should Be Equal Value Json String    ${src_data_prefix_details.json()}    $.name    {{ ipv6_device.sequences[sequence_index].match_criterias.source_data_prefix_list | default("not_defined") }}    msg=source data prefix list
    END

    Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourceIpv6")].value    {{ ipv6_device.sequences[sequence_index].match_criterias.source_ip_prefix | default("not_defined") }}    msg=source ip prefix

{% set test_list = [] %}
{% for item in ipv6_device.sequences[sequence_index].match_criterias.source_ports | default("not_defined") %}
{% set _ = test_list.append(item) %}
{% endfor %}

    ${exp_src_port}=    Create List    {{ test_list | join('   ') }}
    ${rec_src_port}=    Get Value From Json    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourcePort")].value
    IF    ${rec_src_port} == []
        Should Be Equal Value Json String    ${r_id.json()}    $.sequences[{{ sequence_index }}].match.entries[?(@.field=="sourcePort")].value    {{ ipv6_device.sequences[sequence_index].match_criterias.source_ports | default("not_defined") }}    msg=source ports
    ELSE
        ${rec_src_port}=    Split string    ${rec_src_port[0]}
        Lists Should Be Equal    ${rec_src_port}    ${exp_src_port}    ignore_order=True    msg=source ports
    END

{% endfor %}

{% endfor %}

{% endif %}
