//
//  notificationCell.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/25.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit

class notificationCell: UITableViewCell{
   
 
    

  
    @IBOutlet weak var imageAvatar: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var phoneText: UILabel!
    
    @IBOutlet weak var emailText: UILabel!
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var deleteOutlet: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    

    var FbNotifications:Notification?
   
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bibData(FbNotification:Notification){
        
            self.FbNotifications = FbNotification
        let notification = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
       
    
        
        if FbNotification.buyerName != "" {
            
            userName.text = FbNotification.buyerName
            
        }else{
            userName.text = ""
        }
        
        if FbNotification.buyerPhoneNumber != "" {
            
            phoneText.text = FbNotification.buyerPhoneNumber
        }else{
            phoneText.text = ""
        }
        
        if FbNotification.buyeremail != "" {
            emailText.text = FbNotification.buyeremail
        }else{
            emailText.text = ""
        }
        
        if FbNotification.productTitle != "" {
            titleText.text = FbNotification.productTitle
        }else{
            titleText.text = ""
        }
        if FbNotification.buyerMessage != "" {
            textView.text = FbNotification.buyerMessage
        }
        
        
        if FbNotification.buyerId != "" {
            
            
            firebase.child(kUSER).child(FbNotification.buyerId).observe(.value) { (snapShot) in
                
                if snapShot.exists() {
                    
                    let userDictionarys = snapShot.value as! [String:Any]
                    
                    if let avatar = userDictionarys["avatar"] {
                        
                        imageFromData(pictureData: avatar as! String, withBlock: { (image) in
                            
                            self.imageAvatar.image = image!.circleMasked
                        })
                        
                    }
                }
            }
            
            
            
        }else{
            
            self.imageAvatar.image = UIImage(named: "img_placeholder")
        }
        
        
        
        
        
        let newDate = dateformatter()
        newDate.dateFormat = "dd.MM.YYYY"
        
        dateLabel.text = newDate.string(from: FbNotification.createdAt)
        
        
        
        
        
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
}
