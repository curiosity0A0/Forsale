//
//  Notification.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/25.
//  Copyright © 2018年 sen. All rights reserved.
//

import Foundation

class Notification{
    
    var notificationId: String
    let createdAt: Date
    
    let productTitle: String
    let productObjectId: String
    var buyerName: String
    var buyerId: String
    var agentId: String
    var buyerPhoneNumber:String
    var buyeremail:String
    var buyerMessage:String = ""
    //MARK: Initializers
    
    init(_buyerId:String,_agentId:String,_createdAt: Date, _phoneNumber:String,_email:String,_productId:String,_productTitle:String,_buyerMessage:String = "",_buyerName: String) {
        
        notificationId = ""
        createdAt = _createdAt
        buyerId = _buyerId
        agentId = _agentId
        buyerPhoneNumber = _phoneNumber
        buyeremail = _email
        buyerMessage = _buyerMessage
        productTitle = _productTitle
        productObjectId = _productId
        buyerName = _buyerName

        
    }
    
    
    init(_dictionary:NSDictionary) {
        
        notificationId = _dictionary[kNnotificationId] as! String
        
        if let created = _dictionary[KNcreatedAt] {
            
            createdAt = dateformatter().date(from: created as! String)!
        }else{
            
            createdAt = Date()
            
            
        }
        
        
        if let bid = _dictionary[kNbuyerId]{
            
            buyerId = bid as! String
        }else{
            
            buyerId = ""
            
        }
        
        if let agentIda = _dictionary[kNagentId]{
            
            agentId = agentIda as! String
        }else{
            
            agentId = ""
            
        }

        
        if let buyerPhoneNumbera = _dictionary[kNbuyerPhoneNumber]{
            
            buyerPhoneNumber = buyerPhoneNumbera as! String
        }else{
            
            buyerPhoneNumber = ""
            
        }
        
        if let buyeremaila = _dictionary[kNbuyeremail]{
            
            buyeremail = buyeremaila as! String
        }else{
            
            buyeremail = ""
            
        }
        
        
        if let buyerMessagea = _dictionary[kNbuyerMessage]{
            
            buyerMessage = buyerMessagea as! String
        }else{
            
            buyerMessage = ""
            
        }
        
     
        if let productTitlea = _dictionary[kNproductTitle]{
            
            productTitle = productTitlea as! String
        }else{
            
            productTitle = ""
            
        }
        
        if let productObjectIda = _dictionary[kNproductObjectId]{
            
            productObjectId = productObjectIda as! String
        }else{
            
            productObjectId = ""
            
        }
        

     
        if let buyerNamea = _dictionary[kNbuyerName]{
            
            buyerName = buyerNamea as! String
        }else{
            
            buyerName = ""
            
        }
       }
    } // end of the class

func saveNotificationInBackGround(fBnotification:Notification){
    
   let ref = notificationRef.childByAutoId()
    
    fBnotification.notificationId = ref.key
    
    ref.setValue(notificationDictionaryFrom(fbNotification: fBnotification))

    
}




func saveNotificationInBackGrounds(fBnotification:Notification,completion: @escaping (_ error:Error?)->Void){
    
    let ref = notificationRef.childByAutoId()
    
    fBnotification.notificationId = ref.key
    
    ref.setValue(notificationDictionaryFrom(fbNotification: fBnotification)) { (error, ref ) in
        
        completion(error)
    }
    

    
}

func fetchAgentNotification(agentId: String,completion: @escaping(_ allNotification:[Notification])->Void){
    
    var allNotification : [Notification] = []
    var counter = 0
    
    
    notificationHander = notificationRef.queryOrdered(byChild: kNagentId).queryEqual(toValue: agentId).observe(.value, with: { (snapShot) in
        
        if snapShot.exists() {
            
            let dic = ((snapShot.value as! NSDictionary).allValues as NSArray)
            
            for fbNot in dic {
                
                let fbNotification = Notification(_dictionary: fbNot as! NSDictionary)
                allNotification.append(fbNotification)
                counter += 1
                
            }
            //check if done and reture
            
            if counter == allNotification.count {
                    notificationRef.removeObserver(withHandle: notificationHander)
                completion(allNotification)
            }
            
            
            
        }else{
            notificationRef.removeObserver(withHandle: notificationHander)
            completion(allNotification)
        }
        
        
        
    })
    
    
}



func deleteNotification(fbNotification:Notification){
    
    
    notificationRef.child(fbNotification.notificationId).removeValue()
    
}



func notificationDictionaryFrom(fbNotification:Notification)->NSDictionary{
    
    let createdAt = dateformatter().string(from: fbNotification.createdAt)
    
    return NSDictionary(objects: [fbNotification.notificationId,createdAt,fbNotification.buyerName,fbNotification.agentId,fbNotification.buyeremail,fbNotification.buyerId,fbNotification.buyerMessage,fbNotification.buyerPhoneNumber,fbNotification.productObjectId,fbNotification.productTitle], forKeys: [kNnotificationId as NSCopying,KNcreatedAt as NSCopying,kNbuyerName as NSCopying,kNagentId as NSCopying,kNbuyeremail as NSCopying,kNbuyerId as NSCopying,kNbuyerMessage as NSCopying,kNbuyerPhoneNumber as NSCopying,kNproductObjectId as NSCopying,kNproductTitle as NSCopying])
    
    
}





