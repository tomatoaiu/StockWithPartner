//
//  PostDetailViewController.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postPlace: UINib = UINib(nibName: "PostPlaceCell", bundle: nil)
        tableView.register(postPlace, forCellReuseIdentifier: "postPlace")
        
        let rightButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .camera, textColor: UIColor.white.withAlphaComponent(0.9), size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(PostDetailViewController.tappedPhotoButton))
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        self.tableView.estimatedRowHeight = 190
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.clear
        
        self.navigationItem.title = post?.title
    }
    
    @objc func tappedPhotoButton() {
        
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

extension PostDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postPlace", for: indexPath) as! PostPlaceTableViewCell
            
            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            
            if let post = post {
                cell.setValues(post: post)
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostPhotoCell", for: indexPath) as! PostDetailTableViewCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 0
    }
}
