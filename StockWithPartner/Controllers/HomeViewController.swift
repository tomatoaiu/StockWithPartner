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
import SVProgressHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    var postList: [Post?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        let postPlace: UINib = UINib(nibName: "PostPlaceCell", bundle: nil)
        tableView.register(postPlace, forCellReuseIdentifier: "postPlace")
        
        self.tableView.estimatedRowHeight = 190
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.clear
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Update")
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.tableView.refreshControl = self.refreshControl
        
        fetch()
    }
    
    @objc func refresh() {
        self.postList.removeAll()
        fetch()
    }
    
    func fetch() {
        Post.index { (posts) in
            
            posts.forEach({ (post_object) in
                if let post_object = post_object {
                    print(post_object)
                    let post: Post? = Mapper<Post>().map(JSON: post_object)
                    self.postList.append(post)
                }
            })
            
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
            self.refreshControl.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let post = sender as? Post else {
            return
        }
        
        if let next = segue.destination as? PostDetailViewController {
            next.post = post
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
        
        print(indexPath.row)
        print(self.postList.count)
        if indexPath.row > self.postList.count {
            return UITableViewCell()
        }
        
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
        guard let post = self.postList[indexPath.row] else {
            return
        }
        self.performSegue(withIdentifier: "toPostDetail", sender: post)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
}
