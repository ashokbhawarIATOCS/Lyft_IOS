//
//  ChangePasswordVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 09/11/22.
//

import UIKit

class ChangePasswordVC: UIViewController,  UITextFieldDelegate {
    
    @IBOutlet weak var enterOldPasswordTextfield: FormTextField!
    @IBOutlet weak var txtNewPassword: FormTextField!
    @IBOutlet weak var txtConfirmPassword: FormTextField!
    @IBOutlet weak var showOLDPasswordButton: UIButton!
    @IBOutlet weak var showNewPasswordButton: UIButton!
    @IBOutlet weak var showConfirmPasswordButton: UIButton!
    
    @IBOutlet weak var saveChangesButton: CustomButtonDesign!
    @IBOutlet weak var enterOldPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var changePasswordTitleLabel: UILabel!
    @IBOutlet weak var changePasswordSubTitleLabel: UILabel!
    //Handling Eye button
    var eyeOldIconClick : Bool!
    var eyeNewIconClick : Bool!
    var eyeConfirmIconClick : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            txtConfirmPassword.textAlignment = .right
            txtNewPassword.textAlignment = .right
            enterOldPasswordTextfield.textAlignment = .right
        }else{
            
            enterOldPasswordTextfield.textAlignment = .left
            txtNewPassword.textAlignment = .left
            txtConfirmPassword.textAlignment = .left
        }
        enterOldPasswordLabel.text = Constants.enterOldPasswordLabel.localize()
        newPasswordLabel.text = Constants.newPasswordLabel.localize()
        confirmPasswordLabel.text = Constants.confirmPasswordLabel.localize()
        changePasswordTitleLabel.text = Constants.changePasswordTitleLabel.localize()
        changePasswordSubTitleLabel.text = Constants.changePasswordSubTitleLabel.localize()
        
        txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: Constants.confirmPasswordLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtNewPassword.attributedPlaceholder = NSAttributedString(string: Constants.newPasswordLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        enterOldPasswordTextfield.attributedPlaceholder = NSAttributedString(string: Constants.enterOldPasswordLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
      
        saveChangesButton.setTitle(Constants.saveChangesButton.localize(), for: .normal)
        baseBackgroundView()
        showNewPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        showNewPasswordButton.tintColor = .gray
        
        showConfirmPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        showConfirmPasswordButton.tintColor = .gray
        
        showOLDPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        showOLDPasswordButton.tintColor = .gray
        
        // Do any additional setup after loading the view.
        txtNewPassword.setLeftPaddingPoints(15.0)
        txtNewPassword.setRightPaddingPoints(15.0)
        enterOldPasswordTextfield.setLeftPaddingPoints(15.0)
        enterOldPasswordTextfield.setRightPaddingPoints(15.0)
        txtConfirmPassword.setLeftPaddingPoints(15.0)
        txtConfirmPassword.setRightPaddingPoints(15.0)
        
        self.enterOldPasswordLabel.textColor = borderColorandThemeColor
        self.newPasswordLabel.textColor = borderColorandThemeColor
        self.confirmPasswordLabel.textColor = borderColorandThemeColor
        
        enterOldPasswordLabel.isHidden = true
        newPasswordLabel.isHidden = true
        confirmPasswordLabel.isHidden = true
        
        enterOldPasswordTextfield.setDefaultBorderColor()
        txtNewPassword.setDefaultBorderColor()
        txtConfirmPassword.setDefaultBorderColor()
        
        self.hideKeyboardWhenTappedAround()
        // set the default value of eye icon
        eyeNewIconClick = true
        eyeConfirmIconClick = true
        eyeOldIconClick = true

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
        if (textField ==  txtNewPassword) {
            txtNewPassword.setSelectedTextFieldBorderColor()
            txtConfirmPassword.setDefaultBorderColor()
            enterOldPasswordTextfield.setDefaultBorderColor()
            newPasswordLabel.isHidden = false
        } else if (textField ==  enterOldPasswordTextfield) {
            
            txtNewPassword.setDefaultBorderColor()
            txtConfirmPassword.setDefaultBorderColor()
            enterOldPasswordTextfield.setSelectedTextFieldBorderColor()
            enterOldPasswordLabel.isHidden = false
        }
        else
        {
            txtNewPassword.setDefaultBorderColor()
            txtConfirmPassword.setSelectedTextFieldBorderColor()
            enterOldPasswordTextfield.setDefaultBorderColor()
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
        } else if (textField ==  enterOldPasswordTextfield) {
            
            if(enterOldPasswordTextfield.text!.count > 0){
                enterOldPasswordLabel.isHidden = false
            }else{
                enterOldPasswordLabel.isHidden = true
            }
            enterOldPasswordTextfield.setDefaultBorderColor()
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
    
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        if isValidPassword(txtPass: txtNewPassword.text ?? ""){
            if txtNewPassword.text == txtConfirmPassword.text ?? "" {
                callResetPasswordAPI()
            }else{
                self.alert(message: kKeyPasswordNotMatchMessage)
            }
        }else{
            if(txtNewPassword.text=="")
            {
                self.alert(message: kKeyEmptyPassword)
            }
            else
            {
                self.alert(message: kKeyEmptyPasswordMessage)
            }
            
        }
        
    }
    
    // showPasswordButtonAction method.
    @IBAction func showOldPasswordButtonAction(_ sender: Any) {
        // if the button was selected, then deselect it.
        // otherwise if it was not selected, then select it.
        if(eyeOldIconClick == true) {
            //show password in the textfield box
            enterOldPasswordTextfield.isSecureTextEntry = false
            eyeOldIconClick = false
            showOLDPasswordButton.setImage(UIImage(named: "ShowPasswordIcon"), for: .normal)
        } else {
            //Hide password in the textfield box
            enterOldPasswordTextfield.isSecureTextEntry = true
            eyeOldIconClick = true
            showOLDPasswordButton.setImage(UIImage(named: "hidePasswordIcon")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
            showOLDPasswordButton.tintColor = .gray
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
            let urlString =  kBaseURL + kChangePassordAPI;
            self.view.activityStartAnimating()
            var param = [String: Any] ()
            param["old_password"]  = enterOldPasswordTextfield.text ?? ""
            param["password"]  = txtNewPassword.text ?? ""
            param["confirm_password"]  = txtConfirmPassword.text ?? ""

            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            DispatchQueue.main.async {
                                //Navigate to the Explorer screen.
                                
                                let dialogMessage = UIAlertController(title: "Alert", message: "Your password is successfully updated", preferredStyle: .alert)
                                // Create OK button with action handler
                                let ok = UIAlertAction(title: Constants.oK.localize(), style: .default, handler: { (action) -> Void in
                                    //code for the navigation to setting VC and Update the password field.
                                    UserDefaults.standard.set(self.txtNewPassword.text, forKey: kPassword)
                                    _ = self.navigationController?.popViewController(animated: true)
                                })

                                //Add OK button to dialog message
                                dialogMessage.addAction(ok)

                                // Present dialog message to user
                                self.present(dialogMessage, animated: true, completion: nil)
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
            self.updateUserInterface()
        }
    }

}
