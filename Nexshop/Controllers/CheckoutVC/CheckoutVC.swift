//
//  CheckoutVC.swift
//  Nexshop
//
//  Created by Mac on 05/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON
import Stripe

class CheckoutVC: UIViewController,UITextFieldDelegate{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet var viewCard: UIView!
    @IBOutlet weak var tblviewCheckout: UITableView!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var txtCvv: UITextField!
    @IBOutlet weak var lblServiceCharge: UILabel!
    @IBOutlet weak var lblShippingCharge: UILabel!
    @IBOutlet weak var lbblItemsCharge: UILabel!
    
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var imgviewCard: UIImageView!
    @IBOutlet weak var btnTitleDate: UIButton!
    
    
    //MARK:- VARIABLES
    var totalitemscharge = NSNumber()
    var servicecharge = NSNumber()
    var deliverycharge = NSNumber()
    var granndTotal = NSNumber()
    
    var ServicesDict = NSMutableDictionary()
    var is_Payment_Selected = String()
    var isAddressid = String()
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    var FinalSelectedMonth = Int()
    var FinalSelectedYear = Int()
    var mexValue : Int = 19
    var cvvmexValue : Int = 3
    var isValideCard : Bool = false
    var selectedCardType = String()
    var Stripe_Token = String()
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        
        self.tblviewCheckout.isScrollEnabled = false
        
        self.is_Payment_Selected = String()
        
        
        self.tblviewCheckout.isUserInteractionEnabled = true
        
        self.lblGrandTotal.text = "$ " + "\(self.granndTotal)"
        self.lblServiceCharge.text = "$ " + "\(self.servicecharge)"
        self.lbblItemsCharge.text = "$ " + "\(self.totalitemscharge)"
        self.lblShippingCharge.text = "$ " + "\(self.deliverycharge)"
        
        
        self.tblviewCheckout.register(CheckOutCellXIB.self, forCellReuseIdentifier: "CheckOutCellXIB")
        self.tblviewCheckout.register(UINib(nibName: "CheckOutCellXIB", bundle: nil), forCellReuseIdentifier: "CheckOutCellXIB")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        self.txtCardNumber.delegate = self
        self.txtCvv.delegate = self
        txtCardNumber.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        
        
        self.tblviewCheckout.reloadData()
        
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        nums = Set(nums).sorted()
        return nums.count
    }
    
    private func doneHandler()
    {
        
        let date = Date()
        let calendar = Calendar.current
        
        let month = Int(calendar.component(.month, from: date))
        let year = Int(calendar.component(.year, from: date))
        
        if self.FinalSelectedMonth == 0 && self.FinalSelectedYear == 0
        {
            self.FinalSelectedMonth = month
            self.FinalSelectedYear = year
            let Buttondisplay = "\(self.FinalSelectedMonth)" + "/" + "\(self.FinalSelectedYear)"
            
            self.btnTitleDate.setTitleColor(UIColor.black, for: .normal)
            self.btnTitleDate.setTitle(Buttondisplay, for: .normal)
        }
        else
        {
            if FinalSelectedMonth == month
            {
                if year == self.FinalSelectedYear
                {
                    let Buttondisplay = "\(self.FinalSelectedMonth)" + "/" + "\(self.FinalSelectedYear)"
                    
                    self.btnTitleDate.setTitleColor(UIColor.black, for: .normal)
                    self.btnTitleDate.setTitle(Buttondisplay, for: .normal)
                    
                    
                }
                else if year < self.FinalSelectedYear
                {
                    let Buttondisplay = "\(self.FinalSelectedMonth)" + "/" + "\(self.FinalSelectedYear)"
                    
                    self.btnTitleDate.setTitleColor(UIColor.black, for: .normal)
                    self.btnTitleDate.setTitle(Buttondisplay, for: .normal)
                }
                else
                {
                    Loaf("Please select valid date", state: .error, sender: self).show()
                    return
                }
            }
            else if self.FinalSelectedMonth > month
            {
                if year == self.FinalSelectedYear
                {
                    let Buttondisplay = "\(self.FinalSelectedMonth)" + "/" + "\(self.FinalSelectedYear)"
                    self.btnTitleDate.setTitleColor(UIColor.black, for: .normal)
                    self.btnTitleDate.setTitle(Buttondisplay, for: .normal)
                }
                else if year < self.FinalSelectedYear
                {
                    let Buttondisplay = "\(self.FinalSelectedMonth)" + "/" + "\(self.FinalSelectedYear)"
                    self.btnTitleDate.setTitleColor(UIColor.black, for: .normal)
                    self.btnTitleDate.setTitle(Buttondisplay, for: .normal)
                }
                else
                {
                    Loaf("Please select valid date", state: .error, sender: self).show()
                    return
                }
            }
            else
            {
                
                if year == 0 && month == 0
                {
                    
                    
                }
                
                if year == self.FinalSelectedYear
                {
                    Loaf("Please select valid date", state: .error, sender: self).show()
                    return
                    
                    
                }
                else if year < self.FinalSelectedYear
                {
                    let Buttondisplay = "\(self.FinalSelectedMonth)" + "/" + "\(self.FinalSelectedYear)"
                    self.btnTitleDate.setTitleColor(UIColor.black, for: .normal)
                    self.btnTitleDate.setTitle(Buttondisplay, for: .normal)
                }
                else
                {
                    let Buttondisplay = "\(self.FinalSelectedMonth)" + "/" + "\(self.FinalSelectedYear)"
                    self.btnTitleDate.setTitleColor(UIColor.black, for: .normal)
                    self.btnTitleDate.setTitle(Buttondisplay, for: .normal)
                }
            }
        }
        
        
        
    }
    
    private func completetionalHandler(month: Int, year: Int)
    {
        print( "month = ", month, " year = ", year )
        
        FinalSelectedMonth = month
        FinalSelectedYear = year
    }
    
    @objc func keyboardWillAppear()
    {
        AKMonthYearPickerView.sharedInstance.hide()
    }
    
    @objc func keyboardWillDisappear() {
        
    }
    
    @objc func PaymentSuccess(Token:String)
    {
        
        if self.is_Payment_Selected == "Cash On Delivery"
        {
            self.is_Payment_Selected = "cash_on_delivery"
        }
        else if self.is_Payment_Selected == "Credit Card/Debit Card"
        {
            self.is_Payment_Selected = "stripe"
        }
        
        var Paramteres = ["address_id":"\(self.isAddressid)","module":"shopping","payment_method":self.is_Payment_Selected]
        appDelegate.ShowProgess()
        
        if self.is_Payment_Selected == "stripe"
        {
            Paramteres = ["address_id":"\(self.isAddressid)","module":"shopping","payment_method":self.is_Payment_Selected,"token":Token]
        }
        
        print(Paramteres)
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.create_order)!, params: Paramteres, finish: self.OrderCreatedWebService)
        
        
    }
    
    func OrderCreatedWebService (message:String, data:Data?) -> Void
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
                                
                                
                                
                                let ResponseData = dict["data"].dictionaryObject! as NSDictionary
                                
                                print(ResponseData)
                                
                                let data1 = dict["data"].dictionaryObject! as NSDictionary
                                
                                let delivery_date = data1.value(forKey: "delivery_date") as! String
                                
                                let shipping_address = (data1.value(forKey: "shipping_address") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                
                                let Push = self.storyboard!.instantiateViewController(withIdentifier: "OrderPlacedVC") as! OrderPlacedVC
                                Push.Expected_Date = delivery_date
                                Push.ShippingDetails = shipping_address
                                self.navigationController?.pushViewController(Push, animated: true)
                                
                                appDelegate.HideProgress()
                                
                                
                                
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtCardNumber {
            
            let text = (textField.text ?? "") as NSString
            
            
            
            let updatedString = text.replacingCharacters(in: range, with: string)
            
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
            cvvmexValue = 3
            if updatedString.hasPrefix("4") { // visa
                mexValue = 19
                self.imgviewCard.image = UIImage(named: "bt_ic_visa")
                selectedCardType = "visa"
                
                
                
            } else if updatedString.hasPrefix("54") || updatedString.hasPrefix("51") || updatedString.hasPrefix("55") || updatedString.hasPrefix("2") { // mastercard
                mexValue = 19
                self.imgviewCard.image = UIImage(named: "bt_ic_mastercard")
                selectedCardType = "mastercard"
            } else if updatedString.hasPrefix("3") { // amex
                mexValue = 17
                self.imgviewCard.image = UIImage(named: "bt_ic_amex")
                cvvmexValue = 4
                selectedCardType = "american express"
            } else if updatedString.hasPrefix("50") || updatedString.hasPrefix("56") || updatedString.hasPrefix("57") || updatedString.hasPrefix("58") { // maestor
                mexValue = 23
                self.imgviewCard.image = UIImage(named: "bt_ic_maestro")
                selectedCardType = "maestor"
            } else {
                //bt_ic_card_dark
                self.imgviewCard.image = UIImage(named: "bt_ic_card_dark")
                selectedCardType = ""
            }
            
            if range.length == 1 {
                if (range.location == 5 || range.location == 10 || range.location == 15) {
                    let text = textField.text ?? ""
                    textField.text = text.substring(to: text.index(before: text.endIndex))
                }
                return true
            }
            
            if (range.location == 4 || range.location == 9 || range.location == 14) {
                textField.text = String(format: "%@ ", textField.text ?? "")
            }
            
            
            if updatedString.count >= mexValue {
                let isValid = updatedString.isValidCardNumber()
                self.isValideCard = isValid
            }
            
        }
        else if textField == txtCvv {
            
            let text = (textField.text ?? "") as NSString
            
            let updatedString = text.replacingCharacters(in: range, with: string)
            
            if updatedString.count > cvvmexValue {
                return false
            }
            //self.checkCardDetail()
        }
        
        return true
        
        
    }
    
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 19 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        let is456 = string.hasPrefix("1")
        
        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        let is465 = [
            // Amex
            "34", "37",
            
            // Diners Club
            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
            ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = !(is456 || is465)
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
            let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs465Spacing || needs456Spacing || needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnTitleSelectDate(_ sender: Any)
    {
        self.view.endEditing(true)
        AKMonthYearPickerView.sharedInstance.barTintColor =  UIColor.black
        
        AKMonthYearPickerView.sharedInstance.previousYear = 0
        AKMonthYearPickerView.sharedInstance.NextYear = 20
        
        AKMonthYearPickerView.sharedInstance.show(vc: self, doneHandler: doneHandler, completetionalHandler: completetionalHandler)
    }
    
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHandlerCancelPopUp(_ sender: Any)
    {
        self.viewCard.removeFromSuperview()
    }
    
    @IBAction func btnHandlerDonePopUp(_ sender: Any)
    {
        if self.txtCardName.text!.isEmpty == true
        {
            
            Loaf("Please enter cardholder name", state: .error, sender: self).show()
            return
        }
        if self.txtCardNumber.text!.isEmpty == true
        {
            Loaf("Please enter card number", state: .error, sender: self).show()
            return
        }
        if self.txtCardNumber.text!.count < 16 || self.selectedCardType.isEmpty == true
        {
            Loaf("Please enter valid card number", state: .error, sender: self).show()
            return
            
        }
        if self.FinalSelectedYear == 0 || self.FinalSelectedMonth == 0
        {
            Loaf("Please select expiry date", state: .error, sender: self).show()
            return
            
        }
        if self.txtCvv.text?.isEmpty == true
        {
            Loaf("Please enter cvv number", state: .error, sender: self).show()
            return
        }
        
        let cardParams = STPCardParams()
        
        let str = self.txtCardNumber.text!
        let trimmed = str.trimmingCharacters(in: .whitespacesAndNewlines)
        
        cardParams.number = trimmed
        cardParams.expMonth = UInt(self.FinalSelectedMonth)
        cardParams.expYear = UInt(self.FinalSelectedYear)
        cardParams.cvc = self.txtCvv.text!
        
        appDelegate.ShowProgess()
        
        print(cardParams)
        
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                
                let TempMsg =  error!.localizedDescription
                print(TempMsg)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    appDelegate.HideProgress()
                    Loaf(TempMsg, state: .error, sender: self).show()
                    return
                    
                })
                return
            }
            
            print(token.tokenId)
            
            self.Stripe_Token = token.tokenId
            self.PaymentSuccess(Token: self.Stripe_Token)
        }
        
    }
    
    @IBAction func btnHandlerContinue(_ sender: Any)
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        if self.is_Payment_Selected.isEmpty == true
        {
            Loaf("Please select payment method", state: .error, sender: self).show()
            return
        }
        
        if self.is_Payment_Selected == "Cash On Delivery"
        {
            self.PaymentSuccess(Token: "")
        }
        else
        {
            self.viewCard.frame = self.view.frame
            self.view.addSubview(self.viewCard)
        }
        
        
    }
    
}


//MARK:- TABLEVIEW METHODS

extension CheckoutVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.tblviewCheckout.dequeueReusableCell(withIdentifier: "CheckOutCellXIB") as! CheckOutCellXIB
        
        
        if self.is_Payment_Selected.isEmpty == true
        {
            if indexPath.row == 0
            {
                cell.lblPayment.text = "Credit Card/Debit Card"
                cell.imgviewCheck.image = UIImage(named: "ic_check_blue")
                cell.lblPayment.alpha = 1.0
                cell.imgviewCheck.alpha = 1.0
            }
            else
            {
                cell.lblPayment.text = "Cash On Delivery"
                cell.imgviewCheck.image = UIImage(named: "ic_check_blue")
                cell.lblPayment.alpha = 1.0
                cell.imgviewCheck.alpha = 1.0
                
            }
        }
        else
        {
            if self.is_Payment_Selected == "Credit Card/Debit Card"
            {
                if indexPath.row == 0
                {
                    cell.lblPayment.text = "Credit Card/Debit Card"
                    cell.imgviewCheck.image = UIImage(named: "ic_select_blue")
                    cell.lblPayment.alpha = 1.0
                    cell.imgviewCheck.alpha = 1.0
                }
                else
                {
                    cell.lblPayment.text = "Cash On Delivery"
                    cell.imgviewCheck.image = UIImage(named: "ic_check_blue")
                    cell.lblPayment.alpha = 0.5
                    cell.imgviewCheck.alpha = 0.5
                }
                
            }
            else
            {
                if indexPath.row == 0
                {
                    cell.lblPayment.text = "Credit Card/Debit Card"
                    cell.imgviewCheck.image = UIImage(named: "ic_check_blue")
                    cell.lblPayment.alpha = 0.5
                    cell.imgviewCheck.alpha = 0.5
                }
                else
                {
                    cell.lblPayment.text = "Cash On Delivery"
                    cell.imgviewCheck.image = UIImage(named: "ic_select_blue")
                    cell.lblPayment.alpha = 1.0
                    cell.imgviewCheck.alpha = 1.0
                    
                }
            }
        }
        
        
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            self.is_Payment_Selected = "Credit Card/Debit Card"
        }
        else
        {
            self.is_Payment_Selected = "Cash On Delivery"
            
        }
        
        self.tblviewCheckout.reloadData()
    }
}


