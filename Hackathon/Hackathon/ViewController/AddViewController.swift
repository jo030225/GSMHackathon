//
//  AddViewController.swift
//  Hackathon
//
//  Created by 김수환 on 2020/09/18.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import Alamofire
import iOSDropDown

class AddViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet var ITField: DropDown!
    @IBOutlet var language: DropDown!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextField: UITextField!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var value2Label: UILabel!
    @IBOutlet var imageView: UIImageView!
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        testJson(email: "testEmail", pw: "testPassword", tel: "testTel")
        picker.delegate = self
        dropDownITField()
    }
    
    func openLibrary(){
        
        picker.sourceType = .photoLibrary
        
        present(picker, animated: false, completion: nil)
    }
    
    
    @IBAction func imgBtn(_ sender: UIButton) {
        let alert =  UIAlertController(title: "프로필 사진 변경", message: "", preferredStyle: .actionSheet)
        
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
            
        }
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        
        alert.addAction(library)
        
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: nil)
            imageView.image = image
            
        }
        
    }
    
    func dropDownITField(){
        ITField.optionArray = ["웹 개발", "iOS 개발", "Android 개발"]
        ITField.optionIds = [1,2,3]
        ITField.didSelect{ (selectedText , index ,id) in
            self.valueLabel.text! = selectedText
            if id == 1 {
                self.language.optionArray = ["JavaScript", "HTML", "CSS", "Node.js","React"]
                self.language.optionIds = [1,2,3,4,5]
                self.language.didSelect{ (selectedText , index ,id) in
                    self.value2Label.text! = selectedText
                }
            } else if id == 2 {
                self.language.optionArray = ["Swift", "Objective-C"]
                self.language.optionIds = [1,2,3]
                self.language.didSelect{ (selectedText , index ,id) in
                    self.value2Label.text! = selectedText
                }
            } else if id == 3 {
                self.language.optionArray = ["Kotlin", "Java"]
                self.language.optionIds = [1,2,3]
                self.language.didSelect{ (selectedText , index ,id) in
                    self.value2Label.text! = selectedText
                }
            }
        }
    }
    
    
    
    
    func testJson(email: String, pw: String, tel: String) {
        let URL = "http://localhost:3000"
        
        
        let PARAM: Parameters = [
            "email":email,
            "pw": pw,
            "tel": tel
        ]
        //위의 URL와 파라미터를 담아서 POST 방식으로 통신하며, statusCode가 200번대(정상적인 통신) 인지 유효성 검사 진행
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success(let value):
                print("value: \(value)")
                //                    self.resultLabel.text = "\(value)"
                print("\(value)")
            //                    self.sendImage(value: value)
            
            //통신실패
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
                //                    self.resultLabel.text = "\(error)"
                print("\(error)")
            }
        }
        
    }
    
    
}
