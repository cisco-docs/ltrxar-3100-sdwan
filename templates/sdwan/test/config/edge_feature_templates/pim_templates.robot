*** Settings ***
Documentation   Verify PIM Feature Template Configuration
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    feature_templates pim_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.pim_templates is defined %}

*** Test Cases ***
Get PIM Feature Template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    Set Suite Variable    ${r}

{% for pim in sdwan.edge_feature_templates.pim_templates | default([]) %}

Verify Edge Feature PIM Configuration Template {{ pim.name }}
    ${pim_id}=  Get Value From Json   ${r.json()}   $..data[?(@..templateName=="{{ pim.name }}")].templateId
    Log    =====Name=====
    Should Not be Empty   ${pim_id}   msg= {{ pim.name }} not present
    Log    =====Description=====
    Should Be Equal Value Json Special_String   ${r.json()}   $..data[?(@..templateName=="{{ pim.name }}")].templateDescription   {{ pim.description | normalize_special_string }}  msg=description
    ${r_id}=   GET On Session   sdwan_manager   /dataservice/template/feature/definition/${pim_id[0]}
    Set Suite Variable   ${r_id}
    Log    =====DeviceType=====
    {% set dt_list_local = [] %}
    {% for item in pim.device_types | default(defaults.sdwan.edge_feature_templates.pim_templates.device_types) %}
    {% set test = "vedge-" ~ item %}
    {% set _ = dt_list_local.append(test) %}
    {% endfor %}
    ${dt_list}=  Get Value From Json   ${r.json()}   $..data[?(@..templateName=="{{ pim.name }}")].deviceType
    ${dt_list_local}=   Create List   {{ dt_list_local | join('   ') }}
    Lists Should Be Equal    ${dt_list_local}    ${dt_list}[0]   ignore_order=True   msg={{ pim.name }}: device type

    Log    =====SSM Fields=====
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim.ssm.default    {{ pim.ssm_default_variable | default(pim.ssm_default | default("") | lower())}}    msg=ssm default pim
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim.ssm.range    {{ pim.ssm_access_list_range_variable | default(pim.ssm_access_list_range | default("not_defined"))}}    msg=ssm range pim
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim["auto-rp"]    {{ pim.auto_rp_variable | default(pim.auto_rp | default("not_defined") | lower())}}    msg=auto rp pim
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim["spt-threshold"]    {{ pim.spt_threshold_variable | default(pim.spt_threshold | default("not_defined"))}}    msg=spt threshold pim
    Log    =====RP Announce=====
    Should Be Equal Value Json List Length    ${r_id.json()}    $..pim["send-rp-announce"]["send-rp-announce-list"].vipValue    {{ pim.rp_announces | default([]) | length }}    msg=rp announce entries length
    {% for rp_announce in pim.rp_announces | default([]) %}
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim["send-rp-announce"]["send-rp-announce-list"].vipValue[{{ loop.index0 }}]["if-name"]    {{ rp_announce.interface_name_variable | default(rp_announce.interface_name | default("not_defined")) }}    msg=rp announce interface name pim
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim["send-rp-announce"]["send-rp-announce-list"].vipValue[{{ loop.index0 }}]["scope"]    {{ rp_announce.scope_variable | default(rp_announce.scope | default("not_defined")) }}    msg=rp announce scope pim
        Should Be Equal Value Json String    ${r_id.json()}    $..pim["send-rp-announce"]["send-rp-announce-list"].vipValue[{{ loop.index0 }}]["vipOptional"]    {{ rp_announce.optional | default("not_defined") }}    msg=rp announce optional
    {% endfor %}
    Log    =====RP Discovery=====
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim["send-rp-discovery"]["if-name"]    {{ pim.rp_discovery_interface_variable | default(pim.rp_discovery_interface | default("not_defined")) }}    msg=rp discovery interface name pim
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim["send-rp-discovery"]["scope"]    {{ pim.rp_discovery_scope_variable | default(pim.rp_discovery_scope | default("not_defined")) }}    msg=rp discovery scope pim
    Log    =====RP Address=====
    Should Be Equal Value Json List Length    ${r_id.json()}    $..pim["rp-addr"].vipValue    {{ pim.rp_addresses | default([]) | length }}    msg=rp address entries length
    {% for rp_address in pim.rp_addresses | default([]) %}
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim["rp-addr"].vipValue[{{ loop.index0 }}]["address"]    {{ rp_address.ip_address_variable | default(rp_address.ip_address | default("not_defined")) }}    msg=rp address ip address pim
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim["rp-addr"].vipValue[{{ loop.index0 }}]["access-list"]    {{ rp_address.access_list_variable | default(rp_address.access_list | default("not_defined")) }}    msg=rp address access list pim
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim["rp-addr"].vipValue[{{ loop.index0 }}]["override"]    {{ rp_address.override_variable | default(rp_address.override | default("not_defined") | lower()) }}    msg=rp address override pim
        Should Be Equal Value Json String    ${r_id.json()}    $..pim["rp-addr"].vipValue[{{ loop.index0 }}]["vipOptional"]    {{ rp_address.optional | default("not_defined") }}    msg=rp address optional
    {% endfor %}
    Log    =====RP Candidate=====
    Should Be Equal Value Json List Length    ${r_id.json()}    $..pim["rp-candidate"].vipValue    {{ pim.rp_candidates | default([]) | length }}    msg=rp candidates entries length
    {% for rp_candidate in pim.rp_candidates | default([]) %}
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim["rp-candidate"].vipValue[{{ loop.index0 }}]["pim-interface-name"]    {{ rp_candidate.interface_name_variable | default(rp_candidate.interface_name | default("not_defined")) }}    msg=rp candidate interface name pim
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim["rp-candidate"].vipValue[{{ loop.index0 }}]["group-list"]    {{ rp_candidate.access_list_variable | default(rp_candidate.access_list | default("not_defined")) }}    msg=rp candidate access list pim
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim["rp-candidate"].vipValue[{{ loop.index0 }}]["interval"]    {{ rp_candidate.interval_variable | default(rp_candidate.interval | default("not_defined")) }}    msg=rp candidate interval pim
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim["rp-candidate"].vipValue[{{ loop.index0 }}]["priority"]    {{ rp_candidate.priority_variable | default(rp_candidate.priority | default("not_defined")) }}    msg=rp candidate priority pim
        Should Be Equal Value Json String    ${r_id.json()}    $..pim["rp-candidate"].vipValue[{{ loop.index0 }}]["vipOptional"]    {{ rp_candidate.optional | default("not_defined") }}    msg=rp candidate optional
    {% endfor %}
    Log    =====BSR Candidate=====
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim["bsr-candidate"]["bsr-interface-name"]    {{ pim.bsr_candidate_interface_variable | default(pim.bsr_candidate_interface | default("not_defined")) }}    msg=bsr candidate interface name pim
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim["bsr-candidate"]["mask"]    {{ pim.bsr_candidate_hash_mask_length_variable | default(pim.bsr_candidate_hash_mask_length | default("not_defined")) }}    msg=bsr candidate hash mask length pim
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim["bsr-candidate"]["priority"]    {{ pim.bsr_candidate_priority_variable | default(pim.bsr_candidate_priority | default("not_defined")) }}    msg=bsr candidate priority pim
    Should Be Equal Value Json String FT   ${r_id.json()}   $..pim["bsr-candidate"]["accept-rp-candidate"]    {{ pim.bsr_candidate_rp_access_list_variable | default(pim.bsr_candidate_rp_access_list | default("not_defined")) }}    msg=bsr candidate rp access list pim
    Log    =====Interfaces=====
    Should Be Equal Value Json List Length    ${r_id.json()}    $..pim["interface"].vipValue    {{ pim.interfaces | default([]) | length }}    msg=interface entries length
    {% for interface in pim.interfaces | default([]) %}
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim.interface.vipValue[{{ loop.index0 }}].name   {{ interface.interface_name_variable | default(interface.interface_name | default("not_defined")) }}    msg=interface name pim
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim.interface.vipValue[{{ loop.index0 }}]["join-prune-interval"]    {{ interface.join_prune_interval_variable | default(interface.join_prune_interval | default("not_defined")) }}    msg=interface join-prune-interval pim
        Should Be Equal Value Json String FT    ${r_id.json()}    $..pim.interface.vipValue[{{ loop.index0 }}]["query-interval"]    {{ interface.query_interval_variable | default(interface.query_interval | default("not_defined")) }}    msg=interface query-interval pim
        Should Be Equal Value Json String    ${r_id.json()}    $..pim.interface.vipValue[{{ loop.index0 }}]["vipOptional"]    {{ interface.optional | default("not_defined")}}    msg=interface optional
    {% endfor %}
{% endfor %}
{% endif %}
