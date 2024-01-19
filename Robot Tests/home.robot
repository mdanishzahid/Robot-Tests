*** Settings ***
Library           SeleniumLibrary
Library           RequestsLibrary

*** Variables ***
${BASE_URL}       http://your-app-base-url

*** Test Cases ***
Should Have Necessary UI Elements For Adding A Book
    Open Browser    ${BASE_URL}/add-book    browser=chrome
    Page Should Contain Element    id=title-input
    Page Should Contain Element    id=author-input
    Page Should Contain Element    id=submit-button
    Close Browser

Should Add A New Book Successfully
    Open Browser    ${BASE_URL}/add-book    browser=chrome
    Input Text    id=title-input    Sample Book
    Input Text    id=author-input    John Doe
    Click Button    id=submit-button
    Location Should Contain    /books
    Page Should Contain    Sample Book by John Doe
    Close Browser

Should Show Validation Messages For Missing Data
    Open Browser    ${BASE_URL}/add-book    browser=chrome
    Click Button    id=submit-button
    Page Should Contain    Please enter a title
    Page Should Contain    Please enter an author
    Close Browser

Should Display Book Details On Click
    Open Browser    ${BASE_URL}/books    browser=chrome
    Click Element    css=.book-item:first-child
    Location Should Contain    /books/
    Page Should Contain Element    class=book-details
    Close Browser

Should Delete A Book Successfully
    Open Browser    ${BASE_URL}/books    browser=chrome
    Click Element    css=.book-item:first-child .delete-button
    Page Should Contain    Book deleted successfully
    Wait Until Element Is Visible    css=.book-item
    Page Should Contain    ${1} element${/s*} matching css:.book-item
    Close Browser

Should Have Necessary UI Elements For Editing A Book
    Open Browser    ${BASE_URL}/books    browser=chrome
    Page Should Contain Element    css=.edit-button
    Close Browser

Should Edit An Existing Book Successfully
    Open Browser    ${BASE_URL}/books    browser=chrome
    Click Element    css=.edit-button:first-child
    Input Text    id=title-input    Updated Book Title
    Input Text    id=author-input    Jane Doe
    Click Button    id=save-button
    Page Should Contain    Book updated successfully
    Page Should Contain    Updated Book Title by Jane Doe
    Close Browser

Should Display Updated Book Details After Edit
    Open Browser    ${BASE_URL}/books    browser=chrome
    Click Element    css=.edit-button:first-child
    Input Text    id=title-input    Updated Book Title
    Input Text    id=author-input    Jane Doe
    Click Button    id=save-button
    Click Element    css=.book-item:first-child
    Page Should Contain    Updated Book Title by Jane Doe
    Close Browser

*** Test Cases ***
Backend Connection
    ${response}=    Get Request    ${BASE_URL}/api
    Should Be Equal As Numbers    ${response.status_code}    200

Create Operation
    ${new_book}=    Create Dictionary    title=New Book    author=New Author    publishYear=2024
    ${response}=    Post Request    ${BASE_URL}/api/books    data=${new_book}
    Should Be Equal As Numbers    ${response.status_code}    201

Read Operation
    ${response}=    Get Request    ${BASE_URL}/api/books
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Greater Than    ${response.json()['count']}    0

    ${book_id}=    Set Variable    your_book_id
    ${response}=    Get Request    ${BASE_URL}/api/books/${book_id}
    Should Be Equal As Numbers    ${response.status_code}    200

Update Operation
    ${book_id}=    Set Variable    your_book_id
    ${updated_book}=    Create Dictionary    title=Updated Book Title    author=Updated Author    publishYear=2025
    ${response}=    Put Request    ${BASE_URL}/api/books/${book_id}    data=${updated_book}
    Should Be Equal As Numbers    ${response.status_code}    200

Delete Operation
    ${book_id}=    Set Variable    your_book_id
    ${response}=    Delete Request    ${BASE_URL}/api/books/${book_id}
    Should Be Equal As Numbers    ${response.status_code}    200
