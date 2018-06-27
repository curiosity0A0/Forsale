//
//  ResulltVC.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/23.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit

class ResulltVC: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,RecentlyCellDelegete,searchVCdelegate{


    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    @IBOutlet weak var warningLabel: UILabel!
    
    var product: [Product] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

        warningLabel.isHidden = false
    
    }

// delegate collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       

     return product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recentlyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RecentlyCell
        
        recentlyCell.delegate = self
        recentlyCell.generateCell(Product: product[indexPath.row])
        
        return recentlyCell
    }
    
    
    //datasource
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let productsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
        
        productsVC.product = product[indexPath.row]
        self.present(productsVC, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(494))

    }
    
    
    func didClickStarBtn(product: Product) {
        
        favoriteSetting(product: product, collection: collectionView)
       
    }
    
  
    @IBAction func gotosetting(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchVC") as! searchVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    

    func didfinishSetting(whereClause: String) {
        
        LoadProduct(whereclasue: whereClause)
        
    }
    
    //MARK: Load Properties
    func LoadProduct(whereclasue:String){
        
        self.product = []
        
        Product.fetchProductsWIth(whereClauses: whereclasue) { (allProduct) in
            
            if allProduct.count > 0 {
                
                self.warningLabel.isHidden = true
                self.product = allProduct as! [Product]
                self.collectionView.reloadData()
                
            }else{
                self.warningLabel.isHidden = false
                ProgressHUD.showError("No product that your search")
                self.collectionView.reloadData()
            }
        }
        
        
    }
    
    
}
