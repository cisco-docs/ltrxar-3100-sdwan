*** Settings ***
Documentation   Verify Hub And Spoke Topology
Suite Setup     Login SDWAN Manager
Suite Teardown  Run On Last Process    Logout SDWAN Manager
Default Tags    sdwan  config  hub_and_spoke_topology
Resource        ../../../../sdwan_common.resource

{% if sdwan.centralized_policies.definitions.control_policy.hub_and_spoke_topology is defined %}

*** Test Cases ***
Get Hub And Spoke Topology(s)
   ${r}=   GET On Session   sdwan_manager   /dataservice/template/policy/definition/hubandspoke
   Set Suite Variable   ${r}

{% for topology in sdwan.centralized_policies.definitions.control_policy.hub_and_spoke_topology | default([]) %}

Verify Centralized Policies Color Hub and Spoke Topology {{ topology.name }}
   ${topo_id}=  Get Value From Json   ${r.json()}   $..data[?(@..name=="{{ topology.name }}")].definitionId
   ${topo}=   GET On Session   sdwan_manager   /dataservice/template/policy/definition/hubandspoke/${topo_id[0]}
   Should Be Equal Value Json String   ${topo.json()}   $..name   {{ topology.name }}    msg=Topology
   Should Be Equal Value Json String   ${r.json()}   $..data[?(@..name=="{{ topology.name }}")].description   {{ topology.description }}  msg={{ topology.name }}: Description
   Set Suite Variable   ${topo}

   ${vpn_list_id}=  Get Value From Json   ${topo.json()}   $..vpnList
   ${vpn_list}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/vpn/${vpn_list_id[0]}
   Should Be Equal Value Json String   ${vpn_list.json()}   $..name   {{ topology.vpn_list }}   msg={{ topology.name }}: vpn list
   Should Be Equal Value Json List Length   ${topo.json()}   $..definition.subDefinitions  {{ topology.hub_and_spoke_sites | length }}  msg={{ topology.name }}: Site group numbers
{% for site_group in topology.hub_and_spoke_sites | default([]) %}

Verify {{ topology.name }} Topology's Site Group {{ site_group.name }}
   Should Be Equal Value Json String   ${topo.json()}   $..definition.subDefinitions.[{{loop.index0}}].name   {{ site_group.name }}      msg={{ topology.name }} Topology's: {{ site_group.name }} Site group
   ${site_group_value}=   Get Value From Json   ${topo.json()}   $..definition.subDefinitions.[{{loop.index0}}].spokes
   Set Suite Variable   ${site_group_value}
   ${spoke_length}=   Get Length   ${site_group_value[0]}
   Should Be Equal As Integers    ${spoke_length}    {{ site_group.spokes | length }}    msg={{ site_group.name }}: No. of Spoke
   Should Be Equal Value Json String   ${topo.json()}   $..definition.subDefinitions.[{{loop.index0}}].equalPreference   {{ site_group.equal_preference | default("not_defined") }}   msg={{ topology.name }} Topology's {{ site_group.name }} Site group's: Equal Preference
   Should Be Equal Value Json String   ${topo.json()}   $..definition.subDefinitions.[{{loop.index0}}].advertiseTloc   {{ site_group.advertise_tloc | default("not_defined") }}   msg={{ topology.name }} Topology's {{ site_group.name }} Site group's: Advertise Tloc

   ${tloc_id}=   Get Value From Json   ${topo.json()}   $..definition.subDefinitions.[{{loop.index0}}].tlocList
{% if site_group.tloc_list | default("not_defined") | string() == "not_defined" %}
   Should Be Empty   ${tloc_id}   msg={{ topology.name }} Topology's {{ site_group.name }} Site group's: Tloc
{% else %}
   ${tloc}=   GET On Session   sdwan_manager   /dataservice/template/policy/list/tloc/${tloc_id[0]}
   Should Be Equal Value Json String   ${tloc.json()}   $..name   {{ site_group.tloc_list | default("not_defined") }}  msg={{ topology.name }} Topology's {{ site_group.name }} Site group's: Tloc
{% endif %}

{% for spoke in site_group.spokes | default([]) %}

Verify {{ topology.name }} Topology's {{ site_group.name }} Site Group for Spoke {{ spoke.site_list }}
   ${sites}=  GET On Session   sdwan_manager   /dataservice/template/policy/list/site/${site_group_value[0][{{loop.index0}}]['siteList']}
   Should Be Equal Value Json String   ${sites.json()}   $..name   {{ spoke.siteList }}   msg={{ topology.name }} Topology's {{ site_group.name }} Site group's: Spoke {{ spoke.siteList }}
   ${hub_ids}=   Set Variable    ${site_group_value[0][{{loop.index0}}]['hubs']}
   ${hub_numbers}=   Get Length   ${hub_ids}
   Set Suite Variable   ${hub_ids}
   Should Be Equal As Integers    ${hub_numbers}   {{ spoke.hubs | length }}   msg={{ site_group.name }}: Spoke's hub numbers

{% for hubs in spoke.hubs | default([]) %}

Verify {{ topology.name }} Topology's {{ site_group.name }} Site Group's Spoke {{ spoke.site_list }} for Hub {{ hubs.site_list }}
   ${hub_site}=   Get Value From Json   ${hub_ids}   $[{{loop.index0}}].siteList
   ${hub_site_name}=  GET On Session   sdwan_manager   /dataservice/template/policy/list/site/${hub_site}[0]
   Should Be Equal Value Json String   ${hub_site_name.json()}   $..name   {{ hubs.site_list }}  msg={{ spoke.siteList }} Spokes's:{{ hubs.site_list }} Hub site

{% if hubs.ipv4_prefix_lists | default("not_defined") | string() != "not_defined" %}
   Should Be Equal Value Json List Length   ${hub_ids}  $[{{loop.index0}}].prefixLists  {{ hubs.ipv4_prefix_lists | length }}    msg={{ hubs.site_list }} Hub site's:IPv4 prefixes length
   ${prefix_id}=   Get Value From Json   ${hub_ids}   $[{{loop.index0}}].prefixLists
{% for ipv4_prefix in hubs.ipv4_prefix_lists %}
   ${prefix_name}=  GET On Session   sdwan_manager      /dataservice/template/policy/list/prefix/${prefix_id[0][{{loop.index0}}]}
   Should Be Equal Value Json String   ${prefix_name.json()}   $..name   {{ ipv4_prefix }}    msg={{ hubs.site_list }} Hub site's:IPv4 Prefix
{% endfor %}

{% else %}
   ${prefix_id}=   Get Value From Json   ${hub_ids}   $[{{loop.index0}}].prefixLists
   ${outer_empty}=    Run Keyword And Return Status   Should Be Empty   ${prefix_id}   msg={{ hubs.site_list }} Hub site's:IPv4 prefix
   IF   $outer_empty == $True
      Log  $outer_empty
   ELSE
      ${inner_empty}=    Run Keyword And Return Status   Should Be Empty   ${prefix_id}[0]    msg={{ hubs.site_list }} Hub site's:IPv4 prefix
      IF   $inner_empty == $True
         Log    $inner_empty
      ELSE
         Fail   msg={{ hubs.site_list }} Hub site's:IPv4 prefix
      END
   END
{% endif %}

{% if hubs.ipv6_prefix_lists | default("not_defined") | string() != "not_defined" %}
   Should Be Equal Value Json List Length   ${hub_ids}   $[{{loop.index0}}].ipv6PrefixLists  {{ hubs.ipv6_prefix_lists | length }}    msg={{ hubs.site_list }} Hub site's: IPv6 prefixes
{% for ipv6_prefix in hubs.ipv6_prefix_lists %}
   ${ipv6_prefix_name}=  GET On Session   sdwan_manager      /dataservice/template/policy/list/prefix/${ipv6_prefix_id[0][{{loop.index0}}]}
   Should Be Equal Value Json String   ${ipv6_prefix_name.json()}   $..name   {{ ipv6_prefix }}    msg={{ hubs.site_list }} Hub site's: IPv6 Prefix

{% endfor %}

{% else %}
   ${ipv6_prefix_id}=   Get Value From Json   ${hub_ids}   $[{{loop.index0}}].ipv6PrefixLists
   ${outer_empty}=    Run Keyword And Return Status   Should Be Empty   ${ipv6_prefix_id}    msg={{ hubs.site_list }} Hub site's:IPv6 prefix
   IF   $outer_empty == $True
      Log  $outer_empty
   ELSE
      ${inner_empty}=    Run Keyword And Return Status   Should Be Empty   ${ipv6_prefix_id}[0]    msg={{ hubs.site_list }} Hub site's:IPv6 prefix
      IF   $inner_empty == $True
         Log    $inner_empty
      ELSE
         Fail   msg={{ hubs.site_list }} Hub site's:IPv6 prefix
      END
   END
{% endif %}

{% endfor %}

{% endfor %}

{% endfor %}

{% endfor %}
{% endif %}
