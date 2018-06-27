//
//  AddVC.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/16.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import ImagePicker
import IDMPhotoBrowser
import  Firebase

class AddVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,ImagePickerDelegate,ADDDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{

    


    

    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var scoll: UIScrollView!
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var descriptionView: UITextView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var brandTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var warrantyTextField: UITextField!
    
    @IBOutlet weak var DateOfPurchaseTextField: UITextField!
    
    @IBOutlet weak var dealWayTextField: UITextField!
    

    @IBOutlet weak var cityTextField: UITextField!
    

    @IBOutlet weak var statusTextField: UITextField!
    

    @IBOutlet weak var headPhoneSwitch: UISwitch!
    

    @IBOutlet weak var isChargerSwitch: UISwitch!
    
    @IBOutlet weak var postedlabel: UIButton!
    
    
    var headPhoneSwitchValue: Bool = false
    var isChargerSwitchValue: Bool = false
   

    
    var typePicker = UIPickerView()
    var brandPicker = UIPickerView()
    var warrantyPicker = UIPickerView()
    var dateOfPurchasePicker = UIDatePicker()
    var cityPicker = UIPickerView()
    var statusPicker = UIPickerView()
    var activeField: UITextField?
    var dealwayPicker = UIPickerView()
    var product:Product?


    override func viewWillLayoutSubviews() {
        collectionview.collectionViewLayout.invalidateLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        if !isUserLoggin(vc: self){
            return
            
        }
    
    }
    
    var user: Fuser?
    var imageArray : [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
      
        titleTextField.delegate = self
        typeTextField.delegate = self
        brandTextField.delegate = self
        priceTextField.delegate = self
        warrantyTextField.delegate = self
        DateOfPurchaseTextField.delegate = self
        dealWayTextField.delegate = self
        cityTextField.delegate = self
        statusTextField.delegate = self
        
   
        
    scoll.contentSize = CGSize(width: self.view.bounds.width, height: mainView.frame.size.height)
        
        
        dateOfPurchasePicker.addTarget(self, action: #selector(self.dateChange(_:)), for: .valueChanged)
        setuPicker()
        
        if product != nil {
            
            setUpUIforEdit()
        }
    }
    //MARK: IBACTION
    
    
    @IBAction func headSwItchBtn(_ sender: Any) {
        headPhoneSwitchValue != headPhoneSwitchValue
        
    }
    
    
    @IBAction func isChargeValue(_ sender: Any) {
        
        isChargerSwitchValue != isChargerSwitchValue
    }
    
    
    @IBAction func postBtn(_ sender: Any) {
        
        user = Fuser.currentUser()!
        
        if !user!.isSubscription {
           save()
            //check if user can post
//            canUserPost { (canPost) in
//                 save()
//                if canPost {
//                    self.save()
//                }else{
//                    ProgressHUD.showError("You have reached your post limit! so you need to subscript if you want to post it")
//                }
//            }

        }else{
            
            save()
            //save()
        }
        
        
    }
    
    
    @IBAction func addPicture(_ sender: Any) {
        
        let imagePicker = ImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.imageLimit = 6
        
        present(imagePicker,animated: true,completion: nil)
    
    }
    
    
    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    //MARK: HELPER FUNC
    
    func save(){
        
        if titleTextField.text != "" && typeTextField.text != "" && brandTextField.text != "" && priceTextField.text != "" {
            
            //create new property
            
            var newProduct = Product()
            
            
            if product != nil {
                
                newProduct = product!
            }
            
            ProgressHUD.show("Saving....")
            newProduct.type = typeTextField.text!
            newProduct.title = titleTextField.text!
            newProduct.price = Int(priceTextField.text!)!
            newProduct.brand = brandTextField.text!
            newProduct.ownerName = user!.displayName
            newProduct.ownerId = user!.objectId
     

            
            if warrantyTextField.text != "" {
                
                newProduct.warranty = warrantyTextField.text!
            }
            
            if DateOfPurchaseTextField.text != "" {
                
                newProduct.DateOfPurchase = DateOfPurchaseTextField.text!
            }
            if dealWayTextField.text != "" {
                
                newProduct.dealofWay = dealWayTextField.text!
            }
            if cityTextField.text != "" {
                
                newProduct.city = cityTextField.text!
            }
            
            if statusTextField.text != "" {
                
                newProduct.status = statusTextField.text!
            }
            
            if descriptionView.text != "" && descriptionView.text != "Description!" {
                
                newProduct.discrip = descriptionView.text!
            }
           
            
            newProduct.headPhone = headPhoneSwitchValue
            newProduct.isCharger = isChargerSwitchValue
            
            if imageArray.count != 0 {
                
                uploadImages(images: imageArray, userId: user!.objectId, refereceNumber: "Product", titile: titleTextField.text!) { (likeString) in
                    
                    newProduct.imageLink = likeString
                    newProduct.saveProduct()
                    self.dismssView()
                    ProgressHUD.showSuccess("Saved")
                    
                }
                
            }else{

             ProgressHUD.showError("You must upload some pictures!")
   
            }

        }else{
            
            ProgressHUD.showError("Error: Missing required field")
            
        }

    }
    
    

    
    
    func dismssView(){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
        self.present(vc,animated: true,completion: nil)
    }
    
    
    
    
    
    //MARK: - COLLECTION DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ADDCELLVC
        
        print("this array \(imageArray.count)")
        cell.generate(image: imageArray[indexPath.row], index: indexPath)
        cell.delegate = self
        return cell
    }
    
     //MARK: - COLLECTION DELEGATE

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photos = IDMPhoto.photos(withImages: imageArray)
        let broswer = IDMPhotoBrowser(photos: photos)!
        broswer.setInitialPageIndex(UInt(indexPath.row))
        
        
        present(broswer,animated: true,completion: nil)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: collectionview.frame.width / 3 - 7, height: collectionview.frame.height - 2)
    }
    
    
    
    //MARK: IMAGE PICKER DELEGATE
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        self.imageArray = imageArray + images
        
        self.collectionview.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: ADD DELEGATE
    
    func deleteAction(indexPath: IndexPath) {
        
        imageArray.remove(at: indexPath.row)
        collectionview.reloadData()
 }
    
    //MARK: PickerView
    
    func setuPicker(){
        typePicker.delegate = self
        brandPicker.delegate = self
        warrantyPicker.delegate = self
        dateOfPurchasePicker.datePickerMode = .date
        cityPicker.delegate = self
        statusPicker.delegate = self
        dealwayPicker.delegate = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let fliexiblebar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dobeBtnPressed))
        toolbar.setItems([fliexiblebar,doneBtn], animated: true)
        
        typeTextField.inputView = typePicker
        typeTextField.inputAccessoryView = toolbar
        
        brandTextField.inputView = brandPicker
        brandTextField.inputAccessoryView = toolbar
        
        warrantyTextField.inputAccessoryView = toolbar
        warrantyTextField.inputView = warrantyPicker
        
        DateOfPurchaseTextField.inputAccessoryView = toolbar
        DateOfPurchaseTextField.inputView = dateOfPurchasePicker
        
        cityTextField.inputAccessoryView = toolbar
        cityTextField.inputView = cityPicker
        
        statusTextField.inputAccessoryView = toolbar
        statusTextField.inputView = statusPicker
        
        dealWayTextField.inputAccessoryView = toolbar
        dealWayTextField.inputView = dealwayPicker
        
    }
    
    @objc func dobeBtnPressed(){
        
        self.view.endEditing(true)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == typePicker {
            
            return typeArray.count
        }
        
        if pickerView == brandPicker {
            
            return brand.count
        }

        
        if pickerView == warrantyPicker {
            
            return warrantyArray.count
        }
      
        if pickerView == cityPicker {
            
            return cityArray.count
            
        }
        if pickerView == statusPicker {
            
            return statusArray.count
        }
        if pickerView == dealwayPicker{
            
            return DealWayArray.count
        }
        
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePicker {
            
            return typeArray[row]
        }
        
        if pickerView == brandPicker {
            
            return brand[row]
        }
        
        
        if pickerView == warrantyPicker {
            
            return warrantyArray[row]
        }
   
        if pickerView == cityPicker {
            
            return cityArray[row]
            
        }
        if pickerView == statusPicker {
            
            return statusArray[row]
        }
        if pickerView == dealwayPicker {
            
            return DealWayArray[row]
        }
        
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
        
        
        var rowValue = row
        if pickerView == typePicker {
            if rowValue == 0 {rowValue = 1}
           typeTextField.text = typeArray[rowValue]
        }
        
        if pickerView == brandPicker {
            if rowValue == 0 {rowValue = 1}
           brandTextField.text = brand[rowValue]
        }
        
        
        if pickerView == warrantyPicker {
            if rowValue == 0 {rowValue = 1}
            warrantyTextField.text = warrantyArray[rowValue]
        }
     
        if pickerView == cityPicker {
            if rowValue == 0 {rowValue = 1}
            cityTextField.text = cityArray[rowValue]
            
        }
        if pickerView == statusPicker {
            if rowValue == 0 {rowValue = 1}
           statusTextField.text = statusArray[rowValue]
        }
        if pickerView == dealwayPicker {
            if rowValue == 0 {rowValue = 1}
            dealWayTextField.text = DealWayArray[rowValue]
        }

        
    }
    
    @objc func dateChange(_ sender:UIDatePicker){
        
        let components = Calendar.current.dateComponents([.year,.month,.day], from: sender.date)
        
        if activeField == DateOfPurchaseTextField {
            
            DateOfPurchaseTextField.text = "\(components.day!)/\(components.month!)/\(components.year!)"
        }
    }
    
    
    //MARK: UITEXIFILED
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    //MARK: editing product
    
    func setUpUIforEdit() {
       
        addLabel.text = "Edit"
        postedlabel.setTitle("Save", for: .normal)
        
 
    
        
        descriptionView.text = product!.discrip
        titleTextField.text = product!.title
        typeTextField.text = product!.type
        brandTextField.text = product!.brand
        priceTextField.text = "\(product!.price)"
        
        warrantyTextField.text = product!.warranty
        DateOfPurchaseTextField.text = product!.DateOfPurchase
        dealWayTextField.text = product!.dealWay
        cityTextField.text = product!.city
        statusTextField.text = product!.status
        headPhoneSwitchValue = product!.headPhone
        isChargerSwitchValue = product!.isCharger
        //imageArray
        
       
        if product!.imageLink != nil && product!.imageLink != "" {
          
            downloadImages(urls: product!.imageLink!) { (allimage) in
                
               self.imageArray =  allimage as! [UIImage]
                
                print("image count \(self.imageArray.count)")
                self.collectionview.reloadData()
               
            }
            
        }
        
      
        
        
    }
    
    
    
    
    
    

}//end of the class

