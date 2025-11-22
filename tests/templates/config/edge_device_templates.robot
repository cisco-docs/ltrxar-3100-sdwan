*** Settings ***
Documentation   Verify Device Templates
Suite Setup     Login SDWAN Manager
Default Tags    sdwan   config   edge_device_templates
Resource        ../sdwan_common.resource

{% if sdwan.edge_device_templates is defined%}

*** Test Cases ***
Get Edge Device template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/device
    Set Suite Variable    ${r}

{% for edt in sdwan.edge_device_templates | default([]) %}

Verify Edge Device Templates {{ edt.name }}
    ${template_id}=    Get Value From Json    ${r.json()}    $..data[?(@.templateName=="{{ edt.name }}")].templateId
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/device/object/${template_id[0]}
    Should Be Equal Value Json String    ${r_id.json()}    $..templateName    {{ edt.name }}    msg=name
    Should Be Equal Value Json Special_String    ${r_id.json()}    $..templateDescription    {{ edt.description | normalize_special_string }}    msg=description

{% set device_model = "vedge-" ~ edt.device_model %}
    Should Be Equal Value Json String    ${r_id.json()}    $..deviceType    {{ device_model }}    msg=device model

    ${templates_id}=   GET On Session   sdwan_manager   /dataservice/template/feature
    Set Suite Variable    ${templates_id}

    ${system_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_system")].templateId
    Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${system_temp_id[0]}")].templateName    {{ edt.system_template }}    msg=system template

    ${logging_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_system")].subTemplates[?(@.templateType=="cisco_logging")].templateId
    Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${logging_temp_id[0]}")].templateName    {{ edt.logging_template }}    msg=logging template

    ${ntp_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_system")].subTemplates[?(@.templateType=="cisco_ntp")].templateId
    IF    ${ntp_temp_id} == []
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${ntp_temp_id}")].templateName    {{ edt.ntp_template | default("not_defined") }}    msg=ntp template
    ELSE
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${ntp_temp_id[0]}")].templateName    {{ edt.ntp_template | default("not_defined") }}    msg=ntp template
    END

    ${aaa_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cedge_aaa")].templateId
    IF    ${aaa_temp_id} == []
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${aaa_temp_id}")].templateName    {{ edt.aaa_template | default("not_defined") }}    msg=aaa template
    ELSE
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${aaa_temp_id[0]}")].templateName    {{ edt.aaa_template | default("not_defined") }}    msg=aaa template
    END

    ${bfd_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_bfd")].templateId
    Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${bfd_temp_id[0]}")].templateName    {{ edt.bfd_template }}    msg=bfd template

    ${omp_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_omp")].templateId
    Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${omp_temp_id[0]}")].templateName    {{ edt.omp_template }}    msg=omp template

    ${security_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_security")].templateId
    Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${security_temp_id[0]}")].templateName    {{ edt.security_template }}    msg=security template

    ${global_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cedge_global")].templateId
    Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${global_temp_id[0]}")].templateName    {{ edt.global_settings_template }}    msg=global settings template

    ${banner_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_banner")].templateId
    IF    ${banner_temp_id} == []
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${banner_temp_id}")].templateName    {{ edt.banner_template | default("not_defined") }}    msg=banner template
    ELSE
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${banner_temp_id[0]}")].templateName    {{ edt.banner_template | default("not_defined") }}    msg=banner template
    END

    ${snmp_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_snmp")].templateId
    IF    ${snmp_temp_id} == []
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${snmp_temp_id}")].templateName    {{ edt.snmp_template | default("not_defined") }}    msg=snmp template
    ELSE
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${snmp_temp_id[0]}")].templateName    {{ edt.snmp_template | default("not_defined") }}    msg=snmp template
    END

    ${cli_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cli-template")].templateId
    IF    ${cli_temp_id} == []
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${cli_temp_id}")].templateName    {{ edt.cli_template | default("not_defined") }}    msg=cli template
    ELSE
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${cli_temp_id[0]}")].templateName    {{ edt.cli_template | default("not_defined") }}    msg=cli template
    END

    ${lp_policy_id}=    Get Value From Json    ${r_id.json()}    $..policyId
    IF    ${lp_policy_id} == [] or ${lp_policy_id} == ['']
        Should Be Equal Value Json String    ${r_id.json()}    $..policyId    {{ edt.localized_policy }}    msg=localized policy
    ELSE
        ${localized_policies}=   GET On Session   sdwan_manager   /dataservice/template/policy/vedge/definition/${lp_policy_id[0]}
        Should Be Equal Value Json String    ${localized_policies.json()}    $..policyName    {{ edt.localized_policy | default("not_defined") }}    msg=localized policy
    END

    ${sp_policy_id}=    Get Value From Json    ${r_id.json()}    $..securityPolicyId
    IF    ${sp_policy_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..securityPolicyId    {{ edt.security_policy.name | default("not_defined") }}    msg=security policy
    ELSE
        ${security_policies}=   GET On Session   sdwan_manager   /dataservice/template/policy/security/definition/${sp_policy_id[0]}
        Should Be Equal Value Json String    ${security_policies.json()}    $..policyName    {{ edt.security_policy.name | default("not_defined") }}    msg=security policy
    END

    ${utd_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="virtual-application-utd")].templateId
    IF    ${utd_id} == []
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${utd_id}")].templateName    {{ edt.security_policy.container_profile | default("not_defined") }}    msg=container profile
    ELSE
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${utd_id[0]}")].templateName    {{ edt.security_policy.container_profile | default("not_defined") }}    msg=container profile
    END

{% set exp_switchport_templates = [] %}
{% for item in edt.switchport_templates | default([]) %}
{% set _ = exp_switchport_templates.append(item.name) %}
{% endfor %}

{% if edt.switchport_templates is defined %}
    ${exp_switchport_templates} =   Create List   {{ exp_switchport_templates | join('   ') }}
    ${switchport_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="switchport")].templateId
    ${rec_switchport_templates}=    Get Value From Json    ${templates_id.json()}    $..data[?(@.templateId=="${switchport_temp_id[0]}")].templateName
    Lists Should Be Equal    ${rec_switchport_templates}    ${exp_switchport_templates}    msg=switchport templates
{% else %}
    Should Be Equal Value Json String    ${r_id.json()}    $..generalTemplates[?(@.templateType=="switchport")].templateId    {{ edt.switchport_templates | default("not_defined") }}    msg=switchport templates
{% endif %}

    ${thousandeyes_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_thousandeyes")].templateId
    IF    ${thousandeyes_temp_id} == []
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${thousandeyes_temp_id}")].templateName    {{ edt.thousandeyes_template | default("not_defined") }}    msg=thousandeyes template
    ELSE
        Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${thousandeyes_temp_id[0]}")].templateName    {{ edt.thousandeyes_template | default("not_defined") }}    msg=thousandeyes template
    END

{% set vpn0_templates_list = [] %}
{% set vpn512_templates_list = [] %}
{% set _ = vpn0_templates_list.append(edt.vpn_0_template.name) %}
{% set _ = vpn512_templates_list.append(edt.vpn_512_template.name) %}
{% set vpn0_512_list = vpn0_templates_list + vpn512_templates_list %}

{% if edt.vpn_service_templates is defined %}
{% set rec_vpn_service_templates_list = [] %}
{% for item in edt.vpn_service_templates | default([]) %}
{% set test_list = [] %}
{% set _ = test_list.append(item.name) %}
{% set vpn_service_templates_test = ','.join(test_list | map('string')) %}
{% set _ = rec_vpn_service_templates_list.append(vpn_service_templates_test) %}
{% set vpn_templates_list = rec_vpn_service_templates_list + vpn0_512_list %}
    ${list}=   Create List   {{ vpn_templates_list | join('   ') }}
{% endfor %}
{% else %}
    ${list}=   Create List   {{ vpn0_512_list | join('   ') }}
{% endif %}
    Set Suite Variable    ${list}

    ${rec_vpn_names}=    Create List
    ${vpn_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_vpn")].templateId
    FOR    ${id}    IN    @{vpn_temp_id}
        ${rec_vpn_template_name}=    Get Value From Json    ${templates_id.json()}    $..data[?(@.templateId=="${id}")].templateName
        Append To List    ${rec_vpn_names}    ${rec_vpn_template_name[0]}
    END
    Lists Should Be Equal    ${rec_vpn_names}    ${list}    ignore_order=True    msg=vpn templates

    FOR    ${vpn_name}    IN    @{rec_vpn_names}
        IF    '${vpn_name}' == '{{ edt.vpn_0_template.name }}'
            ${sig_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_vpn")]..subTemplates[?(@.templateType=="cisco_secure_internet_gateway")].templateId
            IF    ${sig_temp_id} == []
                Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${sig_temp_id}")].templateName    {{ edt.vpn_0_template.secure_internet_gateway_template | default("not_defined") }}    msg=secure internet gateway template
            ELSE
                Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${sig_temp_id[0]}")].templateName    {{ edt.vpn_0_template.secure_internet_gateway_template | default("not_defined") }}    msg=secure internet gateway template
            END
{% if edt.vpn_0_template.sig_credentials_template is defined %}
{% if edt.vpn_0_template.sig_credentials_template == "umbrella" %}
{% set sig_credentials_template_name = "Cisco-Umbrella-Global-Credentials" %}
{% elif edt.vpn_0_template.sig_credentials_template == "zscaler" %}
{% set sig_credentials_template_name = "Cisco-Zscaler-Global-Credentials" %}
{% endif %}
            ${sig_credentials_template_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_sig_credentials")].templateId
            IF    ${sig_credentials_template_id} == []
                Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${sig_credentials_template_id}")].templateName    {{ sig_credentials_template_name | default("not_defined") }}    msg=sig credentials template
            ELSE
                Should Be Equal Value Json String    ${templates_id.json()}    $..data[?(@.templateId=="${sig_credentials_template_id[0]}")].templateName    {{ sig_credentials_template_name | default("not_defined") }}    msg=sig credentials template
            END
{% endif %}
        END
    END

{% set rec_vpn0_bgp_template = [] %}
{% set _ = rec_vpn0_bgp_template.append(edt.vpn_0_template.bgp_template) | default([]) %}
{% set rec_vpn_service_bgp_template = [] %}
{% for item in edt.vpn_service_templates | default([]) %}
{% set test_list = [] %}
{% set _ = test_list.append(item.bgp_template) %}
{% set vpn_service_bgp_templates_test = ','.join(test_list | map('string')) %}
{% set _ = rec_vpn_service_bgp_template.append(vpn_service_bgp_templates_test) %}
{% endfor %}

{% set rec_bgp_templates = rec_vpn_service_bgp_template + rec_vpn0_bgp_template %}
    ${bgp_temp_list}=   Create List   {{ rec_bgp_templates | join('   ') }}
    Set Suite Variable    ${bgp_temp_list}

    ${rec_bgp_temp_list}=    Create List
    ${bgp_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_vpn")]..subTemplates[?(@.templateType=="cisco_bgp")].templateId
    FOR    ${id}    IN    @{bgp_temp_id}
        ${rec_bgp_temp_name}=    Get Value From Json    ${templates_id.json()}    $..data[?(@.templateId=="${id}")].templateName
        Append To List    ${rec_bgp_temp_list}    ${rec_bgp_temp_name[0]}
    END
    Lists Should Be Equal    ${rec_bgp_temp_list}    ${bgp_temp_list}    ignore_order=True    msg=bgp templates

{% set rec_vpn0_ospf_template = [] %}
{% set _ = rec_vpn0_ospf_template.append(edt.vpn_0_template.ospf_template) | default([]) %}
{% set rec_vpn_service_ospf_template = [] %}
{% for item in edt.vpn_service_templates | default([]) %}
{% set test_list = [] %}
{% set _ = test_list.append(item.ospf_template) %}
{% set vpn_service_ospf_templates_test = ','.join(test_list | map('string')) %}
{% set _ = rec_vpn_service_ospf_template.append(vpn_service_ospf_templates_test) %}
{% endfor %}

{% set rec_ospf_templates = rec_vpn_service_ospf_template + rec_vpn0_ospf_template %}
    ${ospf_temp_list}=   Create List   {{ rec_ospf_templates | join('   ') }}
    Set Suite Variable    ${ospf_temp_list}

    ${rec_ospf_temp_list}=    Create List
    ${ospf_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_vpn")]..subTemplates[?(@.templateType=="cisco_ospf")].templateId
    FOR    ${id}    IN    @{ospf_temp_id}
        ${rec_ospf_temp_name}=    Get Value From Json    ${templates_id.json()}    $..data[?(@.templateId=="${id}")].templateName
        Append To List    ${rec_ospf_temp_list}    ${rec_ospf_temp_name[0]}
    END
    Lists Should Be Equal    ${rec_ospf_temp_list}    ${ospf_temp_list}    ignore_order=True    msg=ospf templates

{% set rec_vpn0_ethernet_interface_templates = [] %}
{% for item in edt.vpn_0_template.ethernet_interface_templates | default([]) %}
{% set _ = rec_vpn0_ethernet_interface_templates.append(item.name) %}
{% endfor %}

{% set rec_vpn512_ethernet_interface_templates = [] %}
{% for item in edt.vpn_512_template.ethernet_interface_templates | default([]) %}
{% set _ = rec_vpn512_ethernet_interface_templates.append(item.name) %}
{% endfor %}

{% set vpn0_512_ethernet_templates_list = rec_vpn512_ethernet_interface_templates + rec_vpn0_ethernet_interface_templates %}
    ${vpn_list}=   Create List   {{ vpn0_512_ethernet_templates_list | join('   ') }}
    Set Suite Variable    ${vpn_list}

{% set rec_vpn_service_ethernet_interface_templates = [] %}
{% for item in edt.vpn_service_templates | default([]) %}
{% for eit_index in range(item.ethernet_interface_templates | default([]) | length()) %}
{% set _ = rec_vpn_service_ethernet_interface_templates.append(item.ethernet_interface_templates[eit_index].name) %}
{% endfor %}
{% endfor %}
    ${vpn_sei_temp_list}=   Create List   {{ rec_vpn_service_ethernet_interface_templates | join('   ') }}
    Set Suite Variable    ${vpn_sei_temp_list}

    ${exp_eit_names}=    Combine Lists    ${vpn_sei_temp_list}    ${vpn_list}
    ${rec_eit_names}=    Create List
    ${eit_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_vpn")]..subTemplates[?(@.templateType=="cisco_vpn_interface")].templateId
    FOR    ${id}    IN    @{eit_temp_id}
        ${rec_eit_template_name}=    Get Value From Json    ${templates_id.json()}    $..data[?(@.templateId=="${id}")].templateName
        Append To List    ${rec_eit_names}    ${rec_eit_template_name[0]}
    END
    Lists Should Be Equal    ${rec_eit_names}    ${exp_eit_names}    ignore_order=True    msg=ethernet interface templates

{% set rec_vpn0_ipsec_interface_templates = [] %}
{% for item in edt.vpn_0_template.ipsec_interface_templates | default([]) %}
{% set _ = rec_vpn0_ipsec_interface_templates.append(item.name) %}
{% endfor %}

{% set rec_vpn_service_ipsec_interface_templates = [] %}
{% for item in edt.vpn_service_templates | default([]) %}
{% for ipsec_index in range(item.ipsec_interface_templates | default([]) | length()) %}
{% set _ = rec_vpn_service_ipsec_interface_templates.append(item.ipsec_interface_templates[ipsec_index].name) %}
{% endfor %}
{% endfor %}

{% set exp_ipsec_interface_templates = rec_vpn_service_ipsec_interface_templates + rec_vpn0_ipsec_interface_templates %}
    ${list}=   Create List   {{ exp_ipsec_interface_templates | join('   ') }}
    ${rec_ipsec_temp_names}=    Create List
    ${ipsec_int_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_vpn")]..subTemplates[?(@.templateType=="cisco_vpn_interface_ipsec")].templateId
    FOR    ${id}    IN    @{ipsec_int_temp_id}
        ${rec_ipsec_int_template_name}=    Get Value From Json    ${templates_id.json()}    $..data[?(@.templateId=="${id}")].templateName
        Append To List    ${rec_ipsec_temp_names}    ${rec_ipsec_int_template_name[0]}
    END
    Lists Should Be Equal    ${rec_ipsec_temp_names}    ${list}    ignore_order=True    msg=ipsec interface templates

{% set rec_vpn0_svi_interface_templates = [] %}
{% for item in edt.vpn_0_template.svi_interface_templates | default([]) %}
{% set _ = rec_vpn0_svi_interface_templates.append(item.name) %}
{% endfor %}

{% set rec_vpn512_svi_interface_templates = [] %}
{% for item in edt.vpn_512_template.svi_interface_templates | default([]) %}
{% set _ = rec_vpn512_svi_interface_templates.append(item.name) %}
{% endfor %}

{% set vpn0_512_svi_templates_list = rec_vpn512_svi_interface_templates + rec_vpn0_svi_interface_templates %}
    ${vpn0_512_svi_templates}=   Create List   {{ vpn0_512_svi_templates_list | join('   ') }}
    Set Suite Variable    ${vpn0_512_svi_templates}

{% set rec_vpn_service_svi_interface_templates = [] %}
{% for item in edt.vpn_service_templates | default([]) %}
{% for svitemp_index in range(item.svi_interface_templates | default([]) | length()) %}
{% set _ = rec_vpn_service_svi_interface_templates.append(item.svi_interface_templates[svitemp_index].name) %}
{% endfor %}
{% endfor %}
    ${vpn_svi_intf_temp_list}=   Create List   {{ rec_vpn_service_svi_interface_templates | join('   ') }}
    Set Suite Variable    ${vpn_svi_intf_temp_list}

    ${exp_svi_int_temp_names}=    Combine Lists    ${vpn_svi_intf_temp_list}    ${vpn0_512_svi_templates}
    ${rec_svi_int_temp_names}=    Create List
    ${svi_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_vpn")]..subTemplates[?(@.templateType=="vpn-interface-svi")].templateId
    FOR    ${id}    IN    @{svi_temp_id}
        ${rec_svi_intf_template_name}=    Get Value From Json    ${templates_id.json()}    $..data[?(@.templateId=="${id}")].templateName
        Append To List    ${rec_svi_int_temp_names}    ${rec_svi_intf_template_name[0]}
    END
    Lists Should Be Equal    ${rec_svi_int_temp_names}    ${exp_svi_int_temp_names}    ignore_order=True    msg=svi interface templates

{% set rec_vpn0_dhcp_server_template = [] %}
{% for item in edt.vpn_0_template.ipsec_interface_templates | default([]) %}
{% set _ = rec_vpn0_dhcp_server_template.append(item.dhcp_server_template) %}
{% endfor %}

{% set rec_eit_dhcp_server_templates = [] %}
{% for item in edt.vpn_service_templates | default([]) %}
{% for dhcp_index in range(item.ethernet_interface_templates | default([]) | length()) %}
{% set _ = rec_eit_dhcp_server_templates.append(item.ethernet_interface_templates[dhcp_index].dhcp_server_template) %}
{% endfor %}
{% endfor %}

{% set rec_ipsec_dhcp_server_templates = [] %}
{% for item in edt.vpn_service_templates | default([]) %}
{% for dhcp_index in range(item.ipsec_interface_templates | default([]) | length()) %}
{% set _ = rec_ipsec_dhcp_server_templates.append(item.ipsec_interface_templates[dhcp_index].dhcp_server_template) %}
{% endfor %}
{% endfor %}

{% set rec_svi_dhcp_server_templates = [] %}
{% for item in edt.vpn_service_templates | default([]) %}
{% for dhcp_index in range(item.svi_interface_templates | default([]) | length()) %}
{% set _ = rec_svi_dhcp_server_templates.append(item.svi_interface_templates[dhcp_index].dhcp_server_template) %}
{% endfor %}
{% endfor %}

{% set dhcp_server_template_names = rec_svi_dhcp_server_templates + rec_ipsec_dhcp_server_templates + rec_eit_dhcp_server_templates + rec_vpn0_dhcp_server_template %}
    ${dhcp_servers_list}=   Create List   {{ dhcp_server_template_names | join('   ') }}
    Set Suite Variable    ${dhcp_servers_list}

    ${rec_dhcp_servers_list}=    Create List
    ${dhcp_servers_temp_id}=    Get Value From Json    ${r_id.json()}    $..generalTemplates[?(@.templateType=="cisco_vpn")]..subTemplates[?(@.templateType=="cisco_dhcp_server")].templateId
    FOR    ${id}    IN    @{dhcp_servers_temp_id}
        ${rec_dhcp_server_name}=    Get Value From Json    ${templates_id.json()}    $..data[?(@.templateId=="${id}")].templateName
        Append To List    ${rec_dhcp_servers_list}    ${rec_dhcp_server_name[0]}
    END
    Lists Should Be Equal    ${rec_dhcp_servers_list}    ${dhcp_servers_list}    ignore_order=True    msg=dhcp server template

{% endfor %}

{% endif %}
