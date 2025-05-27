---
name: Brownfield Import
about: Verify brownfield import works correctly for a specific feature.
title: "[Brownfield Import] "
labels: enhancement
projects: netascode/11
---

## Instructions

Verify brownfield import works correctly for the feature mentioned in the title.

### Steps:
1. Take the particular feature data model from [integration test data](https://wwwin-github.cisco.com/netascode/nac-sdwan/blob/master/tests/integration/fixtures/sdwan/standard_2012/feature_profiles.nac.yaml).
2. Include it in your data model and use Terraform to configure the feature.
3. Use [nac-collector](https://github.com/netascode/nac-collector) to export the feature to JSON format. Verify feature is included in the sdwan.json export.
4. Use [nac-tool](https://wwwin-github.cisco.com/netascode/nac-tool) to convert JSON to YAML. Verify that the converted YAML is same as initial YAML from point 1. This can be done by replacing your initial data from point 1 with converted YAML data  and doing TF apply again like in point 1 -> the expected result here is terraform says "No changes" meaning there is not difference between data you've pushed in step 1 and data you generated in step 4.
5. Remove your TF state. Run [import script](https://wwwin-github.cisco.com/netascode/nac-sdwan-terraform/blob/master/.ci/import.py),  run the terraform apply and verify object is fully imported, no additions (+)  or deletions (-) are seen for any parameter of this feature.

### Log the results below:
- [ ] nac-collector
- [ ] nac-tool
- [ ] import script
- [ ] netascode documentation update

If any point fails, work on the fix and leave the PR in the comment. If all points work, open a PR for [support matrix](https://wwwin-github.cisco.com/netascode/netascode/blob/master/docs/data_model/sdwan/support_matrix.md) and add green flag that we support import for this feature.
