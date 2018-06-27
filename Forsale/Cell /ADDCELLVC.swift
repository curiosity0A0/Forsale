//
//  ADDCELLVC.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/16.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit

protocol ADDDelegate {
    
    func deleteAction(indexPath:IndexPath)
}



class ADDCELLVC: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var deleteOutlet: UIButton!
    
    var delegate : ADDDelegate?
    var indexPath: IndexPath!
    
    func generate(image:UIImage,index:IndexPath){
        
        self.indexPath = index
     
        if image == nil {
            label.isHidden = false
        }else{
            
            label.isHidden = true
                 self.image.image = image
        }
        
        
        
   
        
    }
    
    
    
    
    
    
    
    
    
   
    @IBAction func deleteAction(_ sender: Any) {
        
        delegate!.deleteAction(indexPath: indexPath!)
    }
    
    
}
