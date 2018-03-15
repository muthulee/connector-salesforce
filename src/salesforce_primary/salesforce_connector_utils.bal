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

package src.salesforce_primary;

import ballerina.config;
import ballerina.io;
import ballerina.log;
import ballerina.net.http;
import ballerina.net.uri;
import oauth2;

oauth2:ClientConnector oauth2Connector = null;

function getOAuth2ClientConnector () (oauth2:ClientConnector) {
    if (oauth2Connector == null) {
        io:println("Creating OAuth2 client");
        oauth2Connector = create oauth2:ClientConnector(config:getGlobalValue(ENDPOINT),
                                                        config:getGlobalValue(ACCESS_TOKEN),
                                                        config:getGlobalValue(CLIENT_ID),
                                                        config:getGlobalValue(CLIENT_SECRET),
                                                        config:getGlobalValue(REFRESH_TOKEN),
                                                        config:getGlobalValue(REFRESH_TOKEN_ENDPOINT),
                                                        config:getGlobalValue(REFRESH_TOKEN_PATH));
        io:println("OAuth2 Client created");
    }

    return oauth2Connector;
}


function sendGetRequest (string url) (json, SalesforceConnectorError) {
    endpoint<oauth2:ClientConnector> oauth2Connector {
        getOAuth2ClientConnector();
    }

    http:OutRequest request = {};
    http:InResponse response = {};
    http:HttpConnectorError err;
    SalesforceConnectorError connectorError;

    response, err = oauth2Connector.get(url, request);
    connectorError = checkAndSetErrors(response, err);
    json payload = response.getJsonPayload();

    if (payload == null) {
        log:printWarn("null payload received for: " + url);
    }

    // TODO check if payload is null or had any error
    return payload, connectorError;
}


function prepareUrl (string[] paths, string[] queryParamNames, string[] queryParamValues) (string) {
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

            value, e = uri:encode(value, ENCODING_CHARSET);
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