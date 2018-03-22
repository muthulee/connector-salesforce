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
public function <SalesforceConnector sfConnector> getAvailableApiVersions () returns json {
json response;

    string path = "/services/data";
    try{
        response = sfConnector.get(path);
        }
    catch(error Error){
        throw Error;
    }
    return response;
}

public function <SalesforceConnector sfConnector> getResourcesByApiVersion (string apiVersion) returns json {
json response;

    string path = "/services/data" + apiVersion;
    try{
        response = sfConnector.get(path);
        }
    catch(error Error){
        throw Error;
    }
    return response;
}

@Description {value:"Lists limits information for your organization"}
@Return {value:"response message"}
@Return {value:"Error occured "}
public function <SalesforceConnector sfConnector> getOrganizationLimits () returns json {
json response;

    string path = "/services/data" + API_VERSION + "/limits";
    try{
        response = sfConnector.get(path);
        }
    catch(error Error){
        throw Error;
    }
    return response;
}

@Description {value:"Get feedback on how Salesforce will execute the query, report, or list view based on performance"}
@Param {value:"queryReportOrListview: The parameter to get feedback on"}
@Return {value:"response message"}
@Return {value:"Error occured"}
public function <SalesforceConnector sfConnector> explainQueryOrReportOrListview (string queryReportOrListview) returns json {
json response;

    string path = "/services/data" + API_VERSION + "/query/?explain=" + queryReportOrListview;
    try{
        response = sfConnector.get(path);
        }
    catch(error Error){
        throw Error;
    }
    return response;
}

//============================ utility functions================================//
public function <SalesforceConnector sfConnector> get(string path) returns json {
   error err = {};
   json jsonResult;
    http:Request request = {};
    var response = sfConnector.oauth2.get(path, request);
    match response {
        http:HttpConnectorError conError => {
                                             err = {message:conError.message};
                                             throw err;
                                            }
        http:Response result => {
                                var jsonPayload = result.getJsonPayload();
                                match jsonPayload {
                                                    mime:EntityError entityError => {
                                                        err = {message:entityError.message};
                                                    throw err;
                                                    }
                                                    json jsonRes => {
                                                        jsonResult = jsonRes;
                                                    }
                                }
        }
    }
    return jsonResult;
}
