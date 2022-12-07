//
//  ForgotPasswordVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import UIKit
//import Firebase
class ForgotPasswordVC: UIViewController,UITextFieldDelegate,CountryPickerTableViewDelegate {
    
    @IBOutlet weak var emailMobileTextField: FormTextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitRequestButton: CustomButtonDesign!
    @IBOutlet weak var forgotPasswordTitleLabel: UILabel!
    @IBOutlet weak var forgotPasswordSubTitleLabel: UILabel!
    //check MobileNumber/Email used for send otp
    var isMobileNumberUse : Bool!
    var counrtycodeForPassing : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            emailMobileTextField.textAlignment = .right
        }else{
            emailMobileTextField.textAlignment = .left
           
        }
        forgotPasswordTitleLabel.text = Constants.forgotPasswordTitleLabel.localize()
        forgotPasswordSubTitleLabel.text = Constants.forgotPasswordSubTitleLabel.localize()
        emailLabel.text = Constants.emailLabel.localize()
        
        emailMobileTextField.attributedPlaceholder = NSAttributedString(string: Constants.enterEmailPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        
        submitRequestButton.setTitle(Constants.sbumitButton.localize(), for: .normal)
        isMobileNumberUse = false
        setupViewResizerOnKeyboardShown()
        // Do any additional setup after loading the view.
         counrtycodeForPassing = defaultCounrtyCode
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.customViewStyleMethod()
        emailMobileTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                       for: UIControl.Event.editingChanged)
        //New method for internet handling
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        //New method for internet handling
        NotificationCenter.default.removeObserver(self, name: .flagsChanged, object: nil)
    }
    
    //function for setup the design of the view.
    func customViewStyleMethod()
    {
        baseBackgroundView()
        //set the bottom border of the textfield
        emailMobileTextField.setLeftPaddingPoints(15.0)
        emailMobileTextField.setRightPaddingPoints(15.0)
        emailMobileTextField.setDefaultBorderColor()
        
        self.emailLabel.textColor = borderColorandThemeColor
        //Set the delegate
        emailMobileTextField.delegate =  self
        //launch the keybord on view show
        emailMobileTextField.becomeFirstResponder()
        // Hide the keybord when touch out side the text field.
        self.hideKeyboardWhenTappedAround()
    }
    
    // backButtonAction method.
    @IBAction func backButtonAction(_ sender: Any) {
        //set the back navigation
       _ = navigationController?.popViewController(animated: true)
    }
    
    //Text Field Delegate method Handling
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        emailLabel.isHidden = false
        self.emailLabel.textColor = borderColorandThemeColor
        emailMobileTextField.setSelectedTextFieldBorderColor()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
            emailMobileTextField.setDefaultBorderColor()
        if(emailMobileTextField.text!.count > 0){
            emailLabel.isHidden = false
        }else{
            emailLabel.isHidden = true
        }
    }
    
    var calledFlag = true
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.isEmpty == true
        {
            self.removeCustomViewInTextFiled(textField)
            calledFlag = true
        }
        else
        {
                isMobileNumberUse = false
                self.removeCustomViewInTextFiled(textField)
                calledFlag = true
        }
    }
    
    //delegate method call for the county picker list
    func didSelectRowSelectedValue(didSelectCountryWithName name: String, code: String, dialCode: String) {
        //debugPrint("All details which is seleted",name,code,dialCode)
        counrtycodeForPassing = dialCode
        if(name != "")
        {
            countryCodeButton.setTitle( (code + " " + dialCode), for: .normal)
        }
        //launch the keybord on view show
        emailMobileTextField.becomeFirstResponder()
    }

    @IBAction func submitBtnAction(_ sender: Any) {
        if emailMobileTextField.text == "" {
            emailMobileTextField.setSelectedTextFieldErrorColor()
            emailLabel.isHidden = false
            emailLabel.textColor = borderErrorThemeColor
            self.alert(message: kKeyEmptyEmailMobileMessage)
        }else{
                if isValidEmailID(txtEmail: emailMobileTextField.text ?? ""){
                    callForgotPasswordAPI()
                }else{
                    emailMobileTextField.setSelectedTextFieldErrorColor()
                    emailLabel.isHidden = false
                    emailLabel.textColor = borderErrorThemeColor
                    self.alert(message: kKeyvalidEmailMessage)
                }
        }
    }
    
    //MARK: - Login API call
    
    func callForgotPasswordAPI() {

        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + kForgotPasswordAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            param["email"]  = self.emailMobileTextField.text
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            
                            DispatchQueue.main.async {
                                //Navigate to the ResetPassword screen.
                                let vc = kMainStoryboard.instantiateViewController(withIdentifier: resetPasswordScreenSID) as? ResetPasswordVC
                                if self.isMobileNumberUse {
                                    vc?.strMobileorEmail = "\(self.counrtycodeForPassing!) \(self.emailMobileTextField.text!)"
                                }else
                                  {
                                      vc?.strMobileorEmail = self.emailMobileTextField.text
                                }
                                vc?.strUserID = jsondictionary["userid"] as? String
                                vc?.otpString = jsondictionary["otp"] as? Int
                                vc?.strMobileorEmail = self.emailMobileTextField.text
                                self.navigationController?.pushViewController(vc!, animated: true)
                            }
                        }else{
                            self.alert(message: dictionary["message"] as? String ?? "")
                        }
                        break
                    case .failure(let error):
                        if error.domain == "Timeout" {
                                //timeout here
                                self.alert(message: Constants.timeOutMessage.localize())
                          }
                        else if error.domain == "Network" {
                            self.alert(message: Constants.somethingWentWrong.localize())
                        }
                        break
                    default:
                        break
                    }
                })
            }
        }else{
//            self.alert(message: kKeyNoNetworkMessage)
            self.updateUserInterface()
        }
    }
}
