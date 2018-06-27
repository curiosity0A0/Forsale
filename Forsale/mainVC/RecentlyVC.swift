//
//  RecentlyVC.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/13.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit

class RecentlyVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RecentlyCellDelegete {

    @IBOutlet weak var recentPostCollectionView: UICollectionView!

    
    var products:[Product] = []
    var numberOFProduct: UITextField!

    override func viewWillLayoutSubviews() {
       
        recentPostCollectionView.collectionViewLayout.invalidateLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
     
             loadProduct(limiteNumber: KMaximum)
      
       
       //load product
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }

    //MARK: collectionView Date Source
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return products.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        let RecentlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RecentlyCell
       
        RecentlyCell.generateCell(Product: products[indexPath.row])
        RecentlyCell.delegate = self
        return RecentlyCell
        
    }
    
    
    
    
    //MARK: collectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
                vc.product = products[indexPath.row]
            self.present(vc,animated: true,completion: nil)
        //show properties
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(494))
    }
    
    
    //MARK: - ACTION SECTION
    
    @IBAction func gotoadd(_ sender: Any) {
        
        if !isUserLoggin(vc: self){
            return
        }else{
            
               performSegue(withIdentifier: "addProduct", sender: self)
        }

    }
    
    
    @IBAction func mixterBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Update", message: "Set number of Product to display", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "Number of products"
            textField.borderStyle = .roundedRect
            textField.keyboardType = .numberPad
            self.numberOFProduct = textField

        }
        
        let cancle = UIAlertAction(title: "Cancle", style: .cancel) { (action) in
            
        }
        
        let update = UIAlertAction(title: "Update", style: .default) { (action) in
            
            if self.numberOFProduct.text != "" && self.numberOFProduct.text != "0" {
                
                ProgressHUD.show("Updateding...")
                
                self.loadProduct(limiteNumber: Int(self.numberOFProduct.text!)!)
                
                ProgressHUD.dismiss()
                
            }
            
            
        }
        
        alert.addAction(cancle)
        alert.addAction(update)
        
        present(alert,animated: true,completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Load Product
    

    func loadProduct(limiteNumber: Int){
        
        Product.fetchRecentProducts(limitNumber: limiteNumber) { (allProducts) in
            if allProducts.count != 0 {
                
                
                self.products = allProducts as! [Product]
                
                self.recentPostCollectionView.reloadData()
            }
        }
  
    
    }
    
    //MARK: RecentlyCellDelegete
    
    func didClickStarBtn(product: Product) {
        
        favoriteSetting(product: product, collection: recentPostCollectionView)
    }
//        //check if we have a user
//
//        if Fuser.currentUser() != nil {
//
//            let user = Fuser.currentUser()!
//
//            //check if the product is in favorite
//
//            if user.favaritProperties.contains(product.objectId!){
//                //remove from faborite list
//
//                let index = user.favaritProperties.index(of: product.objectId!)
//                user.favaritProperties.remove(at: index!)
//
//                updateCurrentUserWith(Clause: [kFavoritProperties: user.favaritProperties]) { (sucess) in
//                    if !sucess {
//                        print("error removing favatit")
//                    }else{
//
//                        self.recentPostCollectionView.reloadData()
//                        ProgressHUD.showSuccess("Removed from the list")
//                    }
//                }
//            }else{
//
//                user.favaritProperties.append(product.objectId!)
//
//                updateCurrentUserWith(Clause: [kFavoritProperties: user.favaritProperties]) { (sucess) in
//                    if !sucess {
//                        print("error updating favatit")
//                    }else{
//
//                        self.recentPostCollectionView.reloadData()
//                        ProgressHUD.showSuccess("add to the list")
//                    }
//                }
//
//            }
//
//
//        }else{
//
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "choosePageLogin") as! LoginViewController
//            self.present(vc,animated: true,completion: nil)
//            //show login/register screen
//        }
//        }
    
    

    
    
}
