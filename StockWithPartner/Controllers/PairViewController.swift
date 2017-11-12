//
//  PairViewController.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PairViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var myCodeLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet var DoneView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let me = Auth.auth().currentUser else {
            return
        }
        
        Pair.publishCode(me: me) { (code) in
            let attributeCode = NSMutableAttributedString(string: code)
            let customLetterSpacing = 10
            attributeCode.addAttribute(NSAttributedStringKey.kern, value: customLetterSpacing, range: NSMakeRange(0, attributeCode.length))
            self.myCodeLabel.attributedText = attributeCode
        }
        
        codeTextField.becomeFirstResponder()
        codeTextField.inputAccessoryView = DoneView
        
        let ref = Database.database().reference()
        
        ref.child("users").child(me.uid).child("partner_uid").observe(.value) { (snapshot) in
            let partner_uid = snapshot.value
            if let _ = partner_uid as? String {
                // 相手が入力してくれた
                Login.setDisplayName(me: me, callback: {
                    self.performSegue(withIdentifier: "toPairComplete", sender: nil)
                })
                
                // リスナーのデタッチ
                ref.child("users").child(me.uid).child("partner_uid").removeAllObservers()
            }
        }
    }

    @IBAction func tapDoneButton(_ sender: UIButton) {
        guard let code = codeTextField.text else { return }
        
        doneButton.isEnabled = false
        SVProgressHUD.show()
        
        Pair.codeMatching(code: code) { (result) in
            self.doneButton.isEnabled = true
            
            if result == false {
                SVProgressHUD.showError(withStatus: "Faild")
                return
            }

            SVProgressHUD.dismiss()
            
            guard let me = Auth.auth().currentUser else {
                return
            }
            
            Login.setDisplayName(me: me, callback: {
                self.performSegue(withIdentifier: "toPairComplete", sender: nil)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
