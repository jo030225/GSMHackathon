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
        
        let data = ["Edit Profile", "Log out"]
        
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
            let nameLabel = UILabel(frame: CGRect(x: 0, y: 30, width: view.width-40, height: 30))
            let numLabel = UILabel(frame: CGRect(x: 0, y: 70, width: view.width-40, height: 30))
            let bioTV = UITextView(frame: CGRect(x: 40, y: 110, width: view.width-120, height: 120))
            let miniView = UIView(frame: CGRect(x: 20, y: 250, width: view.width-40,height: 262))
            
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .white
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 3
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = imageView.width/2
            headerView.addSubview(imageView)
            StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
                switch result {
                case .success(let url):
                    self?.downloadImage(imageView: imageView, url: url)
                case .failure( _):
                    print("Fail to download url")
                }
            })
            
            miniView.backgroundColor = .white
            miniView.layer.cornerRadius = 10
            miniView.layer.shadowColor = UIColor.lightGray.cgColor
            miniView.layer.shadowOpacity = 5
            miniView.layer.shadowOffset = .zero
            headerView.addSubview(miniView)
            
            nameLabel.text = "진예원"
            nameLabel.textAlignment = .center
            nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
            miniView.addSubview(nameLabel)
            
            numLabel.text = "2119"
            numLabel.textAlignment = .center
            numLabel.textColor = .gray
            numLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            miniView.addSubview(numLabel)
            
            bioTV.text = "UIUX 디자인에 관심이 있어 열심히 공부하고 있습니다 !"
            bioTV.textAlignment = .center
            bioTV.textColor = .gray
            bioTV.font = UIFont.systemFont(ofSize: 14)
            bioTV.isEditable = false
            bioTV.contentMode = .scaleAspectFit
            bioTV.layer.cornerRadius = 10
            bioTV.layer.backgroundColor = UIColor(red: 1, green: 0.972, blue: 0.929, alpha: 1).cgColor
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
