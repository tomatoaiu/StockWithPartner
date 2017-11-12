//
//  LoginViewController.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD


class LoginViewController: UIViewController, GIDSignInUIDelegate{
    
    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        signInButton.colorScheme = GIDSignInButtonColorScheme.light
        signInButton.style = GIDSignInButtonStyle.wide
    }

    func firebaseLogin(_ credential: AuthCredential) {

        Auth.auth().signIn(with: credential) { (user, error) in
            if let _ = error {
                SVProgressHUD.showError(withStatus: "Error")
                return
            }
            
            guard let user = user else {
                SVProgressHUD.showError(withStatus: "Error")
                return
            }
            
            // Sign in 完了
            
            Login.setDisplayName(me: user, callback: {
                Login.hasPartner(callback: { (result) in
                    SVProgressHUD.dismiss()
                    
                    if result {
                        // すでにsign up済み
                        self.performSegue(withIdentifier: "toMain", sender: nil)
                        
                    } else {
                        // 初回ログイン
                        self.performSegue(withIdentifier: "toPair", sender: nil)
                    }
                })
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
