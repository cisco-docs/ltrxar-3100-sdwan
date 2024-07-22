*** Settings ***
Documentation   Verify System Feature template
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan    config    system_templates
Resource        ../../sdwan_common.resource

{% if sdwan.edge_feature_templates.system_templates is defined%}

*** Test Cases ***
Get System Feature template
    ${r}=    GET On Session    sdwan_manager    /dataservice/template/feature
    ${r}=    Get Value From Json    ${r.json()}    $..data[?(@..templateType=="cisco_system")]
    Set Suite Variable    ${r}

{% for system in sdwan.edge_feature_templates.system_templates | default([]) %}

Verify Edge Feature Template System Feature template {{ system.name }}

    ${system_template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{system.name }}")]
    Should Be Equal Value Json String    ${system_template_id}    $..templateName    {{ system.name }}    msg=system template name
    Should Be Equal Value Json String    ${system_template_id}    $..templateDescription    {{ system.description }}    msg=system template description

{% set test_list = [] %}
{% for item in system.device_types | default(defaults.sdwan.edge_feature_templates.system_templates.device_types) %}
{% set test = "vedge-" ~ item %}
{% set _ = test_list.append(test) %}
{% endfor %}

    ${dt_list}=  Get Value From Json   ${r}   $[?(@..templateName=="{{ system.name }}")].deviceType
    ${test_list}=   Create List   {{ test_list | join('   ') }}
    Lists Should Be Equal    ${dt_list}[0]    ${test_list}    ignore_order=True    msg= {{ system.name }} template device type

    ${template_id}=    Get Value From Json    ${r}    $[?(@.templateName=="{{system.name }}")].templateId
    ${r_id}=    GET On Session    sdwan_manager    /dataservice/template/feature/definition/${template_id[0]}

    Should Be Equal Value Json String    ${r_id.json()}    $..["admin-tech-on-failure"].vipValue    {{ system.admin_tech_on_failure | default("not_defined") | lower() }}    msg=admin tech on failure
    Should Be Equal Value Json String    ${r_id.json()}    $..["admin-tech-on-failure"].vipVariableName    {{ system.admin_tech_on_failure_variable | default("not_defined") }}    msg=admin tech on failure variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["affinity-group"].affinity-group-number.vipValue    {{ system.affinity_group_number | default("not_defined") }}    msg=affinity group number
    Should Be Equal Value Json String    ${r_id.json()}    $..["affinity-group"].affinity-group-number.vipVariableName    {{ system.affinity_group_number_variable | default("not_defined") }}    msg=affinity group number variable

    ${rec_affinity_group_preferences}=    Get Value From Json    ${r_id.json()}    $..["affinity-group"].preference.vipValue
    IF    ${rec_affinity_group_preferences} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..["affinity-group"].preference.vipValue    {{ system.affinity_group_preferences | default("not_defined") }}    msg=affinity group preferences
    ELSE
        ${r_affinity_group_preferences}=    Evaluate    [str(element) for element in ${rec_affinity_group_preferences}[0]]
        ${exp_affinity_group_preferences}=    Create List    {{ system.affinity_group_preferences | join('   ') | default("not_defined") }}
        Lists Should Be Equal    ${r_affinity_group_preferences}    ${exp_affinity_group_preferences}    ignore_order=True    msg=affinity group preferences
    END

    Should Be Equal Value Json String    ${r_id.json()}    $..["affinity-group"].preference.vipVariableName    {{ system.affinity_group_preferences_variable | default("not_defined") }}    msg=affinity group preferences variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["console-baud-rate"].vipValue    {{ system.console_baud_rate | default("not_defined") }}    msg=console baud rate
    Should Be Equal Value Json String    ${r_id.json()}    $..["console-baud-rate"].vipVariableName    {{ system.console_baud_rate_variable | default("not_defined") }}    msg=console baud rate variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["control-session-pps"].vipValue    {{ system.control_session_pps | default("not_defined") }}    msg=control session pps
    Should Be Equal Value Json String    ${r_id.json()}    $..["control-session-pps"].vipVariableName    {{ system.control_session_pps_variable | default("not_defined") }}    msg=control session pps variable

    ${rec_controller_groups}=    Get Value From Json    ${r_id.json()}    $..["controller-group-list"].vipValue
    IF    ${rec_controller_groups} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..["controller-group-list"].vipValue    {{ system.controller_groups | default("not_defined") }}    msg=controller groups
    ELSE
        ${r_controller_groups}=    Evaluate    [str(element) for element in ${rec_controller_groups}[0]]
        ${exp_controller_groups}=    Create List    {{ system.controller_groups | join('   ') | default("not_defined") }}
        Lists Should Be Equal    ${r_controller_groups}    ${exp_controller_groups}    ignore_order=True    msg=controller groups
    END

    Should Be Equal Value Json String    ${r_id.json()}    $..["controller-group-list"].vipVariableName    {{ system.controller_groups_variable | default("not_defined") }}    msg=controller groups variable

    ${rec_device_groups}=    Get Value From Json    ${r_id.json()}    $..["device-groups"].vipValue
    IF    ${rec_device_groups} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..["device-groups"].vipValue    {{ system.device_groups | default("not_defined") }}    msg=device groups
    ELSE
        ${exp_device_groups}=    Create List    {{ system.device_groups | join('   ') | default("not_defined") }}
        Lists Should Be Equal    ${rec_device_groups}[0]    ${exp_device_groups}    ignore_order=True    msg=device groups
    END

    Should Be Equal Value Json String    ${r_id.json()}    $..["device-groups"].vipVariableName    {{ system.device_groups_variable | default("not_defined") }}    msg=device groups variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["enable-mrf-migration"].vipValue    {{ system.enable_mrf_migration | default("not_defined") }}    msg=enable mrf migration
    Should Be Equal Value Json String    ${r_id.json()}    $..["gps-location"].geo-fencing.enable.vipValue    {{ system.geo_fencing | default("not_defined") | lower() }}    msg=geo fencing
    Should Be Equal Value Json String    ${r_id.json()}    $..["gps-location"].geo-fencing.sms.enable.vipValue    {{ system.geo_fencing_sms | default("not_defined") | lower() }}    msg=geo fencing sms
    Should Be Equal Value Json String    ${r_id.json()}    $..["gps-location"].geo-fencing.range.vipValue    {{ system.geo_fencing_range | default("not_defined") }}    msg=geo fencing range
    Should Be Equal Value Json String    ${r_id.json()}    $..["gps-location"].geo-fencing.range.vipVariableName    {{ system.geo_fencing_range_variable | default("not_defined") }}    msg=geo fencing range variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["host-name"].vipVariableName    {{ system.hostname_variable }}    msg=hostname variable
    Should Be Equal Value Json String    ${r_id.json()}    $.idle-timeout.vipValue    {{ system.idle_timeout | default("not_defined") }}    msg=idle timeout
    Should Be Equal Value Json String    ${r_id.json()}    $.idle-timeout.vipVariableName    {{ system.idle_timeout_variable | default("not_defined") }}    msg=idle timeout variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["max-omp-sessions"].vipValue    {{ system.max_omp_sessions | default("not_defined") }}    msg=max omp sessions
    Should Be Equal Value Json String    ${r_id.json()}    $..["max-omp-sessions"].vipVariableName    {{ system.max_omp_sessions_variable | default("not_defined") }}    msg=max omp sessions variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["migration-bgp-community"].vipValue    {{ system.migration_bgp_community | default("not_defined") }}    msg=migration bgp community
    Should Be Equal Value Json String    ${r_id.json()}    $..["multi-tenant"].vipValue    {{ system.multi_tenant | default("not_defined") | lower() }}    msg=multi tenant
    Should Be Equal Value Json String    ${r_id.json()}    $..["multi-tenant"].vipVariableName    {{ system.multi_tenant_variable | default("not_defined") }}    msg=multi tenant variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["gps-location"].latitude.vipValue    {{ system.latitude | default("not_defined") }}    msg=latitude
    Should Be Equal Value Json String    ${r_id.json()}    $..["gps-location"].latitude.vipVariableName    {{ system.latitude_variable | default("not_defined") }}    msg=latitude variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["gps-location"].longitude.vipValue    {{ system.longitude | default("not_defined") }}    msg=longitude
    Should Be Equal Value Json String    ${r_id.json()}    $..["gps-location"].longitude.vipVariableName    {{ system.longitude_variable | default("not_defined") }}    msg=longitude variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["location"].vipValue    {{ system.location | default("not_defined") }}    msg=location
    Should Be Equal Value Json String    ${r_id.json()}    $..["location"].vipVariableName    {{ system.location_variable | default("not_defined") }}    msg=location variable
    Should Be Equal Value Json String    ${r_id.json()}    $.on-demand.enable.vipValue    {{ system.on_demand_tunnel | default("not_defined") | lower() }}    msg=on demand tunnel
    Should Be Equal Value Json String    ${r_id.json()}    $.on-demand.enable.vipVariableName    {{ system.on_demand_tunnel_variable | default("not_defined") }}    msg=on demand tunnel variable
    Should Be Equal Value Json String    ${r_id.json()}    $.on-demand.idle-timeout.vipValue    {{ system.on_demand_tunnel_idle_timeout | default("not_defined") }}    msg=on demand tunnel idle timeout
    Should Be Equal Value Json String    ${r_id.json()}    $.on-demand.idle-timeout.vipVariableName    {{ system.on_demand_tunnel_idle_timeout_variable | default("not_defined") }}    msg=on demand tunnel idle timeout variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["overlay-id"].vipValue    {{ system.overlay_id | default("not_defined") }}    msg=overlay id
    Should Be Equal Value Json String    ${r_id.json()}    $..["overlay-id"].vipVariableName    {{ system.overlay_id_variable | default("not_defined") }}    msg=overlay id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["port-hop"].vipValue    {{ system.port_hopping | default("not_defined") | lower() }}    msg=port hopping
    Should Be Equal Value Json String    ${r_id.json()}    $..["port-hop"].vipVariableName    {{ system.port_hopping_variable | default("not_defined") }}    msg=port hopping variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["port-offset"].vipValue    {{ system.port_offset | default("not_defined") }}    msg=port offset
    Should Be Equal Value Json String    ${r_id.json()}    $..["port-offset"].vipVariableName    {{ system.port_offset_variable | default("not_defined") }}    msg=port offset variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["region-id"].vipValue    {{ system.region_id | default("not_defined") }}    msg=region id
    Should Be Equal Value Json String    ${r_id.json()}    $..["region-id"].vipVariableName    {{ system.region_id_variable | default("not_defined") }}    msg=region id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["role"].vipValue    {{ system.role | default("not_defined") }}    msg=role
    Should Be Equal Value Json String    ${r_id.json()}    $..["role"].vipVariableName    {{ system.role_variable | default("not_defined") }}    msg=role variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["secondary-region"].vipValue    {{ system.secondary_region_id | default("not_defined") }}    msg=secondary region id
    Should Be Equal Value Json String    ${r_id.json()}    $..["secondary-region"].vipVariableName    {{ system.secondary_region_id_variable | default("not_defined") }}    msg=secondary region id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["site-id"].vipValue    {{ system.site_id | default("not_defined") }}    msg=site id
    Should Be Equal Value Json String    ${r_id.json()}    $..["site-id"].vipVariableName    {{ system.site_id_variable | default("not_defined") }}    msg=site id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["description"].vipValue    {{ system.system_description | default("not_defined") }}    msg=system description
    Should Be Equal Value Json String    ${r_id.json()}    $..["description"].vipVariableName    {{ system.system_description_variable | default("not_defined") }}    msg=system description variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["system-ip"].vipVariableName    {{ system.system_ip_variable }}    msg=system ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["clock"].timezone.vipValue    {{ system.timezone | default("not_defined") }}    msg=system timezone
    Should Be Equal Value Json String    ${r_id.json()}    $..["clock"].timezone.vipVariableName    {{ system.timezone_variable | default("not_defined") }}    msg=system timezone variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["track-default-gateway"].vipValue    {{ system.track_default_gateway | default("not_defined") | lower() }}    msg=track default gateway
    Should Be Equal Value Json String    ${r_id.json()}    $..["track-default-gateway"].vipVariableName    {{ system.track_default_gateway_variable | default("not_defined") }}    msg=track default gateway variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["track-interface-tag"].vipValue    {{ system.track_interface_omp_tag | default("not_defined") }}    msg=track interface omp tag
    Should Be Equal Value Json String    ${r_id.json()}    $..["track-interface-tag"].vipVariableName    {{ system.track_interface_omp_tag_variable | default("not_defined") }}    msg=track interface omp tag variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["track-transport"].vipValue    {{ system.track_transport | default("not_defined") | lower() }}    msg=track transport
    Should Be Equal Value Json String    ${r_id.json()}    $..["track-transport"].vipVariableName    {{ system.track_transport_variable | default("not_defined") }}    msg=track transport variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["transport-gateway"].vipValue    {{ system.transport_gateway | default("not_defined") | lower() }}    msg=transport gateway
    Should Be Equal Value Json String    ${r_id.json()}    $..["transport-gateway"].vipVariableName    {{ system.transport_gateway_variable | default("not_defined") }}    msg=transport gateway variable

    Should Be Equal Value Json List Length    ${r_id.json()}    $..["geo-fencing"].sms.mobile-number.vipValue    {{ system.geo_fencing_sms_phone_numbers | length }}    msg=geo fencing phone number list length
{% for system_geo_fencing in system.geo_fencing_sms_phone_numbers | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["geo-fencing"].sms.mobile-number.vipValue[{{loop.index0}}].number.vipValue    {{ system_geo_fencing.number | default("not_defined") }}    msg=geo fencing mobile number
    Should Be Equal Value Json String    ${r_id.json()}    $..["geo-fencing"].sms.mobile-number.vipVariableName    {{ system_geo_fencing.number_variable | default("not_defined") }}    msg=geo fencing mobile number variable
{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $..["tracker"].vipValue    {{ system.endpoint_trackers | length }}    msg=end point trackers length
{% for endpoint_trackers in system.endpoint_trackers | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].name.vipValue    {{ endpoint_trackers.name | default("not_defined") }}    msg=system endpoint trackers name
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].name.vipVariableName    {{ endpoint_trackers.name_variable | default("not_defined") }}    msg=system endpoint trackers name variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].boolean.vipValue    {{ endpoint_trackers.group_criteria | default("not_defined") }}    msg=system endpoint trackers group criteria
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].boolean.vipVariableName    {{ endpoint_trackers.group_criteria_variable | default("not_defined") }}    msg=system endpoint trackers group criteria variable

    ${endpoint_group_trackers}=    Get Value From Json    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].elements.vipValue
    IF    ${endpoint_group_trackers} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].elements.vipValue    {{ endpoint_trackers.group_trackers | default("not_defined") }}    msg=system endpoint trackers group trackers   
    ELSE
        ${group_tracker_list}=    Create List    {{ endpoint_trackers.group_trackers | join('   ') | default("not_defined") }}
        Lists Should Be Equal    ${endpoint_group_trackers}[0]    ${group_tracker_list}    ignore_order=True    msg=system endpoint trackers group trackers
    END

    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].endpoint-api-url.vipValue    {{ endpoint_trackers.endpoint_api_url | default("not_defined") }}    msg=system endpoint trackers api url
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].endpoint-api-url.vipVariableName    {{ endpoint_trackers.endpoint_api_url_variable | default("not_defined") }}    msg=system endpoint trackers api url variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].endpoint-dns-name.vipValue    {{ endpoint_trackers.endpoint_dns_name | default("not_defined") }}    msg=system endpoint trackers endpoint dns name
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].endpoint-dns-name.vipVariableName    {{ endpoint_trackers.endpoint_dns_name_variable | default("not_defined") }}    msg=system endpoint trackers endpoint dns name variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].endpoint-ip.vipValue    {{ endpoint_trackers.endpoint_ip | default("not_defined") }}    msg=system endpoint trackers endpoint ip
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].endpoint-ip.vipVariableName    {{ endpoint_trackers.endpoint_ip_variable | default("not_defined") }}    msg=system endpoint trackers endpoint ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].interval.vipValue    {{ endpoint_trackers.interval | default(defaults.sdwan.edge_feature_templates.system_templates.endpoint_trackers.interval) }}    msg=system endpoint trackers interval
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].interval.vipVariableName    {{ endpoint_trackers.interval_variable | default("not_defined") }}    msg=system endpoint trackers interval variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].multiplier.vipValue    {{ endpoint_trackers.multiplier | default(defaults.sdwan.edge_feature_templates.system_templates.endpoint_trackers.multiplier) }}    msg=system endpoint trackers multiplier
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].multiplier.vipVariableName    {{ endpoint_trackers.multiplier_variable | default("not_defined") }}    msg=system endpoint trackers multiplier variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].vipOptional    {{ endpoint_trackers.optional | default("not_defined") }}    msg=system endpoint trackers optional
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].threshold.vipValue    {{ endpoint_trackers.threshold | default(defaults.sdwan.edge_feature_templates.system_templates.endpoint_trackers.threshold) }}    msg=system endpoint trackers threshold
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].threshold.vipVariableName    {{ endpoint_trackers.threshold_variable | default("not_defined") }}    msg=system endpoint trackers threshold variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].endpoint-ip.vipValue    {{ endpoint_trackers.endpoint_ip | default("not_defined") }}    msg=system endpoint trackers transport ip
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].endpoint-ip.vipVariableName    {{ endpoint_trackers.endpoint_ip_variable | default("not_defined") }}    msg=system endpoint trackers transport ip variable

{% if endpoint_trackers.group_trackers is defined %}    
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].type.vipValue    tracker-group    msg=system endpoint trackers type
{% else %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].type.vipValue    {{ endpoint_trackers.type | default(defaults.sdwan.edge_feature_templates.system_templates.endpoint_trackers.type) }}    msg=system endpoint trackers type
{% endif %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["tracker"].vipValue[{{loop.index0}}].type.vipVariableName    {{ endpoint_trackers.type_variable | default("not_defined") }}    msg=system endpoint trackers type variable

{% endfor %}

    Should Be Equal Value Json List Length    ${r_id.json()}    $..["object-track"].vipValue    {{ system.object_trackers | length }}    msg=object trackers list length
{% for object_tracker in system.object_trackers | default([]) %}
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].boolean.vipValue    {{ object_tracker.group_criteria | default("not_defined") }}    msg=object tracker group criteria
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].boolean.vipVariableName    {{ object_tracker.group_criteria_variable | default("not_defined") }}    msg=object tracker group criteria variable

    ${object_group_trackers}=    Get Value From Json    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].object.vipValue..number.vipValue
    IF    ${object_group_trackers} == []
        Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].object.vipValue..number.vipValue    {{ object_tracker.group_trackers | default("not_defined") }}    msg=object group trackers
    ELSE
        ${r_object_group_trackers}=   Create List
        FOR   ${item}    IN   @{object_group_trackers}
            ${item_int}=   Convert To String   ${item}
            Append To List   ${r_object_group_trackers}   ${item_int}
        END
        ${o_group_tracker}=    Create List    {{ object_tracker.group_trackers | join('  ') | default("not_defined") }}
        Lists Should Be Equal    ${r_object_group_trackers}    ${o_group_tracker}    msg=object group trackers
    END

    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].boolean.vipVariableName    {{ object_tracker.group_trackers_variable | default("not_defined") }}    msg=object group trackers variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].object-number.vipValue    {{ object_tracker.id | default("not_defined") }}    msg=object tracker id
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].object-number.vipVariableName    {{ object_tracker.id_variable | default("not_defined") }}    msg=object tracker id variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].interface.vipValue    {{ object_tracker.interface | default("not_defined") }}    msg=object tracker interface
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].interface.vipVariableName    {{ object_tracker.interface_variable | default("not_defined") }}    msg=object tracker interface variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].ip.vipValue    {{ object_tracker.ip | default("not_defined") }}    msg=object tracker ip
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].ip.vipVariableName    {{ object_tracker.ip_variable | default("not_defined") }}    msg=object tracker ip variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].mask.vipValue    {{ object_tracker.mask | default("not_defined") }}    msg=object tracker mask
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].mask.vipVariableName    {{ object_tracker.mask_variable | default("not_defined") }}    msg=object tracker mask variable
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].vipOptional    {{ object_tracker.optional | default("not_defined") }}    msg=object tracker optional
    Should Be Equal Value Json String    ${r_id.json()}    $..["object-track"].vipValue[{{loop.index0}}].vpn.vipValue    {{ object_tracker.vpn_id | default("not_defined") }}    msg=object tracker vpn id

{% endfor %}

{% endfor %}

{% endif %}
