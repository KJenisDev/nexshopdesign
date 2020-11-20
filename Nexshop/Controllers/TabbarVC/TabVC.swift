//
//  TabVC.swift
//  Nexshop
//
//  Created by Mac on 01/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import AZTabBar

class TabVC: UIViewController {
    
    
    //MARK:- VARIABLES
    
    var counter = 0
    var tabController:AZTabBarController!
    var resultArray:[String] = []
    var Selected_index = 0
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var icons = [UIImage]()
        icons.append(UIImage(named: "home-gray")!)
        icons.append(UIImage(named: "feed-gray")!)
        icons.append(UIImage(named: "Group 12351")!)
        icons.append(UIImage(named: "Group 12350")!)
        
        
        var sIcons = [UIImage]()
        sIcons.append(UIImage(named: "home-blue")!)
        sIcons.append(UIImage(named: "feed-blue")!)
        sIcons.append(UIImage(named: "Group 12354")!)
        sIcons.append(UIImage(named: "Group 12353")!)
        
        
        
        //init
        //tabController = .insert(into: self, withTabIconNames: icons)
        tabController = .insert(into: self, withTabIcons: icons, andSelectedIcons: sIcons)
        
        //set delegate
        tabController.delegate = self
        
        let Home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
        let Feed = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedVC")
        let Cart = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC")
        let Profile = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
        
        tabController.setViewController(Home, atIndex: 0)
        tabController.setViewController(Feed, atIndex: 1)
        tabController.setViewController(Cart, atIndex: 2)
        tabController.setViewController(Profile, atIndex: 3)
        
        
        let color = UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        
        tabController.selectedColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD")
        tabController.highlightColor = color
        tabController.highlightedBackgroundColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        tabController.defaultColor = .lightGray
        tabController.buttonsBackgroundColor = UIColor(red: (247.0/255), green: (247.0/255), blue: (247.0/255), alpha: 1.0)
        tabController.selectionIndicatorHeight = 0
        tabController.selectionIndicatorColor = color
        tabController.tabBarHeight = 60
        
        tabController.setIndex(Selected_index, animated: true)
        
        self.tabController.onlyShowTextForSelectedButtons = !self.tabController.onlyShowTextForSelectedButtons
        
        tabController.animateTabChange = true
        tabController.onlyShowTextForSelectedButtons = true
        tabController.setTitle("Home", atIndex: 0)
        tabController.setTitle("Feed", atIndex: 1)
        tabController.setTitle("Cart", atIndex: 2)
        tabController.setTitle("Profile", atIndex: 3)
        tabController.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
        let container = tabController.buttonsContainer
        container?.layer.shadowOffset = CGSize(width: 0, height: -2)
        container?.layer.shadowRadius = 10
        container?.layer.shadowOpacity = 0.1
        container?.layer.shadowColor = UIColor.black.cgColor
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getNavigationController(root: UIViewController)->UINavigationController{
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.title = title
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        return navigationController
    }
    
    
    
}


extension TabVC: AZTabBarDelegate{
    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int) -> UIStatusBarStyle {
        return (index % 2) == 0 ? .default : .lightContent
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int) -> Bool {
        return true//index != 2 && index != 3
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index: Int) -> Bool {
        return true
    }
    
    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int) {
        //print("didMoveToTabAtIndex \(index)")
    }
    
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int) {
       // print("didSelectTabAtIndex \(index)")
    }
    
    func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index: Int) {
       // print("willMoveToTabAtIndex \(index)")
    }
    
    func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index: Int) {
        //print("didLongClickTabAtIndex \(index)")
    }
    
    
    
}

