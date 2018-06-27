//
//  searchMenuCell.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/23.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit

class searchMenuCell: UICollectionViewCell {
    
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var label: UILabel!
    
    
    func generate(image:String,label:String){
        
        self.imageView.image = UIImage(named: image)
            self.label.text = label
    }
    
}
