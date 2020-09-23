//
//  MainViewController.swift
//  Hackathon
//
//  Created by 김수환 on 2020/09/23.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import FirebaseAuth
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var table: UITableView!
    var models = [InstagramPost]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        append()
        
        table.register(MainTableViewCell.nib(), forCellReuseIdentifier: MainTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        //refecth data
        append()
    }
    
    
    
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            validateAuth()
        }
        private func validateAuth(){
    //        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
         
            
            if FirebaseAuth.Auth.auth().currentUser == nil{
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                present(nav,animated: false)
            }
        }
    
    
    func append(){
        models.removeAll()
        fetchPostdata {[weak self] (posts) in
            guard let strongself = self else{
                return
            }
            for post in posts {
                print("postData : \(post.title)\n")
                let image = "http://3.136.17.152:3000/images/\(post.link!)"
                print(image)
                strongself.models.append(InstagramPost(TextViewName: post.title, postImageName: image, contents: post.contents))
            }
        }
    }
    
    func fetchPostdata(completionHandler: @escaping ([Post]) -> Void){
           models.removeAll()
           let url = URL(string: "http://3.136.17.152:3000")!
           
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               
               guard let data = data else { return }
               
               do {
                   
                   let postsData = try JSONDecoder().decode([Post].self, from: data)
                   
                   completionHandler(postsData)
                   
               }catch{
                   let error = error
                   print("\(error.localizedDescription)")
               }
               DispatchQueue.main.async {
                   self.table.refreshControl?.endRefreshing()
                   
                   self.table.reloadData()
               }
           }.resume()
       }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           return models.count
           
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
           cell.configure(with: models[indexPath.row])
           return cell
       }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 300
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
       }
    
    
}
struct Post: Codable {
    var num: Int!
    var id: String!
    var title: String!
    var contents: String!
    var recruit:String
    var link: String!
    var tag: String!
    var boards: String!
    var dates: String!
    var heart: String!
}

struct InstagramPost {
    let TextViewName: String
    let postImageName: String
    let contents: String
}
