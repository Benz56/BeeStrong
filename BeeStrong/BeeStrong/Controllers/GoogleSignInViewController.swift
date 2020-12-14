//
//  GoogleSignInViewController.swift
//  BeeStrong
//
//  Created by Sofie Louise Madsen on 14/12/2020.
//

import UIKit
import GoogleSignIn

class GoogleSignInViewController: UIViewController {
    //Create GIDSignInButton 
    weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
      super.viewDidLoad()

      GIDSignIn.sharedInstance()?.presentingViewController = self

      // Automatically sign in the user.
      GIDSignIn.sharedInstance()?.restorePreviousSignIn()

      // ...
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
