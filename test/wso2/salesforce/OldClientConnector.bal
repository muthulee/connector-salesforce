package src.wso2.salesforce;

import ballerina.io;
import ballerina.net.http;
import ballerina.net.uri;
import org.wso2.ballerina.connectors.oauth2;

@Description {value:"Salesforcerest client connector"}
@Param {value:"baseUrl: The endpoint base url"}
@Param {value:"accessToken: The access token of the account"}
@Param {value:"clientId: The client Id of the account"}
@Param {value:"clientSecret: The client secret of the account"}
@Param {value:"refreshToken: The refresh token of the account"}
@Param {value:"refreshTokenEndpoint: The refresh token endpoint url"}
@Param {value:"refreshTokenPath: The path for obtaining a refresh token"}
@Param {value:"apiVersion: API version available"}
public connector ClientConnector (string baseUrl, string accessToken, string clientId, string clientSecret, string refreshToken,
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
    @Return {value:"Error occurred during oauth2 client invocation."}
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
    @Return {value:"Error occured during oauth2 client invocation."}
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

    @Description {value:"Lists the available objects and their metadata for your organization and available to the logged-in user"}
    @Return {value:"Array of available objects"}
    @Return {value:"Error occured"}
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
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectBasicInfo (string sobjectName) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sobjectName}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    //equals to create new record
    @Description {value:"Creates new records"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"payload: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action createSObjectRecord (string sObjectName, json record) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}`;
        request.setJsonPayload(record);
        response, err = oauth2Connector.post(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    @Description {value:"Creates new records or updates existing records (upserts records) based on the value of a
     specified external ID field"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"fieldId: The external field id"}
    @Param {value:"fieldValue: The external field value"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action upsertSObjectRowsByExternalId (string sObjectName, string fieldId, string fieldValue, json record) (json, SalesforceConnectorError) {
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

    @Description {value:"Completely describes the individual metadata at all levels for the specified object"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectDescribe (string sObjectName) (json, SalesforceConnectorError) {
        http:OutRequest request = {};
        http:InResponse response = {};
        http:HttpConnectorError err;
        SalesforceConnectorError connectorError;

        string requestURI = string `{{BASE_URI}}/{{apiVersion}}/{{SOBJECTS}}/{{sObjectName}}/{{DESCRIBE}}`;
        response, err = oauth2Connector.get(requestURI, request);
        connectorError = checkAndSetErrors(response, err);

        return response.getJsonPayload(), connectorError;
    }

    @Description {value:"Retrieves the list of individual records that have been deleted within the given timespan for the specified object"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"startTime: The start time of the time span"}
    @Param {value:"endTime: The end time of the time span"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectRecordsGetDeleted (string sObjectName, string startTime, string endTime) (json, SalesforceConnectorError) {
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
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"startTime: The start time of the time span"}
    @Param {value:"endTime: The end time of the time span"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectGetUpdated (string sObjectName, string startTime, string endTime) (json, SalesforceConnectorError) {
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

    //@Description {value:"Retrieves information about alternate named layouts for a given object."}
    //@Param {value:"object: object name given"}
    //@Param {value:"alternateName: alternate named layouts for a given object"}
    //@Return {value:"response message"}
    //@Return {value:"error:error occured"}
    //action sObjectNamedLayouts (string object, string alternateName) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + object + NAMED_LAYOUTS_SUFFIX + alternateName;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Accesses records based on the specified object ID, can be used with external objects "}
    //@Param {value:"sobjectName: The relevant sobject name"}
    //@Return {value:"response message"}
    //@Return {value:"Error occured during oauth2 client invocation."}
    //action sObjectRows (string sobjectName, string rowId) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + sobjectName + "/" + rowId;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    jsonresponse = response.getJsonPayload();
    //
    //    return jsonresponse, err;
    //}
    //
    //@Description {value:"Creates new records or updates existing records (upserts records) based on the value of a
    // specified external ID field"}
    //@Param {value:"sobjectName: The relevant sobject name"}
    //@Param {value:"fieldId: The external field id"}
    //@Param {value:"fieldValue: The external field value"}
    //@Return {value:"response message"}
    //@Return {value:"Error occured"}
    //action sObjectRowsByExternalId (string sobjectName, string fieldId, string fieldValue)
    //(json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + sobjectName + "/" + fieldId + "/" + fieldValue;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    jsonresponse = response.getJsonPayload();
    //
    //    return jsonresponse, err;
    //}
    //
    //@Description {value:"Retrieves the specified blob field from an individual record."}
    //@Param {value:"sObjectName: The relevant sobject name"}
    //@Param {value:"id:"}
    //@Param {value:"blobField: "}
    //@Return {value:"Binary data for the required blob"}
    //@Return {value:"Error occured"}
    //action sObjectBlobRetrieve (string sObjectName, string id, string blobField) (blob, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + SOBJECTS + sObjectName + "/" + id + "/" + blobField;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    blob blobResponse = response.getBinaryPayload();
    //
    //    return blobResponse, err;
    //}
    //
    //@Description {value:"Get an approval layout description for a specified object and/or specified process"}
    //@Param {value:"sObjectName:The relevant SObject name"}
    //@Param {value:"approvalProcessName: required approval process"}
    //@Return {value:"Returns a list of approval layouts for a specified object in json format"}
    //@Return {value:"Error occured"}
    //action sObjectApprovalLayouts (string sObjectName, string approvalProcessName) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    json jsonResponse;
    //
    //    if (approvalProcessName != null) {
    //        //To get an approval layout description for a particular approval process
    //        string requestURI = BASE_URI + SOBJECTS + sObjectName + APPROVAL_LAYOUT_SUFFIX + approvalProcessName;
    //        response, e = oauth2Connector.get(requestURI, request);
    //        jsonResponse = response.getJsonPayload();
    //    } else {
    //        string requestURI = BASE_URI + SOBJECTS + sObjectName + APPROVAL_LAYOUT_SUFFIX;
    //        response, e = oauth2Connector.get(requestURI, request);
    //        jsonResponse = response.getJsonPayload();
    //    }
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Get a  a list of compact layouts for a specific object"}
    //@Param {value:"sObjectName: The relevant SObject name"}
    //@Return {value:"Returns a list of compact layouts for a specific object"}
    //@Return {value:"Error occured"}
    //action sObjectCompactLayouts (string sObjectName) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + SOBJECTS + sObjectName + COMPACT_LAYOUT_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Get a list of layouts and descriptions (with a list of fields and the layout name)"}
    //@Param {value:"sObjectName: The relevant SObject name"}
    //@Param {value:"recordTypeId: Id of the relevant record type"}
    //@Return {value:"Returns a list of layouts and descriptions in Json format"}
    //@Return {value:"Error occured"}
    //action describeLayouts (string sObjectName, string recordTypeId) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    json jsonResponse;
    //
    //    if (sObjectName == null && recordTypeId == null) {
    //        string requestURI = BASE_URI + SOBJECTS + "Global" + DESCRIBE_LAYOUT_SUFFIX;
    //        response, e = oauth2Connector.get(requestURI, request);
    //        jsonResponse = response.getJsonPayload();
    //    }
    //    else if (recordTypeId == null) {
    //        string requestURI = BASE_URI + SOBJECTS + sObjectName + DESCRIBE_LAYOUT_SUFFIX;
    //        response, e = oauth2Connector.get(requestURI, request);
    //        jsonResponse = response.getJsonPayload();
    //    } else {
    //        string requestURI = BASE_URI + SOBJECTS + sObjectName + DESCRIBE_LAYOUT_SUFFIX + recordTypeId;
    //        response, e = oauth2Connector.get(requestURI, request);
    //        jsonResponse = response.getJsonPayload();
    //    }
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Query for actions displayed in the UI, given a user, a context, device format, and a record ID"}
    //@Return {value:"Json response message"}
    //@Return {value:"Error occured"}
    //action sObjectPlatformAction () (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + PLATFORM_ACTION_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Get a specific object’s actions as well as global actions"}
    //@Param {value:"sObjectName: relevant object's name"}
    //@Return {value:"Return specific object's actions in a Json response"}
    //@Return {value:"Error occured"}
    //action sObjectQuickActions (string sObjectName) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + sObjectName + QUICK_ACTIONS_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Accesses records by traversing object relationships via friendly URLs,
    //can retrieve, update, or delete the record associated with the traversed relationship field"}
    //@Param {value:"sObjectName: relevant object's name"}
    //@Param {value:"id: object's id"}
    //@Param {value:"relationship_field_name: "}
    //action sObjectRelationships (string sObjectName, string id, string relationshipFieldName) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + sObjectName + "/" + id + "/" + relationshipFieldName;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns a list of suggested Salesforce Knowledge articles for a case, work order, or work order line item."}
    //@Param {value:""}
    ////To return suggested articles for a case, work order, or work order line item that is being created, use vXX.X/sobjects/SObject/suggestedArticles?language=article language&subject=subject&description=description. The SObject can be Case, WorkOrder, or WorkOrderLineItem. Suggestions are based on common keywords in the title, description, and other information that’s entered before the record has been saved and assigned an ID.
    ////For example: vXX.X/sobjects/Case/suggestedArticles?language=article language&subject=subject&description=description or vXX.X/sobjects/WorkOrder/suggestedArticles?language=article language&subject=subject&description=description.
    ////To return suggested articles for an existing record with an ID, use vXX.X/sobjects/SObject/ID/suggestedArticles?language=article language
    //
    //@Description {value:"Use the HTTP GET method to get password expiration status,"}
    //@Param {value:"userId: unique id for the user"}
    //@Param {value:"password: password for the user"}
    //action getPasswordExpirationStatus (string userId, string password) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + "User" + "/" + userId + "/" + password;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Use the HTTP POST method to set the password"}
    //@Param {value:"userId: unique id for the user"}
    //@Param {value:"password: password for the user"}
    //action setPassword (string userId, string password) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + "User" + "/" + userId + "/" + password;
    //    response, e = oauth2Connector.post(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Use the HTTP DELETE method to reset the password"}
    //@Param {value:"userId: unique id for the user"}
    //@Param {value:"password: password for the user"}
    //action deletePassword (string userId, string password) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + "User" + "/" + userId + "/" + password;
    //    response, e = oauth2Connector.delete(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Gets the definition of a platform event in JSON format for a given event name."}
    //@Param {value:"Platform_Event_Name__e: "}
    //@Return {value:"returns definition of a platform event in JSON format"}
    //@Return {value:"Error occured"}
    //action platformEventSchemabyEventName (string Platform_Event_Name__e) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + Platform_Event_Name__e + "/eventSchema";
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Gets the definition of a platform event in JSON format for a given schema ID."}
    //@Param {value:"schemaId: "}
    //@Return {value:"returns the definition of a platform event in JSON format"}
    //@Return {value:"Error occured"}
    //action platformEventSchemabySchemaId (string schemaId) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + EVENT_SCHEMA_ID_SUFFIX + schemaId;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Get a list of custom actions:"}
    //@Return {value:" returns a list of general action types for the current organization in JSON format"}
    //@Return {value:"Error occured"}
    //action getInvocableActions () (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + ACTIONS_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Use standard actions to add more functionality to organization's applications."}
    //@Param {value:"actionType: standard action type"}
    //@Param {value:"actionName: name given to the action"}
    //@Return {value:" returns POST action's information in JSON format"}
    //@Return {value:"Error occured"}
    //action doInvocableAction (string actionType, string actionName) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + ACTIONS_SUFFIX + "/" + actionType + "/" + actionName;
    //    response, e = oauth2Connector.post(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns detailed information about a list view, including the ID, the columns, and the SOQL query"}
    //@Param {value:"sObjectType: Type of the specific SObject"}
    //@Param {value:"queryLocator: "}
    //@Return {value:"Returns information about a list view in a JSON response"}
    //@Return {value:"Error occured"}
    //action listViewDescribe (string sObjectType, string queryLocator) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + sObjectType + "/listviews/" + queryLocator + "/describe";
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Executes the SOQL query for the list view, returns the resulting data and presentation information"}
    //action listViewResults (string sObjectType, string listViewId) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + sObjectType + "/listviews/" + listViewId + "/results";
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Executes a simple RESTful search using parameters instead of a SOSL clause."}
    //action parameterizedSearch (string searchString) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + "/parameterizedSearch/" + "?q=" + searchString;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns a list of all approval processes"}
    //action processApprovals () (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + PROCESS_APPROVALS_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    ////@Description {value:"Returns a list of all active workflow rules. If a rule has actions, the actions will be listed under the rule."}
    ////action getProcessRules () () {
    ////To get a list of the workflow rules or to trigger one or more workflow rules, the URI is: /vXX.X/process/rules/
    ////To get the rules for a particular object: /vXX.X/process/rules/SObjectName
    ////To get the metadata for a particular rule: /vXX.X/process/rules/SObjectName/workflowRuleId
    ////
    ////}
    //
    //@Description {value:"Executes the specified SOQL query"}
    //@Param {value:"queryString: The request SOQL query"}
    //@Return {value:"response message"}
    //@Return {value:"Error occured during oauth2 client invocation."}
    //action query (string queryString) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + "/query/?q=" + queryString;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"QueryAll will return records that have been deleted because of a merge or delete, archived Task
    // and Event records"}
    //@Param {value:"queryString: The request SOQL query"}
    //@Return {value:"response message"}
    //@Return {value:"Error occured during oauth2 client invocation."}
    //action queryAll (string queryString) (json, http:HttpConnectorError) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    http:HttpConnectorError e;
    //
    //    string requestURI = BASE_URI + apiVersion + "/queryAll/?q=" + queryString;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    // /vXX.X/queryAll/?q=SOQL query
    //    // For retrieving additional query results if the initial results are too large:
    //    // /vXX.X/queryAll/query identifier
    //    return jsonResponse, e;
    //}
    //
    //@Description {value:"Returns the list of recently used list views for the given sObject type."}
    //action recentListView (string sObjectType) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SOBJECTS + sObjectType + RECENT_LISTVIEW_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Gets the most recently accessed items that were viewed or referenced by the current user"}
    //action recentlyViewedItems () (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + RECENTLY_VIEWD_ITEMS_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Lists information about object record counts in your organization."}
    //action recordCount (string[] objectList) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    string csvObjectList = "";
    //    int i = 0;
    //
    //    //reading the string array and concatenating to a comma separated single string
    //    foreach element in objectList {
    //        while (i < lengthof objectList) {
    //            csvObjectList = csvObjectList + "," + objectList[i];
    //            i = i + 1;
    //        }
    //    }
    //    string requestURI = BASE_URI + apiVersion + RECORD_COUNT_SUFFIX + csvObjectList;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Gets the current user’s most relevant items.Relevant items include
    //records for objects in the user’s global search scope and also most recently used (MRU) objects."}
    //action relevantItems () (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + DESCRIBE_GLOBAL_SUFFIX + RELEVANT_ITEMS_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns the existing Knowledge language settings,
    //including the default knowledge language and a list of supported Knowledge language information."}
    //action retrieveKnowledgeLanguageSettings () (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + RETRIEVE_KNOWLEDGE_LANGUAGE_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Executes the specified SOSL search."}
    //action search (string SOSLSearchString) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    //The search string must be URL-encoded.
    //    string requestURI = BASE_URI + apiVersion + SEARCH_SUFFIX + SOSLSearchString;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns an ordered list of objects in the default global search scope of a logged-in user."}
    //action searchScopeAndOrder () (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SEARCH_SUFFIX + SEARCH_SCOPE_ORDER_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns search result layout information for the objects in the query string."}
    //action searchResultLayouts (string[] objectList) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    string csvObjectList = "";
    //    int i = 0;
    //
    //    //reading the string array and concatenating to a comma separated single string
    //    foreach element in objectList {
    //        while (i < lengthof objectList) {
    //            csvObjectList = csvObjectList + "," + objectList[i];
    //            i = i + 1;
    //        }
    //    }
    //    string requestURI = BASE_URI + apiVersion + SEARCH_RESULT_LAYOUT_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns a list of suggested records whose names match the user’s search string."}
    //action searchSuggestedRecords (string searchString, string objectTypes) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SEARCH_SUGGESTED_RECORD_SUFFIX + searchString + "&sobject=" + objectTypes;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns a list of Salesforce Knowledge article titles that match the user’s search query string."}
    //action searchSuggestedArticleTitleMatches (string searchString, string articleLanguage, string articlePublicationStatus) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SEARCH_SUGGEST_TITLE_SUFFIX + searchString + "&language=" + articleLanguage + "&publishStatus=" + articlePublicationStatus;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns a list of suggested searches based on the user’s query string text matching searches
    //that other users have performed in Salesforce Knowledge."}
    //action searchSuggestedQueries (string searchString, string languageOfQuery) (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + SEARCH_SUGGESTED_QUERIES + searchString + "&language=" + languageOfQuery;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}
    //
    //@Description {value:"Returns a list of all tabs—including Lightning page tabs—available to the current user"}
    //action getAllTabs () (json, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    string requestURI = BASE_URI + apiVersion + TABS_SUFFIX;
    //    response, e = oauth2Connector.get(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    return jsonResponse, err;
    //}

    //@Description {value:"Gets the list of icons and colors used by themes in the Salesforce application."}
    //action getThemes () (json, error) {
    //    json response;
    //    error e;
    //
    //    string requestURI = BASE_URI + apiVersion + THEMES_SUFFIX;
    //    response, e = sendRequest(oauth2Connector, Method.GET, requestURI, null);
    //
    //    return response, e;
    //}
}

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
    io:println(response);
    return connectorError;
}

// TODO Move these structs to another package once https://github.com/ballerina-lang/ballerina/issues/4736 is fixed.//
public struct ApiVersion {
    string |version|;
    string label;
    string url;
}


public struct SalesforceError {
    //string[] fields;
    string message;
    string errorCode;
}

public struct SalesforceConnectorError {
    string[] messages;
    http:HttpConnectorError connectionError;
    SalesforceError[] salesforceErrors;
}