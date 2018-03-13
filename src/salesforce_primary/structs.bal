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

import ballerina.net.http;

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

public struct QueryResult {
    boolean done;
    int totalSize;
    json[] records;
    string nextRecordsUrl;
}

public struct QueryPlan {
    int cardinality;
    string[] fields;
    string leadingOperationType;
    FeedbackNote[] notes;
    float relativeCost;
    int sobjectCardinality;
    string sobjectType;
}

public struct FeedbackNote {
    string description;
    string[] fields;
    string tableEnumOrId;
}