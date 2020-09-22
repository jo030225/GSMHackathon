//
//  ViewController.swift
//  Hackathon
//
//  Created by 김수환 on 2020/09/18.
//  Copyright © 2020 김수환. All rights reserved.
//
import SideMenu
import UIKit
import FirebaseAuth
import Alamofire

struct APIResponse: Codable {
    let results: APIResponseResults
    let status: String
}

struct APIResponseResults: Codable {
    let num: Int
    let id: String
    let title: String
    let contents: String
    let recruit: String
    let link: String
    let tag: String
    let board: String
    let dates: String
    let heart: String
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuControllerDelegate  {
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var sideMenu: SideMenuNavigationController?
    
    private let settingsController = SettingViewController()
    private let infoController = InfoViewController()
    
    private var titledata = [String]()
    private var contentsdata = [String]()
    private var linkdata = [String]()
    private var tagdata = [String]()
    private var datesdata = [String]()
    private var heartdata = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPostdata { (posts) in
            for post in posts {
                self.titledata.append("\(post.title!)")
                print("\(self.titledata)")
                self.contentsdata.append("\(post.contents!)")
                self.datesdata.append("\(post.dates!)")
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "Cell")
        
        tableView.reloadData()
        //fetchData()
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
        }

        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        testJson(email: myEmail)
//        getName(email: myEmail)
        
        //-------사이드 메뉴
        let menu = MenuController(with: SideMenuItem.allCases)
        
        menu.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        addChildControllers()
        //------사이드 메뉴
        
    }
    
    
    //    로그인 확인
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    @objc private func didPullToRefresh() {
        //refecth data
    }
    
    func fetchPostdata(completionHandler: @escaping ([Post]) -> Void){
            
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
                
            }.resume()
        }
    
    func getName(email:String) {
        
     let URL = "http://localhost:3000/showName"
               
               
               let PARAM: Parameters = [
                   "email":email,
                   
               ]
               //위의 URL와 파라미터를 담아서 POST 방식으로 통신하며, statusCode가 200번대(정상적인 통신) 인지 유효성 검사 진행
               let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200..<300)
               //결과값으로 문자열을 받을 때 사용
               alamo.responseString() { response in
                   switch response.result
                   {
                   //통신성공
                   case .success(let value):
                       print("success:\(value)")
                       
                     
                       
                   //통신실패
                   case .failure(let error):
                       print("error: \(String(describing: error.errorDescription))")
                     
                   }
               }
               
           }

    
    
    func testJson(email: String) {
        let URL = "http://localhost:3000/CheckName"
        
        
        let PARAM: Parameters = [
            "email":email,
            
        ]
        //위의 URL와 파라미터를 담아서 POST 방식으로 통신하며, statusCode가 200번대(정상적인 통신) 인지 유효성 검사 진행
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success(let value):
                if value == "Failed"{
                    print("Failed: \(value)")
                    
                    let vc = RegisterViewController()
                               let nav = UINavigationController(rootViewController: vc)
                               nav.modalPresentationStyle = .fullScreen
                    self.present(nav,animated: false)

                    
                }
                
                else{
                    print("Success: \(value)")
                }
                
              
                
            //통신실패
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
              
            }
        }
        
    }
    
    
    private func validateAuth(){
        
        if FirebaseAuth.Auth.auth().currentUser == nil{
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav,animated: false)
        }
    }
    
    
    
    
    //----------사이드 메뉴
    private func addChildControllers() {
        addChild(settingsController)
        addChild(infoController)
        
        view.addSubview(settingsController.view)
        view.addSubview(infoController.view)
        
        settingsController.view.frame = view.bounds
        infoController.view.frame = view.bounds
        
        settingsController.didMove(toParent: self)
        infoController.didMove(toParent: self)
        
        settingsController.view.isHidden = true
        infoController.view.isHidden = true
    }
    
    @IBAction func didTapMenuButton() {
        present(sideMenu!, animated: true)
    }    
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
        if named.rawValue != "logOut"{
        title = named.rawValue
        }
        
        switch named {
        case .home:
            settingsController.view.isHidden = true
            infoController.view.isHidden = true
            
        case .info:
            settingsController.view.isHidden = true
            infoController.view.isHidden = false
            
        case .settings:
            settingsController.view.isHidden = false
            infoController.view.isHidden = true
        case .LogOut:
            
            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                      return
                  }
                print("\(UserDefaults.standard.setValue(nil, forKey: "name"))")
                let actionSheet = UIAlertController(title: "\(myEmail)님 로그아웃 하시겠습니까?", message: "", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {[weak self] _ in
                    
                    guard let StrongSelf = self else{
                        return
                    }
                    
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
                actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
                
                self.present(actionSheet, animated: true)
                
            
        }
        
    }
    //------------------
    
    @IBAction func ChatBtnTapped(_ sender: Any) {
        let vc = ConversationsViewController()
        vc.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //-------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titledata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        print("cellForRowAt")
        cell.projectName.text = titledata[(indexPath as NSIndexPath).row]
        cell.projectContents.text = contentsdata[(indexPath as NSIndexPath).row]
        cell.dDay.text = datesdata[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let callDetail = self.storyboard?.instantiateViewController(withIdentifier: "ProjectContentsView")
        callDetail?.modalTransitionStyle = .coverVertical
        self.present(callDetail!, animated: true, completion: nil)
    }
    
    
}

