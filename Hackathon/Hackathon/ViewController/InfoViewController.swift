//
//  InfoViewController.swift
//  Hackathon
//
//  Created by 김수환 on 2020/09/18.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = UIColor(red: 0.938, green: 1, blue: 0.959, alpha: 1).cgColor
        let viewV = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 262))
        
        viewV.layer.backgroundColor = UIColor(red: 0.343, green: 0.538, blue: 0.409, alpha: 1).cgColor
        view.addSubview(viewV)
        
        
    }
  

}
