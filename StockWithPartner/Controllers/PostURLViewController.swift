//
//  PostURLViewController.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit
import OpenGraph
import Firebase
import SVProgressHUD

class PostURLViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var postUrlLabel: UITextView!
    @IBOutlet weak var postUrlTextField: UITextField!
    @IBOutlet weak var postUrlButton: UIButton!
    
    @IBAction func postUrlTapped(_ sender: Any) {
        
        
        SVProgressHUD.show()
        
        guard let me = Auth.auth().currentUser else {
            SVProgressHUD.showError(withStatus: "Invaild Auth")
            return
        }
        
        guard let urlString = postUrlTextField.text else {
            SVProgressHUD.showError(withStatus: "Invaild String")
            return
        }
        
        guard let url = URL(string: urlString) else {
            SVProgressHUD.showError(withStatus: "Invalid URL")
            return
        }
        
        OpenGraph.fetch(url: url) { og, error in
            
            let ref = Database.database().reference()
            
            ref.child("users").child(me.uid).child("partner_uid").observeSingleEvent(of: .value, with: { (snapshot) in
                let partner_uid = snapshot.value
                
                if let partner_uid = partner_uid as? String {
                    
                    let new_post = ref.child("posts").childByAutoId()
                    new_post.setValue([
                        "title"       : og?[.title],
                        "url"         : url.absoluteString,
                        "description" : og?[.description],
                        "image-url"   : og?[.image],
                        "owner"       : [
                            me.uid : true,
                            partner_uid : true
                        ]
                    ], withCompletionBlock: { (error, newPostRef) in
                        ref.child("users").child(me.uid).child("posts").updateChildValues([new_post.key : true], withCompletionBlock: { (error, myRef) in
                            ref.child("users").child(partner_uid).child("posts").updateChildValues([new_post.key : true], withCompletionBlock: { (error, yourRef) in
                                SVProgressHUD.showSuccess(withStatus: "追加完了しました。")
                                self.postUrlTextField.text = ""
                                self.postUrlTextField.endEditing(true)
                                self.tabBarController?.selectedIndex = 0
                            })
                        })
                    })
                } else {
                    SVProgressHUD.showError(withStatus: "no partner found")
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        postUrlButton.layer.borderWidth = 1
        postUrlButton.layer.borderColor = UIColor.white.cgColor
        
        postUrlTextField.delegate = self
        postUrlTextField.layer.borderWidth = 1
        postUrlTextField.layer.borderColor = UIColor.white.cgColor
//        postUrlTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
