//
//  MainTabBarController.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit
import Firebase
import FontAwesome_swift

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers?[0].tabBarItem.image = UIImage.fontAwesomeIcon(name: .home, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        self.viewControllers?[1].tabBarItem.image = UIImage.fontAwesomeIcon(name: .shareAlt, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        self.viewControllers?[2].tabBarItem.image = UIImage.fontAwesomeIcon(name: .gear, textColor: UIColor.white, size: CGSize(width: 30, height: 30))
        
        guard let _ = Auth.auth().currentUser else { return }
        
        Login.hasPartner { (result) in
            if result == false {
                self.performSegue(withIdentifier: "toPair", sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
