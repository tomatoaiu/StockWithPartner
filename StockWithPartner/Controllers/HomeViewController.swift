//
//  HomeViewController.swift
//  StockWithPartner
//
//  Created by TaikiFnit on 2017/11/11.
//  Copyright © 2017 FlyingAroundBottle. All rights reserved.
//

import UIKit
import FontAwesome_swift
import ObjectMapper

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var postList: [Post?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postPlace: UINib = UINib(nibName: "PostPlaceCell", bundle: nil)
        tableView.register(postPlace, forCellReuseIdentifier: "postPlace")
        
        self.tableView.estimatedRowHeight = 190
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.clear
        
        Post.index { (posts) in
            
            posts.forEach({ (post_object) in
                if let post_object = post_object {
                    let post: Post? = Mapper<Post>().map(JSON: post_object)
                    self.postList.append(post)
                    self.tableView.reloadData()
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postPlace", for: indexPath) as! PostPlaceTableViewCell
        
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        guard let post = self.postList[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.setValues(post: post)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
}
