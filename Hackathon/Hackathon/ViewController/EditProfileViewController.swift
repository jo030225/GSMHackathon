//
//  EditProfileViewController.swift
//  Hackathon
//
//  Created by 황원비 on 2020/09/22.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var numTF: UITextField!
    @IBOutlet var bioTF: UITextField!
    @IBOutlet var viewV: UIView!
    @IBOutlet var changeBtn: UIButton!
    
    var name = String()
    var num = String()
    var bio = String()
    
    let picker = UIImagePickerController()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            picker.delegate = self
            
            viewV.layer.cornerRadius = 30
            changeBtn.layer.cornerRadius = 20
            // Do any additional setup after loading the view.
        }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "카메라 열기", message: "camera is not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion: nil)
            imageView.image = image
        }
    }
    @IBAction func changeImgBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "앨범 열기", style: .destructive){
            (action) in
            self.openLibrary()
        })
        alert.addAction(UIAlertAction(title: "카메라 열기", style: .destructive){
            (action) in
            self.openCamera()
        })
        present(alert, animated: true, completion: nil)
    }
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "저장", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive){ [self]
            (action) in
//            name = nameTF.text!
//            num = numTF.text!
//            bio = bioTF.text!
//
//            dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
