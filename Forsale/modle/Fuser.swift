//
//  Fuser.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/12.
//  Copyright © 2018年 sen. All rights reserved.
//

import Foundation
import Firebase

class Fuser {
    
    
    let objectId: String
    var pushId: String?
    let createdAt: Date
    var updatedAt: Date
    var displayName:String
    var avatar:String
    var phoneNumber: String
    var isSubscription: Bool
    var favaritProperties: [String]
    var Status: String
    var userEmail: String
    
    init(_objectId: String,_pushId: String?,_createdAt: Date,_updatedAt: Date,_displayName:String = "" , _avatar:String = "" ,_phoneNumber:String = ""){
        
        objectId = _objectId
        pushId = _pushId
        createdAt = _createdAt
        updatedAt = _updatedAt
        displayName = _displayName
        avatar = _avatar
        phoneNumber = _phoneNumber
        isSubscription = false
        Status = ""
        userEmail = ""

        favaritProperties = []
    }
    
    init(_dictionary: NSDictionary){
        
        
        objectId = _dictionary[kOBJECTID] as! String
        pushId = _dictionary[kPushID] as? String
        
        
        if let created = _dictionary[kCREATEDAT]{
            
            createdAt = dateformatter().date(from: created as! String)!
        }else{
            
            createdAt = Date()
        }
        
        if let updated = _dictionary[kUpdated]{
            
            updatedAt = dateformatter().date(from: updated as! String)!
        }else{
            
            updatedAt = Date()
        }
        
        if let phone = _dictionary[kPhoneNumber]{
            
            phoneNumber = phone as! String
        }else{
            phoneNumber = ""
        }
        
        if let dispaly = _dictionary[kDisplayName]{
            
            displayName = dispaly as! String
        }else{
            displayName = ""
        }
        
        if let avat = _dictionary[kAvatar]{
            
            avatar = avat as! String
        }else{
            avatar = ""
        }
        
        if let subscription = _dictionary[kIsSubscription] {
            
            isSubscription = subscription as! Bool
        }else{
            
            isSubscription = false
        }
        
        if let favorit = _dictionary[kFavoritProperties]{
            
            favaritProperties = favorit as! [String]
        }else{
            favaritProperties = []
        }
        
        if let statu = _dictionary[kStatus]{
            
            Status = statu as! String
        }else{
            
            Status = ""
        }
        
        if let email = _dictionary[KuserEmail]{
            
            userEmail = email as! String
        }else{
            
            userEmail = ""
        }
        
        
        
    }
    
  class  func currentId()->String {
        
        return Auth.auth().currentUser!.uid 
        
    }
    
  class  func currentUser() -> Fuser? {
        
        if Auth.auth().currentUser != nil {
            
            if let dictionary = UserDefaults.standard.object(forKey: KcurrentUser){
                
                       return Fuser(_dictionary: dictionary as! NSDictionary)
            }
  
        }
        
        return nil
    }
    
    
    
    class func  registerWith(verificationCode:String,completion:@escaping (_ error:Error?,_ shouldLogin: Bool)->Void){
        
    
    let verificationID = UserDefaults.standard.value(forKey: kVERIFICATION)
    
    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: verificationCode)
    
    
    Auth.auth().signIn(with: credential) { (firuser1, error) in
        
        if error != nil {
            
       
            completion(error,false)
            return
        }
        //fetchUser
        
        fetchFireUser(userID: firuser1!.uid, completion: { (firuser) in
            
            if firuser != nil && firuser!.displayName != nil {
             
                
                
                //we have the user
                saveToUserDefault(user: firuser!)
           
                completion(error,true)
                return
            }else{
                //we don't have user
                
                let fuser = Fuser(_objectId: firuser1!.uid, _pushId: "", _createdAt: Date(), _updatedAt: Date(), _displayName: "", _avatar: "", _phoneNumber: firuser1!.phoneNumber!)
                
                saveToUserDefault(user: fuser)
                saveToFire(user: fuser)
                
                completion(error,false)
                
            }
            
            
        })
        
        
        
        
        
        
    }
        
        
        
        
    }
    
    
    class func deleteUser(completion: @escaping(_ error: Error?)->Void) {
        
        let user = Auth.auth().currentUser
        user?.delete(completion: { (error) in
            
            completion(error)
            
        })
    }
    
    class func logoutUser(withblock: @escaping(_ success: Bool)->Void){
     
        UserDefaults.standard.removeObject(forKey: KoneSignalID)
        RemoveOneSignalID()
       UserDefaults.standard.removeObject(forKey: KcurrentUser)
        UserDefaults.standard.synchronize()
        
        do{
            
            try Auth.auth().signOut()
            withblock(true)
        } catch let error as NSError {
             withblock(false)
            print("Error loging out\(error.localizedDescription)")
           
        }
    }
    
    
    
}//end of the class



func userDictionary(fuser:Fuser) -> NSDictionary {
    let createdAt = dateformatter().string(from: fuser.createdAt)
    let updatedAt = dateformatter().string(from: fuser.updatedAt)

        return NSDictionary(objects: [createdAt,updatedAt,fuser.objectId,fuser.pushId!,fuser.displayName,fuser.phoneNumber,fuser.favaritProperties,fuser.isSubscription,fuser.avatar,fuser.Status,fuser.userEmail], forKeys: [kCREATEDAT as NSCopying,kUpdated as NSCopying,kOBJECTID as NSCopying,kPushID as NSCopying,kDisplayName as NSCopying, kPhoneNumber as NSCopying,kFavoritProperties as NSCopying,kIsSubscription as NSCopying, kAvatar as NSCopying,kStatus as NSCopying,KuserEmail as NSCopying])

}

func saveToFire(user:Fuser){
    
  let ref = firebase.child(kUSER).child(user.objectId)
    
    ref.setValue(userDictionary(fuser: user))
    
}

func saveToUserDefault(user:Fuser){
    
    UserDefaults.standard.set(userDictionary(fuser: user), forKey: KcurrentUser)
    UserDefaults.standard.synchronize()
}


func fetchFireUser(userID:String,completion: @escaping(_ user:Fuser?)->Void){
    
    firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue:userID ).observeSingleEvent(of: .value) { (snapshot) in
        
        if snapshot.exists() {
            
            let dictionary = ((snapshot.value as! NSDictionary).allValues as NSArray ).firstObject as! NSDictionary
            
            let fuser = Fuser.init(_dictionary: dictionary)
            return completion(fuser)
            
        }else{
            
            return completion(nil)
        }
        
        
        
    }
    
}

func updateCurrentUserWith(Clause:[String:Any],withblock:@escaping(_ successful:Bool)-> Void){
    
    
    if UserDefaults.standard.object(forKey: KcurrentUser) != nil {
        
        
        let currentUser = Fuser.currentUser()!
        let userObject = userDictionary(fuser: currentUser).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(Clause)
        
        let ref = firebase.child(kUSER).child(currentUser.objectId)
        ref.updateChildValues(Clause) { (error, snapshot) in
            if error != nil {
                
                withblock(false)
                return
            }
            
            UserDefaults.standard.setValue(userObject, forKey: KcurrentUser)
            UserDefaults.standard.synchronize()
            withblock(true)
        }
 
    }

}

//MARK: CHECK USER IS LOGGIN?

func isUserLoggin(vc:UIViewController)->Bool {
    
    if Fuser.currentUser() != nil {
        
        return true
    }else{
        
        let VCPAGE = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "choosePageLogin") as! LoginViewController
        
        vc.present(VCPAGE, animated: true, completion: nil)
        return false
    }
    
}






//MARK: OneSignal

func updateOneSignalId(){
    if Fuser.currentUser() != nil {
        
        if let pushID = UserDefaults.standard.string(forKey: KoneSignalID){
            
            //set one signal id
            
            setOneSignalID(pushId: pushID)
        }else{
            
            //remove one signal id
            RemoveOneSignalID()
        }
        
        
    }
}

func setOneSignalID(pushId:String){
  updateCurrentUserOneSignalID(newid: pushId)
}
func RemoveOneSignalID(){
    updateCurrentUserOneSignalID(newid:"")
}

func updateCurrentUserOneSignalID(newid:String){
    updateCurrentUserWith(Clause: [kPushID:newid,kUpdated:dateformatter().string(from: Date())]) { (success) in
        print("One Signal id was updated - \(success)")
    }
}

//MARK: FAVORITE

    func favoriteSetting(product:Product,collection:UICollectionView){
        
        if Fuser.currentUser() != nil {
            
            let user = Fuser.currentUser()!
            
            if user.favaritProperties.contains(product.objectId!){
                
                let index = user.favaritProperties.index(of: product.objectId!)
                user.favaritProperties.remove(at: index!)
                updateCurrentUserWith(Clause: [kFavoritProperties:user.favaritProperties]) { (bool) in
                    
                    if !bool {
                        print("error in removing")
                    }else{
                        
                            collection.reloadData()
                        ProgressHUD.showSuccess("Removed from the list")
                    }
                }
                
            }else{
                user.favaritProperties.append(product.objectId!)
                updateCurrentUserWith(Clause: [kFavoritProperties:user.favaritProperties]) { (bool) in
                    
                    if !bool {
                        print("error in adding")
                    }else{
                        
                        collection.reloadData()
                        ProgressHUD.showSuccess("added to the list")
                    }
                }
                
                
                
            }
            
        }
}


    




