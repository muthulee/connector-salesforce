package src.wso2.salesforce;

import org.wso2.ballerina.connectors.oauth2;
import ballerina.net.http;
import ballerina.io;

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
    @Param {value:"requestingApiVersion: The api version to get resources"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action listResourcesByApiVersion () (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion;
        response, e = oauth2Connector.get(requestURI, request);
        //io:println(response.getJsonPayload());
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Lists limits information for your organization"}
    @Param {value:"apiVersion: The api version to send request to"}
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
    @Param {value:"apiVersion: the api version to send request"}
    @Return {value:"Array of available objects"}
    @Return {value:"Error occured"}
    action describeGlobal () (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        int i = 0;

        string requestURI = BASE_URI + apiVersion + DESCRIBE_GLOBAL_SUFIX;

        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Describes the individual metadata for the specified object"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectBasicInfo (string sobjectName) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECT + sobjectName;
        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    //equals to create new record
    @Description {value:"Creates new records"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"payload: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action createSObjectRecord (string sobjectName, json payload) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + DESCRIBE_GLOBAL_SUFIX + "/" + sobjectName;
        request.setJsonPayload(payload);
        response, e = oauth2Connector.post(requestURI, request);
        json jsonResponse = response.getJsonPayload();
        json id = jsonResponse.id;

        return id, err;
    }

    @Description {value:"Creates new records or updates existing records (upserts records) based on the value of a
     specified external ID field"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"fieldId: The external field id"}
    @Param {value:"fieldValue: The external field value"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action upsertSObjectRowsByExternalId (string sobjectName, string fieldId, string fieldValue)
    (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECT + sobjectName + "/" + fieldId + "/" + fieldValue;
        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Completely describes the individual metadata at all levels for the specified object"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectDescribe (string sobjectName) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + SOBJECT + sobjectName + SOBJECT_DESCRIBE_SUFFIX;
        response, e = oauth2Connector.get(requestURI, request);
        json jasonResponse = response.getJsonPayload();

        return jasonResponse, err;
    }


    @Description {value:"Updates an existing record"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"payload: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectUpdate (string sobjectName, string recordId, json payload) (http:Response, http:HttpConnectorError) {
        http:Request requestMsg = {};
        http:Response response = {};

        string requestURI = BASE_URI + apiVersion + "/sobjects/" + sobjectName + "/" + recordId;
        requestMsg.setJsonPayload(payload);
        response, e = oauth2Connector.patch(requestURI, requestMsg);

        return response, e;
    }

    @Description {value:"If record exists, update it else inserts it"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"externalField: The external field id"}
    @Param {value:"fieldValueId: The external field value"}
    @Param {value:"payload: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action sObjectUpsert (string apiVersion, string sobject, string externalField, string fieldValueId, json payload)
    (http:Response, http:HttpConnectorError) {
        http:Request requestMsg = {};
        http:Response response = {};

        string requestURI = "/services/data/" + apiVersion + "/sobjects/" + sobject + "/" + externalField + "/" + fieldValueId;
        requestMsg.setJsonPayload(payload);
        response, e = oauth2Connector.patch(requestURI, requestMsg);

        return response, e;
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