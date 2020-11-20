//
//  TearmsAndUseVC.swift
//  Nexshop
//

import UIKit
import WebKit


class TearmsAndUseVC: UIViewController,WKNavigationDelegate,WKUIDelegate{
    
    //MARK:- OUTLETS
    @IBOutlet weak var vw_main: UIView!
    @IBOutlet weak var tbl_terms: UITableView!
    @IBOutlet weak var imgviewMenu: UIImageView!
    
    @IBOutlet weak var WebviewTemrs: WKWebView!
    @IBOutlet weak var btnTitleAgree: MyRoundedButton!
    
    //MARK:- VARIABLES
    
    var isFromSideMenu = false
    
    
    
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
        {
            self.vw_main.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        if isFromSideMenu == true
        {
            self.imgviewMenu.image = UIImage(named: "Group 12349")
            self.btnTitleAgree.isHidden = true
        }
        else
        {
            self.imgviewMenu.image = UIImage(named: "back-white")
            self.btnTitleAgree.isHidden = false
        }
        
        appDelegate.ShowProgess()
        
        
        let url = URL(string: "https://zestbrains.techboundary.xyz/public/privacypolicy")!
        let request = URLRequest(url: url)
        WebviewTemrs.navigationDelegate = self
        WebviewTemrs.load(request)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK:- ALL FUNCTIONS
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            
            appDelegate.HideProgress()
        })
    }
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerAgree(_ sender: Any)
    {
        if isFromSideMenu == true
               {
                   appDelegate.SetHomeRoot()
               }
               else
               {
                   self.navigationController?.popViewController(animated: true)
               }
        
        
    }
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        if isFromSideMenu == true
        {
            CommonClass.sharedInstance.openLeftSideMenu()
            present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}






