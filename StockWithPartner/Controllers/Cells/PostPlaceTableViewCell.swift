//
//  PostPlaceTableViewCell.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import FontAwesome_swift

class PostPlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.text = "No Title"
        self.descriptionTextView.text = "No description"
        self.urlLabel.text = ""
        self.postImageView.image = nil
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setValues(post: Post) {
        self.titleLabel.text = post.title ?? "No Title"
        self.descriptionTextView.text = post.description ?? "No description"
        self.urlLabel.text = post.url
        
        if let post_url = post.url {
            let url = URL(string: post_url)
            
            if let url = url {
                let placeHolderImage = UIImage.fontAwesomeIcon(name: .image, textColor: UIColor.white.withAlphaComponent(0.3), size: CGSize(width: postImageView.bounds.width, height: postImageView.bounds.height), backgroundColor: UIColor.clear, borderWidth: 0, borderColor: UIColor.clear)
                self.postImageView.af_setImage(withURL: url, placeholderImage: placeHolderImage, imageTransition: UIImageView.ImageTransition.curlUp(2))
            }
        } else {
            // ...
        }
    }
}
