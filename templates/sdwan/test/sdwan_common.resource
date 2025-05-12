*** Settings ***
Library   pabot.PabotLib
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   OperatingSystem
Library   String
Library   packaging.version
Library   myutils.py

*** Variables ***
&{login_json}=   j_username=%{SDWAN_USERNAME}   j_password=%{SDWAN_PASSWORD}
&{headers}=   content-type=application/x-www-form-urlencoded

*** Keywords ***
Get SDWAN Manager Token
   Create Session   login   %{SDWAN_URL}   verify=${False}   disable_warnings=1   headers=${headers}
   ${log_level}=   Set Log Level   NONE
   ${response}=   Wait Until Keyword Succeeds   6x   10s   POST On Session   login   /j_security_check   data=${login_json}
   Set Log Level   ${log_level}
   ${r_token}=   Wait Until Keyword Succeeds   6x   10s   GET On Session   login   /dataservice/client/token
   ${cookie}=   Get from dictionary   ${response.headers}   set-cookie
   ${r_cookie}=   Split string   ${cookie}   separator=;
   Set Parallel Value For Key   manager_token   ${r_token.text}
   Set Parallel Value For Key   manager_cookie   ${r_cookie[0]}

Get SDWAN Manager Version
   ${response}=   Wait Until Keyword Succeeds   6x   10s   GET On Session   sdwan_manager   /dataservice/system/device/controllers   params=model=vmanage
   ${r_version}=   Get Value From Json   ${response.json()}   $.data[0].version
   Set Parallel Value For Key   manager_version   ${r_version[0]}

Login SDWAN Manager
   Run Only Once   Get SDWAN Manager Token
   ${manager_token}=   Get Parallel Value For Key   manager_token
   ${manager_cookie}=   Get Parallel Value For Key   manager_cookie
   ${m_headers}=   Create Dictionary   X-XSRF-TOKEN=${manager_token}   Cookie=${manager_cookie}   accept=application/json
   Create Session   sdwan_manager   %{SDWAN_URL}   headers=${m_headers}
   Run Only Once   Get SDWAN Manager Version

Logout SDWAN Manager
   ${manager_cookie}=   Get Parallel Value For Key   manager_cookie
   ${m_headers}=   Create Dictionary   Cookie=${manager_cookie}   accept=*/*
   ${manager_version}=   Get Parallel Value For Key   manager_version
   ${version_check}=   Evaluate   packaging.version.Version('${manager_version}') >= packaging.version.Version('20.12')
   IF   ${version_check}
       ${response}=   Wait Until Keyword Succeeds   6x   10s   POST On Session   sdwan_manager   /logout   headers=${m_headers}
   ELSE
       ${response}=   Wait Until Keyword Succeeds   6x   10s   GET On Session   sdwan_manager   /logout   headers=${m_headers}
   END

Should Be Equal Value Json String
   [Arguments]   ${json}    ${json_path}   ${value}=${EMPTY}  ${msg}=${EMPTY}
   ${r_value}=   Get Value From Json   ${json}   ${json_path}
   ${r_value}=   Set Variable If    ${r_value} == []    not_defined    ${r_value[0]}
   Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Strings    ${r_value}    ${value}    values=False    msg=${msg} expected: '${value}' and got: '${r_value}'  

Should Be Equal Value Json List
   [Arguments]   ${json}   ${json_path}   ${value}=${None}   ${msg}=${EMPTY}
   ${r_value}=   Get Value From Json   ${json}   ${json_path}
   Run Keyword If   "${value}" != "${None}"   Lists Should Be Equal   ${r_value}   ${value}   ignore_order=True    values=False    msg=${msg} expected: '${value}' and got: '${r_value}'    

Should Be Equal Value Json List Length
   [Arguments]   ${json}   ${json_path}   ${value}=${None}   ${msg}=${EMPTY}
   ${r_value}=   Get Value From Json   ${json}   ${json_path}
   ${status}=    Run Keyword And Return Status  Get Length   ${r_value[0]}
   IF  ${status} == ${True}
       ${r_length}=    Get Length     ${r_value[0]}
   ELSE
       ${r_length}=    Get Length     ${r_value}
   END
   Run Keyword If   "${value}" != "${None}"  Should Be Equal As Integers    ${r_length}    ${value}  values=False  msg=${msg} expected '${value}' items and got: '${r_length}' 

# This keyword is used to extract the right vip value from Feature Template based on vipType
Should Be Equal Value Json String FT
   [Arguments]   ${json}    ${json_path}   ${value}=${EMPTY}  ${msg}=${EMPTY}
   ${r_value_viptype}=   Get Value From Json   ${json}    ${json_path}.vipType
   IF    ${r_value_viptype} != []
      ${r_value_vipvalue}=   Get Value From Json   ${json}    ${json_path}.vipValue
      ${r_value_vipvariable}=   Get Value From Json   ${json}    ${json_path}.vipVariableName
      IF    "${r_value_viptype}[0]"=="constant"
         ${r_value_vip}=   Set Variable    ${r_value_vipvalue}
         ${r_value_msg_suffix}=  Set Variable    ${EMPTY}
      ELSE IF    "${r_value_viptype}[0]"=="variableName"
         ${r_value_vip}=  Set Variable    ${r_value_vipvariable}
         ${r_value_msg_suffix}=  Set Variable    variable
      ELSE
         ${r_value_vip}=  Set Variable    [${EMPTY}]
            ${r_value_msg_suffix}=  Set Variable    ${EMPTY}
      END
      ${r_value}=   Set Variable If    ${r_value_vip} == []    not_defined    ${r_value_vip[0]}
   ELSE
      ${r_value}=   Set Variable    not_defined
      ${r_value_msg_suffix}=  Set Variable    ${EMPTY}
   END
   Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Strings    ${r_value}    ${value}    msg=${msg} ${r_value_msg_suffix}

# This keyword is used to retrieve the correct VIP value from the Feature Template based on the vipType when the value is provided as a list.
Should Be Equal Value Json List FT
   [Arguments]   ${json}    ${json_path}   ${value}=["not_defined"]  ${msg}=${EMPTY}
   ${l_value_viptype}=    Get Value From Json    ${json}    ${json_path}.vipType
   IF    ${l_value_viptype} != []
      ${l_value}=    Get Value From Json    ${json}    ${json_path}.vipValue
      ${l_value_variable}=    Get Value From Json    ${json}    ${json_path}.vipVariableName
      IF    "${l_value_viptype}[0]"=="constant"
         Lists Should Be Equal    ${l_value[0]}    ${value}    ignore_order=True    msg=${msg}
      ELSE IF    "${l_value_viptype}[0]"=="variableName"
         Should Be Equal As Strings    ${l_value_variable[0]}    ${value[0]}    msg=${msg} variable
      ELSE
         Should Be Equal As Strings    not_defined    ${value[0]}    msg=${msg}
      END
   ELSE
      Should Be Equal As Strings    not_defined    ${value[0]}    msg=${msg}
   END

Should Be Equal Value Json Yaml
    [Arguments]    ${json}    ${json_path}    ${value}    ${var_value}    ${msg}    ${var_msg}
    ${opt_type}=    Get Value From Json    ${json}    ${json_path}.optionType
    IF    ${opt_type} == ['global']
        ${type_check}=    Evaluate    type($value).__name__
        IF    '${type_check}' == 'list'
            ${dt_list}=    Get Value From Json    ${json}    ${json_path}.value
            ${r_dt_list}=    Evaluate    [str(element) for element in ${dt_list}[0]]
            Lists Should Be Equal    ${r_dt_list}    ${value}    ignore_order=True    values=False    msg=${msg} expected: '${value}' and got: '${r_dt_list}'
        ELSE
            Should Be Equal Value Json String    ${json}    ${json_path}.value    ${value}    msg=${msg}
        END 
    ELSE IF    ${opt_type} == ['variable']
        ${r_value}=    Get Value From Json    ${json}    ${json_path}.value
        ${r_value}=    Evaluate    '${r_value[0]}'.replace("{", "").replace("}", "")
        Should Be Equal As Strings    ${var_value}    ${r_value}    values=False    msg=${var_msg} expected: '${var_value}' and got: '${r_value}'
    ELSE
        Should Be Equal As Strings    not_defined    ${value}    values=False    msg=${msg} expected: '${value}' and got: 'not_defined'    
        Should Be Equal As Strings    not_defined    ${var_value}    values=False    msg=${var_msg} expected: '${var_value}' and got: 'not_defined'
    END

# This keyword is same as "Should Be Equal Value Json String" but it normalizes the special characters and spaces for robot evaluation
Should Be Equal Value Json Special_String
   [Arguments]   ${json}    ${json_path}   ${value}=${EMPTY}  ${msg}=${EMPTY}
   ${r_value}=   Get Value From Json   ${json}   ${json_path}
   TRY
      ${r_value}=   Set Variable If    ${r_value} == [] or ${r_value} == ['']    not_defined    ${r_value}[0]
   EXCEPT
      ${r_value}=   Set Variable    not_defined
   END
   ${r_value}=   normalize escapes spaces    text=${r_value}
   ${value}=   normalize escapes spaces    text=${value}
   Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Strings    ${r_value}    ${value}    msg=${msg} expected: '${value}' and got: '${r_value}'

# This keyword is same as "Should Be Equal Value Json String FT" but it normalizes the special characters and spaces for robot evaluation
Should Be Equal Value Json Special_String FT
   [Arguments]   ${json}    ${json_path}   ${value}=${EMPTY}  ${msg}=${EMPTY}
   ${r_value_viptype}=   Get Value From Json   ${json}    ${json_path}.vipType
   IF    ${r_value_viptype} != []
      ${r_value_vipvalue}=   Get Value From Json   ${json}    ${json_path}.vipValue
      ${r_value_vipvariable}=   Get Value From Json   ${json}    ${json_path}.vipVariableName
      IF    "${r_value_viptype}[0]"=="constant"
         ${r_value_vip}=   Set Variable    ${r_value_vipvalue}
         ${r_value_msg_suffix}=  Set Variable    ${EMPTY}
      ELSE IF    "${r_value_viptype}[0]"=="variableName"
         ${r_value_vip}=  Set Variable    ${r_value_vipvariable}
         ${r_value_msg_suffix}=  Set Variable    variable
      ELSE
         ${r_value_vip}=  Set Variable    [${EMPTY}]
         ${r_value_msg_suffix}=  Set Variable    ${EMPTY}
      END
      ${r_value}=   Set Variable If    ${r_value_vip} == []    not_defined    ${r_value_vip}
   ELSE
      ${r_value}=   Set Variable    not_defined
      ${r_value_msg_suffix}=  Set Variable    ${EMPTY}
   END
   TRY
      ${r_value}=   Set Variable If    ${r_value} == []    not_defined    ${r_value}[0]
   EXCEPT
      ${r_value}=   Set Variable    not_defined
   END
   ${r_value}=   normalize escapes spaces    text=${r_value}
   ${value}=   normalize escapes spaces    text=${value}
   Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Strings    ${r_value}    ${value}    msg=${msg} expected: '${value}' and got: '${r_value}'