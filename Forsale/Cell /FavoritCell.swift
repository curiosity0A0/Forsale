//
//  FavoritCell.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/22.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit

@objc protocol FavoritCelldelegate {
    @objc optional func  didClickStarBtn(product: Product)
}

class FavoritCell: UICollectionViewCell{
 
    
 
 

    
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView!
    
   
    @IBOutlet weak var staroutlet: UIButton!
    
    
    @IBOutlet weak var isSoldDisplay: UIImageView!
    
    
    var product:Product!
    var delegate: FavoritCelldelegate?
    
    func generate(product:Product){
    
        self.product = product
        
        if product.imageLink != "" && product.imageLink != nil {
            
            downloadImages(urls: product.imageLink!) { (imageView) in
                
                self.imageView.image = imageView.first!
                self.activity.stopAnimating()
                self.activity.isHidden = true
                
            }
            
        }else{
            
            self.imageView.image = UIImage(named: "sample")
            self.activity.stopAnimating()
            self.activity.isHidden = true
        }
        
        if let user = Fuser.currentUser() {
            
            if user.favaritProperties.contains(product.objectId!){
                
                staroutlet.setImage(UIImage(named: "starFilled-1"), for: .normal)
  
            }else{
                
                staroutlet.setImage(UIImage(named: "star"), for: .normal)
            }
        }
        
        if product.isSold {
            self.isSoldDisplay.isHidden = false
        }else{
            self.isSoldDisplay.isHidden = true
        }
        
        
        
        
        
    }
    
    
    @IBAction func startAction(_ sender: Any) {
        
        delegate!.didClickStarBtn!(product: product)
    
    }
    


    
    
    
    
    
}
