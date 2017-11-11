//
//  PairComplete.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/12.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import Foundation
import Firebase

class PairComplete{
    static func fetchPartnersName(me: User, callback: @escaping (String)->Void) {
        let ref = Database.database().reference()
        
        ref.child("users").child(me.uid).child("partner_uid").observeSingleEvent(of: .value) { (snapshot) in
            let partner_uid = snapshot.value
            
            if let partner_uid = partner_uid as? String {
                
                ref.child("users").child(partner_uid).child("name").observeSingleEvent(of: .value, with: { (partnerSnapshot) in
                    let name = partnerSnapshot.value
                    
                    if let name = name as? String {
                        callback(name)
                        return
                    } else {
                        callback("")
                    }
                })
            } else {
                callback("")
            }
        }
    }
}
