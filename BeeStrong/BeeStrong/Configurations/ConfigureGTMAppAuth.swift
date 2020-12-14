//
//  ConfigureGTMAppAuth.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 14/12/2020.
//

import UIKit
import AppAuth
import GTMAppAuth
import GoogleAPIClientForREST

class ConfigureGTMAppAuthViewController: UIViewController {
    
    private let kKeychainItemName = "SeatingChartIOS"
    private let kClientID = "102352110855-vall5gr93l9bq2v90ck5vehdpqp73hm6.apps.googleusercontent.com"
    private let kRedirectURI = "get your own u scrub"
    //private let kAuthorizerKey = "authorization"
    private let kIssuer = "https://accounts.google.com"

    var authState: OIDAuthState?
    
    let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
    var authorization: GTMAppAuthFetcherAuthorization?
    var kExampleAuthorizerKey = "authorization"
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var textView: UITextView!
    
    // When the view loads, create necessary subviews
    // and initialize the Google Calendar API service
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuth()
        
    }
    
    //delegates
    func logMessage(_ message: String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        textView.text = textView.text + "\n" + dateString + ": " + message
    }
    @IBAction func authorize(_ sender: Any)
    {
        auth()
    }
    
    func saveAuth()
    {
        if authorization != nil && (authorization?.canAuthorize())! {
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: authorization!)
            userDefaults.set(encodedData, forKey: kExampleAuthorizerKey)
            userDefaults.synchronize()
        }
        else {
            userDefaults.removeObject(forKey: kExampleAuthorizerKey)
        }
    }
    
    func loadAuth()
    {
        if let _ = userDefaults.object(forKey: kExampleAuthorizerKey)
        {
            let decoded = userDefaults.object(forKey: kExampleAuthorizerKey) as! Data
            let testAuth = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! GTMAppAuthFetcherAuthorization
            authorization = testAuth
            //service.authorizer = authorization
        }
    }
    
    @IBAction func doWork(_ sender: Any)
    {
        //If service has authorizer
        /*if let _ = service.authorizer {
            // create event, etc.
        }
        else
        {
            auth()
        }
 */
    }

    func auth()
    {
        //need this potatoe
        let issuer = URL(string: kIssuer)!
        let redirectURI = URL(string: kRedirectURI)!

        logMessage("Fetching configuration for issuer: " + issuer.description)
        // discovers endpoints
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer, completion: {(_ configuration: OIDServiceConfiguration?, _ error: Error?) -> Void in
            if configuration == nil {
                self.logMessage("Error retrieving discovery document: " + (error?.localizedDescription)!)
                return
            }
            self.logMessage("Got configuration: " + configuration!.description)
            // builds authentication request
            let scopes = [kGTLRAuthScopeCalendar]
            let request = OIDAuthorizationRequest(configuration: configuration!, clientId: self.kClientID, scopes: scopes, redirectURL: redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
            // performs authentication request
            self.logMessage("Initiating authorization request with scope: " + request.scope!.description)
            /*
            self.appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: self, callback: {(_ authState: OIDAuthState?, _ error: Error?) -> Void in
                if authState != nil {
                    self.logMessage("Got authorization tokens. Access token: " + (authState?.lastTokenResponse?.accessToken!.description)!)
                    self.authorization = GTMAppAuthFetcherAuthorization(authState: authState!)
                    self.service.authorizer = self.authorization
                    self.driveService.authorizer = self.authorization
                    
                    self.saveAuth()
                }
                else {
                    self.logMessage("Authorization error: " + (error?.localizedDescription.description)!)
                }
            })
 */
        })
    }
}
