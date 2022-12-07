//
//  VerifyAccountVC.swift
//  ClinTrial
//
//  Created by Ideaqu on 18/02/19.
//  Copyright © 2019 Ideaqu. All rights reserved.
//

import UIKit
import Firebase

class VerifyAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtSixdigitCode: FormTextField!
    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var digitLabel: UILabel!
    @IBOutlet weak var confirmButton: CustomButtonDesign!
    @IBOutlet weak var verifyAccountTitleLabel: UILabel!
    @IBOutlet weak var verifyAccountSubTitleLabel: UILabel!
    
    var strUserID : String?
    var strMobileorEmail : String?
    var otpString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        digitLabel.text = Constants.sixDigitCodelabel.localize()
        
        verifyAccountTitleLabel.text = Constants.verifyAccountTitleLabel.localize()
        verifyAccountSubTitleLabel.text = Constants.verifyAccountSubTitleLabel.localize()
        
        txtSixdigitCode.attributedPlaceholder = NSAttributedString(string: Constants.verifyAccountTextPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        confirmButton.setTitle(Constants.capConfirmButton.localize(), for: .normal)
        let resendAttributedTitle = NSAttributedString(string: Constants.resendButton.localize(), attributes:[.underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.gray])
        resendCodeButton.setAttributedTitle(resendAttributedTitle, for: .normal)
        baseBackgroundView()
        digitLabel.isHidden = true
        txtSixdigitCode.setDefaultBorderColor()
        txtSixdigitCode.setLeftPaddingPoints(15.0)
        txtSixdigitCode.setRightPaddingPoints(15.0)
        self.hideKeyboardWhenTappedAround()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
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
        txtSixdigitCode.setDefaultBorderColor()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if(txtSixdigitCode.text!.count > 0){
            digitLabel.isHidden = false
        }else{
            digitLabel.isHidden = true
        }
        
         txtSixdigitCode.setDefaultBorderColor()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // set bottom border color to blue
        digitLabel.isHidden = false
        txtSixdigitCode.setSelectedTextFieldBorderColor()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtSixdigitCode {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 6
        }else{
            return true
        }
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if txtSixdigitCode.text != "" {
            callVerifyOTPAPI()
        }
        else
        {
            alert(message: kKeyEmptyVerifyAccountMessage)
        }
    }
    
    // backButtonAction method.
    @IBAction func backButtonAction(_ sender: Any) {
        //set the back navigation
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendCodeButtonAction(_ sender: Any) {
        callResendAPI()
    }
    // MARK: - API call
    
    func callVerifyOTPAPI() {
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + kVerifyOTPAPI;
            self.view.activityStartAnimating()
            var param = [String: Any] ()
            
            param["otp"]  = txtSixdigitCode.text ?? ""
            param["userid"]  = strUserID
            
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            DispatchQueue.main.async {
//                                    //Navigate to the ResetPassword screen.
//                                    let vc = kMainStoryboard.instantiateViewController(withIdentifier: resetPasswordScreenSID) as? ResetPasswordVC
//                                    vc?.strMobileorEmail = self.strMobileorEmail!
//                                    vc?.otpString = self.txtSixdigitCode.text ?? ""
//                                    self.navigationController?.pushViewController(vc!, animated: true)
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
    
    //MARK: - Login API call
    
    func callResendAPI() {
        if Connectivity.isConnectedToInternet {
            
            var urlString : String!
            urlString =  kBaseURL + kResendAPI
            
            self.view.activityStartAnimating()
            var param = [String: Any] ()
            param["userid"] = strUserID
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            
                            self.alert(message: dictionary["message"] as! String)
                            
                            DispatchQueue.main.async {
                                self.resendCodeButton.titleLabel?.textColor = blueClorCodeForTitles
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
            //self.alert(message: kKeyNoNetworkMessage)
            self.updateUserInterface()
        }
    }
}
