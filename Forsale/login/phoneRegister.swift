//
//  phoneRegister.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/12.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class phoneRegister: UIViewController {

    
    
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    
    @IBOutlet weak var sendoutlet: CustomView!
    
    var phoneplaceholder: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    @IBAction func deleteUser(_ sender: Any) {
    
        deleteUser(self)
    }
    
    @IBAction func sendCode(_ sender: Any) {
            ProgressHUD.show("sending...")
        if phoneTextField.text != "" {
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneTextField.text!, uiDelegate: nil) { (verificationID, error) in
                if error != nil {
                    
                    self.alert(error: error!.localizedDescription)
                    return
                }
             
                self.phoneplaceholder = self.phoneTextField.text
                self.phoneTextField.text = ""
                self.phoneTextField.placeholder = self.phoneplaceholder
                self.phoneTextField.isEnabled = false
                self.verificationCodeTextField.isEnabled = true
                
                self.sendoutlet.setTitle("LOG IN", for: .normal)
                
                
          
                UserDefaults.standard.set(verificationID, forKey: kVERIFICATION)
                UserDefaults.standard.synchronize()
                
                ProgressHUD.showSuccess("sent")
               
            }
            
            

            
            
        }
        
        
        if verificationCodeTextField.text != "" {
            
            Fuser.registerWith(verificationCode: verificationCodeTextField.text!) { (error, shouldLogin) in
                
                
                if error != nil {
                    self.alert(error: error!.localizedDescription)
                    return
                }
                
                if shouldLogin {
                    
                   
                    print("suceefull")
                   let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
                    
                    self.present(vc ,animated: true,completion: nil)
                    
                }else{
                   
                    print("gotofish")
                    self.performSegue(withIdentifier: "FINISHRIGISTER", sender: self)
                }
                
                
                
            }
        }
        
        
     SVProgressHUD.dismiss()
        
    }
    
    func alert(error:String){
        
        let alert = UIAlertController(title: "ERROR", message: error, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}//END OF THE CLASS

extension  phoneRegister: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    
}




