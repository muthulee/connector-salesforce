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

// Ballerina config keys
public const string ENDPOINT = "ENDPOINT";
public const string ACCESS_TOKEN = "ACCESS_TOKEN";
public const string CLIENT_ID = "CLIENT_ID";
public const string CLIENT_SECRET = "CLIENT_SECRET";
public const string REFRESH_TOKEN = "REFRESH_TOKEN";
public const string REFRESH_TOKEN_ENDPOINT = "REFRESH_TOKEN_ENDPOINT";
public const string REFRESH_TOKEN_PATH = "REFRESH_TOKEN_PATH";

//Latest API Version
public const string API_VERSION = "v37.0";

//Salesforce endpoints
public const string BASE_URI = "/services/data";
public const string SOBJECTS = "sobjects";
public const string LIMITS_SUFFIX = "limits";
public const string DESCRIBE = "describe";
public const string QUERY = "query";
public const string SEARCH = "search";
public const string QUERYALL = "queryAll";
public const string PLATFORM_ACTION_SUFFIX = "PlatformAction";
public const string MULTIPLE_RECORDS_SUFFIX = "composite/tree";
public const string FIELDS_SUFFIX = "?fields=";

//=================================  SObjects  ==========================================//
public const string ACCOUNT = "Account";
public const string LEAD = "Lead";
public const string CONTACT = "Contact";
public const string OPPORTUNITY = "Opportunity";
public const string PRODUCT = "Product2";