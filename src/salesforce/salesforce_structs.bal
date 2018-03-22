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

public struct ApiVersion {
   string ^"version";
   string label;
   string url;
}

type SalesforceError object {
   public{
      string message,
      string errorCode;
   }
}

type SalesforceConnectorError object {
   public{
      string[] messages,
      error[] errors,
      SalesforceError[] salesforceErrors;
   }
}

//public struct QueryResult {
//   public{
//      boolean done,
//      int totalSize,
//      json[] records,
//      string nextRecordsUrl;
//   }
//}

public struct SearchResult {
   json attributes;
   string Id;
}

//public struct QueryPlan {
//   int cardinality;
//   string[] fields;
//   string leadingOperationType;
//   FeedbackNote[] notes;
//   float relativeCost;
//   int sobjectCardinality;
//   string sobjectType;
//}

//public struct FeedbackNote {
//   string description;
//   string[] fields;
//   string tableEnumOrId;
//}

//========================== QueryResult bound function ==========================//

@Description {value:"If the query results are too large, retrieve the next batch of results using nextRecordUrl"}
@Return {value:"returns QueryResult struct"}
@Return {value:"Error occured"}
public function <QueryResult queryResult> getNextQueryResult () (QueryResult, SalesforceConnectorError) {
   SalesforceConnectorError connectorError;
   json response;

   response, connectorError = sendGetRequest(queryResult.nextRecordsUrl);

   QueryResult result = {};

   if (connectorError != null) {
       return result, connectorError;
   }

   result.done, _ = (boolean)response.done;
   result.totalSize, _ = (int)response.totalSize;
   result.records, _ = (json[])response.records;
   if (response.nextRecordsUrl != null) {
       result.nextRecordsUrl = response.nextRecordsUrl.toString();
   } else {
       result.nextRecordsUrl = null;
   }

   return result, connectorError;
}