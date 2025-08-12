*** Settings **
Documentation    Verify Router Policy Configuration
Suite Setup    Login SDWAN Manager
Suite Teardown    Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    localized_policies
Resource    ../../../sdwan_common.resource

{% if sdwan.localized_policies.definitions.route_policies is defined %}

*** Test Cases ***
Get Route Policy
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/vedgeroute
    Set Suite Variable    ${r}

{% for route_policy in sdwan.localized_policies.definitions.route_policies | default([]) %}

Verify Localized Policies Route Policy {{ route_policy.name }}
    ${route_policy_id}=   Get Value From Json   ${r.json()}   $..data[?(@..name=="{{ route_policy.name }}")].definitionId
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/definition/vedgeroute/${route_policy_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ route_policy.name }}    msg=name
    Should Be Equal Value Json Special_String    ${r_id.json()}    $..description    {{ route_policy.description | normalize_special_string }}    msg=description
    Should Be Equal Value Json String    ${r_id.json()}    $..defaultAction.type    {{ route_policy.default_action }}    msg=default action type

    Should Be Equal Value Json List Length    ${r_id.json()}    $.sequences    {{ route_policy.sequences | length }}    msg=sequences

{% for sequence in route_policy.sequences | default([]) %}

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].sequenceId    {{ sequence.id }}    msg=id
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].sequenceName    {{ sequence.name }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].sequenceIpType    {{ sequence.ip_type | default(defaults.sdwan.localized_policies.definitions.route_policies.sequences.ip_type) }}    msg=ip type
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].baseAction    {{ sequence.base_action }}    msg=base action

    ${as_path_id}=    Get Value From Json    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="asPath")].ref
    IF    ${as_path_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="asPath")].ref    {{ sequence.match_criterias.as_path_list | default("not_defined") }}    msg=as path list
    ELSE
        ${as_path_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/aspath/${as_path_id[0]}
        Should Be Equal Value Json String    ${as_path_match_id.json()}    $..name    {{ sequence.match_criterias.as_path_list | default("not_defined") }}    msg=as path list
    END

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="localPreference")].value    {{ sequence.match_criterias.bgp_local_preference }}    msg=bgp local preference

    ${expanded_c_id}=    Get Value From Json    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="expandedCommunity")].ref
    IF    ${expanded_c_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="expandedCommunity")].ref    {{ sequence.match_criterias.expanded_community_list | default("not_defined") }}    msg=expanded community list
    ELSE
        ${expanded_c_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/expandedcommunity/${expanded_c_id[0]}
        Should Be Equal Value Json String    ${expanded_c_match_id.json()}    $..name    {{ sequence.match_criterias.expanded_community_list | default("not_defined") }}    msg=expanded community list
    END
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="expandedCommunityInline")].vipVariableName    {{ sequence.match_criterias.expanded_community_list_variable | default("not_defined") }}    msg=expanded community list variable

    ${extended_c_id}=    Get Value From Json    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="extCommunity")].ref
    IF    ${extended_c_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="extCommunity")].ref    {{ sequence.match_criterias.extended_community_list | default("not_defined") }}    msg=extended community list
    ELSE
        ${extended_c_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/extcommunity/${extended_c_id[0]}
        Should Be Equal Value Json String    ${extended_c_match_id.json()}    $..name    {{ sequence.match_criterias.extended_community_list | default("not_defined") }}    msg=extended community list
    END

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="metric")].value    {{ sequence.match_criterias.metric }}    msg=metric

    ${next_hop_id}=    Get Value From Json    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="nextHop")].ref
    IF    ${next_hop_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="nextHop")].ref    {{ sequence.match_criterias.next_hop_prefix_list | default("not_defined") }}    msg=next hop prefix list
    ELSE
        ${next_hop_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/prefix/${next_hop_id[0]}
        Should Be Equal Value Json String    ${next_hop_match_id.json()}    $..name    {{ sequence.match_criterias.next_hop_prefix_list | default("not_defined") }}    msg=next hop prefix list
    END

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="ompTag")].value    {{ sequence.match_criterias.omp_tag }}    msg=omp tag
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="origin")].value    {{ sequence.match_criterias.origin }}    msg=origin
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="ospfTag")].value    {{ sequence.match_criterias.ospf_tag }}    msg=ospf tag
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="peer")].value    {{ sequence.match_criterias.peer }}    msg=peer

    ${prefix_list_id}=    Get Value From Json    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="address")].ref 
    IF    ${prefix_list_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="address")].ref    {{ sequence.match_criterias.prefix_list | default("not_defined") }}    msg=prefix list
    ELSE
        ${prefix_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/prefix/${prefix_list_id[0]}
        Should Be Equal Value Json String    ${prefix_list_match_id.json()}    $..name    {{ sequence.match_criterias.prefix_list | default("not_defined") }}    msg=prefix list
    END

    ${standard_c_list}=    Get Value From Json    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="advancedCommunity")].refs
    IF    ${standard_c_list} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="advancedCommunity")].refs    {{ sequence.match_criterias.standard_community_lists | default("not_defined") }}    msg=standard community list
    ELSE
        Should Be Equal Value Json List Length    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="advancedCommunity")].refs    {{ sequence.match_criterias.standard_community_lists | length }}    msg=standard community list
        ${exp_community_list}=    Create List    {{ sequence.match_criterias.standard_community_lists | join('   ') }}

        FOR    ${id}    IN    @{standard_c_list[0]}
            ${list}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/community/${id}
            ${c_name}=    Get Value From Json    ${list.json()}    $.name
            List Should Contain Value    ${exp_community_list}    ${c_name[0]}    msg=standard community lists
        END
    END

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].match.entries[?(@.field=="advancedCommunity")].matchFlag    {{ sequence.match_criterias.standard_community_lists_criteria }}    msg=standard community lists criteria

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="aggregator")].value.aggregator    {{ sequence.actions.aggregator }}    msg=aggregator
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="aggregator")].value.ipAddress    {{ sequence.actions.aggregator_ip }}    msg=aggregator ip
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="atomicAggregate")].value    {{ sequence.actions.atomic_aggregate | lower }}    msg=atomic aggregate

{% if sequence.actions.communities | default("not_defined") == 'not_defined' %}
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="community")].value    {{ sequence.actions.communities | default("not_defined") }}    msg=no communities defined
{% else %}
    ${com_list}=    Create List    {{ sequence.actions.communities | join('   ') }}
    ${community}=    Get Value From Json    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="community")].value
    ${rec_com_list}=    Split String    ${community[0]}
    Lists Should Be Equal    ${rec_com_list}    ${com_list}    ignore_order=True    msg=communities
{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="community")].vipVariableName    {{ sequence.actions.community_variable | default("not_defined") }}    msg=community variable

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="communityAdditive")].value    {{ sequence.actions.community_additive | lower }}    msg=community additive

{% if sequence.actions.exclude_as_paths | default("not_defined") == 'not_defined' %}
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="asPath")].value.exclude    {{ sequence.actions.exclude_as_paths | default("not_defined") }}    msg=no exclude as path defined
{% else %}
    ${exclude_as_path_list}=    Create List    {{ sequence.actions.exclude_as_paths | join('   ') }}
    ${path}=    Get Value From Json    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="asPath")].value.exclude
    ${rec_path}=    Split String    ${path[0]}
    Lists Should Be Equal    ${rec_path}    ${exclude_as_path_list}    ignore_order=True    msg=exclude as paths
{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="localPreference")].value    {{ sequence.actions.local_preference }}    msg=local preference
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="metric")].value    {{ sequence.actions.metric }}    msg=metric
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="metricType")].value    {{ sequence.actions.metric_type }}    msg=metric type
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="nextHop")].value    {{ sequence.actions.next_hop }}    msg=next hop
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="ompTag")].value     {{ sequence.actions.omp_tag }}    msg=omp tag
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="origin")].value     {{ sequence.actions.origin }}    msg=origin
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="originator")].value     {{ sequence.actions.originator }}    msg=originator
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="ospfTag")].value     {{ sequence.actions.ospf_tag }}    msg=ospf tag

{% if sequence.actions.prepend_as_paths | default("not_defined") == 'not_defined' %}
    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="asPath")].value.prepend    {{ sequence.actions.prepend_as_paths | default("not_defined") }}    msg=no prepend as path defined
{% else %}
    ${prepend_as_path_list}=    Create List    {{ sequence.actions.prepend_as_paths | join('   ') }}
    ${pre_path}=    Get Value From Json    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="asPath")].value.prepend
    ${rec_pre_path}=    Split String    ${pre_path[0]}
    Lists Should Be Equal    ${rec_pre_path}    ${prepend_as_path_list}    ignore_order=True    msg=prepend as paths
{% endif %}

    Should Be Equal Value Json String    ${r_id.json()}    $..sequences[{{loop.index0}}].actions[?(@.type=="set")].parameter[?(@.field=="weight")].value    {{ sequence.actions.weight }}    msg=weight

{% endfor %}

{% endfor %}

{% endif %}
