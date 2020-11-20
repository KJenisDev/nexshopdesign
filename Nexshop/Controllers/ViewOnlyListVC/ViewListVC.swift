//
//  ViewListVC.swift
//  Nexshop
//
//  Created by Mac on 11/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class ViewListVC: UIViewController {
    
    
    
    // MARK: - UIControlers Outlets
    @IBOutlet weak var ViewCart: UIView!
    @IBOutlet weak var CollectionviewHome: UICollectionView!
    
    // MARK: - Variables
    var ToppicksDisplayModel = [TodaysDeal]()
    
    
    // MARK: - View Did Load
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CollectionviewHome.register(UINib(nibName: "HomeSingleProductCelXIB", bundle: nil), forCellWithReuseIdentifier: "HomeSingleProductCelXIB")
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - Other Functions
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
       
    
    // MARK: - UIButton Actions
    
    @IBAction func btnHandlerback(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    // MARK: - UITableView Delegate Methods
    
    
    // MARK: - WEB API Methods
    
    
}

// MARK: - UICollectionView Delegate Methods



extension ViewListVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.ToppicksDisplayModel.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "HomeSingleProductCelXIB", for: indexPath) as! HomeSingleProductCelXIB
        
        if self.ToppicksDisplayModel.count > 0
        {
            
            DispatchQueue.main.async {
                cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 8)
            }
            
            cell.imgviewProduct.kf.indicatorType = .activity
            cell.imgviewProduct.kf.setImage(with: URL(string: self.ToppicksDisplayModel[indexPath.row].thumbnailImg))
            
            
            if self.ToppicksDisplayModel[indexPath.row].is_wishlisted == 1
            {
                cell.imgviewHeart.image = UIImage(named: "ic_red_heart")
                cell.btnTitleHeart.tag = indexPath.row
                
                
            }
            else
            {
                cell.imgviewHeart.image = UIImage(named: "ic_grey_heart")
                cell.btnTitleHeart.tag = indexPath.row
                
            }
            
            cell.lblName.text = self.ToppicksDisplayModel[indexPath.row].name!
            
            cell.lblOldPrice.text = "$ " + "\(self.ToppicksDisplayModel[indexPath.row].price!)"
            
            if self.ToppicksDisplayModel[indexPath.row].price == self.ToppicksDisplayModel[indexPath.row].unitPrice!
            {
                
                cell.lblOff.text = ""
            }
            else
            {
                
                let Offer = Float(self.ToppicksDisplayModel[indexPath.row].discount!)
                let x = Double(Offer).rounded(toPlaces: 1)
                var y = Int(x)
                cell.lblOff.text = "\(y)" + "% off"
                
                
            }
            
            let review = Float(self.ToppicksDisplayModel[indexPath.row].review!)
            let x = Double(review).rounded(toPlaces: 1)
            cell.lblRatings.text = "\(x)"
            
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var Height1 = (self.CollectionviewHome.frame.width - 5)/2
        Height1 = Height1 + 100
        return CGSize(width: (self.CollectionviewHome.frame.width - 5)/2, height: Height1 )
        
        
        
    }
    
}

