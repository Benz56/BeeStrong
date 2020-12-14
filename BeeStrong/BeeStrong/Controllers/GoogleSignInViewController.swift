//
//  GoogleSignInViewController.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 14/12/2020.
//

import UIKit
import GoogleSignIn

class GoogleSignInViewController: UIViewController {
    //Reference GIDSignInButton
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Success. Google Sign In ViewController loaded.")
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    
        // ...
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
      GIDSignIn.sharedInstance().signOut()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
