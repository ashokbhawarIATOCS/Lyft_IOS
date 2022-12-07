//
//  ExtentionFiles.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import Foundation
import UIKit
import CoreLocation

extension UIViewController {
    
    func baseBackgroundView(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundView")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
    }
    //Code For Showing the Custom Textfiled For Country Code and Country Dial Code
    func checkTexfieldContainNoOrEmail(_ textField: UITextField)
    {
        
        let view = UIView(frame: CGRect(x: textField.frame.origin.x, y: 0, width: 110, height: textField.frame.size.height - 10))
        
        countryCodeButton = UIButton(frame: CGRect(x:15.0, y: 0.0, width:80.0,height: textField.frame.size.height - 10))
        
        countryCodeButton.setTitleColor(textFieldTextColor, for: UIControl.State.normal)
        
        if countryCodeButton.titleLabel?.text == nil{
            
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                debugPrint(countryCode)
                countryCodeButton.setTitle( (countryCode + " +" + getCountryPhonceCode(countryCode)), for: .normal)
                countryCodeButton.titleLabel?.font = globalTextFieldFont
              
                countryCodeButton.contentHorizontalAlignment = .left
            }
            else
            {
                countryCodeButton.setTitle("Select Code", for: .normal)
            }
        }
        
        view.addSubview(countryCodeButton)
        
        let arrowView = UIView(frame: CGRect(x:countryCodeButton.frame.width + 14, y: 0, width: 20, height: textField.frame.size.height - 10))
        
        let dropdownArrow = UIButton(frame: CGRect(x: 0, y: (textField.frame.size.height - 10)/2 - 5, width: 10, height: 10))
        dropdownArrow.setImage( UIImage(named: "DropDownArrow")!, for: .normal)
        
        arrowView.addSubview(dropdownArrow)
        view.addSubview(arrowView)
        
        dropdownArrow.addTarget(self, action: #selector(showCountryListAction), for: .touchUpInside)
        
        //        arrowView.addRightBorderWithColor(color: blueClorCodeForTitles, width: 1.0)
        
        countryCodeButton.addTarget(self, action: #selector(showCountryListAction(sender:)), for: .touchUpInside)
        textField.setLeftPaddingPoints(view.frame.size.width)
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = view
        
    }
    //Code for remove the view from the text field
    func removeCustomViewInTextFiled(_ textField: UITextField)
    {
        textField.leftView = nil
       textField.setLeftPaddingPoints(15.0)
    }
    
    //Show the country code list when user tap
    @objc func showCountryListAction(sender: UIButton!) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: countryListPopUpSID) as! CountryCodeListVC
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.preferredContentSize =  CGSize(width: self.view.frame.size.width - 100, height: self.view.frame.size.height - 100)
        vc.myDelegate = (self as! CountryPickerTableViewDelegate)
        if sender.titleLabel?.text ?? "" == "" {
            
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                debugPrint(countryCode)
                countryCodeButton.setTitle( (countryCode + " +" + getCountryPhonceCode(countryCode)), for: .normal)
                countryCodeButton.titleLabel?.font = globalTextFieldFont
               
                countryCodeButton.contentHorizontalAlignment = .left
            }
            vc.selectedCountry = (countryCodeButton.titleLabel?.text?.split(regex: " ").first) ?? ""
            vc.selectedCountryDialCode = (countryCodeButton.titleLabel?.text?.split(regex: " ").last) ?? ""
        }else{
            
            vc.selectedCountry = (sender.titleLabel?.text?.split(regex: " ").first) ?? ""
            vc.selectedCountryDialCode = (sender.titleLabel?.text?.split(regex: " ").last) ?? ""
        }
        vc.preferredContentSize = CGSize(width: 300, height: 400)
        self.present(vc, animated: true, completion: nil)
    }
    
    public func isValidPassword(txtPass : String) -> Bool {
        //        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{6,15}$" // for special character
        let passwordRegex = "(?=.*[0-9]).{6,15}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: txtPass)
    }
    
    public func isValidEmailID(txtEmail : String) -> Bool {
//         let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: txtEmail) {
            return true
        }
        else{
            return false
        }
    }
    
    public func isValidName(txtName: String) -> Bool {
        
        let firstNameRegex = "[a-zA-z]+([ '-][a-zA-Z]+)*$"
        let firstNameTest = NSPredicate(format: "SELF MATCHES %@", firstNameRegex)
        
        let result = firstNameTest.evaluate(with: txtName)
        if result == false {
            return false
        }
        return result
    }
    
    public func isValidMobileNo(mobileNo : String, countryCode: String) -> Bool {
        
        var strMobileNo = mobileNo
        
        var noRegex = "[0-9]{3,13}$"
        if countryCode == "+61" {
            if mobileNo.first == "0" {
                strMobileNo = String(strMobileNo.dropFirst())
            }
            noRegex = "[0-9]{9,9}$"
        }else if countryCode == "+91" {
            noRegex = "[0-9]{10,10}$"
        }
        let noTest = NSPredicate(format: "SELF MATCHES %@", noRegex)
        
        return noTest.evaluate(with: strMobileNo)

    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: Constants.oK.localize(), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
//    func validateDomainFromEmail(text: String) -> Bool {
//           if(text.contains("xpanxion")){
//               return true
//           } else if(text.contains("ust-global"))
//           {
//                return true
//           } else if(text.contains("blueconchtech"))
//           {
//                return true
//           } else {
//               return false
//           }
//       }
    
    //Notification Handler
    @objc func statusManager() {
        updateUserInterface()
    }
    
    //Network related method
    func updateUserInterface() {
        
         let status = Network.reachability?.status
        switch status {
        case .unreachable:
            print("ViewController: Network became unreachable")
        case .wifi:
            
            print("ViewController: Network reachable through WiFi")
        case .wwan:
            
            print("ViewController: Network reachable through Cellular Data")
        case .none:
            print("ViewController: Network reachable through WiFi")
        }
        
        if(status == .unreachable)
        {
            DispatchQueue.main.async {
                // Update UI
                let alertController = UIAlertController(title: "" , message: kInternetAccessAlertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: Constants.oK.localize(), style: UIAlertAction.Style.default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion:nil)
            }

        }
        else if(status == .wifi || status == .wwan)
        {
            DispatchQueue.main.async {
                // Call method when network available
                if self.presentedViewController == nil
                {
                    //debugPrint("Alert not load")
                }
                else
                {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else{
            DispatchQueue.main.async {
                // Update UI
                let alertController = UIAlertController(title: "" , message: kInternetAccessAlertMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: Constants.oK.localize(), style: UIAlertAction.Style.default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion:nil)
            }
        }
    }
    
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShowForResizing),
                                               name:
            UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHideForResizing),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        } else {
            //debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            //debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
    
    func checkforLocationPermission(){
        if self.isLocationPermissionGranted() == false {
            let alert = UIAlertController(title: appName, message: "Covid Update needs your location to inform the organisation your last location was. Please enable location sharing in settings.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { _ in
                self.openSettingsApp()
            }))
            self.present(alert, animated: true, completion: nil)
        } else{
             self.updateLocationInfo()
        }
    }
    func openSettingsApp(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            // Open settings application to enabling the pemission
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            } else {
                UIApplication.shared.openURL(settingsUrl)
            }
        }
    }
    func isLocationPermissionGranted() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }
    
    func updateLocationInfo() {
         LocationManager.instance.startup()
    }
    
    func addApplicationStateObserver(){
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func removeApplicationStateObserver(){
        NotificationCenter.default.removeObserver(UIApplication.didEnterBackgroundNotification)
         NotificationCenter.default.removeObserver(UIApplication.willEnterForegroundNotification)
    }
    @objc func appMovedToBackground() {
        print("app enters background")
    }

    @objc func appCameToForeground() {
        print("app enters foreground")
         self.checkforLocationPermission()
    }
    //POp two views from navigation controllar
    func backTwoView() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        if viewControllers.count >= 3 {
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name:"SF Pro Text Regular", size: 18)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
//        self.separatorStyle = .singleLine
    }
}
extension UICollectionView{
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name:"SF Pro Text Regular", size: 18)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }

    func restore() {
        self.backgroundView = nil
//        self.separatorStyle = .singleLine
    }
}

extension UIView {
    
    // Set shadow and border to view
    func setShadow() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 3
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func activityStartAnimating() {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
         backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
//        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
//         backgroundView.backgroundColor = UIColor.white.withAlphaComponent(1)
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = borderColorandThemeColor
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
    
    
}

extension UIImage {
    func fitImage(size: CGSize) -> UIImage? {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = min(widthRatio, heightRatio)
        
        let imageWidth = self.size.width * ratio
        let imageHeight = self.size.height * ratio
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width:imageWidth, height:imageHeight), false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
}

extension UITextField {
    // set defualt textfield border color
    func setDefaultBorderColor() {
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    //Set editable textfield border colort
    func setSelectedTextFieldBorderColor() {
        self.layer.borderColor = borderColorandThemeColor.cgColor
        self.layer.borderWidth = 2.0
    }
    //Set editable textfield border colort
    func setSelectedTextFieldErrorColor() {
        self.layer.borderColor = errorBorderColor.cgColor
        self.layer.borderWidth = 2.0
    }
    
    // Set placeholder color and font
    func setPlaceholderFontRegular(){
        
        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = self.placeholder // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:Name ?? "", attributes: [NSAttributedString.Key.font:UIFont(name: "SFProDisplay-Regular", size: 17.0)!]) // Font
//        myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range:NSRange(location:0,length:Name.count))    // Color
        self.attributedPlaceholder = myMutableStringTitle
    }
    // Set placeholder color and font
    func setPlaceholderFontSemiBold(){
        
        var myMutableStringTitle = NSMutableAttributedString()
        let Name  = self.placeholder // PlaceHolderText
        myMutableStringTitle = NSMutableAttributedString(string:Name ?? "", attributes: [NSAttributedString.Key.font:UIFont(name: "SFProDisplay-Semibold", size: 17.0)!]) // Font
        self.attributedPlaceholder = myMutableStringTitle
    }
    //Set the bottom border with gray color code
    func setGrayBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = grayColorCode.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    //Set the bottom border with gray color code
    func setLightGrayBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = lightGrayColorCode.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    //Set the bottom border with blue color code
    func setBlueBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = blueClorCodeForTitles.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    //Left padding for the textfield
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    //Right padding for the textfield
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
//    func addInputViewDatePicker(target: Any, selector: Selector) {
//
//        let screenWidth = UIScreen.main.bounds.width
//
//        //Add DatePicker as inputView
//        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))
//        datePicker.datePickerMode = .date
//        self.inputView = datePicker
//
//        //Add Tool Bar as input AccessoryView
//        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
//        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
//        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
//
//        self.inputAccessoryView = toolBar
//     }
//
//       @objc func cancelPressed() {
//         self.resignFirstResponder()
//       }
    func setInputViewDatePicker(target: Any, selector: Selector) {
            // Create a UIDatePicker object and assign to inputView
            let screenWidth = UIScreen.main.bounds.width
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
            datePicker.datePickerMode = .date //2
            // iOS 14 and above
            if #available(iOS 14, *) {// Added condition for iOS 14
              datePicker.preferredDatePickerStyle = .wheels
              datePicker.sizeToFit()
            }
            self.inputView = datePicker //3
            
            // Create a toolbar and assign it to inputAccessoryView
            let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
            let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: Constants.cancel.localize(), style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: Constants.done.localize(), style: .plain, target: target, action: selector) //7
            toolBar.setItems([cancel, flexible, barButton], animated: false) //8
            self.inputAccessoryView = toolBar //9
        }
        
        @objc func tapCancel() {
            self.resignFirstResponder()
        }
}


//UIButton extension

extension UIButton {
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}


//UIColor extension

extension UIColor{
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    a = CGFloat(1)
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
//MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
    
    class func isiPhoneX() -> Bool {
        if self.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            return true
        }
        else if self.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1792 {
            return true
        }
        else if self.current.userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2688 {
            return true
        }
        return false
    }
    
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        let modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad6,11"  : .iPad5, //aka iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //aka iPad 2018
            "iPad7,6"   : .iPad6,
            //iPad mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            //iPad pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            //AppleTV
            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}
enum ScreenType {
    case unknown
    ///iPhone 5, 5C, 5S, iPod Touch 5g, iPhone SE
    case iPhone5
    ///iPhone 6, iPhone 6s, iPhone 7
    case iPhone6
    ///iPhone 6 Plus, iPhone 6s Plus, iPhone 7 Plus
    case iPhonePlus
    
    case iPhoneX
    case iPhoneXr
    
    var size: CGSize {
        switch self {
        case .unknown: return CGSize.zero
        case .iPhone5: return CGSize(width: 320, height: 568)
        case .iPhone6: return CGSize(width: 375, height: 667)
        case .iPhoneX: return CGSize(width: 375, height: 812)
        case .iPhoneXr: return CGSize(width: 414, height: 896)
        case .iPhonePlus: return CGSize(width: 750, height: 1334)
        }
    }
}
//MARK:- @UIScreen
extension UIScreen {
    //Used to determine device
    var screenType: ScreenType {
        let tmp: [ScreenType] = [.iPhone5, .iPhone6, .iPhonePlus, .iPhoneX, .iPhoneXr]
        let height = appDelegate.window?.frame.size.height //self.bounds.size.height
        #if swift(>=3.0)
        if let idx = tmp.firstIndex(where: { $0.size.height == height }) {
            return tmp[idx]
        }
        #else
        if let idx = tmp.indexOf({ $0.size.height == height }) {
            return tmp[idx]
        }
        #endif
        return .unknown
    }
    
    // Variables to identify devices
    var isPhone5: Bool { return self.screenType == .iPhone5 }
    var isPhone6: Bool { return self.screenType == .iPhone6 }
    var isPhoneX: Bool { return self.screenType == .iPhoneX }
    var isPhoneXr: Bool { return self.screenType == .iPhoneXr }
    var isPhonePlus: Bool { return self.screenType == .iPhonePlus }
    var isPhone6Plus: Bool { return self.isPhonePlus }
    
    
}

//Enum for the device type
public enum Model : String {
    case simulator     = "simulator/sandbox",
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPad5              = "iPad 5", //aka iPad 2017
    iPad6              = "iPad 6", //aka iPad 2018
    //iPad mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    //iPad pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}
//MARK:- @String
extension String {
    
    //use of above extension
    func split(regex pattern: String) -> [String] {
        
        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }
        
        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.components(separatedBy: stop)
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    var isNumber:Bool {
        get {
            let badCharacters = NSCharacterSet.decimalDigits.inverted
            return (self.rangeOfCharacter(from: badCharacters) == nil)
        }
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    static var Empty : String {
        return ""
    }
    
    static func removeNil(_ value : String?) -> String{
        return value ?? String.Empty
    }
    
  
    // Localization
    
    func localize()->String{
        
        return NSLocalizedString(self, bundle: currentBundle, comment: "")
        
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func attributedStringWithColor(_ strings: [String], color:UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
//MARK:- @UITapGestureRecognizer
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension UIFont {
    var bold: UIFont {
        return with(traits: .traitBold)
    } // bold
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    } // italic
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    } // boldItalic
    
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    } // with(traits:)
}

extension UILabel {
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

extension UINavigationController {
    
    func backToViewController(vc: Any) {
          // iterate to find the type of vc
          for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
             }
          }
       }
    
    func removeViewController(_ controller: UIViewController.Type) {
            if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
                viewController.removeFromParent()
            }
        }
}

//Use of above extension
//self.navigationController?.backToViewController(passViewcontroller)

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String, underlineStyle : Int, fontSize : CGFloat) -> NSMutableAttributedString {
        let attrs = [
            NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Bold", size: fontSize)!,
            NSAttributedString.Key.underlineStyle : underlineStyle,
            ] as [NSAttributedString.Key : Any]
//        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "SFProDisplay-Bold", size: 14)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func boldAbout(_ text: String, underlineStyle : Int, fontSize : CGFloat, color: UIColor) -> NSMutableAttributedString {
        let attrs = [
            NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: fontSize)!,
            NSAttributedString.Key.underlineStyle : underlineStyle,
            NSAttributedString.Key.foregroundColor : color
            ] as [NSAttributedString.Key : Any]
        //        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "SFProDisplay-Bold", size: 14)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func underline(term: String) {
        
        guard let underlineRange = string.range(of: term) else {
            
            return
        }
        
        let startPosition = string.distance(from: term.startIndex, to: underlineRange.lowerBound)
        let nsrange = NSRange(location: startPosition, length: term.count)
        
        addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: nsrange)
    }
    
    @discardableResult func normal(_ text: String, fontSize : CGFloat) -> NSMutableAttributedString {
        
        let attrs = [
            NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Regular", size: fontSize)!,
            ] as [NSAttributedString.Key : Any]
        //        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "SFProDisplay-Bold", size: 14)!]
        let normal = NSMutableAttributedString(string:text, attributes: attrs)
//        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
    @discardableResult func normalAbout(_ text: String, color:UIColor) -> NSMutableAttributedString {
        
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}

extension UIImageView {

 public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {

        if self.image == nil{
              self.image = PlaceHolderImage
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }}

