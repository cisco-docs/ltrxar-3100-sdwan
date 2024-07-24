*** Setting ***
Documentation     Verify feature Policies
Suite Setup       Login SDWAN Manager
Suite Teardown    Run On Last Process   Logout SDWAN Manager
Default Tags      sdwan   config   feature policy
Resource          ../../sdwan_common.resource

{% if sdwan.security_policies.feature_policies is defined %}

*** Test Cases ***

Get Feature Policy List(s)
    ${r}=   GET On Session   sdwan_manager   /dataservice/template/policy/security
    Log   ${r}
    Set Suite Variable   ${r}

{% for feature_policy in sdwan.security_policies.feature_policies | default([]) %}

Verify Feature Policy List {{ feature_policy.name }}
   ${feature_policy_id}=   Get Value From Json   ${r.json()}   $..data[?(@..policyName=="{{ feature_policy.name }}")].policyId
   ${r_id}=   GET On Session   sdwan_manager   dataservice/template/policy/security/definition/${feature_policy_id[0]}
   Should Be Equal Value Json String   ${r_id.json()}   $..policyName   {{ feature_policy.name }}   msg=feature policy name
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDescription   {{ feature_policy.description | default("not_defined") }}   msg=feature policy description
   Should Be Equal Value Json String   ${r_id.json()}   $..policyUseCase   {{ feature_policy.use_case}}   msg=use case
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.tcpSynFloodLimit   {{ feature_policy.additional_settings.firewall.tcp_syn_flood_limit }}   msg=tcp sync
   Should Be Equal Value Json String   ${r_id.json()}   $.policyDefinition.settings.highSpeedLogging.vrf   {{ feature_policy.additional_settings.firewall.high_speed_logging.vpn_id | default("not_defined") }}   msg=vpn id
   Should Be Equal Value Json String   ${r_id.json()}   $.policyDefinition.settings.highSpeedLogging.serverIp   {{ feature_policy.additional_settings.firewall.high_speed_logging.server_ip | default("not_defined") }}   msg=server ip
   Should Be Equal Value Json String   ${r_id.json()}   $.policyDefinition.settings.highSpeedLogging.port   {{ feature_policy.additional_settings.firewall.high_speed_logging.server_port | default("not_defined") }}   msg=server port
   ${zbf_yaml_data}=   Create List   {{ feature_policy.firewall_policies | default([]) | join('   ') }}
   ${zbf_rest_api_ref_list}=    Get Value From Json    ${r_id.json()}    $..policyDefinition..assembly[?(@.type=="zoneBasedFW")].definitionId
   ${zbf_name_list}=    Create List
   FOR    ${id}    IN    @{zbf_rest_api_ref_list}
            ${zbf_list_ref_data}=   GET On Session   sdwan_manager   /dataservice/template/policy/definition/zonebasedfw/${id}
            ${zbf_name}=    Get Value From Json    ${zbf_list_ref_data.json()}    $.name
            Append To List   ${zbf_name_list}    ${zbf_name[0]}
   END
   Lists Should Be Equal    ${zbf_name_list}   ${zbf_yaml_data}    ignore_order=True    msg=zone based firewall list

{% if feature_policy.additional_settings.firewall.audit_trail is defined and feature_policy.additional_settings.firewall.audit_trail == True %}
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.auditTrail   on   msg=audit trial
{% elif feature_policy.additional_settings.firewall.audit_trail is defined and feature_policy.additional_settings.firewall.audit_trail == False %}
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.auditTrail   off   msg=audit trial
{% else %} 
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.auditTrail   not_defined   msg=audit trial  
{% endif %} 


{% if feature_policy.additional_settings.firewall.match_stats_per_filter is defined and feature_policy.additional_settings.firewall.match_stats_per_filter == True  %}
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.platformMatch   on   msg=Match Statistics per-filter
{% elif feature_policy.additional_settings.firewall.match_stats_per_filter is defined and feature_policy.additional_settings.firewall.match_stats_per_filter == False %}   
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.platformMatch   off   msg=Match Statistics per-filter
{% else %} 
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.platformMatch   not_defined   msg=Match Statistics per-filter  
{% endif %} 


{% if feature_policy.additional_settings.firewall.direct_internet_applications is defined and feature_policy.additional_settings.firewall.direct_internet_applications == True  %}
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.zoneToNozoneInternet   allow   msg=Direct internet applications
{% elif feature_policy.additional_settings.firewall.direct_internet_applications is defined and feature_policy.additional_settings.firewall.direct_internet_applications == False  %}   
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.zoneToNozoneInternet   deny   msg=Direct internet applications
{% else %} 
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.zoneToNozoneInternet   not_defined   msg=Direct internet applications
{% endif %} 
# | feature_policy.url_filtering_policy is defined | feature_policy.advanced_malware_protection_policy
{% if feature_policy.intrusion_prevention_policy is defined  %}
   ${ips_yaml_id}=   Set Variable  {{ feature_policy.intrusion_prevention_policy }}
   ${ips_rest_api_id}=    Get Value From Json    ${r_id.json()}    $..policyDefinition..assembly[?(@.type=="intrusionPrevention")].definitionId
   IF    ${ips_rest_api_id} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..policyDefinition..assembly[?(@.type=="intrusionPrevention")].definitionId    {{ feature_policy.intrusion_prevention_policy | default("not_defined") }}    msg=intrusion prevention policy
   ELSE
        ${ips_rest_api_data}=    GET On Session    sdwan_manager    /dataservice/template/policy/definition/intrusionprevention/${ips_rest_api_id[0]}
        Should Be Equal Value Json String    ${ips_rest_api_data.json()}    $..name    ${ips_yaml_id}    msg=intrusion prevention policy
   END
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.logging[0].serverIP   {{ feature_policy.additional_settings.ips_url_amp.external_syslog_server.server_ip | default("not_defined") }}   msg=External Syslog Server IP
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.logging[0].vpn   {{ feature_policy.additional_settings.ips_url_amp.external_syslog_server.vpn_id | default("not_defined") }}   msg=External Syslog Server VPN
   Should Be Equal Value Json String   ${r_id.json()}   $..policyDefinition.settings.failureMode  {{ feature_policy.additional_settings.ips_url_amp.failure_mode | default("not_defined") }}   msg=failure mode
{% endif %} 

{% endfor %}

{% endif %}