*** Settings ***
Documentation   Verify Custom Control Topology
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    custom_control_topology
Resource        ../../../../sdwan_common.resource

{% if sdwan.centralized_policies.definitions.control_policy.custom_control_topology is defined %}

*** Test Cases ***
Get Custom Control Topology
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/control
    Set Suite Variable    ${r}

{% for cct in sdwan.centralized_policies.definitions.control_policy.custom_control_topology | default([]) %}

Verify Centralized Policies Control Policy Custom Control Topology {{ cct.name }}
    ${cct_id}=   Get Value From Json   ${r.json()}   $..data[?(@..name=="{{ cct.name }}")].definitionId
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/definition/control/${cct_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ cct.name }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $..description    {{ cct.description }}    msg=description
    Should Be Equal Value Json String    ${r_id.json()}    $..defaultAction.type    {{ cct.default_action_type }}    msg=default action type

{% for sequence in cct.sequences | default([]) %}

{% if sequence.type == 'tloc' %}

    ${cct_seq_tloc}=   Get Value From Json   ${r_id.json()}   $..sequences[?(@.sequenceType=="tloc")]
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..baseAction    {{ sequence.base_action }}    msg=base action
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..sequenceId    {{ sequence.id }}    msg=id
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..sequenceName    {{ sequence.name }}    msg=name
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..sequenceIpType    {{ sequence.ip_type }}    msg=ip type
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..sequenceType    {{ sequence.type }}    msg=type
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="carrier")].value    {{ sequence.match_criterias.carrier | default("not_defined") }}    msg=carrier

    ${color_list_ref_id}=    Get Value From Json    ${cct_seq_tloc}    $..match.entries[?(@.field=="colorList")].ref
    IF    ${color_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="colorList")].ref    {{ sequence.match_criterias.color_list | default("not_defined") }}    msg=color list
    ELSE
        ${color_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/color/${color_list_ref_id[0]}
        Should Be Equal Value Json String    ${color_list_match_id.json()}    $..name    {{ sequence.match_criterias.color_list | default("not_defined") }}    msg=color list
    END

    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="domainId")].value    {{ sequence.match_criterias.domain_id | default("not_defined") }}    msg=domain id
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="groupId")].value    {{ sequence.match_criterias.group_id | default("not_defined") }}    msg=group id
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="ompTag")].value    {{ sequence.match_criterias.omp_tag | default("not_defined") }}    msg=omp tag
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="originator")].value    {{ sequence.match_criterias.originator | default("not_defined") }}    msg=originator
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="preference")].value    {{ sequence.match_criterias.preference | default("not_defined") }}    msg=preference

    ${site_list_ref_id}=    Get Value From Json    ${cct_seq_tloc}    $..match.entries[?(@.field=="siteList")].ref
    IF    ${site_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="siteList")].ref    {{ sequence.match_criterias.site_list | default("not_defined") }}    msg=site list
    ELSE
        ${site_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/site/${site_list_ref_id[0]}
        Should Be Equal Value Json String    ${site_list_match_id.json()}    $..name    {{ sequence.match_criterias.site_list | default("not_defined") }}    msg=site list
    END

    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="siteId")].value    {{ sequence.match_criterias.site_id | default("not_defined") }}    msg=site id

    ${region_list_ref_id}=    Get Value From Json    ${cct_seq_tloc}    $..match.entries[?(@.field=="regionList")].ref
    IF    ${region_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="regionList")].ref    {{ sequence.match_criterias.region_list | default("not_defined") }}    msg=region list
    ELSE
        ${region_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/region/${region_list_ref_id[0]}
        Should Be Equal Value Json String    ${region_list_match_id.json()}    $..name    {{ sequence.match_criterias.region_list | default("not_defined") }}    msg=region list
    END

    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="regionId")].value    {{ sequence.match_criterias.region_id | default("not_defined") }}    msg=region id

    ${tloc_list_ref_id}=    Get Value From Json    ${cct_seq_tloc}    $..match.entries[?(@.field=="tlocList")].ref
    IF    ${tloc_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="tlocList")].ref    {{ sequence.match_criterias.tloc_list | default("not_defined") }}    msg=tloc list
    ELSE
        ${tloc_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/tloc/${tloc_list_ref_id[0]}
        Should Be Equal Value Json String    ${tloc_list_match_id.json()}    $..name    {{ sequence.match_criterias.tloc_list | default("not_defined") }}    msg=tloc list
    END

    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="tloc")].value.ip    {{ sequence.match_criterias.tloc.ip | default("not_defined") }}    msg=tloc ip
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="tloc")].value.color    {{ sequence.match_criterias.tloc.color | default("not_defined") }}    msg=tloc color
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..match.entries[?(@.field=="tloc")].value.encap    {{ sequence.match_criterias.tloc.encap | default("not_defined") }}    msg=tloc encap
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..actions..parameter[?(@.field=="ompTag")].value   {{ sequence.actions.omp_tag | default("not_defined") }}    msg=tloc actions omp tag
    Should Be Equal Value Json String    ${cct_seq_tloc}    $..actions..parameter[?(@.field=="preference")].value    {{ sequence.actions.preference | default("not_defined") }}    msg=tloc actions preference

{% else %}

    ${cct_seq_route}=   Get Value From Json   ${r_id.json()}   $..sequences[?(@.sequenceType=="route")]
    Should Be Equal Value Json String    ${cct_seq_route}    $..baseAction    {{ sequence.base_action }}    msg=base action
    Should Be Equal Value Json String    ${cct_seq_route}    $..sequenceId    {{ sequence.id }}    msg=id
    Should Be Equal Value Json String    ${cct_seq_route}    $..sequenceName    {{ sequence.name }}    msg=name
    Should Be Equal Value Json String    ${cct_seq_route}    $..sequenceIpType    {{ sequence.ip_type }}    msg=ip type
    Should Be Equal Value Json String    ${cct_seq_route}    $..sequenceType    {{ sequence.type }}    msg=type

    ${color_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..match.entries[?(@.field=="colorList")].ref
    IF    ${color_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="colorList")].ref    {{ sequence.match_criterias.color_list | default("not_defined") }}    msg=color list
    ELSE
        ${color_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/color/${color_list_ref_id[0]}
        Should Be Equal Value Json String    ${color_list_match_id.json()}    $..name    {{ sequence.match_criterias.color_list | default("not_defined") }}    msg=color list
    END

    ${community_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..match.entries[?(@.field=="community")].ref
    IF    ${community_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="community")].ref    {{ sequence.match_criterias.community_list | default("not_defined") }}    msg=match criteria community list
    ELSE
        ${community_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/community/${community_list_ref_id[0]}
        Should Be Equal Value Json String    ${community_list_match_id.json()}    $..name    {{ sequence.match_criterias.community_list | default("not_defined") }}    msg=match criteria community list
    END

    ${expanded_community_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..match.entries[?(@.field=="expandedCommunity")].ref
    IF    ${expanded_community_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="expandedCommunity")].ref    {{ sequence.match_criterias.expanded_community_list | default("not_defined") }}    msg=expanded community list
    ELSE
        ${expanded_community_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/expandedcommunity/${expanded_community_list_ref_id[0]}
        Should Be Equal Value Json String    ${expanded_community_list_match_id.json()}    $..name    {{ sequence.match_criterias.expanded_community_list | default("not_defined") }}    msg=expanded community list
    END

    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="ompTag")].value    {{ sequence.match_criterias.omp_tag | default("not_defined") }}    msg=omp tag
    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="origin")].value    {{ sequence.match_criterias.origin | default("not_defined") }}    msg=origin
    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="originator")].value    {{ sequence.match_criterias.originator | default("not_defined") }}    msg=originator
    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="preference")].value    {{ sequence.match_criterias.preference | default("not_defined") }}    msg=preference

    ${site_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..match.entries[?(@.field=="siteList")].ref
    IF    ${site_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="siteList")].ref    {{ sequence.match_criterias.site_list | default("not_defined") }}    msg=site list
    ELSE
        ${site_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/site/${site_list_ref_id[0]}
        Should Be Equal Value Json String    ${site_list_match_id.json()}    $..name    {{ sequence.match_criterias.site_list | default("not_defined") }}    msg=site list
    END

    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="siteId")].value    {{ sequence.match_criterias.site_id | default("not_defined") }}    msg=site id

    ${region_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..match.entries[?(@.field=="regionList")].ref
    IF    ${region_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="regionList")].ref    {{ sequence.match_criterias.region_list | default("not_defined") }}    msg=region list
    ELSE
        ${region_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/region/${region_list_ref_id[0]}
        Should Be Equal Value Json String    ${region_list_match_id.json()}    $..name    {{ sequence.match_criterias.region_list | default("not_defined") }}    msg=region list
    END

    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="regionId")].value    {{ sequence.match_criterias.region_id | default("not_defined") }}    msg=region id
    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="pathType")].value    {{ sequence.match_criterias.path_type | default("not_defined") }}    msg=path type

    ${tloc_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..match.entries[?(@.field=="tlocList")].ref
    IF    ${tloc_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="tlocList")].ref    {{ sequence.match_criterias.tloc_list | default("not_defined") }}    msg=tloc list
    ELSE
        ${tloc_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/tloc/${tloc_list_ref_id[0]}
        Should Be Equal Value Json String    ${tloc_list_match_id.json()}    $..name    {{ sequence.match_criterias.tloc_list | default("not_defined") }}    msg=tloc list
    END

    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="tloc")].value.ip    {{ sequence.match_criterias.tloc.ip | default("not_defined") }}    msg=tloc ip
    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="tloc")].value.color    {{ sequence.match_criterias.tloc.color | default("not_defined") }}    msg=tloc color
    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="tloc")].value.encap    {{ sequence.match_criterias.tloc.encap | default("not_defined") }}    msg=tloc encap

    ${vpn_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..match.entries[?(@.field=="vpnList")].ref
    IF    ${vpn_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="vpnList")].ref    {{ sequence.match_criterias.vpn_list | default("not_defined") }}    msg=vpn list
    ELSE
        ${vpn_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/vpn/${vpn_list_ref_id[0]}
        Should Be Equal Value Json String    ${vpn_list_match_id.json()}    $..name    {{ sequence.match_criterias.vpn_list | default("not_defined") }}    msg=vpn list
    END

    Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="vpn")].value    {{ sequence.match_criterias.vpn | default("not_defined") }}    msg=vpn

    ${ipv4_prefix_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..match.entries[?(@.field=="prefixList")].ref
    IF    ${ipv4_prefix_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..match.entries[?(@.field=="prefixList")].ref    {{ sequence.match_criterias.ipv4_prefix_list | default("not_defined") }}    msg=ipv4 prefix list
    ELSE
        ${ipv4_prefix_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/prefix/${ipv4_prefix_list_ref_id[0]}
        Should Be Equal Value Json String    ${ipv4_prefix_list_match_id.json()}    $..name    {{ sequence.match_criterias.ipv4_prefix_list | default("not_defined") }}    msg=ipv4 prefix list
    END

    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="community")].value    {{ sequence.actions.community | default("not_defined") }}    msg=community
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="communityAdditive")].value    {{ sequence.actions.community_additive | default("not_defined") | lower }}    msg=community additive
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="ompTag")].value    {{ sequence.actions.omp_tag | default("not_defined") }}    msg=actions omp tag
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="preference")].value    {{ sequence.actions.preference | default("not_defined") }}    msg=actions preference
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="tloc")].value.ip    {{ sequence.actions.tloc.ip | default("not_defined") }}    msg=tloc ip
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="tloc")].value.color    {{ sequence.actions.tloc.color | default("not_defined") }}    msg=tloc color
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="tloc")].value.encap    {{ sequence.actions.tloc.encap | default("not_defined") }}    msg=tloc encap

    ${tloc_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="tlocList")].ref
    IF    ${tloc_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="tlocList")].ref    {{ sequence.actions.tloc_list | default("not_defined") }}    msg=tloc list
    ELSE
        ${tloc_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/tloc/${tloc_list_ref_id[0]}
        Should Be Equal Value Json String    ${tloc_list_match_id.json()}    $..name    {{ sequence.actions.tloc_list | default("not_defined") }}    msg=tloc list
    END

    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="tlocAction")].value   {{ sequence.actions.tloc_action | default("not_defined") }}    msg=tloc action
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="service")].value.type   {{ sequence.actions.service.type | default("not_defined") }}    msg=service type
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="service")].value.vpn   {{ sequence.actions.service.vpn | default("not_defined") }}    msg=service vpn
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="service")].value.tloc.ip    {{ sequence.actions.service.tloc.ip | default("not_defined") }}    msg=service tloc ip
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="service")].value.tloc.color   {{ sequence.actions.service.tloc.color | default("not_defined") }}    msg=service tloc color
    Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="service")].value.tloc.encap     {{ sequence.actions.service.tloc.encap | default("not_defined") }}    msg=service tloc encap

    ${tloc_list_ref_id}=    Get Value From Json    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="service")].value[?(@.field=="tlocList")].ref
    IF    ${tloc_list_ref_id} == []
        Should Be Equal Value Json String    ${cct_seq_route}    $..actions[?(@.type=="set")].parameter[?(@.field=="service")].value[?(@.field=="tlocList")].ref    {{ sequence.actions.service.tloc_list | default("not_defined") }}    msg=service tloc list
    ELSE
        ${tloc_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/tloc/${tloc_list_ref_id[0]}
        Should Be Equal Value Json String    ${tloc_list_match_id.json()}    $..name    {{ sequence.actions.service.tloc_list | default("not_defined") }}    msg=service tloc list
    END

    ${export_to_vpn_list_ref_id}=    Get Value From Json    ${r_id.json()}    $..actions[?(@.type=="exportTo")][?(@.field=="vpnList")].ref
    IF    ${export_to_vpn_list_ref_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..actions[?(@.type=="exportTo")][?(@.field=="vpnList")].ref    {{ sequence.actions.export_to_vpn_list | default("not_defined") }}    msg=export to vpn list
    ELSE
        ${export_to_vpn_list_match_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/vpn/${export_to_vpn_list_ref_id[0]}
        Should Be Equal Value Json String    ${export_to_vpn_list_match_id.json()}    $..name    {{ sequence.actions.export_to_vpn_list | default("not_defined") }}    msg=export to vpn list
    END

{% endif %}

{% endfor %}

{% endfor %}

{% endif %}
