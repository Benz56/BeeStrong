//
//  GoogleSignInViewController.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 14/12/2020.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class GoogleSignInViewController: UIViewController {
    
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    private let scopes = [kGTLRAuthScopeCalendarEvents, kGTLRAuthScopeCalendar]
    
    let googleCalendarAPI = GoogleCalendarAPI();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sign-out button is hidden and disabled by default
        enableButton(signOutButton, false)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        updateScreen()
        // Register notification to update screen after user successfully signed in
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidSignInGoogle(_:)),
                                               name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
    }
    
    // MARK:- Notification
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        // Update screen after user successfully signed in
        updateScreen()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.scopes.append(contentsOf: scopes)
        GIDSignIn.sharedInstance()?.signIn()
        updateScreen()
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        updateScreen()
    }
    
    func enableButton(_ button: UIButton,_ enable: Bool) {
        button.isHidden = !enable
        button.isEnabled = enable
    }
    
    private func updateScreen() {
        //The GIDSignIn‘s currentUser is an instance of GIDGoogleUser. You can use it to get all the user information such as user ID, user’s full name, email, and authentication token.
        if let user = GIDSignIn.sharedInstance()?.currentUser {
            // User signed in
            
            // Show greeting message
            welcomeTitle.text = "Signed in"
            welcomeMessage.text = "Hello \(user.profile.givenName!)!"
            
            // Hide sign in button
            enableButton(signInButton, false)
            
            // Show sign out button
            enableButton(signOutButton, true)
            
        } else {
            // User signed out
            
            // Show sign in message
            welcomeTitle.text = "Please sign in..."
            welcomeMessage.text = "This allows the app to add\nyour training sessions to Google Calendar."
            
            // Show sign in button
            enableButton(signInButton, true)
            
            // Hide sign out button
            enableButton(signOutButton, false)
        }
    }
}
