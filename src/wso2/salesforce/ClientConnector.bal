package src.wso2.salesforce;

import org.wso2.ballerina.connectors.oauth2;
import ballerina.net.http;
import ballerina.io;
import ballerina.net.uri;

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
        create oauth2:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken,
                                      refreshTokenEndpoint, refreshTokenPath);
    }
    http:HttpConnectorError e;
    error err = {};
    json jsonresponse;

    @Description {value:"List summary details about each REST API version available"}
    @Return {value:"Array of available API versions"}
    @Return {value:"Error occured"}

    action listAvailableApiVersions () (ApiVersion[], error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        ApiVersion[] apiVersions = [];
        json[] apiVersionsJsonArray = [];
        int i = 0;

        response, e = oauth2Connector.get(BASE_URI, request);
        io:println("Error is:");
        io:println(e);
        json jsonResponse = response.getJsonPayload();
        apiVersionsJsonArray, err = (json[])jsonResponse;

        foreach element in apiVersionsJsonArray {
            //io:println(element);
            apiVersions[i], err = <ApiVersion>element;
            //io:println(apiVersions[i]);
            i = i + 1;
        }

        return apiVersions, err;
    }

    @Description {value:"Lists the resources available for the specified API version"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action listResourcesByApiVersion () (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion;
        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Lists limits information for your organization"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action listOrganizationLimits () (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + LIMITS_SUFFIX;
        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Lists the available objects and their metadata for your organization and available to the logged-in user"}
    @Return {value:"Array of available objects"}
    @Return {value:"Error occured"}
    action describeGlobal () (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        int i = 0;

        string requestURI = BASE_URI + apiVersion + DESCRIBE_GLOBAL_SUFFIX;

        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Describes the individual metadata for the specified object"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectBasicInfo (string sobjectName) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECTS + sobjectName;
        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    //equals to create new record
    @Description {value:"Creates new records"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"payload: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action createSObjectRecord (string sobjectName, json payload) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + DESCRIBE_GLOBAL_SUFFIX + "/" + sobjectName;
        request.setJsonPayload(payload);
        response, e = oauth2Connector.post(requestURI, request);
        json jsonResponse = response.getJsonPayload();
        json id = jsonResponse.id;

        return id, err;
    }

    @Description {value:"Creates new records or updates existing records (upserts records) based on the value of a
     specified external ID field"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"fieldId: The external field id"}
    @Param {value:"fieldValue: The external field value"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action upsertSObjectRowsByExternalId (string sobjectName, string fieldId, string fieldValue)
    (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECTS + sobjectName + "/" + fieldId + "/" + fieldValue;
        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Completely describes the individual metadata at all levels for the specified object"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectDescribe (string sobjectName) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECTS + sobjectName + SOBJECT_DESCRIBE_SUFFIX;
        response, e = oauth2Connector.get(requestURI, request);
        json jasonResponse = response.getJsonPayload();

        return jasonResponse, err;
    }

    @Description {value:"Retrieves the list of individual records that have been deleted within the given timespan
     for the specified object"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"startTime: The start time of the time span"}
    @Param {value:"endTime: The end time of the time span"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectRecordsGetDeleted (string sobjectName, string startTime, string endTime)
    (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECT + sobjectName + "/deleted/?start=" +
                            uri:encode(startTime, "utf-8") + "&end=" + uri:encode(endTime, "utf-8");
        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Retrieves the list of individual records that have been updated (added or changed)
     within the given timespan for the specified object"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"startTime: The start time of the time span"}
    @Param {value:"endTime: The end time of the time span"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectGetUpdated (string sobjectName, string startTime, string endTime)
    (json, error) {
        http:OutRequest requestMsg = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECTS + sobjectName + "/updated/?start=" +
                            uri:encode(startTime, "utf-8") + "&end=" + uri:encode(endTime, "utf-8");
        response, e = oauth2Connector.get(requestURI, requestMsg);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Retrieves information about alternate named layouts for a given object."}
    @Param {value:"object: object name given"}
    @Param {value:"alternateName: alternate named layouts for a given object"}
    @Return {value:"response message"}
    @Return {value:"error:error occured"}
    action sObjectNamedLayouts (string object, string alternateName) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECTS + object + NAMED_LAYOUTS_SUFFIX + alternateName;
        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Accesses records based on the specified object ID, can be used with external objects "}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectRows (string sobjectName, string rowId) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECTS + sobjectName + "/" + rowId;
        response, e = oauth2Connector.get(requestURI, request);
        jsonresponse = response.getJsonPayload();

        return jsonresponse, err;
    }

    @Description {value:"Creates new records or updates existing records (upserts records) based on the value of a
     specified external ID field"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"fieldId: The external field id"}
    @Param {value:"fieldValue: The external field value"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectRowsByExternalId (string sobjectName, string fieldId, string fieldValue)
    (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECTS + sobjectName + "/" + fieldId + "/" + fieldValue;
        response, e = oauth2Connector.get(requestURI, request);
        jsonresponse = response.getJsonPayload();

        return jsonresponse, err;
    }

    @Description {value:"Retrieves the specified blob field from an individual record."}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"id:"}
    @Param {value:"blobField: "}
    action sObjectBlobRetrieve (string sObjectName, string id, string blobField) (blob, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + SOBJECTS + sObjectName + "/" + id + "/" + blobField;
        response, e = oauth2Connector.get(requestURI, request);
        blob blobResponse = response.getBinaryPayload();

        return blobResponse, err;
    }

    //action sobjects/SObjectName/describe/approvalLayouts/

    @Description {value:"Updates an existing record"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"payload: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectUpdate (string sobjectName, string recordId, json payload) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + "/sobjects/" + sobjectName + "/" + recordId;
        request.setJsonPayload(payload);
        response, e = oauth2Connector.patch(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"If record exists, update it else inserts it"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"externalField: The external field id"}
    @Param {value:"fieldValueId: The external field value"}
    @Param {value:"payload: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectUpsert (string sobject, string externalField, string fieldValueId, json payload)
    (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = "/services/data/" + apiVersion + "/sobjects/" + sobject + "/" + externalField + "/" + fieldValueId;
        request.setJsonPayload(payload);
        response, e = oauth2Connector.patch(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TODO Move these structs to another package once https://github.com/ballerina-lang/ballerina/issues/4736 is fixed.//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct ApiVersion {
    string |version|;
    string label;
    string url;
}