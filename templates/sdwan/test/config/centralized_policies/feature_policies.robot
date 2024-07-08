*** Settings ***
Documentation   Verify Feature Policies
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process   Logout SDWAN Manager
Default Tags    sdwan    config    feature_policies
Resource        ../../sdwan_common.resource

{% if sdwan.centralized_policies.feature_policies is defined%}

*** Test Cases ***
Get Feature Policies
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/policy/vsmart
    Set Suite Variable    ${r}

{% for fp in sdwan.centralized_policies.feature_policies | default([]) %}

Verify Centralized Policies Feature Policies {{ fp.name }}
    ${fp_id}=    Get Value From Json    ${r.json()}    $..data[?(@.policyName=="{{ fp.name }}")].policyId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/vsmart/definition/${fp_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $..policyName    {{ fp.name }}    msg=name
    Should Be Equal Value Json String    ${r_id.json()}    $..policyDescription    {{ fp.description }}     msg=description

    ${hs_ids_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="hubAndSpoke")].definitionId
    ${hs_ids_length}=    Get Length    ${hs_ids_list}
    Should Be Equal As Integers    ${hs_ids_length}    {{ fp.hub_and_spoke_topology | default([]) | length }}    msg=hub and spoke topology length

{% for hs_index in range(fp.hub_and_spoke_topology | default([]) | length()) %}

    ${hs_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/hubandspoke/${hs_ids_list[{{ hs_index }}]}
    Should Be Equal Value Json String    ${hs_id.json()}    $..name    {{ fp.hub_and_spoke_topology[hs_index].policy_definition }}    msg=hub and spoke topology name

{% endfor %}

    ${mesh_ids_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="mesh")].definitionId
    ${mesh_ids_length}=    Get Length    ${mesh_ids_list}
    Should Be Equal As Integers    ${mesh_ids_length}    {{ fp.mesh_topology | default([]) | length }}    msg=mesh topology length

{% for mesh_index in range(fp.mesh_topology | default([]) | length()) %}

    ${mesh_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/mesh/${mesh_ids_list[{{ mesh_index }}]}
    Should Be Equal Value Json String    ${mesh_id.json()}    $..name    {{ fp.mesh_topology[mesh_index].policy_definition }}    msg=mesh topology name

{% endfor %}

    ${cct_ids_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].definitionId
    ${cct_ids_length}=    Get Length    ${cct_ids_list}
    Should Be Equal As Integers    ${cct_ids_length}    {{ fp.custom_control_topology | default([]) | length }}    msg=custom control topology length

{% for cct_index in range(fp.custom_control_topology | default([]) | length()) %}

    ${cct_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/control/${cct_ids_list[{{ cct_index }}]}
    Should Be Equal Value Json String    ${cct_id.json()}    $..name    {{ fp.custom_control_topology[cct_index].policy_definition }}    msg=custom control topology name

    ${cct_sl_in_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="in")].siteLists
    ${exp_site_in_list}=    Create List    {{ fp.custom_control_topology[cct_index].site_region.site_lists_in | default([]) | join('   ') }}
    IF    ${cct_sl_in_list} == []
        Should Be Equal Value Json List    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="in")].siteLists    ${exp_site_in_list}    msg=custom control topology site lists in
    ELSE
        ${cct_sl_in_ids_length}=    Get Length    ${cct_sl_in_list[0]}
        Should Be Equal As Integers    ${cct_sl_in_ids_length}    {{ fp.custom_control_topology[cct_index].site_region.site_lists_in | default([]) | length }}    msg=custom control topology site lists in length

        ${temp_res_sl_in_list}=    Create List
        FOR    ${id}    IN    @{cct_sl_in_list[0]}
            ${site_list_in_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/site/${id}
            ${site_in_name}=    Get Value From Json    ${site_list_in_id.json()}    $.name
            Append To List    ${temp_res_sl_in_list}    ${site_in_name[0]}
        END
        Lists Should Be Equal    ${temp_res_sl_in_list}    ${exp_site_in_list}    ignore_order=True    msg=custom control topology site lists in name
    END

    ${cct_sl_out_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="out")].siteLists
    ${exp_site_out_list}=    Create List    {{ fp.custom_control_topology[cct_index].site_region.site_lists_out | default([]) | join('   ') }}
    IF    ${cct_sl_out_list} == []
        Should Be Equal Value Json List    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="out")].siteLists    ${exp_site_out_list}    msg=custom control topology site lists out
    ELSE
        ${cct_sl_out_ids_length}=    Get Length    ${cct_sl_out_list[0]}
        Should Be Equal As Integers    ${cct_sl_out_ids_length}    {{ fp.custom_control_topology[cct_index].site_region.site_lists_out | default([]) | length }}    msg=custom control topology site lists out length

        ${temp_res_sl_out_list}=    Create List
        FOR    ${id}    IN    @{cct_sl_out_list[0]}
            ${site_list_out_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/site/${id}
            ${site_out_name}=    Get Value From Json    ${site_list_out_id.json()}    $.name
            Append To List    ${temp_res_sl_out_list}    ${site_out_name[0]}
        END
        Lists Should Be Equal    ${temp_res_sl_out_list}    ${exp_site_out_list}    ignore_order=True    msg=custom control topology site lists out name
    END

    ${cct_rl_in_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="in")].regionLists
    ${exp_region_in_list}=    Create List    {{ fp.custom_control_topology[cct_index].site_region.region_lists_in | default([]) | join('   ') }}
    IF    ${cct_rl_in_list} == []
        Should Be Equal Value Json List    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="in")].regionLists    ${exp_region_in_list}    msg=custom control topology region lists in
    ELSE
        ${cct_rl_in_ids_length}=    Get Length    ${cct_rl_in_list[0]}
        Should Be Equal As Integers    ${cct_rl_in_ids_length}    {{ fp.custom_control_topology[cct_index].site_region.region_lists_in | default([]) | length }}    msg=custom control topology region lists in length

        ${temp_res_rl_in_list}=    Create List
        FOR    ${id}    IN    @{cct_rl_in_list[0]}
            ${rl_in_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/region/${id}
            ${rl_in_name}=    Get Value From Json    ${rl_in_id.json()}    $.name
            Append To List    ${temp_res_rl_in_list}    ${rl_in_name[0]}
        END
        Lists Should Be Equal    ${temp_res_rl_in_list}    ${exp_region_in_list}    ignore_order=True    msg=custom control topology region lists in name
    END

    ${cct_rl_out_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="out")].regionLists
    ${exp_region_out_list}=    Create List    {{ fp.custom_control_topology[cct_index].site_region.region_lists_out | default([]) | join('   ') }}
    IF    ${cct_rl_out_list} == []
        Should Be Equal Value Json List    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="out")].regionLists    ${exp_region_out_list}    msg=custom control topology region lists out
    ELSE
        ${cct_rl_out_ids_length}=    Get Length    ${cct_rl_out_list[0]}
        Should Be Equal As Integers    ${cct_rl_out_ids_length}    {{ fp.custom_control_topology[cct_index].site_region.region_lists_out | default([]) | length }}    msg=custom control topology region lists out length

        ${temp_res_rl_out_list}=    Create List
        FOR    ${id}    IN    @{cct_rl_out_list[0]}
            ${rl_out_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/region/${id}
            ${rl_out_name}=    Get Value From Json    ${rl_out_id.json()}    $.name
            Append To List    ${temp_res_rl_out_list}    ${rl_out_name[0]}
        END
        Lists Should Be Equal    ${temp_res_rl_out_list}    ${exp_region_out_list}    ignore_order=True    msg=custom control topology region lists out name
    END

    Should Be Equal Value Json String    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="in")].regionIds[0]    {{ fp.custom_control_topology[cct_index].site_region.region_in | default("not_defined") }}    msg=custom control topology region in
    Should Be Equal Value Json String    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="control")].entries[?(@.direction=="out")].regionIds[0]    {{ fp.custom_control_topology[cct_index].site_region.region_out | default("not_defined") }}    msg=custom control topology region out

{% endfor %}

    ${vpn_ids_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="vpnMembershipGroup")].definitionId
    ${vpn_ids_length}=    Get Length    ${vpn_ids_list}
    Should Be Equal As Integers    ${vpn_ids_length}    {{ fp.vpn_membership | default([]) | length }}    msg=vpn membership length

{% for vpn_index in range(fp.vpn_membership | default([]) | length()) %}

    ${vpn_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/vpnmembershipgroup/${vpn_ids_list[{{ vpn_index }}]}
    Should Be Equal Value Json String    ${vpn_id.json()}    $..name    {{ fp.vpn_membership[vpn_index].policy_definition }}    msg=vpn membership name

{% endfor %}

    ${app_ids_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="appRoute")].definitionId
    ${app_ids_length}=    Get Length    ${app_ids_list}
    Should Be Equal As Integers    ${app_ids_length}    {{ fp.application_aware_routing | default([]) | length }}    msg=application aware routing length

{% for app_index in range(fp.application_aware_routing | default([]) | length()) %}

    ${app_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/approute/${app_ids_list[{{ app_index }}]}
    Should Be Equal Value Json String    ${app_id.json()}    $..name    {{ fp.application_aware_routing[app_index].policy_definition }}    msg=application aware routing name

    ${aar_sl_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="appRoute")].entries..siteLists
    ${exp_site_list}=    Create List    {{ fp.application_aware_routing[app_index].site_region_vpn.site_lists | default([]) | join('   ') }}
    IF    ${aar_sl_list} == []
        Should Be Equal Value Json List    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="appRoute")].entries..siteLists    ${exp_site_list}    msg=application aware routing site lists
    ELSE
        ${aar_sl_ids_length}=    Get Length    ${aar_sl_list[0]}
        Should Be Equal As Integers    ${aar_sl_ids_length}    {{ fp.application_aware_routing[app_index].site_region_vpn.site_lists | default([]) | length }}    msg=application aware routing site lists length

        ${temp_res_site_list}=    Create List
        FOR    ${id}    IN    @{aar_sl_list[0]}
            ${sl_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/site/${id}
            ${sl_name}=    Get Value From Json    ${sl_id.json()}    $.name
            Append To List    ${temp_res_site_list}    ${sl_name[0]}
        END
        Lists Should Be Equal    ${temp_res_site_list}    ${exp_site_list}    ignore_order=True    msg=application aware routing site lists name
    END

    ${aar_rl_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="appRoute")].entries..regionLists[0]
    IF    ${aar_rl_list} == []
        Should Be Equal Value Json String    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="appRoute")].entries..regionLists    {{ fp.application_aware_routing[app_index].site_region_vpn.region_list | default("not_defined") }}    msg=application aware routing region lists
    ELSE
        ${rl_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/region/${aar_rl_list[0]}
        Should Be Equal Value Json String    ${rl_id.json()}    $.name    {{ fp.application_aware_routing[app_index].site_region_vpn.region_list | default("not_defined") }}    msg=application aware routing region lists name
    END

    Should Be Equal Value Json String    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="appRoute")].entries..regionIds[0]    {{ fp.application_aware_routing[app_index].site_region_vpn.region | default("not_defined") }}    msg=application aware routing region

    ${aar_vl_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="appRoute")].entries..vpnLists
    ${exp_vpn_list}=    Create List    {{ fp.application_aware_routing[app_index].site_region_vpn.vpn_lists | default([]) | join('   ') }}
    IF    ${aar_vl_list} == []
        Should Be Equal Value Json List    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="appRoute")].entries..vpnLists    ${exp_vpn_list}    msg=application aware routing vpn lists
    ELSE
        ${aar_vl_ids_length}=    Get Length    ${aar_vl_list[0]}
        Should Be Equal As Integers    ${aar_vl_ids_length}    {{ fp.application_aware_routing[app_index].site_region_vpn.vpn_lists | default([]) | length }}    msg=application aware routing vpn lists length

        ${temp_res_vpn_list}=    Create List
        FOR    ${id}    IN    @{aar_vl_list[0]}
            ${vl_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/vpn/${id}
            ${vl_name}=    Get Value From Json    ${vl_id.json()}    $.name
            Append To List    ${temp_res_vpn_list}    ${vl_name[0]}
        END
        Lists Should Be Equal    ${temp_res_vpn_list}    ${exp_vpn_list}    ignore_order=True    msg=application aware routing vpn lists name
    END

{% endfor %}

    ${td_ids_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="data")].definitionId
    ${td_ids_length}=    Get Length    ${td_ids_list}
    Should Be Equal As Integers    ${td_ids_length}    {{ fp.traffic_data | default([]) | length }}    msg=traffic data length

    ${td_dict}=    Create Dictionary
{% for tdt_index in range(fp.traffic_data | default([]) | length()) %}

    ${td_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/data/${td_ids_list[{{ tdt_index }}]}
    ${td_name}=    Get Value From Json    ${td_id.json()}    $..name
    ${td_dict}[${td_name[0]}]=    Set Variable    ${td_ids_list[{{ tdt_index }}]}

{% endfor %}

{% for td_index in range(fp.traffic_data | default([]) | length()) %}

    ${td_dt_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/data/${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}
    Should Be Equal Value Json String    ${td_dt_id.json()}    $..name    {{ fp.traffic_data[td_index].policy_definition }}    msg=traffic data name

    Should Be Equal Value Json List Length    ${r_id.json()}    $.policyDefinition.assembly[?(@.definitionId=="${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}")].entries    {{ fp.traffic_data[td_index].site_region_vpn | default([]) | length }}    msg=traffic data site region vpn length

{% set sort_site_region_vpn = fp.traffic_data[td_index]['site_region_vpn'] | default([]) | sort(attribute='direction') %}
{% for td_sr_index in range(sort_site_region_vpn | length()) %}

    Should Be Equal Value Json String    ${r_id.json()}    $.policyDefinition.assembly[?(@.definitionId=="${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}")].entries[{{ td_sr_index }}].direction    {{ sort_site_region_vpn[td_sr_index].direction }}    msg=traffic data direction

    ${td_sl_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.definitionId=="${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}")].entries[{{ td_sr_index }}].siteLists
    ${exp_td_site_list}=    Create List    {{ sort_site_region_vpn[td_sr_index].site_lists | default([]) | join('   ') }}
    IF    ${td_sl_list} == []
        Should Be Equal Value Json List    ${r_id.json()}    $.policyDefinition.assembly[?(@.definitionId=="${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}")].entries[{{ td_sr_index }}].siteLists    ${exp_td_site_list}    msg=traffic data site lists
    ELSE
        ${td_sl_ids_length}=    Get Length    ${td_sl_list[0]}
        Should Be Equal As Integers    ${td_sl_ids_length}    {{ sort_site_region_vpn[td_sr_index].site_lists | default([]) | length }}    msg=traffic data site lists length

        ${temp_td_sl_list}=    Create List
        FOR    ${id}    IN    @{td_sl_list[0]}
            ${td_sl_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/site/${id}
            ${td_sl_name}=    Get Value From Json    ${td_sl_id.json()}    $.name
            Append To List    ${temp_td_sl_list}    ${td_sl_name[0]}
        END
        Lists Should Be Equal    ${temp_td_sl_list}    ${exp_td_site_list}    ignore_order=True    msg=traffic data sv site lists name
    END

    ${td_rl_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.definitionId=="${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}")].entries[{{ td_sr_index }}].regionLists[0]
    IF    ${td_rl_list} == []
        Should Be Equal Value Json String    ${r_id.json()}    $.policyDefinition.assembly[?(@.definitionId=="${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}")].entries[{{ td_sr_index }}].regionLists    {{ sort_site_region_vpn[td_sr_index].region_list | default("not_defined") }}    msg=traffic data region lists
    ELSE
        ${td_rl_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/region/${td_rl_list[0]}
        Should Be Equal Value Json String    ${td_rl_id.json()}    $.name    {{ sort_site_region_vpn[td_sr_index].region_list | default("not_defined") }}    msg=traffic data region lists name
    END

    Should Be Equal Value Json String    ${r_id.json()}    $.policyDefinition.assembly[?(@.definitionId=="${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}")].entries[{{ td_sr_index }}].regionIds[0]    {{ sort_site_region_vpn[td_sr_index].region | default("not_defined") }}    msg=traffic data region

    ${td_vl_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.definitionId=="${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}")].entries[{{ td_sr_index }}].vpnLists
    ${exp_td_vpn_list}=    Create List    {{ sort_site_region_vpn[td_sr_index].vpn_lists | default([]) | join('   ') }}
    IF    ${td_vl_list} == []
        Should Be Equal Value Json List    ${r_id.json()}    $.policyDefinition.assembly[?(@.definitionId=="${td_dict["{{ fp.traffic_data[td_index].policy_definition }}"]}")].entries[{{ td_sr_index }}].vpnLists    ${exp_td_vpn_list}    msg=traffic data vpn lists
    ELSE
        ${td_vl_ids_length}=    Get Length    ${td_vl_list[0]}
        Should Be Equal As Integers    ${td_vl_ids_length}    {{ sort_site_region_vpn[td_sr_index].vpn_lists | default([]) | length }}    msg=traffic data vpn lists length

        ${temp_td_vl_list}=    Create List
        FOR    ${id}    IN    @{td_vl_list[0]}
            ${td_vl_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/vpn/${id}
            ${td_vl_name}=    Get Value From Json    ${td_vl_id.json()}    $.name
            Append To List    ${temp_td_vl_list}    ${td_vl_name[0]}
        END
        Lists Should Be Equal    ${temp_td_vl_list}    ${exp_td_vpn_list}    ignore_order=True    msg=traffic data vpn lists name
    END

{% endfor %}

{% endfor %}

    ${cflowd_ids_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="cflowd")].definitionId
    ${cflowd_ids_length}=    Get Length    ${cflowd_ids_list}
    Should Be Equal As Integers    ${cflowd_ids_length}    {{ fp.cflowd | default([]) | length }}    msg=cflowd length

{% for cflowd_index in range(fp.cflowd | default([]) | length()) %}

    ${cflowd_id}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/cflowd/${cflowd_ids_list[{{ cflowd_index }}]}
    Should Be Equal Value Json String    ${cflowd_id.json()}    $..name    {{ fp.cflowd[cflowd_index].policy_definition }}    msg=cflowd name

    ${cflowd_sl_list}=    Get Value From Json    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="cflowd")].entries..siteLists
    ${exp_cflowd_site_list}=    Create List    {{ fp.cflowd[cflowd_index].site_lists | default([]) | join('   ') }}
    IF    ${cflowd_sl_list} == []
        Should Be Equal Value Json List    ${r_id.json()}    $.policyDefinition.assembly[?(@.type=="cflowd")].entries..siteLists    ${exp_cflowd_site_list}    msg=cflowd site lists
    ELSE
        ${cflowd_sl_ids_length}=    Get Length    ${cflowd_sl_list[0]}
        Should Be Equal As Integers    ${cflowd_sl_ids_length}    {{ fp.cflowd[cflowd_index].site_lists | default([]) | length }}    msg=cflowd site lists length

        ${temp_cflowd_site_list}=    Create List
        FOR    ${id}    IN    @{cflowd_sl_list[0]}
            ${cflowd_sl_id}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/site/${id}
            ${cflowd_sl_name}=    Get Value From Json    ${cflowd_sl_id.json()}    $.name
            Append To List    ${temp_cflowd_site_list}    ${cflowd_sl_name[0]}
        END
        Lists Should Be Equal    ${temp_cflowd_site_list}    ${exp_cflowd_site_list}    ignore_order=True    msg=cflowd site lists name
    END

{% endfor %}

{% endfor %}

{% endif %}
