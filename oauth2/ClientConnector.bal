package oauth2;

import ballerina.io;
import ballerina.net.http;
import ballerina.mime;

public struct OAuth2Client {
    http:ClientEndpoint httpClient;
    OAuthConfig oAuthConfig;
}

public struct OAuthConfig {
    string accessToken;
    string refreshToken;
    string clientId;
    string clientSecret;
    string baseUrl;
    string refreshTokenEP;
    string refreshTokenPath;
}

string accessTokenValue;
http:Response response = {};
http:HttpConnectorError e = {};

public function <OAuth2Client oAuth2Client> init (string baseUrl, string accessToken, string refreshToken,
                                                  string clientId, string clientSecret, string refreshTokenEP, string refreshTokenPath) {
    endpoint http:ClientEndpoint httpEP {targets:[ {uri:baseUrl}]};
    OAuthConfig conf = {};
    conf.accessToken = accessToken;
    conf.refreshToken = refreshToken;
    conf.clientId = clientId;
    conf.clientSecret = clientSecret;
    conf.refreshTokenEP = refreshTokenEP;
    conf.refreshTokenPath = refreshTokenPath;

    oAuth2Client. httpClient = httpEP;
    oAuth2Client. oAuthConfig = conf;
}

public function <OAuth2Client oAuth2Client> get (string path, http:Request originalRequest) returns http:Response | http:HttpConnectorError {
                                                endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
    boolean isRefreshed;
    populateAuthHeader(originalRequest, oAuth2Client.oAuthConfig.accessToken);
    var httpResponse = httpClient-> get(path, originalRequest);
    match httpResponse {
                                                                                                    http:Response res = > response=res;
    http:HttpConnectorError err = > return err;
    }
http:Request request = {};
var isRefreshedTokenResponse = checkAndRefreshToken(request, oAuth2Client.oAuthConfig. accessToken,
oAuth2Client. oAuthConfig.clientId, oAuth2Client.oAuthConfig. clientSecret,
oAuth2Client. oAuthConfig.refreshToken, oAuth2Client.oAuthConfig. refreshTokenEP,
oAuth2Client. oAuthConfig.refreshTokenPath);

                          match isRefreshedTokenResponse {
                                boolean val = > isRefreshed=val;
http:HttpConnectorError err = > returnerr;
}
if (isRefreshed) {
    httpResponse = httpClient-> get ( path, request);
                                            }

                                            match httpResponse {
                                                  http:Response res = >  returnresponse;
http:HttpConnectorError err = > returnerr;
}
}

public function <OAuth2Client oAuth2Client> post (string path, http:Request originalRequest)
returns http:Response | http:HttpConnectorError {
                                                endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
        boolean isRefreshed;
        json originalPayload;
        var originalJsonPayload = originalRequest.getJsonPayload();
        match originalJsonPayload {
        json jsonVal = > originalPayload=jsonVal;
        mime:EntityError err = > io:println(err);
}
populateAuthHeader( originalRequest, oAuth2Client. oAuthConfig.accessToken);
                                                               var httpResponse = httpClient-> post( path, originalRequest);
                                                                                                           match httpResponse {
                                                                                                                 http:Response res = > response=res;
http:HttpConnectorError err = > returnerr;
}
http:Request request = {};
request. setJsonPayload(originalPayload);
                        var isRefreshedTokenResponse = checkAndRefreshToken(request, oAuth2Client.oAuthConfig.accessToken,
                                                                            oAuth2Client.oAuthConfig.clientId, oAuth2Client.oAuthConfig.clientSecret,
                                                                            oAuth2Client.oAuthConfig.refreshToken, oAuth2Client.oAuthConfig.refreshTokenEP,
                                                                            oAuth2Client.oAuthConfig.refreshTokenPath);

match isRefreshedTokenResponse {
boolean val = > isRefreshed=val;
http:HttpConnectorError err = > returnerr;
}
if (isRefreshed) {
    httpResponse = httpClient-> post ( path, request);
                                             }

                                             match httpResponse {
                                                   http:Response res = >  returnresponse;
http:HttpConnectorError err = > returnerr;
}
}

public function <OAuth2Client oAuth2Client> put (string path, http:Request originalRequest)
returns http:Response | http:HttpConnectorError {
                                                endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
        boolean isRefreshed;
        json originalPayload;
        var originalJsonPayload = originalRequest.getJsonPayload();
        match originalJsonPayload {
        json jsonVal = > originalPayload=jsonVal;
        mime:EntityError err = > io:println(err);
}
populateAuthHeader( originalRequest, oAuth2Client. oAuthConfig.accessToken);
                                                               var httpResponse = httpClient-> put( path, originalRequest);
                                                                                                          match httpResponse {
                                                                                                                http:Response res = > response=res;
http:HttpConnectorError err = > returnerr;
}
http:Request request = {};
request. setJsonPayload(originalPayload);
                        var isRefreshedTokenResponse = checkAndRefreshToken(request, oAuth2Client.oAuthConfig.accessToken,
                                                                            oAuth2Client.oAuthConfig.clientId, oAuth2Client.oAuthConfig.clientSecret,
                                                                            oAuth2Client.oAuthConfig.refreshToken, oAuth2Client.oAuthConfig.refreshTokenEP,
                                                                            oAuth2Client.oAuthConfig.refreshTokenPath);

match isRefreshedTokenResponse {
boolean val = > isRefreshed=val;
http:HttpConnectorError err = > returnerr;
}
if (isRefreshed) {
    httpResponse = httpClient-> put ( path, request);
                                            }

                                            match httpResponse {
                                                  http:Response res = >  returnresponse;
http:HttpConnectorError err = > returnerr;
}
}

public function <OAuth2Client oAuth2Client> delete (string path, http:Request originalRequest)
returns http:Response | http:HttpConnectorError {
                                                endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
        boolean isRefreshed;
        populateAuthHeader(originalRequest, oAuth2Client.oAuthConfig.accessToken);
        var httpResponse = httpClient-> delete(path, originalRequest);
        match httpResponse {
        http:Response res = > response=res;
        http:HttpConnectorError err = > return err;
}
http:Request request = {};
var isRefreshedTokenResponse = checkAndRefreshToken(request, oAuth2Client.oAuthConfig. accessToken,
oAuth2Client. oAuthConfig.clientId, oAuth2Client.oAuthConfig. clientSecret,
oAuth2Client. oAuthConfig.refreshToken, oAuth2Client.oAuthConfig. refreshTokenEP,
oAuth2Client. oAuthConfig.refreshTokenPath);

                          match isRefreshedTokenResponse {
                                boolean val = > isRefreshed=val;
http:HttpConnectorError err = > returnerr;
}
if (isRefreshed) {
    httpResponse = httpClient-> delete ( path, request);
                                               }

                                               match httpResponse {
                                                     http:Response res = >  returnresponse;
http:HttpConnectorError err = > returnerr;
}
}

public function <OAuth2Client oAuth2Client> patch (string path, http:Request originalRequest)
returns http:Response | http:HttpConnectorError {
                                                endpoint http:ClientEndpoint httpClient = oAuth2Client.httpClient;
        boolean isRefreshed;
        json originalPayload;
        var originalJsonPayload = originalRequest.getJsonPayload();
        match originalJsonPayload {
        json jsonVal = > originalPayload=jsonVal;
        mime:EntityError err = > io:println(err);
}
populateAuthHeader( originalRequest, oAuth2Client. oAuthConfig.accessToken);
                                                               var httpResponse = httpClient-> patch ( path, originalRequest);
                                                                                                             match httpResponse {
                                                                                                                   http:Response res = > response=res;
http:HttpConnectorError err = > returnerr;
}
http:Request request = {};
request. setJsonPayload(originalPayload);
                        var isRefreshedTokenResponse = checkAndRefreshToken(request, oAuth2Client.oAuthConfig.accessToken,
                                                                            oAuth2Client.oAuthConfig.clientId, oAuth2Client.oAuthConfig.clientSecret,
                                                                            oAuth2Client.oAuthConfig.refreshToken, oAuth2Client.oAuthConfig.refreshTokenEP,
                                                                            oAuth2Client.oAuthConfig.refreshTokenPath);

match isRefreshedTokenResponse {
boolean val = > isRefreshed=val;
http:HttpConnectorError err = > returnerr;
}
if (isRefreshed) {
    httpResponse = httpClient-> patch ( path, request);
                                              }

                                              match httpResponse {
                                                    http:Response res = >  returnresponse;
http:HttpConnectorError err = > returnerr;
}
}

function populateAuthHeader (http:Request request, string accessToken) {
    if (accessTokenValue == null || accessTokenValue == "") {
        accessTokenValue = accessToken;
    }
    request.setHeader("Authorization", "Bearer " + accessTokenValue);
}

function checkAndRefreshToken (http:Request request, string accessToken, string clientId,
                               string clientSecret, string refreshToken, string refreshTokenEP, string refreshTokenPath)
returns (boolean) | http:HttpConnectorError {
                    boolean isRefreshed;
if ((response. statusCode == 401) && refreshToken != null) {
                                     var accessTokenValueResponse = getAccessTokenFromRefreshToken(request, accessToken, clientId, clientSecret,
                                                                                                   refreshToken, refreshTokenEP, refreshTokenPath);
match accessTokenValueResponse {
string accessTokenString = > accessTokenValue=accessTokenString;
http:HttpConnectorError err = > returnerr;
}
isRefreshed = true;
}
return isRefreshed;
}

function getAccessTokenFromRefreshToken (http:Request request, string accessToken, string clientId, string clientSecret,
                                         string refreshToken, string refreshTokenEP, string refreshTokenPath)
returns (string) | http:HttpConnectorError {
                   endpoint http:ClientEndpoint refreshTokenHTTPEP {targets:[ {uri:refreshTokenEP}]};
                                                                               http:Request refreshTokenRequest = {};
http:Response httpRefreshTokenResponse = {};
json accessTokenFromRefreshTokenJSONResponse;

string accessTokenFromRefreshTokenReq = refreshTokenPath + "?refresh_token=" + refreshToken
                                        + "&grant_type=refresh_token&client_secret=" + clientSecret
                                        + "&client_id=" + clientId;
var refreshTokenResponse = refreshTokenHTTPEP -> post( accessTokenFromRefreshTokenReq, refreshTokenRequest);
                                                                                       match refreshTokenResponse {
                                                                                             http:Response httpResponse = > httpRefreshTokenResponse=httpResponse;
http:HttpConnectorError err = > returnerr;
}
var jsonPayload = httpRefreshTokenResponse.getJsonPayload();
                                           match jsonPayload {
                                                 json jsonVal = > accessTokenFromRefreshTokenJSONResponse=jsonVal;
mime:EntityError err = > io:println(err);
}

accessToken, _ = (string)accessTokenFromRefreshTokenJSONResponse.access_token;
request. setHeader("Authorization", "Bearer " + accessToken);

                                                return accessToken;
}