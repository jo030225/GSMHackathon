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

class AddViewController: UIViewController {
    

    @IBOutlet var language: DropDown!
    @IBOutlet var valueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        testJson(email: "testEmail", pw: "testPassword", tel: "testTel")
        
        dropDownLanguage()
    }
    
    
    func dropDownLanguage(){
        language.optionArray = ["1", "2", "3"]
        language.optionIds = [1,2,3]
        language.didSelect{ (selectedText , index ,id) in
            self.valueLabel.text! = "Selected String: \(selectedText)  index: \(index)  Id: \(id)"
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
