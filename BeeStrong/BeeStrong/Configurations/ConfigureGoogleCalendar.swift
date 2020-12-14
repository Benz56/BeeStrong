//
//  ConfigureGoogleCalendar.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 14/12/2020.
//
import Foundation
import AppAuth
import GTMAppAuth
import GoogleAPIClientForREST

class ConfigureGoogleCalendar : UIViewController {
    let configuration = GTMAppAuthFetcherAuthorization.configurationForGoogle()
    private let kClientID = "102352110855-vall5gr93l9bq2v90ck5vehdpqp73hm6.apps.googleusercontent.com"
    private let kClientSecret = ""
    private let redirectURI = "com.googleusercontent.apps.102352110855-vall5gr93l9bq2v90ck5vehdpqp73hm6"
    
    // property of the app's UIApplicationDelegate
    weak var currentAuthorizationFlow: OIDExternalUserAgentSession?
    
    func buildRequest() -> Void {
        /*
        // builds authentication request
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: kClientID,
            clientSecret: kClientSecret,
            scopes: [OIDScopeOpenID, OIDScopeProfile],
            redirectURL: redirectURI,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil);
        // performs authentication request
        appDelegate.currentAuthorizationFlow = OIDAuthState.presentingAuthorizationRequest(
            request,
            callback: { [self] authState, error in
                if let authState = authState {
                    // Creates the GTMAppAuthFetcherAuthorization from the OIDAuthState.
                    let authorization = GTMAppAuthFetcherAuthorization(authState: authState)

                    self.authorization = authorization
                    if let accessToken = authState.lastTokenResponse.accessToken {
                        print(
                            "Got authorization tokens. Access token: \(accessToken)")
                    }
                } else {
                    print("Authorization error: \(error?.localizedDescription ?? "")")
                    self.authorization = nil
                }
            })
 */
    }
    
}
