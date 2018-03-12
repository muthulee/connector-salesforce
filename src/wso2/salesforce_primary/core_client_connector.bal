package src.wso2.salesforce_primary;

import ballerina.net.http;
import ballerina.net.uri;
import test.wso2.salesforce as oauth2;

@Description {value:"Salesforcerest client connector"}
@Param {value:"baseUrl: The endpoint base url"}
@Param {value:"accessToken: The access token of the account"}
@Param {value:"clientId: The client Id of the account"}
@Param {value:"clientSecret: The client secret of the account"}
@Param {value:"refreshToken: The refresh token of the account"}
@Param {value:"refreshTokenEndpoint: The refresh token endpoint url"}
@Param {value:"refreshTokenPath: The path for obtaining a refresh token"}
@Param {value:"apiVersion: API version available"}
public connector CoreClientConnector (string baseUrl, string accessToken, string clientId, string clientSecret, string refreshToken,
                                      string refreshTokenEndpoint, string refreshTokenPath, string apiVersion) {

    endpoint<oauth2:ClientConnector> oauth2Connector {
        create oauth2:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndpoint, refreshTokenPath);
    }

    error _;

    @Description {value:"List summary details about each REST API version available"}
    @Return {value:"Array of available API versions"}
    @Return {value:"Error occured"}
    action listAvailableApiVersions () (json[], SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;

        json[] apiVersions;
        SalesforceConnectorError connectorError;

        response, err = oauth2Connector.get(BASE_URI, request);
        connectorError = checkAndSetErrors(response, err);

        if (connectorError != null) {
            return apiVersions, connectorError;
        }

        apiVersions, _ = (json[])response.getJsonPayload();

        return apiVersions, connectorError;
    }

    @Description {value:"Lists the resources available for the specified API version"}
    @Return {value:"response message"}
    @Return {value:"Error occurred"}
    action listResourcesByApiVersion () (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    @Description {value:"Lists limits information for your organization"}
    @Return {value:"response message"}
    @Return {value:"Error occured "}
    action listOrganizationLimits () (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{LIMITS_SUFFIX}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    // ============================ Describe SObjects available and their fields/metadata ===================== //

    @Description {value:"Lists the available objects and their metadata for your organization and available to the logged-in user"}
    @Return {value:"Array of available objects"}
    @Return {value:"Error occured "}
    action describeGlobal () (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    @Description {value:"Describes the individual metadata for the specified object"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Return {value:"response message"}
    @Return {value:"Error occured "}
    action getSObjectBasicInfo (string sobjectName) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sobjectName}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    @Description {value:"Completely describes the individual metadata at all levels for the specified object"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Return {value:"response message"}
    @Return {value:"Error occured."}
    action describeSObject (string sObjectName) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}/{{DESCRIBE}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    // ============================ Get, create, update, delete records ===================== //

    @Description {value:"Accesses records based on the specified object ID, can be used with external objects "}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Return {value:"response message"}
    @Return {value:"Error occured."}
    action getRecord (string sObjectName, string id) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}/{{id}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    @Description {value:"Creates new records"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"record: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured."}
    action createRecord (string sObjectName, json record) (string, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}`;
        request.setJsonPayload(record);
        response, err = oauth2Connector.post(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        json jsonRespone = response.getJsonPayload();
        return jsonRespone.id.toString(), connectorError;
    }

    @Description {value:"Updates existing records"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"record: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured."}
    action updateRecord (string sObjectName, string id, json record) (boolean, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;
        boolean isUpdated;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}/{{id}}`;
        request.setJsonPayload(record);
        response, err = oauth2Connector.patch(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        if (connectorError == null) {
            isUpdated = true;
        }
        return isUpdated, connectorError;
    }

    @Description {value:"Deletes existing records"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"id: The id of the relevant record supposed to be deleted"}
    @Return {value:"response message"}
    @Return {value:"Error occured."}
    action deleteRecord (string sObjectName, string id) (boolean, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;
        boolean isDeleted;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}/{{id}}`;
        response, err = oauth2Connector.delete(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        if (connectorError == null) {
            isDeleted = true;
        }
        return isDeleted, connectorError;
    }


    // ============================ Create, update, delete records by External IDs ===================== //

    @Description {value:"Accesses records based on the value of a specified external ID field"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"fieldName: The external field name"}
    @Param {value:"fieldValue: The external field value"}
    @Return {value:"response message"}
    @Return {value:"Error occured"}
    action getRecordByExternalId (string sObjectName, string fieldName, string fieldValue) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}/{{fieldName}}/{{fieldValue}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    @Description {value:"Creates new records or updates existing records (upserts records) based on the value of a
     specified external ID field"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"fieldId: The external field id"}
    @Param {value:"fieldValue: The external field value"}
    @Param {value:"record: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured."}
    action upsertSObjectByExternalId (string sObjectName, string fieldId, string fieldValue, json record) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}/{{fieldId}}/{{fieldValue}}`;
        request.setJsonPayload(record);
        response, err = oauth2Connector.patch(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    // ============================ Get updated and deleted records ===================== //

    @Description {value:"Retrieves the list of individual records that have been deleted within the given timespan for the specified object"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"startTime: The start time of the time span"}
    @Param {value:"endTime: The end time of the time span"}
    @Return {value:"response message"}
    @Return {value:"Error occured."}
    action getDeletedRecords (string sObjectName, string startTime, string endTime) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        startTime, _ = uri:encode(startTime, "utf-8");
        endTime, _ = uri:encode(endTime, "utf-8");
        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}/deleted/?start={{startTime}}&end={{endTime}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    @Description {value:"Retrieves the list of individual records that have been updated (added or changed) within the given timespan for the specified object"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"startTime: The start time of the time span"}
    @Param {value:"endTime: The end time of the time span"}
    @Return {value:"response message"}
    @Return {value:"Error occured"}
    action getUpdatedRecords (string sObjectName, string startTime, string endTime) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        startTime, _ = uri:encode(startTime, "utf-8");
        endTime, _ = uri:encode(endTime, "utf-8");
        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}/updated/?start={{startTime}}&end={{endTime}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    @Description { value:"Executes the specified SOQL query"}
    @Param { value:"query: The request SOQL query"}
    @Return { value:"returns QueryResult struct"}
    @Return { value:"Error occured" }
    action query (string query) (QueryResult, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        query = query.replaceAll("\\s+", "+");

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{QUERY}}/?q={{query}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        QueryResult result = {};

        if (connectorError != null) {
            return result, connectorError;
        }

        json jsonResponse = response.getJsonPayload();
        result.done, _ = (boolean)jsonResponse.done;
        result.totalSize, _ = (int)jsonResponse.totalSize;
        result.records, _ = (json[])jsonResponse.records;
        result.nextRecordsUrl, _ = (string)jsonResponse.nextRecordsUrl;

        return result, connectorError;
    }

    @Description { value:"If the queryAll results are too large, retrieve the next batch of results using nextRecordUrl"}
    @Param { value:"nextRecordsUrl: The url sent with first batch of queryAll results to get the next batch"}
    @Return { value:"returns QueryResult struct"}
    @Return { value:"Error occured" }
    action nextQueryResult (string nextRecordsUrl) (QueryResult, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        response, err = oauth2Connector.get(nextRecordsUrl, request);
        connectorError = checkAndSetErrors(response, err);

        QueryResult result = {};

        if (connectorError != null) {
            return result, connectorError;
        }

        json jsonResponse = response.getJsonPayload();
        result.done, _ = (boolean)jsonResponse.done;
        result.totalSize, _ = (int)jsonResponse.totalSize;
        result.records, _ = (json[])jsonResponse.records;
        if (jsonResponse.nextRecordsUrl != null) {
            result.nextRecordsUrl = jsonResponse.nextRecordsUrl.toString();
        } else {
            result.nextRecordsUrl = null;
        }

        return result, connectorError;
    }

    @Description {value:"QueryAll will return records that have been deleted because of a merge or delete, archived Task
     and Event records"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"queryString: The request SOQL query"}
    @Return {value:"response message"}
    @Return {value:"Error occured."}
    action getAllQueries (string queryAllString) (QueryResult, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        queryAllString = queryAllString.replaceAll("\\s+", "+");

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{QUERYALL}}/?q={{queryAllString}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        QueryResult result = {};

        if (connectorError != null) {
            return result, connectorError;
        }

        json jsonResponse = response.getJsonPayload();
        result.done, _ = (boolean)jsonResponse.done;
        result.totalSize, _ = (int)jsonResponse.totalSize;
        result.records, _ = (json[])jsonResponse.records;
        result.nextRecordsUrl, _ = (string)jsonResponse.nextRecordsUrl;

        return result, connectorError;
    }

    @Description { value:"Get feedback on how Salesforce will execute the query, report, or list view"}
    @Param { value:"queryReportOrListview: The parameter to get feedback on"}
    @Return { value:"response message"}
    @Return { value:"Error occured" }
    action explainQueryReportOrListview (string queryReportOrListview) (QueryPlan[], SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        queryReportOrListview = queryReportOrListview.replaceAll("\\s+", "+");

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{QUERY}}/?explain={{queryReportOrListview}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        QueryPlan[] queryPlans = [];
        if (connectorError != null) {
            return queryPlans, connectorError;
        }

        json jsonResponse = response.getJsonPayload();
        json[] plans;
        plans, _ = (json[])jsonResponse.plans;

        foreach i, plan in plans {
            queryPlans[i], _ = <QueryPlan>plan;
        }

        return queryPlans, connectorError;
    }
}

// ============================ function to check and set errors ===================== //

@Description {value:"Function to check errors and set errors to relevant error types"}
@Param {value:"response: http response"}
@Param {value:"httpError: http connector error"}
@Return {value:"Error occured"}
function checkAndSetErrors (http:InResponse response, http:HttpConnectorError httpError) (SalesforceConnectorError) {
    SalesforceConnectorError connectorError;
    if (httpError != null) {
        connectorError = {messages:[httpError.message], connectionError:httpError};
    } else if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
        json[] body;
        error _;
        body, _ = (json[])response.getJsonPayload();
        connectorError = {messages:[], salesforceErrors:[]};
        foreach i, e in body {
            SalesforceError sfError = {message:e.message.toString(), errorCode:e.errorCode.toString()};
            connectorError.messages[i] = e.message.toString();
            connectorError.salesforceErrors[i] = sfError;
        }
    }
    return connectorError;
}