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

package src.salesforce;

import ballerina.net.http;
import oauth2;

//@Description {value:"Salesforce Client Connector"}
//public struct SalesforceConnector {
//    oauth2:OAuth2Client oauth2;
//}
//
//public function <SalesforceConnector sfConnector> init (string baseUrl, string accessToken, string refreshToken,
//                                                        string clientId, string clientSecret, string refreshTokenEP, string refreshTokenPath) {
//    sfConnector.oauth2 = {};
//    sfConnector.oauth2.init(baseUrl, accessToken, refreshToken,
//                            clientId, clientSecret, refreshTokenEP, refreshTokenPath);
//}
//
//@Description {value:"Lists summary details about each REST API version available"}
//@Return {value:"Array of available API versions"}
//@Return {value:"Error occured"}
//public function <SalesforceConnector sfConnector> getAvailableApiVersions () returns json[] | SalesforceConnectorError {
//    json response;
//    json[] apiVersions;
//    SalesforceConnectorError connectorError;
//
//    string path = prepareUrl([BASE_PATH], null, null);
//    response, connectorError = sfConnector.sendGetRequest(path);
//
//    if (response != null) {
//        apiVersions, _ = (json[])response;
//    }
//
//    return apiVersions, connectorError;
//}
//
//@Description {value:"Lists the resources available for the specified API version"}
//@Return {value:"response message"}
//@Return {value:"Error occurred"}
//public function <SalesforceConnector sfConnector> getResourcesByApiVersion (string apiVersion) returns json | SalesforceConnectorError {
//    json response;
//    SalesforceConnectorError connectorError;
//
//    string path = prepareUrl([BASE_PATH, apiVersion], null, null);
//    var output = sfConnector.sendGetRequest(path);
//    //response, connectorError = sfConnector.sendGetRequest(path);
//}
//
//@Description {value:"Lists limits information for your organization"}
//@Return {value:"response message"}
//@Return {value:"Error occured "}
//public function <SalesforceConnector sfConnector> getOrganizationLimits () returns json | SalesforceConnectorError {
//    json response;
//    SalesforceConnectorError connectorError;
//
//    string path = prepareUrl([API_BASE_PATH, LIMITS], null, null);
//    response, connectorError = sfConnector.sendGetRequest(path);
//
//    return response, connectorError;
//}
//
//// ================================= Query ================================ //
//
////@Description {value:"Executes the specified SOQL query"}
////@Param {value:"query: The request SOQL query"}
////@Return {value:"returns QueryResult struct"}
////@Return {value:"Error occured"}
////public function <SalesforceConnector sfConnector> getQueryResult (string query) returns QueryResult | SalesforceConnectorError {
////    SalesforceConnectorError connectorError;
////    json response;
////
////    string path = prepareUrl([API_BASE_PATH, QUERY], [Q], [query]);
////    response, connectorError = sendGetRequest(path);
////
////    QueryResult result = {};
////
////    if (connectorError != null) {
////        return result, connectorError;
////    }
////
////    result.done, _ = (boolean)response.done;
////    result.totalSize, _ = (int)response.totalSize;
////    result.records, _ = (json[])response.records;
////    if (response.nextRecordsUrl != null) {
////        result.nextRecordsUrl = response.nextRecordsUrl.toString();
////    } else {
////        result.nextRecordsUrl = null;
////    }
////
////    return result, connectorError;
////}
//
////@Description {value:"Returns records that have been deleted because of a merge or delete, archived Task
////     and Event records"}
////@Param {value:"apiVersion: The api version to send request to"}
////@Param {value:"queryString: The request SOQL query"}
////@Return {value:"response message"}
////@Return {value:"Error occured."}
////public function <SalesforceConnector sfConnector> getAllQueries (string query) (QueryResult, SalesforceConnectorError) {
////    SalesforceConnectorError connectorError;
////    json response;
////
////    string path = prepareUrl([API_BASE_PATH, QUERYALL], [Q], [getQueryResult]);
////    response, connectorError = sendGetRequest(path);
////
////    QueryResult result = {};
////
////    if (connectorError != null) {
////        return result, connectorError;
////    }
////
////    result.done, _ = (boolean)response.done;
////    result.totalSize, _ = (int)response.totalSize;
////    result.records, _ = (json[])response.records;
////    if (response.nextRecordsUrl != null) {
////        result.nextRecordsUrl = response.nextRecordsUrl.toString();
////    } else {
////        result.nextRecordsUrl = null;
////    }
////
////    return result, connectorError;
////}
////
////@Description {value:"Get feedback on how Salesforce will execute the query, report, or list view based on performance"}
////@Param {value:"queryReportOrListview: The parameter to get feedback on"}
////@Return {value:"response message"}
////@Return {value:"Error occured"}
////public function <SalesforceConnector sfConnector> explainQueryOrReportOrListview (string queryReportOrListview) (QueryPlan[], SalesforceConnectorError) {
////    SalesforceConnectorError connectorError;
////    json response;
////
////    string path = prepareUrl([API_BASE_PATH, QUERY], [EXPLAIN], [queryReportOrListview]);
////    response, connectorError = sendGetRequest(path);
////
////    QueryPlan[] queryPlans = [];
////    if (connectorError != null) {
////        return queryPlans, connectorError;
////    }
////
////    json[] plans;
////    plans, _ = (json[])response.plans;
////
////    foreach i, plan in plans {
////        queryPlans[i], _ = <QueryPlan>plan;
////    }
////
////    return queryPlans, connectorError;
////}
////
////// ================================= Search ================================ //
////
////@Description {value:"Executes the specified SOSL search"}
////@Param {value:"searchString: The request SOSL string"}
////@Return {value:"returns results in SearchResult struct"}
////@Return {value:"Error occured"}
////public function <SalesforceConnector sfConnector> searchSOSLString (string searchString) (SearchResult[], SalesforceConnectorError) {
////    SalesforceConnectorError connectorError;
////    json response;
////
////    string path = prepareUrl([API_BASE_PATH, SEARCH], [Q], [searchString]);
////    response, connectorError = sendGetRequest(path);
////
////    SearchResult[] searchResults = [];
////    if (connectorError != null) {
////        return searchResults, connectorError;
////    }
////
////    json jsonResponse = response.searchRecords;
////    json[] jsonSearchResults;
////    jsonSearchResults, _ = (json[])jsonResponse;
////
////    foreach i, result in jsonSearchResults {
////        searchResults[i], _ = <SearchResult>result;
////    }
////    return searchResults, connectorError;
////}
//
//// ============================ ACCOUNT SObject: get, create, update, delete ===================== //
//
//@Description {value:"Accesses Account SObject records based on the Account object ID"}
//@Param {value:"accountId: The relevant account's id"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> getAccountById (string accountId) returns json | SalesforceConnectorError {
//    return getRecord(ACCOUNT, accountId);
//}
//
//@Description {value:"Creates new Account object record"}
//@Param {value:"accountRecord: json payload containing Account record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//
//public function <SalesforceConnector sfConnector> createAccount (json accountRecord) returns string | SalesforceConnectorError {
//    return createRecord(ACCOUNT, accountRecord);
//}
//
//@Description {value:"Updates existing Account object record"}
//@Param {value:"accountId: Specified account id"}
//@Param {value:"accountRecord: json payload containing Account record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> updateAccount (string accountId, json accountRecord) returns boolean | SalesforceConnectorError {
//    return updateRecord(ACCOUNT, accountId, accountRecord);
//
//}
//
//@Description {value:"Deletes existing Account's records"}
//@Param {value:"accountId: The id of the relevant Account record supposed to be deleted"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> deleteAccount (string accountId) returns boolean | SalesforceConnectorError {
//    return deleteRecord(ACCOUNT, accountId);
//}
//
//// ============================ LEAD SObject: get, create, update, delete ===================== //
//
//@Description {value:"Accesses Lead SObject records based on the Lead object ID"}
//@Param {value:"leadId: The relevant lead's id"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> getLeadById (string leadId) returns json | SalesforceConnectorError {
//    return getRecord(LEAD, leadId);
//}
//
//@Description {value:"Creates new Lead object record"}
//@Param {value:"leadRecord: json payload containing Lead record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> createLead (json leadRecord) returns string | SalesforceConnectorError {
//    return createRecord(LEAD, leadRecord);
//}
//
//@Description {value:"Updates existing Lead object record"}
//@Param {value:"leadId: Specified lead id"}
//@Param {value:"leadRecord: json payload containing Lead record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> updateLead (string leadId, json leadRecord) returns boolean | SalesforceConnectorError {
//    return updateRecord(LEAD, leadId, leadRecord);
//}
//
//@Description {value:"Deletes existing Lead's records"}
//@Param {value:"leadId: The id of the relevant Lead record supposed to be deleted"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> deleteLead (string leadId) returns boolean | SalesforceConnectorError {
//    return deleteRecord(LEAD, leadId);
//}
//
//// ============================ CONTACTS SObject: get, create, update, delete ===================== //
//
//@Description {value:"Accesses Contacts SObject records based on the Contact object ID"}
//@Param {value:"contactId: The relevant contact's id"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> getContactById (string contactId) returns json | SalesforceConnectorError {
//    return getRecord(CONTACT, contactId);
//}
//
//@Description {value:"Creates new Contact object record"}
//@Param {value:"contactRecord: json payload containing Contact record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> createContact (json contactRecord) returns string | SalesforceConnectorError {
//    return createRecord(CONTACT, contactRecord);
//}
//
//@Description {value:"Updates existing Contact object record"}
//@Param {value:"contactId: Specified contact id"}
//@Param {value:"contactRecord: json payload containing contact record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> updateContact (string contactId, json contactRecord) returns boolean | SalesforceConnectorError {
//    return updateRecord(CONTACT, contactId, contactRecord);
//}
//
////@Description {value:"Deletes existing Contact's records"}
////@Param {value:"contactId: The id of the relevant Contact record supposed to be deleted"}
////@Return {value:"response message"}
////@Return {value:"Error occured during oauth2 client invocation."}
////public function <SalesforceConnector sfConnector> deleteContact (string contactId) returns boolean, | SalesforceConnectorError {
////    return deleteRecord(CONTACT, contactId);
////}
//
//// ============================ OPPORTUNITIES SObject: get, create, update, delete ===================== //
//
//@Description {value:"Accesses Opportunities SObject records based on the Opportunity object ID"}
//@Param {value:"opportunityId: The relevant opportunity's id"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> getOpportunityById (string opportunityId) returns json | SalesforceConnectorError {
//    return getRecord(OPPORTUNITY, opportunityId);
//
//}
//
//@Description {value:"Creates new Opportunity object record"}
//@Param {value:"opportunityRecord: json payload containing Opportunity record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> createOpportunity (json opportunityRecord) returns string | SalesforceConnectorError {
//    return createRecord(OPPORTUNITY, opportunityRecord);
//
//}
//
//@Description {value:"Updates existing Opportunity object record"}
//@Param {value:"opportunityId: Specified opportunity id"}
//@Param {value:"opportunityRecord: json payload containing Opportunity record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> updateOpportunity (string opportunityId, json opportunityRecord) returns boolean | SalesforceConnectorError {
//    return updateRecord(OPPORTUNITY, opportunityId, opportunityRecord);
//
//}
//
//@Description {value:"Deletes existing Opportunity records"}
//@Param {value:"opportunityId: The id of the relevant Opportunity record supposed to be deleted"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> deleteOpportunity (string opportunityId) returns boolean | SalesforceConnectorError {
//    return deleteRecord(OPPORTUNITY, opportunityId);
//
//}
//
//// ============================ PRODUCTS SObject: get, create, update, delete ===================== //
//
//@Description {value:"Accesses Products SObject records based on the Product object ID"}
//@Param {value:"productId: The relevant product's id"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> getProductById (string productId) returns json | SalesforceConnectorError {
//    return getRecord(PRODUCT, productId);
//}
//
//@Description {value:"Creates new Product object record"}
//@Param {value:"productRecord: json payload containing Product record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> createProduct (json productRecord) returns string | SalesforceConnectorError {
//    return createRecord(PRODUCT, productRecord);
//}
//
//@Description {value:"Updates existing Product object record"}
//@Param {value:"productId: Specified product id"}
//@Param {value:"productRecord: json payload containing product record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> updateProduct (string productId, json productRecord) returns boolean | SalesforceConnectorError {
//    return updateRecord(PRODUCT, productId, productRecord);
//}
//
//@Description {value:"Deletes existing product's records"}
//@Param {value:"productId: The id of the relevant Product record supposed to be deleted"}
//@Return {value:"response message"}
//@Return {value:"Error occured during oauth2 client invocation."}
//public function <SalesforceConnector sfConnector> deleteProduct (string productId) returns boolean | SalesforceConnectorError {
//    return deleteRecord(PRODUCT, productId);
//}
//
//// ============================ Generic actions: Get, create, update, delete records ===================== //
//
//@Description {value:"Accesses records based on the specified object ID, can be used with external objects "}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//public function <SalesforceConnector sfConnector> getRecord (string sObjectName, string id) returns json | SalesforceConnectorError {
//    return getRecord(sObjectName, id);
//}
//
//@Description {value:"Creates new records"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"record: json payload containing record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//public function <SalesforceConnector sfConnector> createRecord (string sObjectName, json record) returns string | SalesforceConnectorError {
//    return createRecord(sObjectName, record);
//}
//
//@Description {value:"Updates existing records"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"record: json payload containing record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//public function <SalesforceConnector sfConnector> updateRecord (string sObjectName, string id, json record) returns boolean | SalesforceConnectorError {
//    return updateRecord(sObjectName, id, record);
//}
//
//@Description {value:"Deletes existing records"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"id: The id of the relevant record supposed to be deleted"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//public function <SalesforceConnector sfConnector> deleteRecord (string sObjectName, string id) returns boolean | SalesforceConnectorError {
//    return deleteRecord(sObjectName, id);
//}
//
//@Description {value:"Retrieve field values from a standard object record for a specified SObject ID"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"rowId: The row ID of the required record"}
//@Param {value:"fields: The comma separated set of required fields"}
//@Return {value:"response message"}
//@Return {value:"Error occured"}
//public function <SalesforceConnector sfConnector> getFieldValuesFromSObjectRecord (string sObjectName, string id, string fields) returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, id], [FIELDS], [fields]);
//    response, connectorError = sendGetRequest(path);
//

//    return response, connectorError;
//}
//
//@Description {value:"Retrieve field values from an external object record using Salesforce ID or External ID"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"rowId: The row ID of the required record"}
//@Param {value:"fields: The comma separated set of required fields"}
//@Return {value:"response message"}
//@Return {value:"Error occured"}
//public function <SalesforceConnector sfConnector> getFieldValuesFromExternalObjectRecord (string externalObjectName, string id, string fields)
//returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, externalObjectName, id], [FIELDS], [fields]);
//    response, connectorError = sendGetRequest(path);
//    return response, connectorError;
//}
//
//@Description {value:"Allows to create multiple records"}
//@Param {value:"sObjectName: The relevant sobject name"}
//@Param {value:"payload: json payload containing record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured"}
//public function <SalesforceConnector sfConnector> createMultipleRecords (string sObjectName, json payload) returns json | SalesforceConnectorError {
//    http:OutRequest request = {};
//    http:InResponse response = {};
//    http:HttpConnectorError err;
//    SalesforceConnectorError connectorError;
//    json jsonPayload;
//
//    string requestURI = string `{{API_BASE_PATH}}/{{MULTIPLE_RECORDS}}/{{sObjectName}}`;
//    request.setJsonPayload(payload);
//    response, err = sfConnector.oauth2.get(requestURI, request);
//    jsonPayload, connectorError = checkAndSetErrors(response, err, true);
//
//    return jsonPayload, connectorError;
//}
//
//// ============================ Create, update, delete records by External IDs ===================== //
//
//@Description {value:"Accesses records based on the value of a specified external ID field"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"fieldName: The external field name"}
//@Param {value:"fieldValue: The external field value"}
//@Return {value:"response message"}
//@Return {value:"Error occured"}
//public function <SalesforceConnector sfConnector> getRecordByExternalId (string sObjectName, string fieldName, string fieldValue) returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, fieldName, fieldValue], null, null);
//    response, connectorError = sendGetRequest(path);
//
//    return response, connectorError;
//}
//
//@Description {value:"Creates new records or updates existing records (upserts records) based on the value of a
//     specified external ID field"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"fieldId: The external field id"}
//@Param {value:"fieldValue: The external field value"}
//@Param {value:"record: json payload containing record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//public function <SalesforceConnector sfConnector> upsertSObjectByExternalId (string sObjectName, string fieldId, string fieldValue, json record) returns json | SalesforceConnectorError {
//    http:OutRequest request = {};
//    http:InResponse response = {};
//    http:HttpConnectorError err;
//    SalesforceConnectorError connectorError;
//    json jsonPayload;
//
//    string requestURI = string `{{API_BASE_PATH}}/{{SOBJECTS}}/{{sObjectName}}/{{fieldId}}/{{fieldValue}}`;
//    request.setJsonPayload(record);
//    response, err = sfConnector.oauth2.patch(requestURI, request);
//    jsonPayload, connectorError = checkAndSetErrors(response, err, false);
//
//    return jsonPayload, connectorError;
//}
//
//// ============================ Get updated and deleted records ===================== //
//
//@Description {value:"Retrieves the list of individual records that have been deleted within the given timespan for the specified object"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"startTime: The start time of the time span"}
//@Param {value:"endTime: The end time of the time span"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//public function <SalesforceConnector sfConnector> getDeletedRecords (string sObjectName, string startTime, string endTime) returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, DELETED], [START, END], [startTime, endTime]);
//    response, connectorError = sendGetRequest(path);
//
//    return response, connectorError;
//}
//
//@Description {value:"Retrieves the list of individual records that have been updated (added or changed) within the given timespan for the specified object"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"startTime: The start time of the time span"}
//@Param {value:"endTime: The end time of the time span"}
//@Return {value:"response message"}
//@Return {value:"Error occured"}
//public function <SalesforceConnector sfConnector> getUpdatedRecords (string sObjectName, string startTime, string endTime) returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, UPDATED], [START, END], [startTime, endTime]);
//    response, connectorError = sendGetRequest(path);
//
//    return response, connectorError;
//}
//
//// ============================ Describe SObjects available and their fields/metadata ===================== //
//
//@Description {value:"Lists the available objects and their metadata for your organization and available to the logged-in user"}
//@Return {value:"Array of available objects"}
//@Return {value:"Error occured "}
//public function <SalesforceConnector sfConnector> describeAvailableObjects () returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS], null, null);
//    response, connectorError = sendGetRequest(path);
//
//    return response, connectorError;
//}
//
//@Description {value:"Describes the individual metadata for the specified object"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Return {value:"response message"}
//@Return {value:"Error occured "}
//public function <SalesforceConnector sfConnector> getSObjectBasicInfo (string sobjectName) returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sobjectName], null, null);
//    response, connectorError = sendGetRequest(path);
//
//    return response, connectorError;
//}
//
//@Description {value:"Completely describes the individual metadata at all levels for the specified object.
//                        Can be used to retrieve the fields, URLs, and child relationships"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//public function <SalesforceConnector sfConnector> describeSObject (string sObjectName) returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, DESCRIBE], null, null);
//    response, connectorError = sendGetRequest(path);
//
//    return response, connectorError;
//}
//
//@Description {value:"Query for actions displayed in the UI, given a user, a context, device format, and a record ID"}
//@Return {value:"response message"}
//@Return {value:"Error occured"}
//public function <SalesforceConnector sfConnector> sObjectPlatformAction () returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, PLATFORM_ACTION], null, null);
//    response, connectorError = sendGetRequest(path);
//
//    return response, connectorError;
//}
//
////=============================== Utility Functions ======================================//
//
//@Description {value:"Prepare and send the request"}
//@Param {value:"url: The relevant url to be used to send the request"}
//@Return {value:"response json"}
//@Return {value:"Error occured."}
//function <SalesforceConnector sfConnector> sendGetRequest (string url) returns json | SalesforceConnectorError {
//    http:Request request = {};
//    http:Response response = {};
//    http:HttpConnectorError err;
//    SalesforceConnectorError connectorError;
//    json jsonPayload;
//
//    var output = sfConnector.oauth2.get(url, request);
//    match output{
//        http:Response => {jsonPayload = response.getJsonPayload();
//                            return jsonPayload;}
//        http:HttpConnectorError => {checkAndSetErrors(output, true);}
//    }
//}
//
//@Description {value:"Prepare and send POST request"}
//@Param {value:"url: The relevant url to be used to send the request"}
//@Param {value:"body: json payload to be sent as request body"}
//@Return {value:"response json"}
//@Return {value:"Error occured."}
//function <SalesforceConnector sfConnector> sendPostRequest (string url, json body) returns json | SalesforceConnectorError {
//    http:OutRequest request = {};
//    http:InResponse response = {};
//    http:HttpConnectorError err;
//    SalesforceConnectorError connectorError;
//    json jsonPayload;
//
//    request.setJsonPayload(body);
//    response, err = sfConnector.oauth2.post(url, request);
//    jsonPayload, connectorError = checkAndSetErrors(response, err, true);
//
//    return jsonPayload, connectorError;
//}
//
//@Description {value:"Prepare and send DELETE request"}
//@Param {value:"url: The relevant url to be used to send the request"}
//@Return {value:"Error occured."}
//function <SalesforceConnector sfConnector> sendDeleteRequest (string url) returns SalesforceConnectorError {
//    http:OutRequest request = {};
//    http:InResponse response = {};
//    http:HttpConnectorError err;
//    SalesforceConnectorError connectorError;
//
//    response, err = sfConnector.oauth2.delete(url, request);
//    _, connectorError = checkAndSetErrors(response, err, false);
//
//    return connectorError;
//}
//
//@Description {value:"Prepare and send PATCH request"}
//@Param {value:"url: The relevant url to be used to send the request"}
//@Param {value:"body: json payload to be sent as request body"}
//@Return {value:"Error occured."}
//function <SalesforceConnector sfConnector> sendPatchRequest (string url, json body) returns SalesforceConnectorError {
//    http:OutRequest request = {};
//    http:InResponse response = {};
//    http:HttpConnectorError err;
//    SalesforceConnectorError connectorError;
//
//    request.setJsonPayload(body);
//    response, err = sfConnector.oauth2.patch(url, request);
//    _, connectorError = checkAndSetErrors(response, err, false);
//
//    return connectorError;
//}
//
//@Description {value:"Accesses records based on the specified object ID, can be used with external objects "}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//function <SalesforceConnector sfConnector> getRecord (string sObjectName, string id) returns json | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, id], null, null);
//    response, connectorError = sendGetRequest(path);
//
//    return response, connectorError;
//}
//
//@Description {value:"Creates new records"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"record: json payload containing record data"}
//@Return {value:"Created record's ID"}
//@Return {value:"Error occured."}
//function <SalesforceConnector sfConnector> createRecord (string sObjectName, json record) returns string | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//    json response;
//    string id;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName], null, null);
//    response, connectorError = sendPostRequest(path, record);
//
//    if (connectorError != null) {
//        return id, connectorError;
//    }
//
//    log:printDebug(response.toString());
//
//    try {
//        id = response.id.toString();
//    } catch (error e) {
//        log:printErrorCause("Unable to get the newly created record's id", e);
//        connectorError = setError(e);
//    }
//
//    return id, connectorError;
//}
//
//@Description {value:"Updates existing records"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"record: json payload containing record data"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//function <SalesforceConnector sfConnector> updateRecord (string sObjectName, string id, json record) returns boolean | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, id], null, null);
//    connectorError = sendPatchRequest(path, record);
//
//    return connectorError == null, connectorError;
//}
//
//@Description {value:"Deletes existing records"}
//@Param {value:"sobjectName: The relevant sobject name"}
//@Param {value:"id: The id of the relevant record supposed to be deleted"}
//@Return {value:"response message"}
//@Return {value:"Error occured."}
//function <SalesforceConnector sfConnector> deleteRecord (string sObjectName, string id) returns boolean | SalesforceConnectorError {
//    SalesforceConnectorError connectorError;
//
//    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, id], null, null);
//    connectorError = sendDeleteRequest(path);
//
//    return connectorError == null, connectorError;
//}
