//
//  Login.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import Foundation
import Firebase

class Login {
    
    static func hasPartner(callback: @escaping (Bool) -> Void) {
        let ref = Database.database().reference()
        guard let me = Auth.auth().currentUser else {
            print("Faild to get current user")
            callback(false)
            return
        }
        
        ref.child("users").child(me.uid).child("partner_uid").observeSingleEvent(of: .value) { (snapshot) in
            let partner_uid = snapshot.value
            
            if let _ = partner_uid as? String {
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    static func setDisplayName(me: User, callback: @escaping () -> Void) {
        let ref = Database.database().reference()
        
        ref.child("users").child(me.uid).child("name").setValue(me.displayName) { (error, userRef) in
            callback()
        }
    }
}
