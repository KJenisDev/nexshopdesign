//
//  AddNewAddressVC.swift
//  Nexshop
//
//  Created by Mac on 06/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
import Loaf
import SKCountryPicker

protocol UpdateAddress
{
    func UpdateAddress(isAddressId:String)
}




class AddNewAddressVC: UIViewController,CLLocationManagerDelegate{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var btnTitleAlt: UIButton!
    
    
    @IBOutlet weak var txtAlt: ACFloatingTextfield!
    
    
    @IBOutlet weak var txtCountry: ACFloatingTextfield!
    @IBOutlet weak var btnTitleCountry: UIButton!
    
    @IBOutlet weak var txtZipCode: ACFloatingTextfield!
    
    @IBOutlet weak var txtName: ACFloatingTextfield!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var txtMobileNumber: ACFloatingTextfield!
    
    @IBOutlet weak var txtHouse: ACFloatingTextfield!
    @IBOutlet weak var txtRoad: ACFloatingTextfield!
    @IBOutlet weak var txtCity: ACFloatingTextfield!
    @IBOutlet weak var txtState: ACFloatingTextfield!
    @IBOutlet weak var imgviewHome: UIImageView!
    @IBOutlet weak var imgviewOffice: UIImageView!
    
    //MARK:- VARIABLES
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentlatitude =  Double()
    var currentlogitude =  Double()
    var currentLC = CLLocationCoordinate2D()
    var latitude = String()
    var logitude = String()
    var type = String()
    var UpadteAddressDelegate:UpdateAddress?
    var Country_Code = String()
    
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.distanceFilter = 10.0
        
        return _locationManager
    }()
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        self.type = String()
        self.imgviewHome.image = UIImage(named: "ic_check_blue")
        self.imgviewOffice.image = UIImage(named: "ic_check_blue")
        
        let country = CountryManager.shared.currentCountry
                   self.Country_Code = country!.dialingCode!
                   
        self.btnTitleCountry.setTitle(country?.dialingCode, for: .normal)

        
        
        
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            { (placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                print(placemarks)
                
                if placemarks != nil
                {
                    if placemarks!.count > 0
                    {
                        
                        let pm = placemarks! as [CLPlacemark]
                        
                        if pm.count > 0 {
                            let pm = placemarks![0]
                            var addressString: String = ""
                            
                            if pm.subLocality != nil {
                                addressString = addressString + pm.subLocality! + ", "
                            }
                            if pm.thoroughfare != nil {
                                addressString = addressString + pm.thoroughfare! + ", "
                            }
                            if pm.locality != nil {
                                addressString = addressString + pm.locality! + ", "
                            }
                            if pm.country != nil {
                                addressString = addressString + pm.country! + ", "
                            }
                            if pm.postalCode != nil {
                                addressString = addressString + pm.postalCode! + " "
                            }
                            
                            if pm.postalCode!.isEmpty == false
                            {
                                self.txtZipCode.text = "\(pm.postalCode!)"
                            }
                            if pm.locality!.isEmpty == false
                            {
                                self.txtCity.text = "\(pm.locality!)"
                            }
                            
                            
                            print(pm)
                            print(pm.subLocality)
                            print(pm.thoroughfare)
                            print(pm.locality)
                            print(pm.country)
                            print(pm.postalCode)
                            
                            appDelegate.HideProgress()
                            
                        }
                    }
                }
                else
                    
                {
                    
                }
                
                
                
                
        })
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func AddNewAddress (message:String, data:Data?) -> Void
    {
        do
        {
            if data != nil
            {
                DispatchQueue.main.async {
                    
                    let parsedData =  try? JSON(data: data!)
                    
                    if parsedData == nil
                    {
                        appDelegate.HideProgress()
                        Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
                        return
                        
                    }
                    else
                    {
                        let dict:JSON = parsedData!
                        let status = dict["status"].int
                        
                        if status == 0
                        {
                            let ErrorDic:String = dict["message"].string!
                            appDelegate.HideProgress()
                            appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                            return
                            
                        }
                        else if status == 1
                        {
                            
                            DispatchQueue.main.async {
                                
                                appDelegate.HideProgress()
                                self.UpadteAddressDelegate?.UpdateAddress(isAddressId: "")
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                        }
                            
                        else
                        {
                            let ErrorDic:String = dict["message"].string!
                            appDelegate.HideProgress()
                            appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                            return
                        }
                    }
                    
                }
                
            }
            
        }
            
        catch
        {
            
            appDelegate.HideProgress()
            Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
            return
            
        }
    }
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnhandlerAlt(_ sender: Any) {
    }
    
    @IBAction func btnHandlerCountry(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            
            
            self.Country_Code = country.dialingCode!
            self.btnTitleCountry.setTitle(country.dialingCode, for: .normal)

        }
        countryController.detailColor = UIColor.black
    }
    
    
    @IBAction func btnHandlerHome(_ sender: Any)
    {
        self.type = "Home"
        self.imgviewHome.image = UIImage(named: "ic_select_blue")
        self.imgviewOffice.image = UIImage(named: "ic_check_blue")
    }
    
    
    
    @IBAction func btnHandlerOffice(_ sender: Any)
    {
        self.type = "Office"
        self.imgviewHome.image = UIImage(named: "ic_check_blue")
        self.imgviewOffice.image = UIImage(named: "ic_select_blue")
    }
    
    
    @IBAction func btnHandlerAddNewAddress(_ sender: Any)
    {
        if self.txtName.text?.isEmpty == true
        {
            Loaf("Please enter full name", state: .error, sender: self).show()
            return
        }
        if self.txtHouse.text?.isEmpty == true
        {
            Loaf("Please enter house# /suite # name", state: .error, sender: self).show()
            return
        }
        if self.txtRoad.text?.isEmpty == true
        {
            Loaf("Please enter street number", state: .error, sender: self).show()
            return
        }
        if self.txtCity.text?.isEmpty == true
              {
                  Loaf("Please enter city", state: .error, sender: self).show()
                  return
              }
              if self.txtState.text?.isEmpty == true
              {
                  Loaf("Please enter state", state: .error, sender: self).show()
                  return
              }
        if self.txtZipCode.text?.isEmpty == true
        {
            Loaf("Please enter zipcode", state: .error, sender: self).show()
            return
        }
        if self.txtCountry.text?.isEmpty == true
        {
            Loaf("Please enter country", state: .error, sender: self).show()
            return
        }
        if self.txtMobileNumber.text?.isEmpty == true
        {
            Loaf("Please enter mobile number", state: .error, sender: self).show()
            return
        }
       
        
      
      
        if self.type == ""
        {
            Loaf("Please select address type", state: .error, sender: self).show()
            return
        }
        
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        let Paramteres = ["name":"\(self.txtName.text!)","tag":"\(self.type)","house_number":"\(self.txtHouse.text!)","state":"\(self.txtState.text!)","country":"","city":"\(self.txtCity.text!)","zipcode":"\(self.txtZipCode.text!)","mobile_no":"\(self.txtMobileNumber.text!)","lat":"\(appDelegate.latitude)","lng":"\(appDelegate.logitude)","country_code":self.Country_Code,"col_number":self.txtRoad.text!]
        
        print(Paramteres)
        
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.add_address)!, params: Paramteres, finish: self.AddNewAddress)
    }
    
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func btnHandlerUseCurrentLocation(_ sender: Any)
    {
        /// Check if user has authorized Total Plus to use Location Services
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                self.locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                break
                
            case .restricted, .denied:
                let alert = UIAlertController(title: "Allow Location Access", message: "Nexshop needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                print("Full Access")
                
                if CommonClass.sharedInstance.isReachable() == false
                {
                    Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                    return
                }
                
                appDelegate.ShowProgess()
                self.getAddressFromLatLon(pdblLatitude: appDelegate.latitude, withLongitude: appDelegate.logitude)
                
                break
            }
        }
    }
    
    
}




