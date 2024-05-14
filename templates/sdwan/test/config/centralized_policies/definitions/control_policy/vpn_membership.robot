*** Settings ***
Documentation   Verify VPN Membership
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    vpn_membership
Resource        ../../../../sdwan_common.resource

{% if sdwan.centralized_policies.definitions.control_policy.vpn_membership is defined %}

*** Test Cases ***
Get VPN Membership
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/vpnmembershipgroup
    Set Suite Variable    ${r}

{% for vpn_membership in sdwan.centralized_policies.definitions.control_policy.vpn_membership | default([]) %}
Verify Centralized Policies Control Policy VPN Membership {{ vpn_membership.name }}
    ${vpn_membership_id}=    Get Value From Json    ${r.json()}    $..data[?(@..name=="{{vpn_membership.name }}")].definitionId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/vpnmembershipgroup/${vpn_membership_id[0]}
    Set Suite Variable    ${r_id}
    Should Be Equal Value Json String    ${r_id.json()}    $..name    {{ vpn_membership.name }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $..description    {{ vpn_membership.description }}    msg=description

    ${group_items}=   Get Value From Json   ${r_id.json()}   $..sites
    ${res_groups_length}=    Get Length     ${group_items[0]}
    Should Be Equal As Integers    ${res_groups_length}    {{ vpn_membership.groups | length }}    msg=groups

{% for item in vpn_membership.groups %}
Verify Site List {{ item.site_list }} for {{ vpn_membership.name }}
    ${site_list_id}=    Get Value From Json    ${r_id.json()}    $..definition.sites[{{loop.index0}}].siteList
    ${site_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/site/${site_list_id[0]}
    Should Be Equal Value Json String    ${site_id.json()}    $..name    {{ item.site_list }}    msg=Site list {{ item.site_list }} with VPN membership {{ vpn_membership.name }}
{% endfor %}

{% for item in vpn_membership.groups %}
{% set test_list = [] %}
{% for item_vpn in item.vpn_lists %}
{% set _ = test_list.append(item_vpn) %}
{% endfor %}

    ${vpn_list_id}=    Get Value From Json    ${r_id.json()}    $..definition.sites[{{loop.index0}}].vpnList
    ${rec_vpn_list}=    Create List

    FOR    ${index}    IN    @{vpn_list_id[0]}
        ${vpn_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/list/vpn/${index}
        ${vpn_list_name}=    Get Value From Json    ${vpn_id.json()}    $..name
        Append To List    ${rec_vpn_list}    ${vpn_list_name[0]}
    END

    ${exp_vpn_list}=   Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal   ${rec_vpn_list}   ${exp_vpn_list}   ignore_order=True   msg=VPN list expexted ${exp_vpn_list} but received ${rec_vpn_list} with VPN membership {{ vpn_membership.name }}

{% endfor %}

{% endfor %}

{% endif %}
