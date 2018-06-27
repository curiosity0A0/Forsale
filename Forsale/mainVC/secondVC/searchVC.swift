//
//  searchVC.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/24.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit

protocol searchVCdelegate {
    func didfinishSetting(whereClause:String)
}

class searchVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{


 
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var typeParameter: UITextField!
    
    @IBOutlet weak var brandParameter: UITextField!
    
    @IBOutlet weak var piceParameter: UITextField!
    
    @IBOutlet weak var warrnatyParameter: UITextField!
    
    @IBOutlet weak var dealwayParameter: UITextField!
    
    @IBOutlet weak var cityParameter: UITextField!
    
    @IBOutlet weak var headphoneSwitchOutlet: UISwitch!
    
    
    @IBOutlet weak var chargerSwitchOutle: UISwitch!
    
    var delegate:searchVCdelegate?
    var headPhoneValue = false
    var ischargerValue = false
    
   var TypePicker = UIPickerView()
    var brandPicker = UIPickerView()
    var pricePikcer = UIPickerView()
    var warrantyPicker = UIPickerView()
    var dealwayPicker = UIPickerView()
    var cityPikcer = UIPickerView()
    var activityTexiFeild: UITextField?
    
    var minPrice = ""
   var maxPrice = ""
    var KwhereClause = ""
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: mainView.frame.size.height + 30)
        
        setupPikcer()
    }

    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    //MARK: IBACTION
    @IBAction func donePressed(_ sender: Any) {
        
        if typeParameter.text != "" {
            
            KwhereClause = "type = '\(typeParameter.text!)'"
            if brandParameter.text != "" {
                
                KwhereClause = KwhereClause + " and brand = '\(brandParameter.text!)'"
                
            }
            
            if warrnatyParameter.text != "" {
                
                KwhereClause = KwhereClause + " and warranty = '\(warrnatyParameter.text!)'"
                
            }
            
            if dealwayParameter.text != "" {
                
                KwhereClause = KwhereClause + " and dealofWay = '\(dealwayParameter.text!)'"
                
            }
            
            if cityParameter.text != "" {
                
                KwhereClause = KwhereClause + " and  city = '\(cityParameter.text!)'"
               
            }
            
            //price complicated
            
            if piceParameter.text != "" && piceParameter.text != "Any-Any"{
                minPrice = piceParameter.text!.components(separatedBy: "-").first!
                maxPrice = piceParameter.text!.components(separatedBy: "-").last!
                
                if minPrice == "" {minPrice = "Any"}
                if maxPrice == "" {maxPrice = "Any"}
                if minPrice == "Any" && maxPrice != "Any"{
                    
                    KwhereClause = KwhereClause + " and price <= \(maxPrice)"
                }
                if maxPrice == "Any" && minPrice != "Any"{
                    KwhereClause = KwhereClause + " and price >= \(minPrice)"
                }
                if minPrice != "Any" && maxPrice != "Any" {
                    
                    KwhereClause = KwhereClause + " and price > \(minPrice) and price < \(maxPrice)"
                }
                
            }
            
            
            if headPhoneValue {
                KwhereClause = KwhereClause + " and headPhone = '\(headPhoneValue)'"
                
            }
            if ischargerValue {
                KwhereClause = KwhereClause + " and headPhone = '\(ischargerValue)'"
                
            }
            
             print(KwhereClause)
            
            
            
            delegate!.didfinishSetting(whereClause: KwhereClause)
           self.dismiss(animated: true, completion: nil)
        }else{
            
            ProgressHUD.showError("Missing required fields!")
            print("Invalid search parameter")
        }
        
        
    }
    
    
    @IBAction func headPhoneSwitch(_ sender: Any) {
        
        headPhoneValue = !headPhoneValue
        
    }
    
 
    @IBAction func chargerSwitch(_ sender: Any) {
        
        ischargerValue = !ischargerValue
    }
    
    //MARK: helper
    
    func setupPikcer() {
        
         TypePicker.delegate = self
         brandPicker.delegate = self
         pricePikcer.delegate = self
         warrantyPicker.delegate = self
         dealwayPicker.delegate = self
         cityPikcer.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissBtnPressd))
        toolBar.setItems([flexibleBar,doneButton], animated: true)
        
        
        typeParameter.inputAccessoryView = toolBar
        typeParameter.inputView = TypePicker
        
        brandParameter.inputAccessoryView = toolBar
        brandParameter.inputView = brandPicker
        
        piceParameter.inputAccessoryView = toolBar
        piceParameter.inputView = pricePikcer
        
        warrnatyParameter.inputAccessoryView = toolBar
        warrnatyParameter.inputView = warrantyPicker
        
        dealwayParameter.inputAccessoryView = toolBar
        dealwayParameter.inputView = dealwayPicker
        
        cityParameter.inputAccessoryView = toolBar
        cityParameter.inputView = cityPikcer
        
        
        
        
        
        
        
        
    }
    
    
    @objc func dismissBtnPressd(){
        
        self.view.endEditing(true)
    }
    
    
    //picker delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if pickerView == pricePikcer {
            
            return 2
        }
        
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case TypePicker:
            return typeArray.count
        case brandPicker:
            return brand.count
        case warrantyPicker :
            return warrantyArray.count
        case pricePikcer :
            return minPreceArray.count
        case dealwayPicker :
            return DealWayArray.count
        case cityPikcer :
            return cityArray.count
            
        default:
            return 0
        }
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case TypePicker:
            return typeArray[row]
        case brandPicker:
            return brand[row]
        case warrantyPicker :
            return warrantyArray[row]
        case pricePikcer :
            if component == 0 {
                
                return minPreceArray[row]
            }else{
                
                return maxPreceArray[row]
            }
            
            
        case dealwayPicker :
            return DealWayArray[row]
        case cityPikcer :
            return cityArray[row]
            
        default:
            return ""
        }
        
        
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var rowValue = row
        switch pickerView {
        case TypePicker:
            if rowValue == 0 { rowValue = 1}
            
            typeParameter.text = typeArray[rowValue]
        case brandPicker:
               if rowValue == 0 { rowValue = 1}
          brandParameter.text = brand[rowValue]
        case warrantyPicker :
               if rowValue == 0 { rowValue = 1}
            warrnatyParameter.text = warrantyArray[rowValue]
        case pricePikcer :
               if rowValue == 0 { rowValue = 1}
               if component == 0 {
                
                minPrice = minPreceArray[rowValue]
               }else{
                maxPrice = maxPreceArray[rowValue]
                
            }
            
            piceParameter.text = minPrice + "-" + maxPrice
        case dealwayPicker :
               if rowValue == 0 { rowValue = 1}
            dealwayParameter.text = DealWayArray[rowValue]
        case cityPikcer :
               if rowValue == 0 { rowValue = 1}
            cityParameter.text = cityArray[rowValue]
            
        default:
           break
        }

    }

    
}
