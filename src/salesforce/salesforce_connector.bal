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
import ballerina.mime;
import oauth2;

@Description {value:"Salesforce Client Connector"}
public struct SalesforceConnector {
    oauth2:OAuth2Client oauth2;
}

public function <SalesforceConnector sfConnector> init (string baseUrl, string accessToken, string refreshToken,
                                                        string clientId, string clientSecret, string refreshTokenEP, string refreshTokenPath) {
    sfConnector.oauth2 = {};
    sfConnector.oauth2.init(baseUrl, accessToken, refreshToken,
                            clientId, clientSecret, refreshTokenEP, refreshTokenPath);
}

@Description {value:"Lists summary details about each REST API version available"}
@Return {value:"Array of available API versions"}
@Return {value:"Error occured"}
public function <SalesforceConnector sfConnector> getAvailableApiVersions () returns json | error {

error Error = {};
http:Request request = {};

    string path = "/services/data";
    var response = sfConnector.oauth2.get(path, request);
    match response {
        http:HttpConnectorError conError => {
                                             Error = {message:conError.message};
                                             return Error;
                                            }
        http:Response result => {
                                var jsonPayload = result.getJsonPayload();
                                match jsonPayload {
                                                    mime:EntityError entityError => {
                                                        Error = {message:entityError.message};
                                                    return Error;
                                                    }
                                                    json jsonResult => {
                                                    return jsonResult;
                                                    }
                                }
        }
    }
}

public function <SalesforceConnector sfConnector> getResourcesByApiVersion (string apiVersion) returns json {

// error Error = {};
// http:Request request = {};

    string path = "/services/data" + apiVersion;
json response = 

}


public function <SalesforceConnector sfConnector> test(string path) returns json | error {
    error Error = {};
    http:Request request = {};
    var response = sfConnector.oauth2.get(path, request);
    match response {
        http:HttpConnectorError conError => {
            Error = {message:conError.message};
            return Error;
        }
        http:Response result => {
            var jsonPayload = result.getJsonPayload();
            match jsonPayload {
                mime:EntityError entityError => {
                    Error = {message:entityError.message};
                    return Error;
                }
                json jsonResult => {
                    return jsonResult;
                }
            }
        }
    }
}

public function <SalesforceConnector sfConnector> createRecord (string sObjectName, string id) returns boolean {
    http:Request request = {};
    error sfError = {};
    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, id], null, null);
    var response = sfConnector.oauth2.delete(path, request);
    match response {
        http:HttpConnectorError conError => {
            Error = {message:conError.message};
            throw Error;
        }
        http:Response result => {
            if (result.statusCode == 200 || result.statusCode == 201 || result.statusCode == 204) {
                json value = result.getJsonPayload();
                return true;
            } else {
                sfError = {message:"Was not updated"};
                throw sfError;
            }
        }
    }
}



public function <SalesforceConnector sfConnector> updateRecord (string sObjectName, string id) returns boolean {
    http:Request request = {};
    error sfError = {};
    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, id], null, null);
    var response = sfConnector.oauth2.delete(path, request);
    match response {
        http:HttpConnectorError conError => {
            Error = {message:conError.message};
            throw Error;
        }
        http:Response result => {
            if (result.statusCode == 200 || result.statusCode == 201 || result.statusCode == 204) {
                return true;
            } else {
                sfError = {message:"Was not updated"};
                throw sfError;
            }
        }
    }
}


public function <SalesforceConnector sfConnector> deleteRecord (string sObjectName, string id) returns boolean {
    http:Request request = {};
    error sfError = {};
    string path = prepareUrl([API_BASE_PATH, SOBJECTS, sObjectName, id], null, null);
    var response = sfConnector.oauth2.delete(path, request);
    match response {
        http:HttpConnectorError conError => {
            Error = {message:conError.message};
            throw Error;
        }
        http:Response result => {
            if (result.statusCode == 200 || result.statusCode == 201 || result.statusCode == 204) {
                return true;
            } else {
                sfError = {message:"Was not deleted"};
                throw sfError;
            }
        }
    }
}

function prepareUrl (string[] paths, string[] queryParamNames, string[] queryParamValues) returns string {
    string url = "";
    error e;

    if (paths != null) {
        foreach path in paths {
            if (!path.hasPrefix("/")) {
                url = url + "/";
            }

            url = url + path;
        }
    }

    if (queryParamNames != null) {
        url = url + "?";
        boolean first = true;
        foreach i, name in queryParamNames {
            string value = queryParamValues[i];

            value = uri:encode(value, ENCODING_CHARSET);
            if (e != null) {
                log:printErrorCause("Unable to encode value: " + value, e);
                break;
            }

            if (first) {
                url = url + name + "=" + value;
                first = false;
            } else {
                url = url + "&" + name + "=" + value;
            }
        }
    }

    log:printDebug("Prepared URL: " + url);
    return url;
}

