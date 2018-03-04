package src.wso2.salesforce;

import ballerina.net.uri;
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
@Param {value:"refreshTokenPath: "}

public connector ClientConnector (string baseUrl, string accessToken, string clientId, string clientSecret, string refreshToken,
                                  string refreshTokenEndpoint, string refreshTokenPath) {

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

        response, e = oauth2Connector.get(VERSIONS_URI, request);
        io:println("Error is:");
        io:println(e);
        json jsonResponse = response.getJsonPayload();
        //io:println("JSON Payload is: " + jsonResponse.toString());
        apiVersionsJsonArray, err = (json[])jsonResponse;
        //io:println("Json casted response is:");
        //io:println(apiVersionsJsonArray);

        foreach element in apiVersionsJsonArray {
            io:println(element);
            apiVersions[i], err = <ApiVersion>element;
            io:println(apiVersions[i]);
            i = i + 1;
        }

        return apiVersions, err;
    }

    @Description {value:"Lists the available objects and their metadata for your organization and available to the logged-in user"}
    @Param {value:"apiVersion: the api version to send request"}
    @Return {value:"Array of available objects"}
    @Return {value:"Error occured"}
    action describeGlobal (string apiVersion) (SObject[], error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        json[] sobjectsJsonArray;
        SObject[] sobjects = [];
        int i = 0;

        string describeGlobalURI = VERSIONS_URI + apiVersion + DESCRIBE_GLOBAL_SUFIX;

        response, e = oauth2Connector.get(describeGlobalURI, request);
        json jsonResponse = response.getJsonPayload();
        //io:println("Json response is: \n" + jsonResponse.sobjects.toString());
        //sobjectsJsonArray, err = jsonResponse.sobjects;
        //io:println(sobjectsJsonArray);
        io:println(err);

        foreach element in jsonResponse.sobjects {
            //io:println(element);
            sobjects[i], err = <SObject>element;
            //io:println(sobjects[i]);
            i = i + 1;
        }

        return sobjects, err;
    }
}

public struct ApiVersion {
    string |version|;
    string label;
    string url;
}

public struct SObject {
    boolean activateable;
    boolean custom;
    boolean customSetting;
    boolean createable;
    boolean deletable;
    boolean deprecatedAndHidden;
    boolean feedEnabled;
    string keyPrefix;
    string label;
    string labelPlural;
    boolean layoutable;
    boolean mergeable;
    boolean mruEnabled;
    string name;
    boolean queryable;
    boolean replicateable;
    boolean retrieveable;
    boolean searchable;
    boolean triggerable;
    boolean undeletable;
    boolean updateable;
    json urls;
}

public struct ConnectorError {
    string statusCode; //for response
    string message;
    boolean isConnectionError;
    SalesforceError salesforceError;
}

public struct SalesforceError {
    string errorCode;
    string message;
}