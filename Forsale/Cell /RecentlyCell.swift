//
//  RecentlyCell.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/14.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import Firebase

@objc protocol RecentlyCellDelegete {
    @objc optional func  didClickStarBtn(product: Product)
}

class RecentlyCell: UICollectionViewCell {
    
    
    @IBOutlet weak var usreAvatar: UIImageView!
    
   
    
    @IBOutlet weak var SartOutlet: UIButton!
    
    
    @IBOutlet weak var loadingOutlet: UIActivityIndicatorView!
    
    
    @IBOutlet weak var productImageView: UIImageView!
    
    
    @IBOutlet weak var typeParameter: UILabel!
    
    @IBOutlet weak var brandParameter: UILabel!
    
    @IBOutlet weak var priceParameter: UILabel!
    
    @IBOutlet weak var UserName: UILabel!
    
  
    @IBOutlet weak var descrip: UITextView!
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var isSold: UIImageView!
    
  
    
    var delegate: RecentlyCellDelegete?
    var Product:Product!
    
    
 
    
    func generateCell(Product:Product){
      
        self.Product = Product
        UserName.text = Product.ownerName
       
        if !Product.isSold {
            
            isSold.isHidden = true
            
        }else{
            isSold.isHidden = false
        }
        
        
        //like product
        
        if self.SartOutlet != nil {
            
            if Fuser.currentUser() != nil && Fuser.currentUser()!.favaritProperties.contains(Product.objectId!){
                
                self.SartOutlet.setImage(UIImage(named: "starFilled-1"), for: .normal)
            }else{
                
                self.SartOutlet.setImage(UIImage(named: "star"), for: .normal)
            }
            
        }
        
        
        if Product.ownerId != "" {
            
           
            firebase.child(kUSER).child(Product.ownerId!).observe(DataEventType.value) { (snapShot) in
                
                if let dic = snapShot.value as? [String:Any]{
                    
                    imageFromData(pictureData: (dic["avatar"] as? String)!, withBlock: { (imageAvatar) in
                        
                        self.usreAvatar.image = imageAvatar?.circleMasked
                 
                        
                    })
                   // print(snapShot.value)
                }
            }
        }else{
            
               usreAvatar.image = UIImage(named: "icons8-user_male_circle")
        }
        
        if Product.imageLink != nil && Product.imageLink != "" {
            
            
            downloadImages(urls: Product.imageLink!) { (images) in
                
                
               
                self.loadingOutlet.stopAnimating()
                self.loadingOutlet.isHidden = true
             self.productImageView.image = images.first!
                
                
            }
            
            
       
            
        }else{
            productImageView.image = UIImage(named: "mac-1")
            self.loadingOutlet.stopAnimating()
            self.loadingOutlet.isHidden = true
        }
        
        title.text = Product.title
        descrip.text = Product.discrip
        typeParameter.text = Product.type
        brandParameter.text = Product.brand
        priceParameter.text = "\(Product.price)"
        priceParameter.sizeToFit()
         let newDateFormatter = dateformatter()
        newDateFormatter.dateFormat = "dd.MM.YYYY"

    }
    
    
    
    @IBAction func starBtnPress(_ sender: Any) {
        
        delegate!.didClickStarBtn!(product: Product)
        
    }
    
    
}
