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

class PostURLViewController: UIViewController {

	@IBOutlet weak var postUrlLabel: UILabel!
	@IBOutlet weak var postUrlTextField: UITextField!
	@IBAction func postUrlButton(_ sender: Any) {
//		let url = postUrlTextField.text!
//		print(url)
		
		let url = "https://github.com/satoshi-takano/OpenGraph"
		
		guard let me = Auth.auth().currentUser else {
			return
		}
		
		OpenGraph.fetch(url: URL(string: url)!) { og, error in
			print(og?[.title]) // => og:title of the web site
			print(og?[.type])  // => og:type of the web site
			print(og?[.image]) // => og:image of the web site
			print(og?[.url])   // => og:url of the web site
			print(og?[.description])   // => og:url of the web site
			
			let ref = Database.database().reference()
			
			
			ref.child("users").child(me.uid).child("partner_uid").observeSingleEvent(of: .value, with: { (snapshot) in
				let partner_uid = snapshot.value
				
				if let partner_uid = partner_uid as? String {
				
				let new_post = ref.child("posts").childByAutoId()
					new_post.setValue([
						"title"       : og?[.title],
						"url"         : og?[.url],
						"description" : og?[.description],
						"image-url"   : og?[.image],
						"owner"       : [
							me.uid : true,
							partner_uid : true
						]
						])
					
					ref.child("users").child(me.uid).child("posts").updateChildValues([new_post.key : true])
					ref.child("users").child(partner_uid).child("posts").updateChildValues([new_post.key : true])
				}
			})

		}
		
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
