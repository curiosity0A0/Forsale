//
//  ProfileVC.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/21.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import Firebase


class ProfileVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FavoritCelldelegate{

  
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userPhone: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var userEmail: UILabel!
    
    
    @IBOutlet weak var userStatusOutlet: UITextView!
    
    
    @IBOutlet weak var mainScrollVIew: UIScrollView!
    
    @IBOutlet weak var displayNoProduct: UILabel!
    
    

    var products:[Product] = []
    
    
    @IBOutlet weak var mainView: UIView!
    
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        collectionView.reloadData()
        if !isUserLoggin(vc: self){
            
            return
        }else{
         
            FavoriteloadProduct()
            userInfo()
            
            if segment.selectedSegmentIndex == 0 {
              
                FavoriteloadProduct()
                  collectionView.reloadData()
            }else if segment.selectedSegmentIndex == 1 {
                
                fetchPosted()
              
                
            }
            
            
         
        }
        
        
      
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.mainScrollVIew.contentSize = CGSize(width: self.view.bounds.width, height: mainView.frame.height + 10)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    
    
    //MARK: IBACTION
    
    
    @IBAction func choseWayToDisplay(_ sender: UISegmentedControl) {
        
                collectionView.reloadData()
        switch sender.selectedSegmentIndex {
        case 0:
            
            FavoriteloadProduct()
        
          
              case 1:
                fetchPosted()
           
            
        default:
            
            print("nothings")
        }
        
        
        
    }
    @IBAction func goToNotify(_ sender: Any) {
        
        performSegue(withIdentifier: "notify", sender: self)
    }
    
    @IBOutlet weak var gotoNotify: UIButton!
    
    @IBAction func EDITACTION(_ sender: Any) {
        
        let alert = UIAlertController(title: "User Menu", message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit info", style: .default) { (action) in
            // go to finish
            
            let finishVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editing") as! FinishVC
            self.present(finishVC,animated: true,completion: nil)
            
        }
        
        let logout = UIAlertAction(title: "Log Out", style: .destructive) { (action) in

            Fuser.logoutUser(withblock: { (success) in
                
                if success {
                    
                    let mainvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
                    
                    self.present(mainvc,animated: true,completion: nil)
                    
                }
            })
            
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alert.addAction(edit)
        alert.addAction(logout)
        alert.addAction(cancel)
        present(alert,animated: true,completion: nil)
        
    }
    
    //MARKL: DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritCell", for: indexPath) as! FavoritCell
        
        cell.delegate = self
         cell.generate(product: products[indexPath.row])
  
       
        return cell
    }
    
    //MARK: RecentlyCellDelegete
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
        
        
        vc.product = products[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width / 3 - 7, height: CGFloat(124))
        
    }
    
    //MARK: LoadProperties
    
    func FavoriteloadProduct(){
        
        self.products = []
        
        
        let user = Fuser.currentUser()!
        let stringArray = user.favaritProperties
        let string = "'" + stringArray.joined(separator: "', '") + "'"
        
        if user.favaritProperties.count > 0 {
            let whereClause = "objectId IN (\(string))"
            print(whereClause)
            Product.fetchProductsWIth(whereClauses: whereClause) { (allProduct) in
                
                if allProduct.count != 0 {
                    
                    print("this is \(allProduct)")
                    self.products = allProduct as! [Product]
                    self.displayNoProduct.isHidden = true
                    self.collectionView.reloadData()
                    
                }
            }
            
        }else if user.favaritProperties.count == 0{
            
            displayNoProduct.isHidden = false
            collectionView.reloadData()
            
        }

    }
    
    //MARK: USER INFO
    
    func userInfo(){
        
        
        let user = Fuser.currentUser()!
        
       
        if user.avatar != "" && user.avatar != nil {
            
            imageFromData(pictureData: user.avatar) { (userimage) in
                
                userImage.image = userimage?.circleMasked
                
            }
        }else{
            
            userImage.image = UIImage(named: "sample")?.circleMasked
        }
        
      
        
        if user.userEmail != "" && user.userEmail != nil {
            
            userEmail.text = user.userEmail
            
        }else{
            userEmail.text = ""
        }
        
        
        if user.phoneNumber != "" && user.phoneNumber != nil {
            
            userPhone.text = user.phoneNumber
            
        }else{
            userPhone.text = ""
        }
        
        if user.displayName != "" {
            userName.text = user.displayName
        }else{
            userName.text = ""
        }
        
        if user.Status != "" {
            
            userStatusOutlet.text = user.Status
        }else{
            userStatusOutlet.text = ""
        }
     
        
        
        
    }
    
    //MARK: POST ACTION
    

    func fetchPosted(){
        
        let userid = Fuser.currentId()
        
        let whereClause = "ownerId = '\(userid)'"
        
        Product.fetchProductsWIth(whereClauses: whereClause) { (postedProducts) in
            
            if postedProducts.count != 0 {
                self.products = postedProducts as! [Product]
                self.displayNoProduct.isHidden = true
                self.collectionView.reloadData()
                
            }else{
                self.displayNoProduct.isHidden = false
                self.collectionView.reloadData()

            }
          
        }
        
    }
    
    
    func didClickStarBtn(product: Product) {
        
        favoriteSetting(product: product, collection: collectionView)
        
        
//        let user = Fuser.currentUser()!
//
//        if user.favaritProperties.contains(product.objectId!){
//
//            let index = user.favaritProperties.index(of: product.objectId!)
//            user.favaritProperties.remove(at: index!)
//
//            updateCurrentUserWith(Clause: [kFavoritProperties:user.favaritProperties]) { (successful) in
//
//                if successful {
//
//                    ProgressHUD.showSuccess("Removed")
//                    self.collectionView.reloadData()
//                }else{
//                    ProgressHUD.showError("Someting should be wrong!")
//                     self.collectionView.reloadData()
//                }
//            }
//
//
//        }else{
//
//            user.favaritProperties.append(product.objectId!)
//            updateCurrentUserWith(Clause: [kFavoritProperties:user.favaritProperties]) { (successful) in
//
//                if successful {
//
//                    ProgressHUD.showSuccess("saved")
//                    self.collectionView.reloadData()
//                }else{
//                    ProgressHUD.showError("Someting should be wrong!")
//                     self.collectionView.reloadData()
//                }
//            }
//
//        }

    }

}
