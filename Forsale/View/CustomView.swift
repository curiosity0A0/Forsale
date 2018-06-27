//
//  CustomView.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/11.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit

class CustomView: UIButton {

    
    override func awakeFromNib() {
        setUI()
    }

    func setUI(){
        
        self.layer.cornerRadius = 20
           self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
     
    }
    
}
