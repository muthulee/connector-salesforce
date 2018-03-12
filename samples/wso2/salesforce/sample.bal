package samples.wso2.salesforce;

import ballerina.io;
import ballerina.net.http;
import ballerina.time;
import src.wso2.salesforce_primary as sfp;
import src.wso2.salesforce_secondary as sfs;

http:HttpConnectorError e;
http:InResponse response = {};
error err = {};


string baseUrl = "https://wso2--wsbox.cs8.my.salesforce.com";
string accessToken = "00DL0000002ASPS!ASAAQHyEs5qD9BzTEevUWAIUOjGh0e9zyVIojgS1dLwNXhlMBXGre8IwNoruuV6joCjAR0qG1B8KhNOxYSczwOuRmCEQU6LG";
string clientId = "3MVG9MHOv_bskkhSA6dmoQao1M5bAQdCQ1ePbHYQKaoldqFSas7uechL0yHewu1QvISJZi2deUh5FvwMseYoF";
string clientSecret = "1164810542004702763";
string refreshToken = "5Aep86161DM2BuiV6zOy.J2C.tQMhSDLfkeFVGqMEInbvqLfxzBz58_XPXLUMpHViE8EqTjdV7pvnI1xq8pMfOA";
string refreshTokenEndpoint = "https://test.salesforce.com";
string refreshTokenPath = "/services/oauth2/token";
string apiVersion = "v37.0";
string sampleSObjectAccount = "Account";
string sampleSObjectLead = "Lead";
string sampleSObjectProduct = "Product";
string sampleSObjectContact = "Contact";
string sampleSObjectOpportunity = "Opportunity";
string namedLayoutInfo = "";

public function main (string[] args) {

    endpoint<sfp:CoreClientConnector> salesforceCoreConnector {
        create sfp:CoreClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndpoint, refreshTokenPath, apiVersion);
    }

    endpoint<sfs:ClientConnector> salesforceConnector {
        create sfs:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndpoint, refreshTokenPath, apiVersion);
    }

    sfp:SalesforceConnectorError err;
    json jsonResponse;

    time:Time now = time:currentTime();
    string endDateTime = now.format("yyyy-MM-dd'T'HH:mm:ssZ");
    time:Time weekAgo = now.subtractDuration(0, 0, 7, 0, 0, 0, 0);
    string startDateTime = weekAgo.format("yyyy-MM-dd'T'HH:mm:ssZ");

    io:println("------------------------MAIN METHOD: API Versions----------------------");
    json[] apiVersions;
    apiVersions, err = salesforceCoreConnector.listAvailableApiVersions();
    checkErrors(err);
    io:println("Found " + lengthof apiVersions + " API versions");

    jsonResponse, err = salesforceCoreConnector.listResourcesByApiVersion();
    checkErrors(err);
    io:println(string `Number of resources by API Version {{apiVersion}}: {{lengthof jsonResponse.getKeys()}}`);

    io:println("\n------------------------MAIN METHOD: Organizational Limits-------------------------");
    jsonResponse, err = salesforceCoreConnector.listOrganizationLimits();
    checkErrors(err);
    io:println(string `There are resource limits for {{lengthof jsonResponse.getKeys()}} resources`);


    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    // ============================ Describe SObjects available and their fields/metadata ===================== //

    io:println("\n-----------------------MAIN METHOD: Describe global and sobject metadata---------------------------");
    jsonResponse, err = salesforceCoreConnector.describeGlobal();
    checkErrors(err);
    io:println(string `Global has {{lengthof jsonResponse.sobjects}} sobjects`);

    jsonResponse, err = salesforceCoreConnector.getSObjectBasicInfo(sampleSObjectAccount);
    checkErrors(err);
    io:println(string `SObject '{{sampleSObjectAccount}}' has {{lengthof jsonResponse.objectDescribe.getKeys()}} keys and {{lengthof jsonResponse.recentItems}} recent items`);

    jsonResponse, err = salesforceCoreConnector.describeSObject(sampleSObjectAccount);
    checkErrors(err);
    io:println(string `Describe {{sampleSObjectAccount}} has {{lengthof jsonResponse.fields}} fields and {{lengthof jsonResponse.childRelationships}} child relationships`);
    jsonResponse, err = salesforceCoreConnector.describeSObject(sampleSObjectAccount);
    io:println(string `Describe {{sampleSObjectAccount}} has {{lengthof jsonResponse.fields}} fields and {{lengthof jsonResponse.childRelationships}} child relationships`);

    ////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////

    io:println("\n------------------------MAIN METHOD: Handling Records---------------------------");
    json account = {Name:"ABC Inc", BillingCity:"New York", Global_POD__c:"UK"};
    json lead = {};
    string id;


    /////////////////////////////////////////////////////////////////////////////////////////////////
    // ============================ Get, create, update, delete records ========================== //

    id, err = salesforceCoreConnector.createRecord(sampleSObjectAccount, account);
    if (err == null) {
        io:println(string `Created {{sampleSObjectAccount}} with id: {{id}}`);
    } else {
        io:println(string `Error occurred when creating {{sampleSObjectAccount}}: {{err.messages[0]}}`);
        return;
    }

    jsonResponse, err = salesforceCoreConnector.getRecord(sampleSObjectAccount, id);
    checkErrors(err);
    io:println(string `Name of {{sampleSObjectAccount}} with id {{id}} is {{jsonResponse.Name.toString()}}`);

    account.Name = "ABC Pvt Ltd";
    boolean isUpdated;
    isUpdated, err = salesforceCoreConnector.updateRecord(sampleSObjectAccount, id, account);
    if (isUpdated) {
        io:println(string `{{sampleSObjectAccount}} successfully updated`);
    } else {
        io:println(string `Error occurred when updating {{sampleSObjectAccount}}: {{err.messages[0]}}`);
    }

    //TODO Error occurs due to empty payload
    boolean isDeleted;
    isDeleted, err = salesforceCoreConnector.deleteRecord(sampleSObjectAccount, id);
    if (isDeleted) {
        io:println(string `{{sampleSObjectAccount}}[{{id}}] successfully deleted`);
    } else {
        io:println(string `Error occurred when deleting {{sampleSObjectAccount}}[{{id}}]: {{err.messages[0]}}`);
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    // ============================ Create, update, delete records by External IDs ===================== //

    // TODO Make this part work by creating an actual external ID in salesforce
    io:println("\n------------------------MAIN METHOD: Handling records by External IDs-----------");
    account.Name = "Updated Logistics and Transport";
    jsonResponse, err = salesforceCoreConnector.upsertSObjectByExternalId(sampleSObjectAccount, "id__c", "123456", account);
    if (err == null) {
        io:println("Upsert successful: " + jsonResponse.toString());
    } else {
        io:println(string `Error occurred when upserting {{sampleSObjectAccount}}: {{err.messages[0]}}`);
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////
    // ============================ Get updated and deleted records ============================= //

    io:println("\n------------------------MAIN METHOD: Get updated and deleted----------------");
    jsonResponse, err = salesforceCoreConnector.getDeletedRecords(sampleSObjectAccount, startDateTime, endDateTime);
    checkErrors(err);
    io:println(string `Found {{lengthof jsonResponse.deletedRecords}} deleted records`);

    jsonResponse, err = salesforceCoreConnector.getUpdatedRecords(sampleSObjectAccount, startDateTime, endDateTime);
    checkErrors(err);
    io:println(string `Found {{lengthof jsonResponse.ids}} ids of updated records`);

    io:println("\n------------------------MAIN METHOD: Executing queries----------------");
    sfp:QueryResult queryResult;

    queryResult, err = salesforceCoreConnector.query("SELECT name FROM Account");
    checkErrors(err);
    io:println(string `Found {{lengthof queryResult.records}} results. Next result URL: {{queryResult.nextRecordsUrl}}`);

    while (queryResult.nextRecordsUrl != null) {
        queryResult, err = salesforceCoreConnector.nextQueryResult(queryResult.nextRecordsUrl);
        io:println(string `Found {{lengthof queryResult.records}} results. Next result URL: {{queryResult.nextRecordsUrl}}`);
    }

    sfp:QueryPlan[] queryPlans;

    queryPlans, err = salesforceCoreConnector.explainQueryReportOrListview("SELECT name FROM Account");
    checkErrors(err);
    io:println(string `Found {{lengthof queryPlans}} query plans`);
    io:println(queryPlans);


    /////////////////////////////////////////////////////////////////////////////////////////////////////
    // ============================ ACCOUNT SObject: get, create, update, delete ===================== //

    id, err = salesforceConnector.createAccount(account);
    if (err == null) {
        io:println(string `Created {{sampleSObjectAccount}} with id: {{id}}`);
    } else {
        io:println(string `Error occurred when creating {{sampleSObjectAccount}}: {{err.messages[0]}}`);
        return;
    }

    jsonResponse, err = salesforceConnector.getAccountById(id);
    io:println(string `Name of {{sampleSObjectAccount}} with id {{id}} is {{jsonResponse.Name.toString()}}`);

    account.Name = "ABC Pvt Ltd";
    isUpdated, err = salesforceConnector.updateAccount(id, account);
    if (isUpdated) {
        io:println(string `{{sampleSObjectAccount}} successfully updated`);
    } else {
        io:println(string `Error occurred when updating {{sampleSObjectAccount}}: {{err.messages[0]}}`);
    }
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //// ============================ LEAD SObject: get, create, update, delete ===================== //
    //
    //id, err = salesforceConnector.createLead(lead);
    //if (err == null) {
    //    io:println(string `Created {{sampleSObjectLead}} with id: {{id}}`);
    //} else {
    //    io:println(string `Error occurred when creating {{sampleSObjectLead}}: {{err.messages[0]}}`);
    //    return;
    //}
    //
    //jsonResponse, err = salesforceConnector.getAccountById(id);
    //io:println(string `Name of {{sampleSObjectLead}} with id {{id}} is {{jsonResponse.Name.toString()}}`);
    //
    //account.Name = "ABC Pvt Ltd";
    //boolean isUpdated;
    //isUpdated, err = salesforceConnector.updateAccount(id);
    //if (isUpdated) {
    //    io:println(string `{{sampleSObjectAccount}} successfully updated`);
    //} else {
    //    io:println(string `Error occurred when updating {{sampleSObjectLead}}: {{err.messages[0]}}`);
    //}

}

function checkErrors (sfp:SalesforceConnectorError err) {
    if (err != null) {
        if (err.connectionError != null) {
            io:println(string `Connection error: {{err.connectionError.message}}`);
        } else {
            io:println(string `Salesforce Error {{err.salesforceErrors[0].message}} with error code: {{err.salesforceErrors[0].errorCode}}`);
        }
    }
}