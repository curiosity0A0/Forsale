//
//  PushNotification.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/25.
//  Copyright © 2018年 sen. All rights reserved.
//

import Foundation
import OneSignal

func sendPushNotification(toProperty:Product,message:String){
    
    getUserToPush(userId: toProperty.ownerId!) { (userPushID) in
        
        
        let currentUser = Fuser.currentUser()
        
        OneSignal.postNotification(["contents":["en":"\(currentUser!.displayName)\n\(message)"],"iso_badgeType" : "Increase","ios_badgeCount": "1" ,"include_player_ids" : userPushID])
        
        ProgressHUD.showSuccess("Notification Sent!")
    }
    
}



func getUserToPush(userId: String ,result: @escaping (_ Pushid:[String]) -> Void){
    
    firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observeSingleEvent(of: .value) { (snapShot) in
        
        
        if snapShot.exists() {
            
            
            let userDictionary = ((snapShot.value as! NSDictionary).allValues as Array).first
            
            let fuser = Fuser(_dictionary: userDictionary as! NSDictionary)
            
            result([fuser.pushId!])
          
        }else{
            
            ProgressHUD.showError("couldnt send Notification")
        }
        
    }
}

