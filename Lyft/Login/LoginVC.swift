//
//  LoginVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import UIKit


class LoginVC: UIViewController, UITextFieldDelegate,CountryPickerTableViewDelegate   {
     //MARK:- @IBOutlet

        @IBOutlet weak var baseView: UIView!
        @IBOutlet weak var mainScrollView: UIScrollView!
        @IBOutlet weak var contentView: UIView!
        @IBOutlet weak var lblEmail: UILabel!
        @IBOutlet weak var lblEmailErrorMessage: UILabel!
        @IBOutlet weak var txtEmail: FormTextField!
        @IBOutlet weak var btnCheckEmail: UIButton!
        @IBOutlet weak var lblPassword: UILabel!
        @IBOutlet weak var lblPasswordErrorMessage: UILabel!
        @IBOutlet weak var txtPasswprd: FormTextField!
        @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var languagChangeButton: UIButton!
    @IBOutlet weak var loginButton: RoundButton!
    @IBOutlet weak var signInButton: UIButton!
    private var selectedLanguage : Language = .arabic {
        didSet{
              setLocalization(language: selectedLanguage)
        }
    }
    //MARK:- Variables
        var counrtycodeForPassing : String!
        var isMobileNumberUse : Bool!
        var lastOffset: CGPoint!
        var eyeIconClick : Bool!
    
    var languageChange = true
    
     //MARK:- View Controller Life Cycle
        override func viewDidLoad() {
            
            super.viewDidLoad()
            setFontAndTextColor()
            lastOffset = self.mainScrollView.contentOffset
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
           
            loadUiOfLogin()
        }
    func loadUiOfLogin(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        customViewStyleMethod()
        eyeIconClick = true
        hideLabel()
        if(txtEmail.text!.isEmpty) {
             btnCheckEmail.isHidden =  true
        }
        txtEmail.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                       for: UIControl.Event.editingChanged)
        
        showPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        showPasswordButton.tintColor = .gray
        
        loginButton.setTitle(Constants.signIn.localize(), for: .normal)
        loginButton.backgroundColor = .black
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            txtEmail.textAlignment = .right
            txtPasswprd.textAlignment = .right
        }else{
            txtEmail.textAlignment = .left
            txtPasswprd.textAlignment = .left
        }
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: Constants.usernameLabelPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtPasswprd.attributedPlaceholder = NSAttributedString(string: Constants.passwordLabelPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        titleLabel.text = Constants.loginTitleLabel.localize()
        
        let forgotAttributedTitle = NSAttributedString(string: Constants.forgotPasswordButton.localize(), attributes:[ .foregroundColor: UIColor.black])
        let signUpAttributedTitle = NSAttributedString(string: Constants.signUpButtonForLogin.localize(), attributes: [ .foregroundColor: UIColor.black])
        
        forgotPasswordButton.setAttributedTitle(forgotAttributedTitle, for: .normal)
        
        skipButton.setTitle(Constants.skip.localize(), for: .normal)
        
        signInButton.setAttributedTitle(signUpAttributedTitle, for: .normal)
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            self.languagChangeButton.setTitle(Constants.english.localize(), for: .normal)
            languageChange = false
        }else{
            self.languagChangeButton.setTitle(Constants.arabic.localize(), for: .normal)
            languageChange = true
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
            self.view.endEditing(true)
        }

        //function for setup the design of the view.
        func customViewStyleMethod()
        {
            baseBackgroundView()
           if( calledFlag == false) {
                isMobileNumberUse = true
            } else {
                isMobileNumberUse = false
                counrtycodeForPassing = defaultCounrtyCode
                txtEmail.setLeftPaddingPoints(15.0)
                txtEmail.setRightPaddingPoints(15.0)
                txtPasswprd.setLeftPaddingPoints(15.0)
                txtPasswprd.setRightPaddingPoints(15.0)
            }
            txtEmail.delegate = self
            txtPasswprd.delegate = self
            self.hideKeyboardWhenTappedAround()
        }
        
        var calledFlag = true
        @objc func textFieldDidChange(_ textField: UITextField) {
            if textField.text?.isEmpty == true {
                self.removeCustomViewInTextFiled(textField)
                calledFlag = true
            } else {
                if(checkForStringStartWithNoOrText(text: (textField.text)!) == true)
                {
                    if(calledFlag ==  true) {
                        if (textField.text?.count)! <= emailMobileTextCharMinCount  {
                            calledFlag = false
                            self.checkTexfieldContainNoOrEmail(txtEmail)
                            let mobileNumberWithCountryCode = countryCodeButton.titleLabel?.text!.components(separatedBy: " ")
                            
                            counrtycodeForPassing = mobileNumberWithCountryCode![1]
                        }
                    }
                         isMobileNumberUse = true
                } else {
                    self.removeCustomViewInTextFiled(textField)
                    isMobileNumberUse = false
                    calledFlag = true
                }
            }
        }
        @objc override func dismissKeyboard() {
//            navigationController?.setNavigationBarHidden(true, animated: false)
            view.endEditing(true)
        }
        func hideLabel(){
            if(txtEmail.text!.isEmpty) {
                lblEmail.isHidden = true
                lblEmailErrorMessage.isHidden = true
                txtEmail.setDefaultBorderColor()
            }
            if(txtPasswprd.text!.isEmpty)
            {
                lblPassword.isHidden = true
                lblPasswordErrorMessage.isHidden = true
                txtPasswprd.setDefaultBorderColor()
            }
        }
        func setFontAndTextColor() {
           
            // Set font and text color
            self.lblEmail.textColor                     = borderColorandThemeColor
            self.lblEmailErrorMessage.textColor         = borderColorandThemeColor
            self.txtEmail.font                          = globalTextFieldFont
            self.txtEmail.textColor                     = textFieldTextColor
            self.lblPassword.textColor                     = borderColorandThemeColor
            self.lblPasswordErrorMessage.textColor         = borderColorandThemeColor
            self.txtPasswprd.font                          = globalTextFieldFont
            self.txtPasswprd.textColor                     = textFieldTextColor
            txtEmail.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
            self.lblEmail.font                          = lblTittleFont
            self.lblEmailErrorMessage.font              = lblTittleFont
            self.lblPassword.font                          = lblTittleFont
            self.lblPasswordErrorMessage.font              = lblTittleFont
            self.txtEmail.setRightPaddingPoints(50)
        }
    //MARK:-  Hide And Show Logo
        func setView(view1: UIView, hidden: Bool) {
            
            if hidden {
            UIView.animate(withDuration: 0.5, animations: {
                if UIScreen.main.screenType == .iPhone5 {
                     self.mainScrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: self.contentView.frame.origin.y - 50)
                } else if UIScreen.main.screenType == .iPhone6 {
                    self.mainScrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: self.contentView.frame.origin.y - 50)
                }
                else if UIScreen.main.screenType == .iPhoneX {
                    
                    let bottomOffset = CGPoint(x: self.lastOffset.x, y: self.contentView.frame.origin.y - 220)
                    self.mainScrollView.setContentOffset(bottomOffset, animated: true)

                }
                else if UIScreen.main.screenType == .iPhoneXr {
                    let bottomOffset = CGPoint(x: self.lastOffset.x, y: self.contentView.frame.origin.y - 220)
                    self.mainScrollView.setContentOffset(bottomOffset, animated: true)
                }
                self.loadViewIfNeeded()

               })
            }else{
                UIView.animate(withDuration: 0.5, animations: {
                    // scroll to the position above keyboard 10 points
                    self.mainScrollView.contentOffset = self.lastOffset
                })
            }
        }
        
        //MARK:- TextFields Delegates
        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.returnKeyType = .next
            
//            if textField == self.txtEmail {
//                self.navigationItem.title = "LYFT"
//                navigationController?.navigationBar.barTintColor = UIColor.black
//                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTittleFont,NSAttributedString.Key.foregroundColor:headerTextYellowColor]
//                self.navigationItem.hidesBackButton = true
//                navigationController?.setNavigationBarHidden(false, animated: false)
//
//            } else if textField == self.txtPasswprd {
//                            self.navigationItem.title = "LYFT"
//                            navigationController?.navigationBar.barTintColor = UIColor.black
//                            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTittleFont,NSAttributedString.Key.foregroundColor:headerTextYellowColor]
//                    self.navigationItem.hidesBackButton = true
//                            navigationController?.setNavigationBarHidden(false, animated: false)
//            }
//            else{
                 textField.setDefaultBorderColor()
//            }
        }
        
        func validateSingleField(textField:UITextField) -> Bool{
           if(textField == txtEmail) {
               if txtEmail.text == ""{
                   lblEmail.isHidden = false
                   lblEmailErrorMessage.isHidden = false
                   lblEmail.textColor = errorBorderColor
                   lblEmailErrorMessage.textColor = errorBorderColor
                   txtEmail.setSelectedTextFieldErrorColor()
                   return false
               }
           } else if(textField == txtPasswprd) {
             if txtPasswprd.text == ""{
              lblPassword.isHidden = false
              lblPasswordErrorMessage.isHidden = false
              lblPassword.textColor = errorBorderColor
              lblPasswordErrorMessage.textColor = errorBorderColor
              txtPasswprd.setSelectedTextFieldErrorColor()
              return false
            }
              
           } else {
              return true
              }
          return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            debugPrint("TextField did end editing method called\(textField.text!)")
            if textField == txtEmail {
                txtEmail.setDefaultBorderColor()
            }else{
                textField.setDefaultBorderColor()
            }
           if validateSingleField(textField: textField) {
                             print("Validated")
            } else {
                             print("Not Validated")
            }
            
//            navigationController?.setNavigationBarHidden(true, animated: false)
            view.endEditing(true)
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            if textField == txtEmail {
                guard let textFieldText = textField.text,
                    let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                        return false
                }
                let substringToReplace = textFieldText[rangeOfTextToReplace]
                let count = textFieldText.count - substringToReplace.count + string.count
                
                if(textField ==  txtEmail) {
                    if (newString.length > 0) {
                        lblEmail.isHidden = false
                        lblEmail.textColor = borderColorandThemeColor
                        txtEmail.setSelectedTextFieldBorderColor()
                        lblEmailErrorMessage.isHidden = true
                    } else {
                        lblEmail.isHidden = true
                        txtEmail.setDefaultBorderColor()
                        //setView(view: mobileNumberLabel, hidden: true)
                    }
                    return count < 40
                }
                if (textField ==  txtEmail) {
                    return newString.length <= maxLength
                } else {
                    let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: newString as String))
                    if(isNumber == true) {
                        return newString.length <= maxLength
                    } else {
                        return true
                    }
                }
            }
                    if textField == txtPasswprd {
                          if(textField ==  txtPasswprd) {
                              if (newString.length > 0) {
                                  showPasswordButton.isHidden = false
                                  lblPassword.isHidden = false
                                  lblPasswordErrorMessage.isHidden = true
                                  txtPasswprd.setSelectedTextFieldBorderColor()
                                  lblPassword.textColor = borderColorandThemeColor
                                  lblPasswordErrorMessage.textColor = borderColorandThemeColor

                              } else {
                                  showPasswordButton.isHidden = true
                                  lblPassword.isHidden = true
                                  lblPasswordErrorMessage.isHidden = true
                                  txtPasswprd.setDefaultBorderColor()
                              }
                          }
                          if (textField ==  txtPasswprd) {
                              return newString.length <= maxLength
                          } else {
                              let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: newString as String))
                              if(isNumber == true)
                              {
                                  return newString.length <= maxLength
                              } else {
                                  return true
                              }
                          }
                      }
            return true
        }


    @IBAction func languagChangeButtonAction(_ sender: Any) {
        languageChange = !languageChange
        if languageChange {
            self.languagChangeButton.setTitle(Constants.arabic.localize(), for: .normal)
            self.changeLangugaeAPICalling(language: .english)
        } else {
            languagChangeButton.setTitle(Constants.english.localize(), for: .normal)
                self.changeLangugaeAPICalling(language: .arabic)
        }
    }
    func changeLangugaeAPICalling(language : Language){
        DispatchQueue.main.async {
            //Navigate to the ResetPassword screen.
            UserDefaults.standard.set(language.code, forKey: klanguage)
            setLocalization(language: language)
            self.selectedLanguage = language
            self.loadView()
            self.loadUiOfLogin()
            guard let transitionView = self.navigationController?.view else {return}
            UIView.beginAnimations("anim", context: nil)
            UIView.setAnimationDuration(0.8)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationTransition(self.selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
            UIView.commitAnimations()
        }
        
//        if Connectivity.isConnectedToInternet {
//
//            let urlString =  kBaseURL + kChangeLanguageAPI;
//            self.view.activityStartAnimating()
//            var param = [String: Any] ()
//                param["lan"]  = language.code
//            self.view.isUserInteractionEnabled = false
//            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
//
//                DispatchQueue.main.async(execute: {() -> Void in
//
//                    self.view.activityStopAnimating()
//
//                    switch response {
//                    case .success(let dictionary as [String: Any]):
//                        if (dictionary["status"] as? Int == 200) {
//                            DispatchQueue.main.async {
//                                //Navigate to the ResetPassword screen.
//                                setLocalization(language: language)
//                                UserDefaults.standard.set(language, forKey: klanguage)
//
//                                guard let transitionView = self.navigationController?.view else {return}
//                                UIView.beginAnimations("anim", context: nil)
//                                UIView.setAnimationDuration(0.8)
//                                UIView.setAnimationCurve(.easeInOut)
//                                UIView.setAnimationTransition(self.selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
//                                UIView.commitAnimations()
//                            }
//                        }else{
//                            self.alert(message: dictionary["message"] as? String ?? "")
//                        }
//                        break
//                    case .failure(let error):
//                        if error.domain == "Timeout" {
//                                //timeout here
//                                self.alert(message: timeOutMessage)
//                          }
//                        else if error.domain == "Network" {
//                            self.alert(message: "Something went wrong, please try again")
//                        }
//                        break
//                    default:
//                        break
//                    }
//                })
//            }
//        }else{
////            self.alert(message: kKeyNoNetworkMessage)
//            self.updateUserInterface()
//        }
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        //code for dirlect landing to homescreen
        UserDefaults.standard.set("true", forKey: skipUserLogin)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: mainHomeForMenuVCSID) as? MainViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func showPasswordButtonAction(_ sender: Any) {
               if(eyeIconClick == true) {
                   txtPasswprd.isSecureTextEntry = false
                   eyeIconClick = false
                    showPasswordButton.setImage(UIImage(named: "ShowPasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                   showPasswordButton.tintColor = .gray
               } else {
                   txtPasswprd.isSecureTextEntry = true
                   eyeIconClick = true
                   showPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                   showPasswordButton.tintColor = .gray
               }
           }
        func didSelectRowSelectedValue(didSelectCountryWithName name: String, code: String, dialCode: String) {
            debugPrint("All details which is seleted",name,code,dialCode)
            counrtycodeForPassing = dialCode
            if(name != "")
            {
                countryCodeButton.setTitle( (code + " " + dialCode), for: .normal)
            }
            txtEmail.becomeFirstResponder()
        }
        
        @IBAction func textFieldEditingChanges(_ sender: FormTextField) {
            print(sender.text!)
            if isValidEmail(emailStr: sender.text!){
                btnCheckEmail.isHidden =  false
                btnCheckEmail.setImage(UIImage(named: "checkArrow")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                btnCheckEmail.tintColor = borderColorandThemeColor
            }else{
                
                 btnCheckEmail.isHidden =  true
            }
        }
        
        func showEmailErrorView()
        {
            txtEmail.setSelectedTextFieldErrorColor()
            lblEmail.isHidden = false
            lblEmail.textColor = borderErrorThemeColor
            lblEmailErrorMessage.isHidden = false
            lblEmailErrorMessage.text = Constants.emailLoginErrorMessage.localize()
            lblEmailErrorMessage.textColor = borderErrorThemeColor
        }
        
         func showPasswordErrorView()
            {
                txtPasswprd.setSelectedTextFieldErrorColor()
                lblPassword.isHidden = false
                lblPassword.textColor = borderErrorThemeColor
                lblPasswordErrorMessage.textColor = borderErrorThemeColor
                lblPasswordErrorMessage.isHidden = false
                lblPasswordErrorMessage.text = Constants.passwordCharLimitErrorMessage.localize()
            }
    
     //MARK:- Custom button Actions
        var flagValidateEmailMobile = false
    
        @IBAction func loginButtonAction(_ sender: Any) {
            lblEmail.isHidden = true
            lblEmailErrorMessage.isHidden = true
            txtEmail.setDefaultBorderColor()
            lblPassword.isHidden = true
            lblPasswordErrorMessage.isHidden = true
            txtPasswprd.setDefaultBorderColor()
            var finalNumber : String  = ""
            if(txtEmail.text!.isEmpty == false)
            {
                if isMobileNumberUse {
                    if isValidMobileNo(mobileNo: txtEmail.text ?? "", countryCode: counrtycodeForPassing ) {
                        //condition to check the database
                        if txtEmail.text!.first == "0" {
                           finalNumber = counrtycodeForPassing + " " + String(txtEmail.text!.dropFirst())
                        }
                        else
                        {
                            finalNumber = counrtycodeForPassing + " " + txtEmail.text!
                        }
                        flagValidateEmailMobile = true
                    }else{
                       // Show the red line error
                         self.showEmailErrorView()
                    }
                }else{
                    if isValidEmailID(txtEmail: txtEmail.text ?? ""){
                             flagValidateEmailMobile = true
                    }else{
                         self.showEmailErrorView()
                    }
            }
            } else {
                self.showEmailErrorView()
                return
            }
            if(txtPasswprd.text!.isEmpty == false) {
                       if(txtPasswprd.text!.count > 5) {
                           if isMobileNumberUse {
                            if txtEmail.text!.first == "0" {
                               finalNumber = counrtycodeForPassing + " " + String(txtEmail.text!.dropFirst())
                            } else {
                                finalNumber = counrtycodeForPassing + " " + txtEmail.text!
                            }
                               //  condition for the moblile and password can validate
                               self.callLoginAPI(emailAndMobileNumber: finalNumber)
                           } else {
                              //  condition for the email and password can validate
                               self.callLoginAPI(emailAndMobileNumber: txtEmail.text!)
                           }
                       } else {
                           self.showPasswordErrorView()
                       }
                   } else {
                       self.showPasswordErrorView()
                   }
        }
    

    //    MARK: - API calling For Login
    func callLoginAPI(emailAndMobileNumber: String){
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + kLoginAPI;
            self.view.activityStartAnimating()
            // declare the parameter as a dictionary that contains string as key and value combination. considering inputs are valid
            var parameters = [String: Any] ()
            parameters["email"]  = emailAndMobileNumber
            parameters["password"]  = txtPasswprd.text!
            self.view.isUserInteractionEnabled = false
            
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: parameters) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    self.view.isUserInteractionEnabled = true
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                                DispatchQueue.main.async {
                                    
                                    if (jsondictionary["reg_completed"] as? String == "0"){
                                        UserDefaults.standard.set(0, forKey: kRegCompleted)
                                    }else{
                                        UserDefaults.standard.set(1, forKey: kRegCompleted)
                                    }
                                    UserDefaults.standard.set("false", forKey: skipUserLogin)
                                    UserDefaults.standard.set(emailAndMobileNumber, forKey: kEmailAndMobile)
                                    UserDefaults.standard.set(self.txtPasswprd.text, forKey: kPassword)
                                    
                                    UserDefaults.standard.set(jsondictionary["token"], forKey: kSessionAccessToken)
                                    //Language Update in Userdefault.
                                    
                                    UserDefaults.standard.set(jsondictionary["email"] as? String, forKey: kEmailLogin)
                                    UserDefaults.standard.set(jsondictionary["fullname"] as? String, forKey: kLoginUserName)
                                    UserDefaults.standard.set(jsondictionary["photo"] as? String, forKey: kUserProfilePicture)
                                    UserDefaults.standard.set(jsondictionary["phonenumber"] as? String, forKey: kMobileNumber)
                                    UserDefaults.standard.set(jsondictionary["membership_id"] as? String ?? "", forKey: memberShipID)
                                    
                                    if (jsondictionary["lan_selection"] as? String) != nil {
                                            UserDefaults.standard.set(jsondictionary["lan_selection"] as? String, forKey: klanguage)
                                                if(jsondictionary["lan_selection"] as? String == "ar"){
                                                    self.selectedLanguage = .arabic
                                                    setLocalization(language: .arabic)
                                                }else{
                                                    self.selectedLanguage = .english
                                                    setLocalization(language: .english)
                                                }
                                        guard let transitionView = self.navigationController?.view else {return}
                                        UIView.beginAnimations("anim", context: nil)
                                        UIView.setAnimationDuration(0.8)
                                        UIView.setAnimationCurve(.easeInOut)
                                        UIView.setAnimationTransition(self.selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
                                        UIView.commitAnimations()
                                        
                                           }else {
                                               UserDefaults.standard.set("en", forKey: klanguage)
                                           }
                                  
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: mainHomeForMenuVCSID) as? MainViewController
                                self.navigationController?.pushViewController(vc!, animated: true)
                                }
                        }else{
                            self.alert(message: dictionary["message"] as? String ?? "")
                        }
                        break
                    case .failure(let error):
                        if error.domain == "Timeout" {
                            self.alert(message: Constants.timeOutMessage.localize())
                        }
                        break
                    default:
                        break
                    }
                })
            }
        }else{
            self.updateUserInterface()
        }
    }
    }
