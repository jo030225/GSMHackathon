//
//  ProfileViewController.swift
//  Hackathon
//
//  Created by 김수환 on 2020/09/18.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import FirebaseAuth

import GoogleSignIn

class ProfileViewController: UIViewController {
        @IBOutlet var tableView: UITableView!
        
        let data = ["프로필 수정", "Log out"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableHeaderView = createTableHeader()
            // Do any additional setup after loading the view.
        }
        
        func createTableHeader() -> UIView? {
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                return nil
            }
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            let filename = safeEmail + "_profile_picture.png"
            
            let path = "images/"+filename
            
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 578))
            
            headerView.layer.backgroundColor = UIColor(red: 1, green: 0.972, blue: 0.929, alpha: 1).cgColor
            
            let imageView = UIImageView(frame: CGRect(x: (view.width - 150)/2, y: 75, width: 150, height: 150))
            let nameLabel = UILabel(frame: CGRect(x: 160, y: 10, width: view.width, height: 30))
            let numLabel = UILabel(frame: CGRect(x: 160, y: 40, width: view.width, height: 30))
            let bioTV = UITextView(frame: CGRect(x: 160, y: 70, width: view.width, height: 180))
            let miniView = UIView(frame: CGRect(x: 20, y: 230, width: view.width-40,height: 262))
            
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .white
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 3
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = imageView.width/2
            
            miniView.backgroundColor = .white
        
            
            headerView.addSubview(imageView)
            headerView.addSubview(miniView)
            StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
                switch result {
                case .success(let url):
                    self?.downloadImage(imageView: imageView, url: url)
                case .failure( _):
                    print("Fail to download url")
                }
            })
            
            nameLabel.text = "이름"
            //nameLabel.textAlignment = .center
            nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            miniView.addSubview(nameLabel)
            
            numLabel.text = "학번"
            //numLabel.textAlignment = .center
            numLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            miniView.addSubview(numLabel)
            
            bioTV.text = "관심분야"
            //bioTV.textAlignment = .center
            bioTV.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            bioTV.isEditable = false
            bioTV.contentMode = .scaleAspectFit
            bioTV.backgroundColor = .white
            bioTV.autocapitalizationType = .sentences
            miniView.addSubview(bioTV)
            
            return headerView
        }
        
        func downloadImage(imageView: UIImageView, url: URL){
            URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    imageView.image = image
                }
            }).resume()
        }
        
    }

    extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath)
            cell.textLabel?.text = data[indexPath.row]
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let row = indexPath.row
            

            let editProfileActionSheet = UIAlertController(title: "", message: "",preferredStyle: .actionSheet)
            editProfileActionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            editProfileActionSheet.addAction(UIAlertAction(title: "프로필 수정", style: .destructive){
                (action) in
                let vcName = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController")
                vcName?.modalTransitionStyle = .coverVertical
                self.present(vcName!, animated: true, completion: nil)
            })
            
            
            let loginActionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            loginActionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {[weak self] _ in
                
                guard let StrongSelf = self else{
                    return
                }
                
                //LogOut Facebook
               
                
                //google Logout
                GIDSignIn.sharedInstance()?.signOut()
                
                do{
                    try FirebaseAuth.Auth.auth().signOut()
                    
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    StrongSelf.present(nav,animated: true)
                }
                catch{
                    print("failed to log out")
                }
                
            }))
            loginActionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            
            if row == 0{
                present(editProfileActionSheet, animated: true)
            }
            else if row == 1{
                present(loginActionSheet, animated: true)
            }
        }
    @IBAction func chatBtnClicked(_ sender: UIBarButtonItem) {
        let vc = ConversationsViewController()
               vc.title = ""
               navigationController?.pushViewController(vc, animated: true)
    }
    
}
