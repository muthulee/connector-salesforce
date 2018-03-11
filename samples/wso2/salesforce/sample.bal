package samples.wso2.salesforce;

import ballerina.io;
import ballerina.net.http;
import ballerina.time;
import src.wso2.salesforce;

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
string sampleSObject = "Account";
string namedLayoutInfo = "";

public function main (string[] args) {

    //calling the ClientConnector and creating the instance
    endpoint<salesforce:ClientConnector> salesforceConnector {
        create salesforce:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndpoint, refreshTokenPath, apiVersion);
    }

    salesforce:SalesforceConnectorError err;
    json jsonResponse;
    time:Time now = time:currentTime();
    string endDateTime = now.format("yyyy-MM-dd'T'HH:mm:ssZ");
    time:Time weekAgo = now.subtractDuration(0, 0, 7, 0, 0, 0, 0);
    string startDateTime = weekAgo.format("yyyy-MM-dd'T'HH:mm:ssZ");

    io:println("------------------------MAIN METHOD: API Versions----------------------");
    json[] apiVersions;
    apiVersions, err = salesforceConnector.listAvailableApiVersions();
    io:println("Found " + lengthof apiVersions + " API versions");

    jsonResponse, err = salesforceConnector.listResourcesByApiVersion();
    io:println(string `Number of resources by API Version {{apiVersion}}: {{lengthof jsonResponse.getKeys()}}`);

    io:println("\n------------------------MAIN METHOD: Organizational Limits-------------------------");
    jsonResponse, err = salesforceConnector.listOrganizationLimits();
    io:println(string `There are resource limits for {{lengthof jsonResponse.getKeys()}} resources`);

    io:println("\n-----------------------MAIN METHOD: Describe global and sobject metadata---------------------------");
    jsonResponse, err = salesforceConnector.describeGlobal();
    io:println(string `Global has {{lengthof jsonResponse.sobjects}} sobjects`);

    jsonResponse, err = salesforceConnector.getSObjectBasicInfo(sampleSObject);
    io:println(string `SObject '{{sampleSObject}}' has {{lengthof jsonResponse.objectDescribe.getKeys()}} keys and {{lengthof jsonResponse.recentItems}} recent items`);

    jsonResponse, err = salesforceConnector.describeSObject(sampleSObject);
    io:println(string `Describe {{sampleSObject}} has {{lengthof jsonResponse.fields}} fields and {{lengthof jsonResponse.childRelationships}} child relationships`);

    io:println("\n------------------------MAIN METHOD: Handling Records---------------------------");
    json account = {Name:"ABC Inc", BillingCity:"New York", Global_POD__c:"UK"};
    string id;

    jsonResponse, err = salesforceConnector.createRecord(sampleSObject, account);
    if (err == null) {
        id = jsonResponse.id.toString();
        io:println(string `Created {{sampleSObject}} with id: {{id}}`);
    } else {
        io:println(string `Error occurred when creating {{sampleSObject}}: {{err.messages[0]}}`);
        return;
    }

    jsonResponse, err = salesforceConnector.getRecord(sampleSObject, id);
    io:println(string `Name of {{sampleSObject}} with id {{id}} is {{jsonResponse.Name.toString()}}`);

    account.Name = "ABC Pvt Ltd";
    jsonResponse, err = salesforceConnector.updateRecord(sampleSObject, id, account);
    if (err == null) {
        io:println(string `{{sampleSObject}} successfully updated`);
    } else {
        io:println(string `Error occurred when updating {{sampleSObject}}: {{err.messages[0]}}`);
    }

    // TODO Error occurs due to empty payload
    //jsonResponse, err = salesforceConnector.deleteRecord(sampleSObject, id);
    //if (err == null) {
    //    io:println(string `{{sampleSObject}}[{{id}}] successfully deleted`);
    //} else {
    //    io:println(string `Error occurred when deleting {{sampleSObject}}[{{id}}]: {{err.messages[0]}}`);
    //}

    // TODO Make this part work by creating an actual external ID in salesforce
    io:println("\n------------------------MAIN METHOD: Handling records by External IDs-----------");
    account.Name = "Updated Logistics and Transport";
    jsonResponse, err = salesforceConnector.upsertSObjectByExternalId(sampleSObject, "id__c", "123456", account);
    if (err == null) {
        io:println("Upsert successful: " + jsonResponse.toString());
    } else {
        io:println(string `Error occurred when upserting {{sampleSObject}}: {{err.messages[0]}}`);
    }

    io:println("\n------------------------MAIN METHOD: Get updated and deleted----------------");
    jsonResponse, err = salesforceConnector.getDeletedRecords(sampleSObject, startDateTime, endDateTime);
    io:println(string `Found {{lengthof jsonResponse.deletedRecords}} deleted records`);

    jsonResponse, err = salesforceConnector.getUpdatedRecords(sampleSObject, startDateTime, endDateTime);
    io:println(string `Found {{lengthof jsonResponse.ids}} ids of updated records`);
}
