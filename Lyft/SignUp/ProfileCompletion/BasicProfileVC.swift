//
//  BasicProfileVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 03/12/22.
//

import UIKit

class BasicProfileVC : UIViewController,UITextFieldDelegate,CountryPickerTableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
//    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var txtFirstName: FormTextField!
    @IBOutlet weak var lblFirstNameErrorMsg: UILabel!
    @IBOutlet weak var btnFirstNameCheck: UIButton!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var txtLastName: FormTextField!
    @IBOutlet weak var lblLastNameErrorMsg: UILabel!
    @IBOutlet weak var btnLastNameCheck: UIButton!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var txtMobile: FormTextField!
    @IBOutlet weak var lblMobileErrorMsg: UILabel!
    @IBOutlet weak var btnMobileCheck: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: FormTextField!
    @IBOutlet weak var lblEmailErrorMsg: UILabel!
    @IBOutlet weak var btnEmailCheck: UIButton!
    
    @IBOutlet weak var lblEmergencyPhoneNumber: UILabel!
    @IBOutlet weak var txtEmergencyPhoneNumber: FormTextField!
    @IBOutlet weak var lblEmergencyPhoneNumberErrorMsg: UILabel!
    @IBOutlet weak var btnEmergencyPhoneNumberCheck: UIButton!
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var txtCity: FormTextField!
    @IBOutlet weak var lblCityErrorMsg: UILabel!
    
    @IBOutlet weak var lblNationalId: UILabel!
    @IBOutlet weak var txtNationalId: FormTextField!
    @IBOutlet weak var lblNationalIdErrorMsg: UILabel!
    
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var txtGender: FormTextField!
//    @IBOutlet weak var lblGenderErrorMsg: UILabel!
    
    @IBOutlet weak var lblMaritalStatus: UILabel!
    @IBOutlet weak var txtMaritalStatus: FormTextField!
//    @IBOutlet weak var lblMaritalStatusErrorMsg: UILabel!
    
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var txtOccupation: FormTextField!
//    @IBOutlet weak var lblOccupationErrorMsg: UILabel!
    
    @IBOutlet weak var lblEnterDOB: UILabel!
    @IBOutlet weak var txtEnterDOB: FormTextField!
//    @IBOutlet weak var lblEnterDOBErrorMsg: UILabel!
    
    @IBOutlet weak var btnNext: RoundButton!
    @IBOutlet weak var basicInformationTitleLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    
    var profileDetails = [String:Any]()
    var counrtycodeForPassing : String!
    var isMobileNumberUse : Bool!
    var passwordString: String?
    var confirmPasswordString: String?
    var cameFromScreen = ""

    var pickerView: UIPickerView! = UIPickerView()
    var genderList = [Constants.male.localize(), Constants.female.localize()]
    var maritalList = [Constants.married.localize(), Constants.unMarried.localize()]
    var occupationList = [Constants.artist.localize(), Constants.civil.localize(), Constants.designers.localize(), Constants.engineering.localize(), Constants.entrepreneur.localize(), Constants.legal.localize(), Constants.management.localize(), Constants.medical.localize(), Constants.student.localize(), Constants.other.localize()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        setFontAndTextColor()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        updateLocationInfo()
        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.isNavigationBarHidden = true
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.isNavigationBarHidden = false
        }
        
        callingBasicProfileAPI()
        self.navigationItem.title = Constants.basicInformationTitle.localize()
        hideLable()
        //Hide Keybord
        baseBackgroundView()
        customViewStyleMethod()
        // TextField Delegate
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtMobile.delegate = self
        txtEmergencyPhoneNumber.delegate = self
        txtCity.delegate = self
        txtNationalId.delegate = self
        txtGender.delegate = self
        txtMaritalStatus.delegate = self
        txtOccupation.delegate = self
        txtEnterDOB.delegate = self
        txtEmail.delegate = self
        txtMobile.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                           for: UIControl.Event.editingChanged)
        txtEmergencyPhoneNumber.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                           for: UIControl.Event.editingChanged)
   
        if (cameFromScreen == "ProfileScreen"){
            stepLabel.isHidden = true
            btnNext.setTitle(Constants.updateProfile.localize(), for: .normal)
        }else{
            stepLabel.isHidden = false
            btnNext.setTitle(Constants.nextButton.localize(), for: .normal)
        }
        stepLabel.text = Constants.step1of3.localize()
        btnNext.backgroundColor = .black
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            txtFirstName.textAlignment = .right
            txtLastName.textAlignment = .right
            txtMobile.textAlignment = .right
            txtEmergencyPhoneNumber.textAlignment = .right
            txtCity.textAlignment = .right
            txtNationalId.textAlignment = .right
            txtGender.textAlignment = .right
            txtMaritalStatus.textAlignment = .right
            txtOccupation.textAlignment = .right
            txtEnterDOB.textAlignment = .right
            txtEmail.textAlignment = .right
        }else{
            txtFirstName.textAlignment = .left
            txtLastName.textAlignment = .left
            txtMobile.textAlignment = .left
            txtEmergencyPhoneNumber.textAlignment = .left
            txtCity.textAlignment = .left
            txtNationalId.textAlignment = .left
            txtGender.textAlignment = .left
            txtMaritalStatus.textAlignment = .left
            txtOccupation.textAlignment = .left
            txtEnterDOB.textAlignment = .left
            txtEmail.textAlignment = .left
        }
       
        basicInformationTitleLabel.text = Constants.basicInformationTitle.localize()
        
        lblFirstName.text = Constants.firstNameLabel.localize()
        lblFirstNameErrorMsg.text = Constants.firstNameLabelError.localize()
        lblLastName.text = Constants.lastNameLabel.localize()
        lblLastNameErrorMsg.text = Constants.lastNameLabelError.localize()
        lblMobile.text = Constants.phoneNumber.localize()
        lblMobileErrorMsg.text = Constants.phoneNumberLabelError.localize()
        lblEmergencyPhoneNumber.text = Constants.emergencyLabel.localize()
        lblEmergencyPhoneNumberErrorMsg.text = Constants.emergencyLabelError.localize()
        lblCity.text = Constants.cityLabel.localize()
        lblCityErrorMsg.text = Constants.cityLabelError.localize()
        lblNationalId.text = Constants.nationalIDLabel.localize()
        lblNationalIdErrorMsg.text = Constants.nationalIDLabelError.localize()
        lblGender.text = Constants.genderLabelPlaceholder.localize()
        lblMaritalStatus.text = Constants.maritalStatusLabel.localize()
        lblOccupation.text = Constants.occupationLabel.localize()
        lblEnterDOB.text = Constants.dobLabel.localize()
        lblEmail.text = Constants.mailIdLabel.localize()
        lblEmailErrorMsg.text = Constants.mailIDLabelError.localize()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtGender.inputView = pickerView
        txtOccupation.inputView = pickerView
        txtMaritalStatus.inputView = pickerView
        self.pickerView = pickerView
//        txtEnterDOB.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        self.txtEnterDOB.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
           
    }
    
    @objc func tapDone() {
            if let datePicker = self.txtEnterDOB.inputView as? UIDatePicker { // 2-1
                let dateformatter = DateFormatter() // 2-2
                dateformatter.dateStyle = .medium // 2-3
                dateformatter.dateFormat = "yyyy-MM-dd"
                self.txtEnterDOB.text = dateformatter.string(from: datePicker.date) //2-4
            }
        lblEnterDOB.isHidden = false
        lblEnterDOB.textColor = borderColorandThemeColor
        txtEnterDOB.setSelectedTextFieldBorderColor()
            self.txtEnterDOB.resignFirstResponder() // 2-5
        }
    
    @IBAction func backButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
         navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func customViewStyleMethod()
    {
        if( calledFlag == false)
        {
            isMobileNumberUse = true
        }
        else
        {
            isMobileNumberUse = false
            counrtycodeForPassing = defaultCounrtyCode
            txtFirstName.setLeftPaddingPoints(15.0)
            txtLastName.setLeftPaddingPoints(15.0)
            txtEmail.setLeftPaddingPoints(15.0)
            txtMobile.setLeftPaddingPoints(15.0)
            txtEmergencyPhoneNumber.setLeftPaddingPoints(15.0)
            txtCity.setLeftPaddingPoints(15.0)
            txtNationalId.setLeftPaddingPoints(15.0)
            txtGender.setLeftPaddingPoints(15.0)
            txtMaritalStatus.setLeftPaddingPoints(15.0)
            txtOccupation.setLeftPaddingPoints(15.0)
            txtEnterDOB.setLeftPaddingPoints(15.0)
          
            txtFirstName.setRightPaddingPoints(50.0)
            txtLastName.setRightPaddingPoints(50.0)
            txtMobile.setRightPaddingPoints(50.0)
            txtEmergencyPhoneNumber.setRightPaddingPoints(50.0)
            txtCity.setRightPaddingPoints(5)
            txtNationalId.setRightPaddingPoints(5)
            txtMaritalStatus.setRightPaddingPoints(5)
            txtGender.setRightPaddingPoints(5)
            txtOccupation.setRightPaddingPoints(5)
            txtEnterDOB.setRightPaddingPoints(5)
            txtEmail.setRightPaddingPoints(50.0)
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
            if(textField == txtMobile || textField == txtEmergencyPhoneNumber){
                calledFlag = true
            }else{
                calledFlag = false
            }
            if(checkForStringStartWithNoOrText(text: (textField.text)!) == true)
            {
                if(calledFlag ==  true)
                {
                    if (textField.text?.count)! <= emailMobileTextCharMinCount  {
                        calledFlag = false
                        if(textField == txtMobile){
                        self.checkTexfieldContainNoOrEmail(txtMobile)
                        }else{
                            self.checkTexfieldContainNoOrEmail(txtEmergencyPhoneNumber)
                        }
                        
                        let mobileNumberWithCountryCode = countryCodeButton.titleLabel?.text!.components(separatedBy: " ")
                        
                        counrtycodeForPassing = mobileNumberWithCountryCode![1]
                    }
                }
                isMobileNumberUse = true
            }
            else
            {
                self.removeCustomViewInTextFiled(textField)
                isMobileNumberUse = false
                calledFlag = true
            }
        }
    }
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    func hideLable(){
        lblFirstName.isHidden = true
        lblFirstNameErrorMsg.isHidden = true
        lblLastName.isHidden = true
        lblLastNameErrorMsg.isHidden = true
        lblMobile.isHidden = true
        lblMobileErrorMsg.isHidden = true
        lblEmergencyPhoneNumber.isHidden = true
        lblEmergencyPhoneNumberErrorMsg.isHidden = true
        lblCity.isHidden = true
        lblCityErrorMsg.isHidden = true
        lblNationalId.isHidden = true
        lblNationalIdErrorMsg.isHidden = true
        lblGender.isHidden = true
        lblMaritalStatus.isHidden = true
        lblOccupation.isHidden = true
        lblEnterDOB.isHidden = true
        lblEmail.isHidden = true
        lblEmailErrorMsg.isHidden = true
        btnFirstNameCheck.isHidden = true
        btnLastNameCheck.isHidden = true
        btnMobileCheck.isHidden = true
        btnEmergencyPhoneNumberCheck.isHidden = true
        btnEmailCheck.isHidden = true
    }
    
    func setFontAndTextColor() {
        // Set font and text color
        self.btnNext.titleLabel?.font                = globalBtnFont
        self.btnNext.backgroundColor                 = borderColorandThemeColor
        self.lblFirstName.textColor                     = borderColorandThemeColor
        self.lblFirstNameErrorMsg.textColor                 = borderColorandThemeColor
        self.txtFirstName.font                          = globalTextFieldFont
        self.txtFirstName.textColor                     = textFieldTextColor
        self.lblLastName.textColor                     = borderColorandThemeColor
        self.lblLastNameErrorMsg.textColor                 = borderColorandThemeColor
        self.txtLastName.font                          = globalTextFieldFont
        self.txtLastName.textColor                     = textFieldTextColor
        self.lblMobile.textColor                = borderColorandThemeColor
        self.lblMobileErrorMsg.textColor        = borderColorandThemeColor
        self.txtMobile.font                     = globalTextFieldFont
        self.txtMobile.textColor                     = textFieldTextColor
        self.lblEmergencyPhoneNumber.textColor                = borderColorandThemeColor
        self.lblEmergencyPhoneNumberErrorMsg.textColor        = borderColorandThemeColor
        self.txtEmergencyPhoneNumber.font                     = globalTextFieldFont
        self.txtEmergencyPhoneNumber.textColor                     = textFieldTextColor
        
        
        self.lblCity.textColor                = borderColorandThemeColor
        self.lblCityErrorMsg.textColor        = borderColorandThemeColor
        self.txtCity.font                     = globalTextFieldFont
        self.txtCity.textColor                     = textFieldTextColor
    
        self.lblNationalId.textColor                = borderColorandThemeColor
        self.lblNationalIdErrorMsg.textColor        = borderColorandThemeColor
        self.txtNationalId.font                     = globalTextFieldFont
        self.txtNationalId.textColor                     = textFieldTextColor
      
        self.lblGender.textColor                = borderColorandThemeColor
        self.txtGender.font                     = globalTextFieldFont
        self.txtGender.textColor                     = textFieldTextColor
        
        self.lblMaritalStatus.textColor                = borderColorandThemeColor
        self.txtMaritalStatus.font                     = globalTextFieldFont
        self.txtMaritalStatus.textColor                     = textFieldTextColor
        
        self.lblOccupation.textColor                = borderColorandThemeColor
        self.txtOccupation.font                     = globalTextFieldFont
        self.txtOccupation.textColor                     = textFieldTextColor
        
        self.lblEnterDOB.textColor                = borderColorandThemeColor
        self.txtEnterDOB.font                     = globalTextFieldFont
        self.txtEnterDOB.textColor                     = textFieldTextColor

        self.lblEmail.textColor                = borderColorandThemeColor
        self.lblEmailErrorMsg.textColor        = borderColorandThemeColor
        self.txtEmail.font                     = globalTextFieldFont
        self.txtEmail.textColor                     = textFieldTextColor
        //Placeholder text
        txtFirstName.attributedPlaceholder = NSAttributedString(string: Constants.firstNameLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtLastName.attributedPlaceholder = NSAttributedString(string: Constants.lastNameLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtMobile.attributedPlaceholder = NSAttributedString(string: Constants.phoneNumber.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtEmergencyPhoneNumber.attributedPlaceholder = NSAttributedString(string: Constants.emergencyLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtCity.attributedPlaceholder = NSAttributedString(string: Constants.cityLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtNationalId.attributedPlaceholder = NSAttributedString(string: Constants.nationalIDLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtGender.attributedPlaceholder = NSAttributedString(string: Constants.genderTextPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtMaritalStatus.attributedPlaceholder = NSAttributedString(string: Constants.selectMaritalStatusLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtOccupation.attributedPlaceholder = NSAttributedString(string: Constants.selectOccupationLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtEnterDOB.attributedPlaceholder = NSAttributedString(string: Constants.entertDobLabel.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtEmail.attributedPlaceholder = NSAttributedString(string: Constants.enterEmailPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        
        self.lblFirstName.font                      = lblTittleFont
        self.lblFirstNameErrorMsg.font              = lblTittleFont
        self.lblLastName.font                       = lblTittleFont
        self.lblLastNameErrorMsg.font               = lblTittleFont
        self.lblMobile.font                         = lblTittleFont
        self.lblMobileErrorMsg.font                 = lblTittleFont
        self.lblEmergencyPhoneNumber.font           = lblTittleFont
        self.lblEmergencyPhoneNumberErrorMsg.font   = lblTittleFont
        self.lblCity.font                           = lblTittleFont
        self.lblCityErrorMsg.font                   = lblTittleFont
        self.lblNationalId.font                     = lblTittleFont
        self.lblNationalIdErrorMsg.font             = lblTittleFont
        self.lblEmail.font                          = lblTittleFont
        self.lblEmailErrorMsg.font                  = lblTittleFont
    }
    
    func callingBasicProfileAPI(){
        if Connectivity.isConnectedToInternet {

            let urlString =  kBaseURL + viewProfileApi;
            self.view.activityStartAnimating()

            var param = [String: Any] ()
            param["Accept"]  = "application/json"
            self.view.isUserInteractionEnabled = false

            CustomAlmofire.dataTask_GET(Foundation.URL(string: urlString)!, method: .get, param: param) { response in

                DispatchQueue.main.async(execute: {() -> Void in

                    self.view.activityStopAnimating()
                    self.view.isUserInteractionEnabled = true
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            self.profileDetails = jsondictionary["userProfle"] as! [String : Any]
                                DispatchQueue.main.async {
                                    //Assign Values to the label
                                    self.txtFirstName.text = self.profileDetails["fname"] as? String
                                    self.lblFirstName.isHidden = false
                                    self.txtLastName.text = self.profileDetails["lname"] as? String
                                    self.lblLastName.isHidden = false
                                    self.txtEmail.text = self.profileDetails["email"] as? String
                                    self.lblEmail.isHidden = false
//                                    self.checkTexfieldContainNoOrEmail(self.txtMobile)
                                    self.txtMobile.text = self.profileDetails["phonenumber"] as? String
                                    self.lblMobile.isHidden = false
                                    self.txtNationalId.text = self.profileDetails["national_id_number"] as? String
                                    self.lblNationalId.isHidden = false
//                                    self.checkTexfieldContainNoOrEmail(self.txtEmergencyPhoneNumber)
                                    self.txtEmergencyPhoneNumber.text = self.profileDetails["emergency_contact_number"] as? String
                                    self.lblEmergencyPhoneNumber.isHidden = false
                                    self.txtCity.text = self.profileDetails["city"] as? String
                                    self.lblCity.isHidden = false
                                    self.txtOccupation.text = self.profileDetails["occupation"] as? String
                                    self.lblOccupation.isHidden = false
                                    self.txtEnterDOB.text = self.profileDetails["dob"] as? String
                                    self.lblEnterDOB.isHidden = false
                                   
                                    if(self.profileDetails["gender"] as? String == "1"){
                                        self.txtGender.text =  Constants.male.localize()
                                    }else{
                                        self.txtGender.text =  Constants.female.localize()
                                    }
                                    self.lblGender.isHidden = false
                                    if(self.profileDetails["marital_status"] as? String == "1"){
                                      self.txtMaritalStatus.text = Constants.married.localize()
                                      }else{
                                          self.txtMaritalStatus.text = Constants.unMarried.localize()
                                      }
                                    self.lblMaritalStatus.isHidden = false
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
    
    //delegate method call for the county picker list
    func didSelectRowSelectedValue(didSelectCountryWithName name: String, code: String, dialCode: String) {
        debugPrint("All details which is seleted",name,code,dialCode)
        counrtycodeForPassing = dialCode
        if(name != "")
        {
            countryCodeButton.setTitle( (code + " " + dialCode), for: .normal)
        }
        //launch the keybord on view show
        txtMobile.becomeFirstResponder()
    }
    
    
    //MARK:- Picker delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if txtGender.isFirstResponder{
                return genderList.count
            }else if txtMaritalStatus.isFirstResponder{
                return maritalList.count
            }else if txtOccupation.isFirstResponder{
                return occupationList.count
            }
            return 0
        }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
 
            if txtGender.isFirstResponder{
                return genderList[row]
            }else if txtMaritalStatus.isFirstResponder{
                return maritalList[row]
            }else if txtOccupation.isFirstResponder{
                return occupationList[row]
            }
            return nil
        }

        func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if txtGender.isFirstResponder{
                txtGender.text =  genderList[row]
                lblGender.isHidden = false
                lblGender.textColor = borderColorandThemeColor
                txtGender.setSelectedTextFieldBorderColor()
                self.txtGender.resignFirstResponder()
            }else if txtMaritalStatus.isFirstResponder{
                txtMaritalStatus.text =  maritalList[row]
                lblMaritalStatus.isHidden = false
                lblMaritalStatus.textColor = borderColorandThemeColor
                txtMaritalStatus.setSelectedTextFieldBorderColor()
                self.txtMaritalStatus.resignFirstResponder()
            }else if txtOccupation.isFirstResponder{
                txtOccupation.text =  occupationList[row]
                lblOccupation.isHidden = false
                lblOccupation.textColor = borderColorandThemeColor
                txtOccupation.setSelectedTextFieldBorderColor()
                self.txtOccupation.resignFirstResponder()
            }
        }
    
    
    //MARK:-  TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.returnKeyType = .next
        self.pickerView?.reloadAllComponents()
    }
    func validateSingleField(textField:UITextField) -> Bool{
        if(textField == txtFirstName) {
            if txtFirstName.text == ""{
                lblFirstName.isHidden = false
                lblFirstNameErrorMsg.isHidden = false
                lblFirstName.textColor = errorBorderColor
                lblFirstNameErrorMsg.textColor = errorBorderColor
                txtFirstName.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtLastName) {
            if txtLastName.text == ""{
                lblLastName.isHidden = false
                lblLastNameErrorMsg.isHidden = false
                lblLastName.textColor = errorBorderColor
                lblLastNameErrorMsg.textColor = errorBorderColor
                txtLastName.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtMobile) {
            if !isValidMobileNo(mobileNo: txtMobile.text ?? "", countryCode: counrtycodeForPassing){
            // self.alert(message: kKeyvalidMobileNoMessage)
                lblMobile.isHidden = false
                lblMobileErrorMsg.isHidden = false
                lblMobile.textColor = errorBorderColor
                lblMobileErrorMsg.textColor = errorBorderColor
                lblMobileErrorMsg.text = Constants.validPhoneNumberError.localize()
                txtMobile.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtEmergencyPhoneNumber) {
            if !isValidMobileNo(mobileNo: txtMobile.text ?? "", countryCode: counrtycodeForPassing){
            // self.alert(message: kKeyvalidMobileNoMessage)
                lblEmergencyPhoneNumber.isHidden = false
                lblEmergencyPhoneNumberErrorMsg.isHidden = false
                lblEmergencyPhoneNumber.textColor = errorBorderColor
                lblEmergencyPhoneNumberErrorMsg.textColor = errorBorderColor
                lblEmergencyPhoneNumberErrorMsg.text = Constants.validemergencyPhoneNumberError.localize()
                txtEmergencyPhoneNumber.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtEmail) {
         if let strEmail = txtEmail.text, !isValidEmailID(txtEmail: strEmail) {
            if (txtEmail.text!.isEmpty) {
                lblEmail.isHidden = false
                lblEmailErrorMsg.isHidden = false
                lblEmail.textColor = errorBorderColor
                lblEmailErrorMsg.textColor = errorBorderColor
                txtEmail.setSelectedTextFieldErrorColor()
                return true
            } else {
                lblEmail.isHidden = false
                lblEmailErrorMsg.isHidden = false
                lblEmail.textColor = errorBorderColor
                lblEmailErrorMsg.textColor = errorBorderColor
                txtEmail.setSelectedTextFieldErrorColor()
                return false
            }
         }
        }
        if(textField == txtCity) {
            if txtCity.text == ""{
                lblCity.isHidden = false
                lblCityErrorMsg.isHidden = false
                lblCity.textColor = errorBorderColor
                lblCityErrorMsg.textColor = errorBorderColor
                txtCity.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtNationalId) {
            if txtNationalId.text == ""{
                lblNationalId.isHidden = false
                lblNationalIdErrorMsg.isHidden = false
                lblNationalId.textColor = errorBorderColor
                lblNationalIdErrorMsg.textColor = errorBorderColor
                txtNationalId.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtGender) {
            if txtGender.text == ""{
                lblGender.isHidden = false
                lblGender.textColor = errorBorderColor
                txtGender.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtMaritalStatus) {
            if txtMaritalStatus.text == ""{
                lblMaritalStatus.isHidden = false
                lblMaritalStatus.textColor = errorBorderColor
                txtMaritalStatus.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtOccupation) {
            if txtOccupation.text == ""{
                lblOccupation.isHidden = false
                lblOccupation.textColor = errorBorderColor
                txtOccupation.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtEnterDOB) {
            if txtEnterDOB.text == ""{
                lblEnterDOB.isHidden = false
                lblEnterDOB.textColor = errorBorderColor
                txtEnterDOB.setSelectedTextFieldErrorColor()
                return false
            }
        }
            return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        debugPrint("TextField did end editing method called\(textField.text!)")
        textField.setDefaultBorderColor()
        if validateSingleField(textField: textField) {
            print("Validated")
        } else {
            print("Not Validated")
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        debugPrint("While entering the characters this method gets called")
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == txtFirstName {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtFirstName) {
                if (newString.length > 0)  {
                    lblFirstName.isHidden = false
                    lblFirstNameErrorMsg.isHidden = true
                    lblFirstName.textColor = borderColorandThemeColor
                    txtFirstName.setSelectedTextFieldBorderColor()
                   
                } else {
                    btnFirstNameCheck.isHidden = true
                    lblFirstName.isHidden = true
                    txtFirstName.setDefaultBorderColor()
                }
                return count < 40
            }
        } else  if textField == txtLastName {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtLastName) {
                if (newString.length > 0) {
                    lblLastName.isHidden = false
                    lblLastNameErrorMsg.isHidden = true
                    lblLastName.textColor = borderColorandThemeColor
                    txtLastName.setSelectedTextFieldBorderColor()
                    
                } else {
                    btnLastNameCheck.isHidden = true
                    lblLastName.isHidden = true
                    txtLastName.setDefaultBorderColor()
                }
                return count < 40
            }
        }
        else if textField == txtMobile   {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtMobile) {
                if (newString.length > 0) {
                    lblMobile.isHidden = false
                    lblMobileErrorMsg.isHidden = true
                    btnMobileCheck.isHidden = true
                    lblMobile.textColor = borderColorandThemeColor
                    txtMobile.setSelectedTextFieldBorderColor()
                } else {
                    btnMobileCheck.isHidden = true
                    lblMobile.isHidden = true
                    lblMobileErrorMsg.isHidden = true
                    txtMobile.setDefaultBorderColor()
                    //setView(view: mobileNumberLabel, hidden: true)
                }
                return count < 15
            }
        }else if textField == txtEmergencyPhoneNumber   {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtEmergencyPhoneNumber) {
                if (newString.length > 0) {
                    lblEmergencyPhoneNumber.isHidden = false
                    lblEmergencyPhoneNumberErrorMsg.isHidden = true
                    btnEmergencyPhoneNumberCheck.isHidden = true
                    lblEmergencyPhoneNumber.textColor = borderColorandThemeColor
                    txtEmergencyPhoneNumber.setSelectedTextFieldBorderColor()
                } else {
                    btnEmergencyPhoneNumberCheck.isHidden = true
                    lblEmergencyPhoneNumber.isHidden = true
                    lblEmergencyPhoneNumberErrorMsg.isHidden = true
                    txtEmergencyPhoneNumber.setDefaultBorderColor()
                    //setView(view: mobileNumberLabel, hidden: true)
                }
                return count < 15
            }
        }else if textField == txtEmail {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtEmail) {
                if (newString.length > 0) {
                    lblEmail.isHidden = false
                    lblEmailErrorMsg.isHidden = true
                    btnEmailCheck.isHidden = true
                    lblEmail.textColor = borderColorandThemeColor
                    txtEmail.setSelectedTextFieldBorderColor()
                } else {
                    btnEmailCheck.isHidden = true
                    lblEmail.isHidden = true
                    lblEmailErrorMsg.isHidden = true
                    txtEmail.setDefaultBorderColor()
                }
                return count < 40
            }
        }else  if textField == txtCity {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtCity) {
                if (newString.length > 0) {
                    lblCity.isHidden = false
                    lblCityErrorMsg.isHidden = true
                    lblCity.textColor = borderColorandThemeColor
                    txtCity.setSelectedTextFieldBorderColor()
                    
                } else {
                    lblCity.isHidden = true
                    txtCity.setDefaultBorderColor()
                }
                return count < 40
            }
        }else  if textField == txtNationalId {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtNationalId) {
                if (newString.length > 0) {
                    lblNationalId.isHidden = false
                    lblNationalIdErrorMsg.isHidden = true
                    lblNationalId.textColor = borderColorandThemeColor
                    txtNationalId.setSelectedTextFieldBorderColor()
                    
                } else {
                    lblNationalId.isHidden = true
                    txtNationalId.setDefaultBorderColor()
                }
                return count < 40
            }
        }else  if textField == txtGender {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtGender) {
                if (newString.length > 0) {
                    lblGender.isHidden = false
                    lblGender.textColor = borderColorandThemeColor
                    txtGender.setSelectedTextFieldBorderColor()
                    
                } else {
                    lblGender.isHidden = true
                    txtGender.setDefaultBorderColor()
                }
                return count < 40
            }
        }else  if textField == txtMaritalStatus {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtMaritalStatus) {
                if (newString.length > 0) {
                    lblMaritalStatus.isHidden = false
                    lblMaritalStatus.textColor = borderColorandThemeColor
                    txtMaritalStatus.setSelectedTextFieldBorderColor()
                    
                } else {
                    lblMaritalStatus.isHidden = true
                    txtMaritalStatus.setDefaultBorderColor()
                }
                return count < 40
            }
        }else  if textField == txtOccupation {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtOccupation) {
                if (newString.length > 0) {
                    lblOccupation.isHidden = false
                    lblOccupation.textColor = borderColorandThemeColor
                    txtOccupation.setSelectedTextFieldBorderColor()
                    
                } else {
                    lblOccupation.isHidden = true
                    txtOccupation.setDefaultBorderColor()
                }
                return count < 40
            }
        }else  if textField == txtEnterDOB {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtEnterDOB) {
                if (newString.length > 0) {
                    lblEnterDOB.isHidden = false
                    lblEnterDOB.textColor = borderColorandThemeColor
                    txtEnterDOB.setSelectedTextFieldBorderColor()
                    
                } else {
                    lblEnterDOB.isHidden = true
                    txtEnterDOB.setDefaultBorderColor()
                }
                return count < 40
            }
        }
        return true
    }
    
    @IBAction func textFieldEditingFullName(_ sender: FormTextField) {
        if sender == txtFirstName{
            if sender.text! == ""{
                btnFirstNameCheck.isHidden = true
            }else{
               btnFirstNameCheck.isHidden = false
                
                btnFirstNameCheck.setImage(UIImage(named: "checkArrow")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                btnFirstNameCheck.tintColor = borderColorandThemeColor
                
            }
        }else  if sender == txtLastName{
            if sender.text! == ""{
                btnLastNameCheck.isHidden = true
            }else{
                btnLastNameCheck.isHidden = false
                btnLastNameCheck.setImage(UIImage(named: "checkArrow")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                btnLastNameCheck.tintColor = borderColorandThemeColor
            }
        }
        else if sender == txtMobile{
            if isValidMobileNo(mobileNo: txtMobile.text ?? "", countryCode: counrtycodeForPassing ){
                btnMobileCheck.isHidden =  false
                btnMobileCheck.setImage(UIImage(named: "checkArrow")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                btnMobileCheck.tintColor = borderColorandThemeColor
            }else{
                
                btnMobileCheck.isHidden =  true
            }
        }else if sender == txtEmergencyPhoneNumber{
            if isValidMobileNo(mobileNo: txtEmergencyPhoneNumber.text ?? "", countryCode: counrtycodeForPassing ){
                btnEmergencyPhoneNumberCheck.isHidden =  false
                btnEmergencyPhoneNumberCheck.setImage(UIImage(named: "checkArrow")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                btnEmergencyPhoneNumberCheck.tintColor = borderColorandThemeColor
            }else{
                
                btnEmergencyPhoneNumberCheck.isHidden =  true
            }
        }else if sender == txtEmail{
            if isValidEmail(emailStr: sender.text!){
                btnEmailCheck.isHidden =  false
                btnEmailCheck.setImage(UIImage(named: "checkArrow")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                btnEmailCheck.tintColor = borderColorandThemeColor
            }else{
                
                btnEmailCheck.isHidden =  true
            }
        }
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
      
        if (self.cameFromScreen == "ProfileScreen") {
            validateField(completion: { (success) in
                       if success{
                           self.updateBasicProfileDetailsCalling()
                       }
                   })
        }else{
            let vc = kMainStoryboard.instantiateViewController(withIdentifier: profileCompletionVCSID) as? ProfileCompletionVC
            vc?.cameFromScreen = self.cameFromScreen
            self.navigationController?.pushViewController(vc!, animated: true)
        }  
    }
    
    func updateBasicProfileDetailsCalling()
      {
           var finalmobilecode = ""
          var finalEmergencyMobilecode = ""
          if txtMobile.text!.contains("+") {
              if txtMobile.text!.first == "0" {
                  finalmobilecode = counrtycodeForPassing + " " + String(txtMobile.text!.dropFirst())
              }
              
              if txtEmergencyPhoneNumber.text!.first == "0" {
                  finalEmergencyMobilecode = counrtycodeForPassing + " " + String(txtEmergencyPhoneNumber.text!.dropFirst())
              }
              
          }else {
              if txtMobile.text!.first == "0" {
                  finalmobilecode = counrtycodeForPassing + " " + String(txtMobile.text!.dropFirst())
              }
              else
              {
                  finalmobilecode = counrtycodeForPassing + " " + txtMobile.text!
              }
              
              if txtEmergencyPhoneNumber.text!.first == "0" {
                  finalEmergencyMobilecode = counrtycodeForPassing + " " + String(txtEmergencyPhoneNumber.text!.dropFirst())
              }else{
                  finalEmergencyMobilecode = counrtycodeForPassing + " " + txtEmergencyPhoneNumber.text!
              }
          }
          
          //call the registartion Api from here
          if Connectivity.isConnectedToInternet {
         
              let urlString =  kBaseURL + updateProfileAPI;
              self.view.activityStartAnimating()
              
              var param = [String: Any] ()
                  param["fname"]  = txtFirstName.text
                  param["lname"]  = txtLastName.text
                  param["email"]  = txtEmail.text
//                  param["phonenumber"]  = finalmobilecode
                  param["phonenumber"] =  txtMobile.text
                  param["city"]  = txtCity.text
                  param["dob"]  =  txtEnterDOB.text
                  param["occupation"]  = txtOccupation.text
                  if(txtGender.text == Constants.male.localize()){
                      param["gender"]  = 1
                  }else{
                      param["gender"]  = 2
                  }
                if(txtMaritalStatus.text == Constants.married.localize()){
                        param["marital_status"]  = "1"
                    }else{
                        param["marital_status"]  = "2"
                    }
                    param["emergency_contact_number"] =  txtEmergencyPhoneNumber.text
//                  param["emergency_contact_number"]  = finalEmergencyMobilecode
                  param["national_id_number"]  = txtNationalId.text
              self.view.isUserInteractionEnabled = false
              
              CustomAlmofire.dataTask_PUT(Foundation.URL(string: urlString)!, method: .put, param: param) { (response) in
                  
                  DispatchQueue.main.async(execute: {() -> Void in
                      
                      self.view.activityStopAnimating()
                      self.view.isUserInteractionEnabled = true
                      switch response {
                      case .success(let dictionary as [String: Any]):
                          if (dictionary["status"] as? Int == 200) {
                              let jsondictionary = dictionary["results"] as! NSDictionary
                              DispatchQueue.main.async {
                                 //Naviagete to the next Step screen.
                                  self.navigationController?.popViewController(animated: true)
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
    
    //MARK:- Validation of fields
 var validate : Bool = false
    
    func validateField(completion: (_ result: Bool) -> Void){
        var firstName : Bool = true
        var lastName : Bool = true
        var mobileValidation : Bool = true
        var emergencyMobileValidation : Bool = true
        var city : Bool = true
        var nationalId : Bool = true
        var gender : Bool = true
        var maritalStatus : Bool = true
        var occupation : Bool = true
        var dob : Bool = true
        if txtFirstName.text == ""{
            lblFirstName.isHidden = false
            lblFirstNameErrorMsg.isHidden = false
            lblFirstName.textColor = errorBorderColor
            lblFirstNameErrorMsg.textColor = errorBorderColor
            txtFirstName.setSelectedTextFieldErrorColor()
            lblFirstNameErrorMsg.text = Constants.firstNameLabelError.localize()
           firstName =  false
        } else {
            firstName =  true
        }
        if txtLastName.text == ""{
            lblLastName.isHidden = false
            lblLastNameErrorMsg.isHidden = false
            lblLastName.textColor = errorBorderColor
            lblLastNameErrorMsg.textColor = errorBorderColor
            txtLastName.setSelectedTextFieldErrorColor()
            lblLastNameErrorMsg.text = Constants.lastNameLabelError.localize()
            lastName =  false
        } else {
            lastName =  true
        }
        if !isValidMobileNo(mobileNo: txtMobile.text ?? "", countryCode: counrtycodeForPassing){
            lblMobile.isHidden = false
            lblMobileErrorMsg.isHidden = false
            lblMobile.textColor = errorBorderColor
            lblMobileErrorMsg.textColor = errorBorderColor
            txtMobile.setSelectedTextFieldErrorColor()
            lblMobileErrorMsg.text = Constants.validPhoneNumberError.localize()
            mobileValidation =  false
        } else {
            mobileValidation =  true
        }
        if !isValidMobileNo(mobileNo: txtEmergencyPhoneNumber.text ?? "", countryCode: counrtycodeForPassing){
            lblEmergencyPhoneNumber.isHidden = false
            lblEmergencyPhoneNumberErrorMsg.isHidden = false
            lblEmergencyPhoneNumber.textColor = errorBorderColor
            lblEmergencyPhoneNumberErrorMsg.textColor = errorBorderColor
            txtEmergencyPhoneNumber.setSelectedTextFieldErrorColor()
            lblEmergencyPhoneNumberErrorMsg.text = Constants.validemergencyPhoneNumberError.localize()
            emergencyMobileValidation =  false
        } else {
            emergencyMobileValidation =  true
        }
        if txtCity.text == ""{
            lblCity.isHidden = false
            lblCityErrorMsg.isHidden = false
            lblCity.textColor = errorBorderColor
            lblCityErrorMsg.textColor = errorBorderColor
            txtCity.setSelectedTextFieldErrorColor()
            lblCityErrorMsg.text = Constants.cityLabelError.localize()
            city =  false
        } else {
            city =  true
        }
        if txtNationalId.text == ""{
            lblNationalId.isHidden = false
            lblNationalIdErrorMsg.isHidden = false
            lblNationalId.textColor = errorBorderColor
            lblNationalIdErrorMsg.textColor = errorBorderColor
            txtNationalId.setSelectedTextFieldErrorColor()
            lblNationalIdErrorMsg.text = Constants.nationalIDLabelError.localize()
            nationalId =  false
        } else {
            nationalId =  true
        }
        
        if txtGender.text == ""{
            lblGender.isHidden = false
            lblGender.textColor = errorBorderColor
            txtGender.setSelectedTextFieldErrorColor()
            gender =  false
        } else {
            gender =  true
        }
        if txtMaritalStatus.text == ""{
            lblMaritalStatus.isHidden = false
            lblMaritalStatus.textColor = errorBorderColor
            txtMaritalStatus.setSelectedTextFieldErrorColor()
            maritalStatus =  false
        } else {
            maritalStatus =  true
        }
        if txtOccupation.text == ""{
            lblOccupation.isHidden = false
            lblOccupation.textColor = errorBorderColor
            txtOccupation.setSelectedTextFieldErrorColor()
            occupation =  false
        } else {
            occupation =  true
        }
        if txtEnterDOB.text == ""{
            lblEnterDOB.isHidden = false
            lblEnterDOB.textColor = errorBorderColor
            txtEnterDOB.setSelectedTextFieldErrorColor()
            dob =  false
        } else {
            dob =  true
        }
        if(firstName == true && lastName == true && mobileValidation == true && city == true && emergencyMobileValidation == true && nationalId == true && gender == true && maritalStatus == true && occupation == true && dob == true){
            validate = true
        } else {
            validate = false
        }
        print("Validate Value",validate)
       completion(validate)
    }
}

