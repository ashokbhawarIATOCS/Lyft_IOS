//
//  ImageUploadAndDetails.swift
//  Lyft
//
//  Created by Diwakar Garg on 03/12/22.
//

import UIKit

class ImageUploadAndDetails: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var uploadTitleLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var declarationTextView: UITextView!
    @IBOutlet weak var parentDOBLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var checkBoxImageView: UIImageView!

    @IBOutlet weak var uploadButton: RoundButton!
    @IBOutlet weak var backButton: RoundButton!
    @IBOutlet weak var submitButton: RoundButton!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var txtParentDOB: FormTextField!
    var selectedParResultDictionary  =  Dictionary<String, Int>()
    var cameFromScreen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uploadButton.setTitle(Constants.uploadButton.localize(), for: .normal)
        submitButton.setTitle(Constants.submit.localize(), for: .normal)
        backButton.setTitle(Constants.backButtonTitle.localize(), for: .normal)
        parentDOBLabel.text = Constants.parentDOBLabel.localize()
        uploadTitleLabel.text = Constants.uploadPhoto.localize()
        stepLabel.text = Constants.step3of3.localize()
        profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            txtParentDOB.textAlignment = .right
            declarationTextView.text = consentData["sentence_ar"] as? String
        }else{
            txtParentDOB.textAlignment = .left
            declarationTextView.text = consentData["sentence_en"] as? String
          
        }
        
        let text = NSMutableAttributedString(string:  declarationTextView.text)
        text.addAttribute(NSAttributedString.Key.font,
                                 value: UIFont.systemFont(ofSize: 15),
                                 range: NSRange(location: 0, length: text.length))
               
        let interactableText = NSMutableAttributedString(string: Constants.viewConsent.localize())
        interactableText.addAttribute(NSAttributedString.Key.font,
                                             value: UIFont.systemFont(ofSize: 15),
                                             range: NSRange(location: 0, length: interactableText.length))
               
               // Adding the link interaction to the interactable text
        interactableText.addAttribute(NSAttributedString.Key.link,
                                             value: "ViewConsentLink",
                                             range: NSRange(location: 0, length: interactableText.length))
               
               // Adding it all together
               text.append(interactableText)
               
               // Set the text view to contain the attributed text
        declarationTextView.attributedText = text
               
               // Disable editing, but enable selectable so that the link can be selected
        declarationTextView.isEditable = false
        declarationTextView.isSelectable = true
        declarationTextView.delegate = self
        txtParentDOB.delegate = self
        txtParentDOB.setLeftPaddingPoints(15.0)
        txtParentDOB.setRightPaddingPoints(5)
        self.txtParentDOB.font = globalTextFieldFont
        self.txtParentDOB.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
        checkBoxImageView.tintColor = borderColorandThemeColor
        checkBoxImageView.image = (#imageLiteral(resourceName: "emptyCheckBox")).withRenderingMode(.alwaysTemplate)
        submitButton.isUserInteractionEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func tapDone() {
            if let datePicker = self.txtParentDOB.inputView as? UIDatePicker { // 2-1
                let dateformatter = DateFormatter() // 2-2
                dateformatter.dateStyle = .medium // 2-3
                dateformatter.dateFormat = "yyyy-MM-dd"
                self.txtParentDOB.text = dateformatter.string(from: datePicker.date) //2-4
            }
      
        txtParentDOB.setSelectedTextFieldBorderColor()
        self.txtParentDOB.resignFirstResponder() // 2-5
        }
    
    
    @IBAction func uploadButtonAction(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            self.profileImageView.image = image
            }
    }
    
    @IBAction func backBuutonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBoxButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkBoxImageView.tintColor = borderColorandThemeColor
        checkBoxImageView.image = (sender.isSelected ? #imageLiteral(resourceName: "checked") : #imageLiteral(resourceName: "emptyCheckBox")).withRenderingMode(.alwaysTemplate)
        
            if sender.isSelected {
                submitButton.isUserInteractionEnabled = true
            } else {
                submitButton.isUserInteractionEnabled = false
            }
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        //call the api for teh Par and Image upload
        self.updateCompleteProfileDetailsAPI()
    }

    //MARK TextviewDelegateMethod
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        //present the pop for consent details view
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: consentDetailsVCSID) as? ConsentDetailsVC
        vc?.modalPresentationStyle = .popover
        present(vc!, animated: true, completion: nil)
           return false
       }
    //MARK textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        debugPrint("While entering the characters this method gets called")
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if textField == txtParentDOB {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtParentDOB) {
                if (newString.length > 0) {
                    txtParentDOB.setSelectedTextFieldBorderColor()
                    
                } else {
                    txtParentDOB.setDefaultBorderColor()
                }
                return count < 40
            }
        }
        return true
    }
    
    func updateCompleteProfileDetailsAPI(){
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + completedProfileAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            
            param["photo"]  =  convertImageToBase64String(img: self.profileImageView.image!)
            param["parents_dob"]  =  txtParentDOB.text
            param["is_accepted_tac"] = 1
            param["par"] = self.selectedParResultDictionary
            
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            
                            UserDefaults.standard.set(jsondictionary["userid"], forKey: kUserId)
                            UserDefaults.standard.set(jsondictionary["email_verified"] as? Int, forKey: kEmailVerified)
                            UserDefaults.standard.set(jsondictionary["photo "] as? String, forKey: kUserProfilePicture)
                            UserDefaults.standard.set(jsondictionary["reg_completed"] as? Int, forKey: kRegCompleted)
                            NotificationCenter.default.post(name: Notification.Name("loadProfileImageOnUpdate"), object: nil)
                            DispatchQueue.main.async {
                                //handle the naviagation to home screen
                                _ = self.navigationController?.backToViewController(vc: HomeVC.self)
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
