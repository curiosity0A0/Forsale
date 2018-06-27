//
//  ProductVC.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/20.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import Firebase
import IDMPhotoBrowser

class ProductVC: UIViewController{

    
    @IBOutlet weak var mainScroll: UIScrollView!
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var typeParameter: UILabel!
    
    @IBOutlet weak var brandParameter: UILabel!
    
    @IBOutlet weak var priceParameter: UILabel!
    
    
    @IBOutlet weak var warrantParameter: UILabel!
    
    @IBOutlet weak var dateOfPurchaseParameter: UILabel!
    
    
    @IBOutlet weak var dealWayParameter: UILabel!
    
    
    @IBOutlet weak var cityParameter: UILabel!
    
    @IBOutlet weak var statusParameter: UILabel!
    
    
    @IBOutlet weak var discriptionParameter: UITextView!
    
    
    @IBOutlet weak var activityOutlet: UIActivityIndicatorView!
    
    
    @IBOutlet weak var titileLabel: UILabel!
    
    @IBOutlet weak var messageBtn: UIButton!
  
    @IBOutlet weak var headphoneValue: UILabel!
    
    @IBOutlet weak var chargeValue: UILabel!
    
    @IBOutlet weak var dotMenu: UIButton!
    
    var product: Product!
    var imageArray:[UIImage] = []
    var textFieldMessage : UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !isUserLoggin(vc: self){
            return
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        mainScroll.contentSize = CGSize(width: self.view.frame.width, height: mainView.frame.height + 30)
        
        getPropertyImages()
        setUI()
        
        let guster = UITapGestureRecognizer(target: self, action: #selector(self.displayImage) )
 
        self.imageScrollView.addGestureRecognizer(guster)
        
    
      
    }
    
    
    @objc func backto(){
    
        self.dismiss(animated: true, completion: nil)
    
    
    }

    @objc func displayImage(){
        
        
       
        if let photos = IDMPhoto.photos(withImages: imageArray){
            
            
            let browser = IDMPhotoBrowser(photos: photos)
            browser?.setInitialPageIndex(0)
            
            self.present(browser!, animated: true, completion: nil)
        }
      
      
        
    }
    
    
    //MARK: btn
    @IBAction func messageBtn(_ sender: Any) {
        
        
        let user = Fuser.currentUser()!
        let alert = UIAlertController(title: "Notify", message: "To Notify the owner with messages", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "Say something!"
            textField.borderStyle = .roundedRect
            textField.keyboardType = .default
            self.textFieldMessage = textField
            
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (action) in
            
        }
        
        let Push = UIAlertAction(title: "Push", style: .default) { (action) in
            
            
            if self.textFieldMessage.text != "" {
                
                
                sendPushNotification(toProperty: self.product!, message: self.textFieldMessage.text!)
                let notification = Notification(_buyerId: user.objectId, _agentId: self.product.ownerId!, _createdAt: Date(), _phoneNumber: user.phoneNumber, _email: user.userEmail, _productId: self.product.objectId!, _productTitle: self.product.title!, _buyerMessage: self.textFieldMessage.text!, _buyerName: user.displayName)
                
                saveNotificationInBackGround(fBnotification: notification)
                
             
                
              
            }
            
        }
        
        alert.addAction(cancel)
        alert.addAction(Push)
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func dotMenuBtn(_ sender: Any) {
        
        let soldStatus = product.isSold ? "Mark Available" : "Mark Sold"
        
        let actionMenu = UIAlertController(title: "Product Menu", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit product", style: .default) { (action) in
            
            let AddProduct = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddProduct") as! AddVC
            AddProduct.product = self.product
            self.present(AddProduct, animated: true, completion: nil)
        }
        let soldAction = UIAlertAction(title: soldStatus, style: .default) { (action) in
            
            self.product.isSold = !self.product.isSold
           
            self.product.saveProduct(completion: { (success) in
                
                ProgressHUD.showSuccess("Changed!")
                  self.dismiss(animated: true, completion: nil)
                
            })
         
            
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            ProgressHUD.show("Deleting...")
            Product.deteteProduct(product: self.product, completion: { (message) in
                
                ProgressHUD.showSuccess("Deleted!")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
                
                self.present(vc, animated: true, completion: nil)
                
            })
        }
        
        let canelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        actionMenu.addAction(editAction)
         actionMenu.addAction(soldAction)
         actionMenu.addAction(deleteAction)
         actionMenu.addAction(canelAction)
        
        self.present(actionMenu,animated: true,completion: nil)
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Helper func
    
    func getPropertyImages(){
        if product.imageLink != "" && product.imageLink != nil {
            
            downloadImages(urls: product.imageLink!) { (images) in
                
                self.imageArray = images as! [UIImage]
                self.setSlideShow()
                self.activityOutlet.stopAnimating()
                self.activityOutlet.isHidden = true
            }
        }else{
            
            //we are no images
            self.imageArray.append(UIImage(named: "mac")!)
            self.setSlideShow()
            self.activityOutlet.stopAnimating()
            self.activityOutlet.isHidden = true
        }
    }
    
    func setSlideShow(){
        for i in 0..<imageArray.count {
            
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: imageScrollView.frame.width, height: imageScrollView.frame.height)
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(i + 1)
            imageScrollView.addSubview(imageView)
            
        }
        
    }
    
    
    func setUI(){
        
       
        if Fuser.currentUser() != nil {
            
            if Fuser.currentUser() != nil && product.ownerId != Fuser.currentId() {
                self.messageBtn.isEnabled = true
                self.messageBtn.isHidden = false
            }else if Fuser.currentId() == product.ownerId{
                
                self.dotMenu.isEnabled = true
                self.dotMenu.isHidden = false
                
            }
            
            
        }
        
        
 
        //set properties
        
        titileLabel.text = product.title!
        priceParameter.text = "\(product.price)"
        typeParameter.text = product.type
        brandParameter.text = product.brand
        warrantParameter.text = product.warranty
        dateOfPurchaseParameter.text = product.DateOfPurchase
        dealWayParameter.text = product.dealofWay
        cityParameter.text = product.city
        statusParameter.text = product.status
        discriptionParameter.text = product.discrip
        userName.text = product.ownerName
        if product.headPhone {
            
            headphoneValue.text = "YES!"
        }else{
            
            headphoneValue.text = "NO!"
        }
        
        if product.isCharger {
            
            chargeValue.text = "YES!"
        }else{
            chargeValue.text = "NO!"
        }
        
        
        //get user image
      
        
        firebase.child(kUSER).child(product.ownerId!).observe(DataEventType.value) { (snapShot) in
            
            if let dictionary = snapShot.value as? [String:Any]{
                imageFromData(pictureData: dictionary["avatar"] as! String, withBlock: { (image) in
                  
                    self.userImage.image = image?.circleMasked
                 
                    
                })
                
            }
        }
     
    }
 
}
