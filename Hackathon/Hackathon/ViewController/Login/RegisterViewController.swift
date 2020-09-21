//
//  RegisterViewController.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/22.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import Alamofire
class RegisterViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    

    
    private let NameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "이름을 입력해 주세요......"
        
        field.leftView = UIView(frame: CGRect(x:0, y:0 , width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    private let StudentIDField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "학번을 입력해 주세요......"
        
        field.leftView = UIView(frame: CGRect(x:0, y:0 , width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        
        
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(NameField)
        scrollView.addSubview(StudentIDField)
        
        scrollView.addSubview(registerButton)
        
        
        scrollView.isUserInteractionEnabled = true
        
//        gesture.numberOfTouchesRequired=
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        
        NameField.frame = CGRect(x:30,
                                      y: 30,
                                      width: scrollView.width-60,
                                      height: 52)
        StudentIDField.frame = CGRect(x:30,
                                     y: NameField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        
        registerButton.frame = CGRect(x:30,
                                   y: StudentIDField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        
    }
    
    
    func backMain(){
    //        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage")
    //        self.present(loginPage!, animated: true)
            self.dismiss(animated: true, completion: nil)
        }

        func signUpSuccessAlert(){
            let alert = UIAlertController(title: "회원가입 성공", message: "회원가입을 성공했습니다", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){ (_) in
                self.backMain()
            }
            alert.addAction(ok)
            self.present(alert, animated: false)
        }
    
    
    func testJson(email:String,name: String, studentID:String) {
        let URL = "http://localhost:3000/insertName"
        
        
        let PARAM: Parameters = [
            "email":email,
            "name":name,
            "studentID":studentID
        ]
        //위의 URL와 파라미터를 담아서 POST 방식으로 통신하며, statusCode가 200번대(정상적인 통신) 인지 유효성 검사 진행
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
       alamo.responseString() { response in
        switch response.result
        {
        //통신성공
        case .success(let value):
           if value == "success"{
            self.signUpSuccessAlert()
                print("success: \(value)")
            
                
            }
            
            else{
                print("Failed: \(value)")
            }
                
            //통신실패
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
              
            }
        }
        
    }
    
    @objc private func registerButtonTapped(){
        
        
        NameField.resignFirstResponder()
        StudentIDField.resignFirstResponder()
        
        guard let name = NameField.text,
            let StudentID = StudentIDField.text else{
                return
        }
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        testJson(email:myEmail,name: name, studentID: StudentID)
        
            
        
        

        
     
    }
    func alertUserLoginError(message: String = "서버와의 통신이 불안정 합니다.") {
        let alert = UIAlertController(title: "woops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertUserLogin(message: String = "회원정보를 저장했습니다.") {
        let alert = UIAlertController(title: "success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "check", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentPototoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "take Photo", style: .default, handler: { [weak self]_ in self?.presentCamera()}))
        actionSheet.addAction(UIAlertAction(title: "choose photo", style: .default, handler: { [weak self]_ in self?.presentPhotoPicker()}))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
 
    
}
