//
//  PairCompleteViewController.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/12.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit
import Firebase

class PairCompleteViewController: UIViewController {

    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.borderWidth = 2
        getStartedButton.layer.borderColor = UIColor.white.cgColor
        
        guard let me = Auth.auth().currentUser else {
            return
        }
        
        PairComplete.fetchPartnersName(me: me) { (partnerName) in
            self.yourNameLabel.text = partnerName
            self.myNameLabel.text = me.displayName
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
