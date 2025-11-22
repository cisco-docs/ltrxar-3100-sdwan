# AS Path List

AS Path list specifies one or more BGP AS paths.

{{ doc_gen }}

### Examples

Example-1: This example shows the configuration of an AS-Path list which contains the regex to look for BGP prefixes where AS 65000 has been used as transit.

```yaml
sdwan:
  policy_objects:
    as_path_lists:
      - name: TRANSIT_AS_65000
        as_paths:
          - _65000_
```

Example-2: This example shows the configuration of an AS-Path list which contains the regex to look for BGP prefixes where AS 65000 is the last transit AS.

```yaml
sdwan:
  policy_objects:
    as_path_lists:
      - name: NEIGHBOR_TRANSIT_AS
        as_paths:
          - ^65000
```

Example-3: This example shows the configuration of an AS-Path list which contains the regex to look for BGP prefixes where AS 65000 originator of the prefix.

```yaml
sdwan:
  policy_objects:
    as_path_lists:
      - name: ORIGINATOR_AS_65000
        as_paths:
          - 65000$
```

Example-4: This example shows the configuration of an AS-Path list which contains the regex to look for BGP prefixes where AS-Path is empty.

```yaml
sdwan:
  policy_objects:
    as_path_lists:
      - name: EMPTY_AS_PATH
        as_paths:
          - ^$
```

Example-5: This example shows the configuration of an AS-Path list which contains the regex to look for BGP prefixes where AS 65000 has been used as transit.

```yaml
sdwan:
  policy_objects:
    as_path_lists:
      - name: AS_PATH_4
        as_paths:
          - ^.*
```

Example-6: This example shows the configuration of two AS-Path lists, which contains the regex to look for BGP prefixes where AS 65000 and 65100 has been used as transit.

```yaml
sdwan:
  policy_objects:
    as_path_lists:
      - name: AS_PATH_1
        as_paths:
          - _65100_
      - name: AS_PATH_2
        as_paths:
          - _65000_
```

Example-7: This example shows the configuration of a single AS-Path list, which contains the regex to look for BGP prefixes where the last AS-Path is 65100 OR 65101.

```yaml
sdwan:
  policy_objects:
    as_path_lists:
      - name: ASPATH-PRIVATE
        as_paths:
          - ^65100
          - ^65101
```
