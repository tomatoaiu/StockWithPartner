//
//  Post.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/12.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class Post : Mappable{
    
    var id: String?
    var url: String?
    var title: String?
    var description: String?
    var image_url: UIImage?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        url <- map["url"]
        title <- map["titlte"]
        description <- map["description"]
        image_url <- map["image_url"]
    }
    
    static func index(callback: @escaping ([[String: Any]?]) -> Void) {
        // このuserに紐付けられている投稿一覧を取得する
        
        guard let me = Auth.auth().currentUser else {
            return
        }
        
        let ref = Database.database().reference()
        var posts: [[String: Any]?] = []
        
        ref.child("users").child(me.uid).child("posts").observeSingleEvent(of: .value) { (snapshot) in
            let post_keys = snapshot.value
            
            if let post_keys = post_keys as? [String: Bool] {
                // 投稿を幾つか持っている
                
                let dispatchGroup = DispatchGroup()
                let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
                
                post_keys.keys.forEach({ (post_key) in
                    dispatchGroup.enter()
                    dispatchQueue.async(group: dispatchGroup) {
                        ref.child("posts").child(post_key).observeSingleEvent(of: .value, with: { (snapshot) in
                            let post = snapshot.value
                            
                            if var post = post as? [String: Any] {
                                post["id"] = post_key
                                posts.append(post)
                            }
                            
                            dispatchGroup.leave()
                        })
                    }
                })
                
                dispatchGroup.notify(queue: .main) {
                    callback(posts)
                }
            }
        }
    }
}
