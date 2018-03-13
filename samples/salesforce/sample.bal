//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

package samples.salesforce;

import ballerina.io;
import ballerina.time;
import src.salesforce_primary as sfp;
import src.salesforce_secondary as sfs;

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

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

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


    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    io:println("\n------------------------MAIN METHOD: Handling Records---------------------------");
    json account = {Name:"ABC Inc", BillingCity:"New York", Global_POD__c:"UK"};
    json lead = {LastName:"Carmen", Company:"WSO2", City:"New York"};
    json contact = {LastName:"Patson"};
    json opportunity = {Name:"IoT", StageName:"30 - Proposal/Price Quote", CloseDate:"2011-07-14T19:43:37+0100", Description:"Opportunity for IoT and Cloud"};
    json product = {Name:"APIM", Description:"APIM product"};
    string accountId;
    string leadId;
    string contactId;
    string opportunityId;
    string productId;


    /////////////////////////////////////////////////////////////////////////////////////////////////
    // ============================ Get, create, update, delete records ========================== //

    jsonResponse, err = salesforceCoreConnector.createRecord(sampleSObjectAccount, account);
    if (err == null) {
        accountId = jsonResponse.id.toString();
        io:println(string `Created {{sampleSObjectAccount}} with id: {{accountId}}`);
    } else {
        io:println(string `Error occurred when creating {{sampleSObjectAccount}}: {{err.messages[0]}}`);
        return;
    }

    jsonResponse, err = salesforceCoreConnector.getRecord(sampleSObjectAccount, accountId);
    checkErrors(err);
    io:println(string `Name of {{sampleSObjectAccount}} with id {{accountId}} is {{jsonResponse.Name.toString()}}`);

    account.Name = "ABC Pvt Ltd";
    boolean isUpdated;
    isUpdated, err = salesforceCoreConnector.updateRecord(sampleSObjectAccount, accountId, account);
    if (isUpdated) {
        io:println(string `{{sampleSObjectAccount}} successfully updated`);
    } else {
        io:println(string `Error occurred when updating {{sampleSObjectAccount}}: {{err.messages[0]}}`);
    }

    boolean isDeleted;
    isDeleted, err = salesforceCoreConnector.deleteRecord(sampleSObjectAccount, accountId);
    if (isDeleted) {
        io:println(string `{{sampleSObjectAccount}}[{{accountId}}] successfully deleted`);
    } else {
        io:println(string `Error occurred when deleting {{sampleSObjectAccount}}[{{accountId}}]: {{err.messages[0]}}`);
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    // ============================ Create, update, delete records by External IDs ===================== //

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

    io:println("\n------------------------ACCOUNT SObjecct Information----------------");
    accountId, err = salesforceConnector.createAccount(account);
    if (err == null) {
        io:println(string `Created {{sampleSObjectAccount}} with id: {{accountId}}`);
    } else {
        io:println(string `Error occurred when creating {{sampleSObjectAccount}}: {{err.messages[0]}}`);
        return;
    }

    jsonResponse, err = salesforceConnector.getAccountById(accountId);
    io:println(string `Name of {{sampleSObjectAccount}} with id {{accountId}} is {{jsonResponse.Name.toString()}}`);

    account.Name = "ABC Pvt Ltd";
    isUpdated, err = salesforceConnector.updateAccount(accountId, account);
    if (isUpdated) {
        io:println(string `{{sampleSObjectAccount}} successfully updated`);
    } else {
        io:println(string `Error occurred when updating {{sampleSObjectAccount}}: {{err.messages[0]}}`);
    }

    isDeleted, err = salesforceConnector.deleteAccount(accountId);
    if (isDeleted) {
        io:println(string `{{sampleSObjectAccount}}[{{accountId}}] successfully deleted`);
    } else {
        io:println(string `Error occurred when deleting {{sampleSObjectAccount}}[{{accountId}}]: {{err.messages[0]}}`);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //// ============================ LEAD SObject: get, create, update, delete ===================== //

    io:println("\n------------------------LEAD SObjecct Information-----------------------");
    leadId, err = salesforceConnector.createLead(lead);
    if (err == null) {
        io:println(string `Created {{sampleSObjectLead}} with id: {{leadId}}`);
    } else {
        io:println(string `Error occurred when creating {{sampleSObjectLead}}: {{err.messages[0]}}`);
        return;
    }

    jsonResponse, err = salesforceConnector.getLeadById(leadId);
    io:println(string `Name of {{sampleSObjectLead}} with id {{leadId}} is {{jsonResponse.LastName.toString()}}`);

    lead.City = "Colombo";
    isUpdated, err = salesforceConnector.updateLead(leadId, lead);
    if (isUpdated) {
        io:println(string `{{sampleSObjectLead}} successfully updated`);
    } else {
        io:println(string `Error occurred when updating {{sampleSObjectLead}}: {{err.messages[0]}}`);
    }

    isDeleted, err = salesforceConnector.deleteLead(leadId);
    if (isDeleted) {
        io:println(string `{{sampleSObjectLead}}[{{leadId}}] successfully deleted`);
    } else {
        io:println(string `Error occurred when deleting {{sampleSObjectLead}}[{{leadId}}]: {{err.messages[0]}}`);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //// ============================ Contact SObject: get, create, update, delete ===================== //

    io:println("\n------------------------CONTACT SObjecct Information-----------------------");
    contactId, err = salesforceConnector.createContact(contact);
    if (err == null) {
        io:println(string `Created {{sampleSObjectContact}} with id: {{contactId}}`);
    } else {
        io:println(string `Error occurred when creating {{sampleSObjectContact}}: {{err.messages[0]}}`);
        return;
    }

    jsonResponse, err = salesforceConnector.getContactById(contactId);
    io:println(string `Name of {{sampleSObjectContact}} with id {{contactId}} is {{jsonResponse.LastName.toString()}}`);

    contact.LastName = "Perterson";
    isUpdated, err = salesforceConnector.updateContact(contactId, contact);
    if (isUpdated) {
        io:println(string `{{sampleSObjectContact}} successfully updated`);
    } else {
        io:println(string `Error occurred when updating {{sampleSObjectContact}}: {{err.messages[0]}}`);
    }

    isDeleted, err = salesforceConnector.deleteContact(contactId);
    if (isDeleted) {
        io:println(string `{{sampleSObjectContact}}[{{contactId}}] successfully deleted`);
    } else {
        io:println(string `Error occurred when deleting {{sampleSObjectContact}}[{{contactId}}]: {{err.messages[0]}}`);
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// ========================= Opportunities SObject: get, create, update, delete =================== //
    //
    //io:println("\n------------------------OPPORTUNITIES SObjecct Information-----------------------");
    //json responseOpportunity;
    //responseOpportunity, err = salesforceConnector.createOpportunity(opportunity);
    //if (err == null) {
    //    io:println(responseOpportunity);
    //    io:println(string `Created {{sampleSObjectOpportunity}} with id: {{opportunityId}}`);
    //} else {
    //    io:println(string `Error occurred when creating {{sampleSObjectOpportunity}}: {{err.messages[0]}}`);
    //    return;
    //}
    //
    //jsonResponse, err = salesforceConnector.getOpportunityById(opportunityId);
    //io:println(string `Name of {{sampleSObjectOpportunity}} with id {{opportunityId}} is {{jsonResponse.CloseDate.toString()}}`);
    //
    //contact.Name = "Cloud";
    //isUpdated, err = salesforceConnector.updateOpportunity(opportunityId, opportunity);
    //if (isUpdated) {
    //    io:println(string `{{sampleSObjectOpportunity}} successfully updated`);
    //} else {
    //    io:println(string `Error occurred when updating {{sampleSObjectOpportunity}}: {{err.messages[0]}}`);
    //}
    //
    //isDeleted, err = salesforceConnector.deleteOpportunity(opportunityId);
    //if (isDeleted) {
    //    io:println(string `{{sampleSObjectOpportunity}}[{{opportunityId}}] successfully deleted`);
    //} else {
    //    io:println(string `Error occurred when deleting {{sampleSObjectOpportunity}}[{{contactId}}]: {{err.messages[0]}}`);
    //}

    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //// ============================ Products SObject: get, create, update, delete ===================== //

    io:println("\n------------------------PRODUCTS SObjecct Information-----------------------");
    productId, err = salesforceConnector.createProduct(product);
    if (err == null) {
        io:println(string `Created {{sampleSObjectProduct}} with id: {{productId}}`);
    } else {
        io:println(string `Error occurred when creating {{sampleSObjectProduct}}: {{err.messages[0]}}`);
        return;
    }

    jsonResponse, err = salesforceConnector.getProductById(productId);
    io:println(string `Name of {{sampleSObjectProduct}} with id {{productId}} is {{jsonResponse.Description.toString()}}`);

    contact.Description = "APIM and IS product";
    isUpdated, err = salesforceConnector.updateProduct(productId, product);
    if (isUpdated) {
        io:println(string `{{sampleSObjectProduct}} successfully updated`);
    } else {
        io:println(string `Error occurred when updating {{sampleSObjectProduct}}: {{err.messages[0]}}`);
    }

    isDeleted, err = salesforceConnector.deleteProduct(productId);
    if (isDeleted) {
        io:println(string `{{sampleSObjectProduct}}[{{productId}}] successfully deleted`);
    } else {
        io:println(string `Error occurred when deleting {{sampleSObjectProduct}}[{{productId}}]: {{err.messages[0]}}`);
    }
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