//
//  FinishVC.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/12.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import ImagePicker
import SVProgressHUD
import Firebase


class FinishVC: UIViewController,ImagePickerDelegate {
   
    
    @IBOutlet weak var mainScroll: UIScrollView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var portrait: UIImageView!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var status: UITextView!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    var portraitImage : UIImage?
    var portraitString: String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScroll.contentSize = CGSize(width: self.view.bounds.width, height: mainView.frame.size.height)
        // Do any additional setup after loading the view.
        stupUI()
    }
    
    @IBAction func cameraBtn(_ sender: Any) {
        let imagepickerColler = ImagePickerController()
        imagepickerColler.delegate = self
        imagepickerColler.imageLimit = 1
        present(imagepickerColler,animated: true,completion: nil)
        
        
    }
    
    
    @IBAction func doneBtn(_ sender: Any) {
        
            ProgressHUD.show("updating...")
        if userNameTextField.text != "" && status.text != "" && portraitImage != nil && email.text != "" && phoneNumber.text != ""{
            
    
          
            if self.portraitImage != nil {
                
                let image = UIImageJPEGRepresentation(portraitImage!, 0.6)
                portraitString = image!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            }
            
                    rigister()
            
            
                
            
        }else if userNameTextField.text == "" {
            
            alert(message: "Plz enter your User Name")
           
        }else if status.text == "" {
            
            alert(message: "Plz enter your status")
        }else if portraitImage == nil {
            
            alert(message: "Plz upload your handsome/pretty avatar!")
        }else if email.text == "" {
            alert(message: "Plz enter your email")
        }else if phoneNumber.text == "" {
            alert(message: "Plz enter your Phone Number")
        }
            
            
        }
    


    
    @IBAction func gotoback(_ sender: Any) {
        
   
        if Fuser.currentUser() != nil {
            
            let user = Fuser.currentUser()
            
            if user!.displayName != "" && user!.avatar != "" && user!.Status != "" && user!.userEmail != "" && user!.phoneNumber != "" {
                
                self.dismiss(animated: true, completion: nil)
            }else{
                deleteUser()
            }
            
            
        }
        //delete user
        print("no user in finish vc")
       
    }
    
    //MARK: IMAGEPICKER DELEGETE
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        portraitImage = images.first
        portrait.image = portraitImage!.circleMasked
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: Helper
    
    
    func stupUI(){
        
        if let user = Fuser.currentUser(){
            userNameTextField.text = user.displayName
            status.text = user.Status
            
            
            if user.avatar != "" && user.avatar != nil {
                imageFromData(pictureData: user.avatar) { (image) in
                    
                    self.portraitImage = image
                    self.portrait.image = portraitImage?.circleMasked
                }
                
            }
            
            email.text = user.userEmail
            phoneNumber.text = user.phoneNumber
      
            
            
            
        }
        
  
        
    }
    
    func rigister() {
        
        if let user = Fuser.currentUser(){
            user.Status = status.text!
            user.displayName = userNameTextField.text!
            user.avatar = portraitString!
            user.phoneNumber = phoneNumber.text!
            user.userEmail = email.text!
            updateCurrentUserWith(Clause: [kStatus:user.Status,kDisplayName:user.displayName,kAvatar:user.avatar,KuserEmail:user.userEmail,kPhoneNumber:user.phoneNumber]) { (successful) in
                if !successful {
                    print("not successful")
                    return
                }
                //NOTIFICATION NOT FINISH YET
                
     
               //   ProgressHUD.show("Loading...")
                
             self.gotoApp()
                ProgressHUD.showSuccess("Updated!")
                }
            }
     }
    
    func deleteUser(){
        
        let userID = Fuser.currentId()
        //delete user locally
        UserDefaults.standard.removeObject(forKey: KcurrentUser)
        UserDefaults.standard.removeObject(forKey: "oneSignalID")
        UserDefaults.standard.synchronize()
        // log out user
        
        firebase.child(kUSER).child(userID).removeValue { (error, ref) in
            
            if error != nil {
                print("\(error!.localizedDescription)")
                
            }
            
            Fuser.deleteUser(completion: { (error) in
                if error != nil {
                    print("Error deleting \(error!.localizedDescription)")
                    return
                }
               // SVProgressHUD.showProgress(1)
                self.dismiss(animated: true, completion: nil)
                
            })
            
            
            
            
        }
        
    }

    func gotoApp(){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
        
        self.present(vc,animated: true,completion: nil)
    }
    

    func alert(message:String){
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        alert.addAction(action)
        self.present(alert,animated: true,completion: nil)
    }
    
    
    
    
    
}// END OF CLASS


extension  FinishVC : UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    
}















