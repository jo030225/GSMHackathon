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

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UITextViewDelegate ,UINavigationControllerDelegate {
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var miniView: UIView!
    @IBOutlet weak var adTextView: UITextView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet var ITField: DropDown!
    @IBOutlet var language: DropDown!
    @IBOutlet weak var titleTV: UITextView!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var datePicker: UIDatePicker!
    
    let picker = UIImagePickerController()
    
    var ITFieldData: String = ""
    var languageData: String = ""
    var titleData: String = ""
    var projectIntroduceData: String = ""
    var contentData: String = ""
    var finishdateData: String = ""
    var imgData = UIImage()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //디자인 코드
        addView.layer.cornerRadius = 20
        addView.layer.shadowColor = UIColor.gray.cgColor
        addView.layer.shadowOpacity = 1
        addView.layer.shadowOffset = .zero
        addView.layer.shadowRadius = 10
        titleTV.layer.cornerRadius = 10
        contentTV.layer.cornerRadius = 10
        miniView.layer.cornerRadius = 10
        adTextView.layer.cornerRadius = 5
        okBtn.layer.cornerRadius = 10
        //
        
        placeholderSetting()
        
        picker.delegate = self
        dropDownITField()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact // Replace .inline with .compact
        }
    }
    
    
    //adTextView placeholder 설정 코드
    func placeholderSetting() {
        
        adTextView.delegate = self
        adTextView.text = "모집에 대한 설명을 써주세요!"
        adTextView.textColor = UIColor.lightGray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            
            textView.text = "모집에 대한 설명을 써주세요!"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    func openLibrary(){
        
        picker.sourceType = .photoLibrary
        
        present(picker, animated: false, completion: nil)
    }
    
    func data(){
        titleData = titleTV.text!
        projectIntroduceData = contentTV.text!
        contentData = adTextView.text!
        imgData = imageView.image!
    }
    
//    func nilCheck(){
//        if (titleData == "" || projectIntroduceData == "" || contentData == "" || ITFieldData == "" || languageData == "") {
//            dataCheckAlert()
//        }
//    }
    
    @IBAction func imgBtn(_ sender: UIButton) {
        let alert =  UIAlertController(title: "프로필 사진 변경", message: "", preferredStyle: .actionSheet)
        
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        data()
        
        let formatter = DateFormatter() // DateFormatter 클래스 상수 선언
        formatter.dateFormat = "yyyy.MM.dd. " // formatter의 dateFormat 속성을 설정
        finishdateData = formatter.string(from: datePicker.date)
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        testJson(id: myEmail, projectTitle: titleData, projectIntroduce: projectIntroduceData, ITField: ITFieldData, language: languageData, content: contentData, dates: finishdateData)
        
        SuccessAlert()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: nil)
            imageView.image = image
        }
    }
    
    func goMainPage(){
        guard let goMain = self.storyboard?.instantiateViewController(identifier: "MainPage") else { return }
        goMain.modalPresentationStyle = .fullScreen
        self.present(goMain, animated: true)
    }
    
    func SuccessAlert(){
        let alert = UIAlertController(title: "업로드 성공", message: "업로드를 성공했습니다", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){ (_) in
            self.goMainPage()
        }
        alert.addAction(ok)
        self.present(alert, animated: false)
    }
    
//    func dataCheckAlert(){
//        let alert = UIAlertController(title: "업로드 실패", message: "빈칸이 있습니다.", preferredStyle: UIAlertController.Style.alert)
//        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){ (_) in }
//        alert.addAction(ok)
//        self.present(alert, animated: false)
//    }
    
    func dropDownITField(){
        ITField.optionArray = ["웹 개발", "iOS 개발", "Android 개발"]
        ITField.optionIds = [1,2,3]
        ITField.didSelect{ (selectedText , index ,id) in
            if id == 1 {
                self.language.optionArray = ["JavaScript", "HTML", "CSS", "Node.js","React"]
                self.language.optionIds = [1,2,3,4,5]
                self.language.didSelect{ (selectedText , index ,id) in
                    self.languageData = selectedText
                    //                    print(self.languageData)
                }
            } else if id == 2 {
                self.language.optionArray = ["Swift", "Objective-C"]
                self.language.optionIds = [1,2,3]
                self.language.didSelect{ (selectedText , index ,id) in
                    self.languageData = selectedText
                    //                    print(self.languageData)
                }
            } else if id == 3 {
                self.language.optionArray = ["Kotlin", "Java"]
                self.language.optionIds = [1,2,3]
                self.language.didSelect{ (selectedText , index ,id) in
                    self.languageData = selectedText
                    //                    print(self.languageData)
                }
            }
            self.ITFieldData = selectedText
            //            print(self.ITFieldData)
        }
    }
    
    
    func sendImage(value: String){
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(self.imageView.image!.pngData()!, withName: "", fileName: "test.png", mimeType: "image/png")
            
        }, to: "http://3.136.17.152:3000/image/upload?id=\(value)")
        .responseJSON { response in
            print("\(response)")
        }
    }
    
    
    
    func testJson(id:String,projectTitle: String, projectIntroduce: String, ITField: String, language: String, content: String, dates: String) {
        let URL = "http://3.136.17.152:3000"
        
        
        let PARAM: Parameters = [
            "id":id,
            "title":projectTitle,
            "projectIntroduce": projectIntroduce,
            "ITField": ITField,
            "language": language,
            "content": content,
            "dates": finishdateData
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
//                if self.imgData.images != nil{
                    self.sendImage(value: value)
//                }
                print("\(value)")
            //  self.sendImage(value: value)
            
            //통신실패
            case .failure(let error):
                print("error: \(String(describing: error.errorDescription))")
                //  self.resultLabel.text = "\(error)"
                print("\(error)")
            }
        }
        
    }
    
    
}
