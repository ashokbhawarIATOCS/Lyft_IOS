//
//  ResetPasswordVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import UIKit
//import Firebase

class ResetPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterOTPTextfield: FormTextField!
    @IBOutlet weak var txtNewPassword: FormTextField!
    @IBOutlet weak var txtConfirmPassword: FormTextField!
      @IBOutlet weak var showNewPasswordButton: UIButton!
      @IBOutlet weak var showConfirmPasswordButton: UIButton!
    @IBOutlet weak var resetButton: CustomButtonDesign!
    @IBOutlet weak var enterOTPLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var resetPassworderTitleLabel: UILabel!
    @IBOutlet weak var resetPassworderSubTitleLabel: UILabel!
    
    var otpString : Int?
    var strMobileorEmail : String?
    var strUserID : String?
    
    //Handling Eye button
    var eyeNewIconClick : Bool!
    var eyeConfirmIconClick : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPassworderTitleLabel.text = Constants.resetPasswordTitleLabel.localize()
        resetPassworderSubTitleLabel.text = Constants.resetPasswordSubTitleLabel.localize()
        resetButton.setTitle(Constants.saveChangesButton.localize(), for: .normal)
        
        enterOTPLabel.text = Constants.enterOTP.localize()
        newPasswordLabel.text = Constants.newPasswordLabel.localize()
        confirmPasswordLabel.text = Constants.confirmPasswordLabel.localize()

        txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: Constants.confirmPasswordLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtNewPassword.attributedPlaceholder = NSAttributedString(string: Constants.newPasswordLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        enterOTPTextfield.attributedPlaceholder = NSAttributedString(string: Constants.enterOTP.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            txtConfirmPassword.textAlignment = .right
            txtNewPassword.textAlignment = .right
            enterOTPTextfield.textAlignment = .right
        }else{
            enterOTPTextfield.textAlignment = .left
            txtNewPassword.textAlignment = .left
            txtConfirmPassword.textAlignment = .left
        }
        
        baseBackgroundView()
        showNewPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        showNewPasswordButton.tintColor = .gray
        
        showConfirmPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        showConfirmPasswordButton.tintColor = .gray
        
        // Do any additional setup after loading the view.
        txtNewPassword.setLeftPaddingPoints(15.0)
        txtNewPassword.setRightPaddingPoints(15.0)
        enterOTPTextfield.setLeftPaddingPoints(15.0)
        enterOTPTextfield.setRightPaddingPoints(15.0)
        txtConfirmPassword.setLeftPaddingPoints(15.0)
        txtConfirmPassword.setRightPaddingPoints(15.0)
        
        enterOTPLabel.isHidden = true
        newPasswordLabel.isHidden = true
        confirmPasswordLabel.isHidden = true
        
        self.enterOTPLabel.textColor = borderColorandThemeColor
        self.newPasswordLabel.textColor = borderColorandThemeColor
        self.confirmPasswordLabel.textColor = borderColorandThemeColor
        
        enterOTPTextfield.setDefaultBorderColor()
        txtNewPassword.setDefaultBorderColor()
        txtConfirmPassword.setDefaultBorderColor()
        self.hideKeyboardWhenTappedAround()
        // set the default value of eye icon
        eyeNewIconClick = true
        eyeConfirmIconClick = true

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.dismissKeyboard()
        self.txtConfirmPassword.isSecureTextEntry = true
        self.txtNewPassword.isSecureTextEntry = true
        
        showNewPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        showNewPasswordButton.tintColor = .gray
        
        showConfirmPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        showConfirmPasswordButton.tintColor = .gray
        
        //New method for internet handling
        NotificationCenter.default.removeObserver(self, name: .flagsChanged, object: nil)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //New method for internet handling
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
    }
    
    // MARK: - TextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //debugPrint("TextField should begin editing method called")
        self.enterOTPLabel.textColor = borderColorandThemeColor
        self.newPasswordLabel.textColor = borderColorandThemeColor
        self.confirmPasswordLabel.textColor = borderColorandThemeColor
        if (textField ==  txtNewPassword) {
            txtNewPassword.setSelectedTextFieldBorderColor()
            txtConfirmPassword.setDefaultBorderColor()
            enterOTPTextfield.setDefaultBorderColor()
            newPasswordLabel.isHidden = false
        } else if (textField ==  enterOTPTextfield) {
            
            txtNewPassword.setDefaultBorderColor()
            txtConfirmPassword.setDefaultBorderColor()
            enterOTPTextfield.setSelectedTextFieldBorderColor()
            enterOTPLabel.isHidden = false
        }
        else
        {
            txtNewPassword.setDefaultBorderColor()
            txtConfirmPassword.setSelectedTextFieldBorderColor()
            enterOTPTextfield.setDefaultBorderColor()
            confirmPasswordLabel.isHidden = false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if (textField ==  txtNewPassword) {
            if(txtNewPassword.text!.count > 0){
                newPasswordLabel.isHidden = false
            }else{
                newPasswordLabel.isHidden = true
            }
            txtNewPassword.setDefaultBorderColor()
        } else if (textField ==  enterOTPTextfield) {
            
            if(enterOTPTextfield.text!.count > 0){
                enterOTPLabel.isHidden = false
            }else{
                enterOTPLabel.isHidden = true
            }
            enterOTPTextfield.setDefaultBorderColor()
        }
        else
        {
            if(txtConfirmPassword.text!.count > 0){
                confirmPasswordLabel.isHidden = false
            }else{
                confirmPasswordLabel.isHidden = true
            }
            txtConfirmPassword.setDefaultBorderColor()
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        if isValidPassword(txtPass: txtNewPassword.text ?? ""){
            if txtNewPassword.text == txtConfirmPassword.text ?? "" {
                callResetPasswordAPI()
            }else{
                self.alert(message: kKeyPasswordNotMatchMessage)
            }
        }else{
             if(enterOTPTextfield.text==""){
                self.alert(message: kKeyEmptyResetOTP)
                 enterOTPTextfield.setSelectedTextFieldErrorColor()
                 enterOTPLabel.isHidden = false
                 enterOTPLabel.textColor = borderErrorThemeColor
            }
            else if(txtNewPassword.text=="")
            {
                self.alert(message: kKeyEmptyPassword)
                txtNewPassword.setSelectedTextFieldErrorColor()
                newPasswordLabel.isHidden = false
                newPasswordLabel.textColor = borderErrorThemeColor
            }
            else
            {
                self.alert(message: kKeyEmptyPasswordMessage)
                txtConfirmPassword.setSelectedTextFieldErrorColor()
                confirmPasswordLabel.isHidden = false
                confirmPasswordLabel.textColor = borderErrorThemeColor
            }
        }
        
    }
    
    // showPasswordButtonAction method.
    @IBAction func showNewPasswordButtonAction(_ sender: Any) {
        // if the button was selected, then deselect it.
        // otherwise if it was not selected, then select it.
        if(eyeNewIconClick == true) {
            //show password in the textfield box
            txtNewPassword.isSecureTextEntry = false
            eyeNewIconClick = false
            showNewPasswordButton.setImage(UIImage(named: "ShowPasswordIcon"), for: .normal)
        } else {
            //Hide password in the textfield box
            txtNewPassword.isSecureTextEntry = true
            eyeNewIconClick = true
            showNewPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            showNewPasswordButton.tintColor = .gray
        }
    }
    
    
    // showPasswordButtonAction method.
    @IBAction func showConfirmPasswordButtonAction(_ sender: Any) {
        // if the button was selected, then deselect it.
        // otherwise if it was not selected, then select it.
        if(eyeConfirmIconClick == true) {
            //show password in the textfield box
            txtConfirmPassword.isSecureTextEntry = false
            eyeConfirmIconClick = false
            showConfirmPasswordButton.setImage(UIImage(named: "ShowPasswordIcon"), for: .normal)
        } else {
            //Hide password in the textfield box
            txtConfirmPassword.isSecureTextEntry = true
            eyeConfirmIconClick = true
            showConfirmPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            showConfirmPasswordButton.tintColor = .gray
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - API call
    func callResetPasswordAPI() {
        if Connectivity.isConnectedToInternet {
            let urlString =  kBaseURL + kResetPassordAPI;
            self.view.activityStartAnimating()
            var param = [String: Any] ()
            param["password"]  = txtNewPassword.text ?? ""
            param["email"]  = strMobileorEmail
            param["otp"]  = enterOTPTextfield.text ?? ""

            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            DispatchQueue.main.async {
                                //Navigate to the Explorer screen.
                                let vc = kMainStoryboard.instantiateViewController(withIdentifier: passwordChangeSubmitScreenSID) as? PasswordChangedVC
                                    vc?.newPassword =  self.txtConfirmPassword.text
                                vc?.userEmailId = self.strMobileorEmail!
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
