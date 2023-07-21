*** Settings ***
Documentation       Robot for ordering robots


Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.HTTP
Library    RPA.Tasks
Library    RPA.Excel.Files
Library    RPA.Netsuite
Library    RPA.Tables

*** Tasks ***
Logging into Application
    open the robot order website
    Download the orders file
    #Fill the form to order robots
    Fetch CSV file records



*** Keywords ***
open the robot order website
    Open Available Browser    https://robotsparebinindustries.com/#/
    Click Link    xpath://*[@id="root"]/header/div/ul/li[2]/a
    Click Button    OK

Download the orders file
    Download     https://robotsparebinindustries.com/orders.csv
  

Fill the form to order robots
    [Arguments]    ${order}
    Select From List By Value    head    ${order}[Head]
    Select Radio Button    body    ${order}[Body]
    Input Text    xpath://input[starts-with(@id,"168")]    ${order}[Legs]    
    Input Text    address    ${order}[Address]
    Run until element success    Click Button    Preview
    Run until element success    Click Button    xpath://button[contains(text(),'Order')]
    Run until element success    Click Button    Order another robot
    Run until element success    Click Button    OK

Fetch CSV file records
    ${orderrecords}=    Read table from CSV    orders.csv
    FOR    ${order}    IN    @{orderrecords}
        Fill the form to order robots    ${order}
        
    END

Run until element success
    [Arguments]    ${KW}    @{KWARGS}
    Wait Until Keyword Succeeds    20s    1s    ${KW}    @{KWARGS}    

    #${orderrecords} = Table(columns=['Order number', 'Head', 'Body', 'Legs', 'Address'], rows=20)	
    # Retry with a one-minute timeout and at one second intervals.
#Wait Until Keyword Succeeds    1 min    1 sec    Your keyword that you want to retry