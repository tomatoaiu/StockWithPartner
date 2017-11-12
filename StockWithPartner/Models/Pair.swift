//
//  Pair.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import Foundation
import Firebase

class Pair {
    private static func generateCode() -> String {
        var codeString: String = ""
        
        for _ in 0 ..< 4 {
            codeString += String(arc4random() % 10)
        }
        
        return codeString
    }
    
    static func publishCode(me: User, callback: @escaping (String)->Void) {
        
        let ref = Database.database().reference()
        let code = self.generateCode()
        
        // TODO: codeの重複チェック
        
        // userのpaircodeを取得
        ref.child("users").child(me.uid).child("pairCode").observeSingleEvent(of: .value, with: { (userPairCodeSnapshot) in
            let value = userPairCodeSnapshot.value
            // 既存のコードがある場合は削除
            if let oldCode = value as? String {
                ref.child("pairCodes").child(oldCode).removeValue()
            }
            
            // 新しいcodeをpairsにset
            ref.child("pairCodes").child(code).setValue(me.uid) { (error, pairRef) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                // 新しくsetしたcodeをuserに登録
                ref.child("users").child(me.uid).child("pairCode").setValue(code, withCompletionBlock: { (error, userPairCodeRef) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    callback(code)
                })
            }
        })
    }
    
    static func codeMatching(code: String, callback: @escaping (Bool)->Void) {
        let ref = Database.database().reference()
        guard let me = Auth.auth().currentUser else {
            callback(false)
            return
        }
        
        ref.child("pairCodes").child(code).observeSingleEvent(of: .value) { (snapshot) in
            let partnersUid = snapshot.value
            
            if let partnersUid = partnersUid as? String {
                // 自分のコードを入力した場合
                if partnersUid == me.uid {
                    callback(false)
                    return
                }
                
                // ペア成立
                
                // リスナーのデタッチ
                ref.child("users").child(me.uid).child("partner_uid").removeAllObservers()
                
                // 自分にpartnerのidを追加する
                ref.child("users").child(me.uid).child("partner_uid").setValue(partnersUid, withCompletionBlock: { (error, meRef) in
                    // 相手のpairCodeを削除し,相手に自分のidを追加する
                    ref.child("users").child(partnersUid).child("partner_uid").setValue(me.uid, withCompletionBlock: { (error, partnerRef) in
                        
                        // 不要になったPairing用codeの削除
                        ref.child("users").child(me.uid).child("pairCode").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let myCode = snapshot.value as? String {
                                ref.child("pairCodes").child(myCode).removeValue()
                                ref.child("pairCodes").child(code).removeValue()
                                ref.child("users").child(me.uid).child("pairCode").removeValue()
                                ref.child("users").child(partnersUid).child("pairCode").removeValue()
                            }
                        })
            
                        // 完了通知
                        callback(true)
                    })
                })
            } else {
                callback(false)
            }
        }
    }
}
