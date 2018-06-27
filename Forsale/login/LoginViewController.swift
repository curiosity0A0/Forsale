//
//  ViewController.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/11.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import FBSDKLoginKit



import Firebase


class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {


    @IBOutlet weak var loginmanger: CustomView!




    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let fbtn = FBSDKLoginButton()
//        fbtn.delegate = self
//         fbtn.readPermissions = ["public_profile","email"]
 
    }


    //ACTION

    //MARK FBSDK SETTING
    @IBAction func FSDKLOGIN(_ sender: Any) {
      


        let loginmanager = FBSDKLoginManager()
       loginmanager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (rusult, error) in
           if error != nil {
            self.alert(error: error!.localizedDescription)
            }
            //sucesfull
        self.fetchProfile()
        
      
        }

    }
   
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        

    }
    
    
    func fetchProfile(){
        
        if let token = FBSDKAccessToken.current() {
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            
            Auth.auth().signIn(with: credential) { (firuser, error) in
                if error != nil {
                    
                    self.alert(error: error!.localizedDescription)
                }
                
                let parameter = ["fields":"email,picture.type(normal)"]
               
        
                
                
                
                
                fetchFireUser(userID: firuser!.uid, completion: { (fuser) in
                    if fuser != nil && fuser!.Status != "" {
                        
                        print("fuser:\(fuser!.displayName)")
                     
                         saveToUserDefault(user: fuser!)
                 
                
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
                    //      ProgressHUD.show("Loading...")
                        self.present(vc,animated: true,completion: nil)
                   
                       
                    }else {
                        
                                let fuser = Fuser(_objectId: firuser!.uid, _pushId: "", _createdAt: Date(), _updatedAt: Date(), _displayName: firuser!.displayName!, _avatar:"", _phoneNumber: "")
                        FBSDKGraphRequest(graphPath: "me", parameters: parameter).start(completionHandler: { (connection, result, error) in
                            
                            if error != nil {
                                print(error!.localizedDescription)
                                
                            }
                            
                            if let results = result as? [String:Any] {
                                
                             let email = results["email"]
                                fuser.userEmail = email as! String
                                if let picture = results["picture"] as? NSDictionary,let data = picture["data"] as? NSDictionary,let url = data["url"] as? String {
                                    
                                    let url = NSURL(string: url)
                                    let data = NSData(contentsOf: url as! URL)
                                    let image = UIImage(data: data as! Data)
                                    let imageAvatar = UIImageJPEGRepresentation(image!, 0.5)
                                 print("this is = (\(imageAvatar)")
                                    let imageAvatarString = imageAvatar?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                                    fuser.avatar = imageAvatarString!
                                }
                            }

                            saveToFire(user: fuser)
                            saveToUserDefault(user: fuser)
                            //   ProgressHUD.show("Loading...")
                            self.performSegue(withIdentifier: "FINISHRIGISTER", sender: self)

                            
                            
                            
                            
                        })
                        
                       
                        
//                        let fuser = Fuser(_objectId: firuser!.uid, _pushId: "", _createdAt: Date(), _updatedAt: Date(), _displayName: "", _avatar:"", _phoneNumber: "")
//
//                        saveToFire(user: fuser)
//                        saveToUserDefault(user: fuser)
//                     //   ProgressHUD.show("Loading...")
//                        self.performSegue(withIdentifier: "FINISHRIGISTER", sender: self)
                  
                    }
                })
                
            }
        }

       
    }
   
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

    }
  
    
    
    @IBAction func LOGINWITHPHONE(_ sender: Any) {
        
        performSegue(withIdentifier: "GOTOPHONE", sender: self)
    }

    @IBAction func dismisss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    //MARK: HELPER
    
    func alert(error:String){
        
        let alert = UIAlertController(title: "ERROR", message: error, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
  

    
    
    
    
    
    
    
}

