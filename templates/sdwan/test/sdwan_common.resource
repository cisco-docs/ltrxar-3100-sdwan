*** Settings ***
Library   pabot.PabotLib
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   OperatingSystem
Library   String

*** Variables ***
&{login_json}=   j_username=%{SDWAN_USERNAME}   j_password=%{SDWAN_PASSWORD}
&{headers}=   content-type=application/x-www-form-urlencoded

*** Keywords ***
Get SDWAN Manager Token
   Create Session   login   %{SDWAN_URL}   verify=${False}   disable_warnings=1   headers=${headers}
   ${log_level}=   Set Log Level   NONE
   ${response}=   Wait Until Keyword Succeeds   6x   10s   POST On Session   login   /j_security_check   data=${login_json}
   Set Log Level   ${log_level}
   ${r_token}=   GET On Session   login   /dataservice/client/token
   ${cookie}=   Get from dictionary   ${response.headers}   set-cookie
   ${r_cookie}=   Split string   ${cookie}   separator=;
   Set Parallel Value For Key   manager_token   ${r_token.text}
   Set Parallel Value For Key   manager_cookie   ${r_cookie[0]}

Login SDWAN Manager
   Run Only Once   Get SDWAN Manager Token
   ${manager_token}=   Get Parallel Value For Key   manager_token
   ${manager_cookie}=   Get Parallel Value For Key   manager_cookie
   ${m_headers}=   Create Dictionary   X-XSRF-TOKEN=${manager_token}   Cookie=${manager_cookie}   accept=application/json
   Create Session   sdwan_manager   %{SDWAN_URL}   headers=${m_headers}

Logout SDWAN Manager
   ${manager_cookie}=   Get Parallel Value For Key   manager_cookie
   ${m_headers}=   Create Dictionary   Cookie=${manager_cookie}   accept=*/*
   ${response}=   Wait Until Keyword Succeeds   6x   10s   GET On Session   sdwan_manager   /logout   headers=${m_headers}

Should Be Equal Value Json String
   [Arguments]   ${json}    ${json_path}   ${value}=${EMPTY}  ${msg}=${EMPTY}
   ${r_value}=   Get Value From Json   ${json}   ${json_path}
   ${r_value}=   Set Variable If    ${r_value} == []    not_defined    ${r_value[0]}
   Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Strings    ${r_value}    ${value}    msg=${msg} mismatch

Should Be Equal Value Json List
   [Arguments]   ${json}   ${json_path}   ${value}=${None}   ${msg}=${EMPTY}
   ${r_value}=   Get Value From Json   ${json}   ${json_path}
   Run Keyword If   "${value}" != "${None}"   Lists Should Be Equal   ${r_value}   ${value}   ignore_order=True   msg=${msg} mismatch
