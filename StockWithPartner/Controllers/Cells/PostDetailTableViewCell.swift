//
//  PostDetailTableViewCell.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/12.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var postName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
