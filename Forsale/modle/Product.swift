//
//  Product.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/14.
//  Copyright © 2018年 sen. All rights reserved.
//

import Foundation

@objcMembers
class Product:NSObject {
    
    
    var objectId: String?
   var ProductID: String?
    var ownerId: String?
    var title: String?
    var brand : String?
    var price: Int = 0
    var discrip:String?
    var warranty:String?
    var status: String?
    var type:String?
    var imageLink : String?
    var isSold : Bool = false
    var city : String?
    var country: String?
    var inTopUntil : Date?
    var created: Date?
    var ownerName: String?
    var ownerAvatar: String?
    var DateOfPurchase: String?
    var dealWay: String?
    var accessory:String?
    var headPhone: Bool = false
    var isCharger: Bool = false
    var dealofWay : String?
    var dateeOfPurchase: String?
    
    
    //MARK: save Function
    
    func saveProduct(){
        
        let dataStore = backendless!.data.of(Product().ofClass())
        dataStore!.save(self)
    }
    
    func saveProduct(completion: @escaping (_ value: String)->Void){
        
         let dataStore = backendless!.data.of(Product().ofClass())
        dataStore!.save(self, response: { (result) in
             completion("Successs")
      
        }) { (fault:Fault?) in
            completion(fault!.message)

        }

    }
    
    
    //MARK: DELETE
    
 class func deteteProduct(product:Product){
       let dataStore = backendless!.data.of(Product().ofClass())
            dataStore!.remove(product)
        
    }
   
  class func deteteProduct(product:Product,completion: @escaping(_ value:String)->Void){
        let dataStore = backendless!.data.of(Product().ofClass())
        dataStore!.remove(product, response: { (result) in
            
            completion("Successful")
        }) { (fault:Fault?) in
            completion(fault!.message)
        }
        
    }
    
    //MARK: SEARCH FUNC
    
    class func fetchRecentProducts(limitNumber: Int , completion: @escaping (_ producties: [Product?])->Void){
        
        
        let quiryBuilder = DataQueryBuilder()
        quiryBuilder!.setSortBy(["inTopUntil DESC"])
        // HOW MANY
        quiryBuilder!.setPageSize(Int32(limitNumber))
        quiryBuilder!.setOffset(0)
        
        let dataStore = backendless!.data.of(Product().ofClass())
        dataStore!.find(quiryBuilder, response: { (backendlessProducties) in
            completion(backendlessProducties as! [Product])
        }) { (fault:Fault?) in
            print("Eroro.couldnt get recent producties\(fault!.message)")
            completion([])
        }
        
    }
    
    class func fetchALLProducts(complition: @escaping (_ producties: [Product?])->Void) {
        
        let dataStore = backendless!.data.of(Product().ofClass())
        
        dataStore!.find({ (allProducties) in
            
            complition(allProducties as! [Product])
        }) { (fault:Fault?) in
           
             print("Eroro.couldnt get recent producties\(fault!.message)")
            complition([])
            
        }
        
    }
    class func fetchProductsWIth(whereClauses:String,completion: @escaping(_ producties:[Product?])->Void) {
            let dataStore = backendless!.data.of(Product().ofClass())
            let quiryBuilder = DataQueryBuilder()
            quiryBuilder?.setWhereClause(whereClauses)
        quiryBuilder!.setSortBy(["inTopUntil DESC"])
        dataStore?.find(quiryBuilder, response: { (allProducties) in
            completion(allProducties as! [Product])
        }, error: { (fault: Fault?) in
           
            print("Eroro.couldnt get recent producties\(fault!.message)")
            completion([])
        })
    }

} // end of class



func canUserPost(completion: @escaping (_ canPost:Bool)->Void){
    
    let queryBuilder = DataQueryBuilder()
    let whereClause = "ownerId = '\(Fuser.currentId())'"
    queryBuilder?.setWhereClause(whereClause)
    
    let dataStore = backendless!.data.of(Product().ofClass())
    
    dataStore!.find(queryBuilder, response: { (allProducts) in
        
        allProducts!.count == 0 ? completion(true) : completion(false)
    }) { (fault:Fault?) in
        print(fault!.message)
        completion(true)
    }
}
