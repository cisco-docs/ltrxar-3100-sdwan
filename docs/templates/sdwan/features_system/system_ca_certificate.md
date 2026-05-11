# System CA Certificate

Configure CA Certificate feature in the system profile

{{ doc_gen }}

### Examples

In order to configure CA Certificate, you need a certificate ID. You can retrive certificate ID by using one of the methods below:

Option 1: Set, SDWAN_URL, SDWAN_USERNAME and SDWAN_PASSWORD enviromental variables and use [sdwan-get-ca-certs.py](https://wwwin-github.cisco.com/netascode/nac-sdwan-terraform/blob/master/scripts/python/sdwan-get-ca-certs.py) script:
```
$ python3 scripts/python/sdwan-get-ca-certs.py           
*** Connecting to the SD-WAN Manager API... ***
*** Third-Party CA Certificates ***
Certificate Name: cert1
UUID: d8167c98-0976-49d3-b42f-f8cb9a59e0b5
Subject Common Name: sign.sdwan_autopod.cisco.com
--------------------------------------------------
Certificate Name: cert2
UUID: 278b5db1-8d12-40db-b0a1-e87a55106a4d
Subject Common Name: sign.sdwan_autopod.cisco.com
--------------------------------------------------
```

Option 2: Use API call https://\<manager-ip\>/dataservice/v1/certificate/third-party-ca/

Example-1: This example configures a CA Certificate feature that references a certificate ID under the trustpoint CATP.

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        description: This is a test system profile
        ca_certificate:
          name: ca_thirdparty_certificate
          description: My CA Third Party Certificate Feature
          certificates:
            - certificate_id: b4f23b8f-a3ef-4d2d-af15-705a4217ce11
              trustpoint_name: CATP
```
