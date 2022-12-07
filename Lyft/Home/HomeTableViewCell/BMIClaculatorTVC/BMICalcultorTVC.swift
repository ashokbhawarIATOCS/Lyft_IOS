//
//  BMICalcultorTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 04/11/22.
//

import UIKit

class BMICalcultorTVC: UITableViewCell,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var txtHeight: FormTextField!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var txtWight: FormTextField!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var txtAge: FormTextField!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var txtGender: FormTextField!
    @IBOutlet weak var lblActivityFactor: UILabel!
    @IBOutlet weak var txtActivityFactor: FormTextField!
    
    @IBOutlet weak var calculateBMIButton: UIButton!
    @IBOutlet weak var BMIDetailStackView: UIStackView!
    @IBOutlet weak var BMIBottomStackView: UIStackView!
    @IBOutlet weak var BMIResultView: UIView!
    @IBOutlet weak var bmiResultValueLabel: UILabel!
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var weightStatusLabel: UILabel!
    @IBOutlet weak var belowLabel: UILabel!
    @IBOutlet weak var underWeightLabel: UILabel!
    @IBOutlet weak var healthyLabel: UILabel!
    @IBOutlet weak var obeseLabel: UILabel!
    @IBOutlet weak var overweightLabel: UILabel!
    @IBOutlet weak var aboveLabel: UILabel!
    @IBOutlet weak var bmrLabel: UILabel!
    @IBOutlet weak var bmilabel: UILabel!
    @IBOutlet weak var metabolicRateLabel: UILabel!
    @IBOutlet weak var bmiDescriptionLabel: UILabel!
    
    //create your closure here
    var calculateBMIButtonPressed : ((String) -> Void)?
    
    var genderList = [Constants.male.localize(), Constants.female.localize()]
    var activityFactorList = [Constants.activityFactor1.localize(), Constants.activityFactor2.localize(),Constants.activityFactor3.localize() ,Constants.activityFactor4.localize() ]
    var pickerView: UIPickerView! = UIPickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BMIDetailStackView.isHidden = true
        BMIBottomStackView.isHidden = false
        BMIResultView.isHidden = true
        // Initialization code
        customUILoad()
    }
    func customUILoad(){
        txtHeight.delegate = self
        txtWight.delegate = self
        txtAge.delegate = self
        txtGender.delegate = self
        txtActivityFactor.delegate = self
        lblAge.text  = Constants.agePlaceholder.localize()
        lblHeight.text  = Constants.heightPlaceholder.localize()
        lblWeight.text  = Constants.weightPlaceholder.localize()
        lblGender.text  = Constants.genderLabelPlaceholder.localize()
        lblActivityFactor.text  = Constants.activityFactorPlaceholder.localize()
        calculateBMIButton.setTitle(Constants.calculatBMIButtonTitle.localize(), for: .normal)
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            txtGender.textAlignment = .right
            txtActivityFactor.textAlignment = .right
            txtAge.textAlignment = .right
            txtWight.textAlignment = .right
            txtHeight.textAlignment = .right
        }else{
            txtGender.textAlignment = .left
            txtActivityFactor.textAlignment = .left
            txtAge.textAlignment = .left
            txtWight.textAlignment = .left
            txtHeight.textAlignment = .left
        }
        self.lblHeight.textColor = borderColorandThemeColor
        self.lblWeight.textColor = borderColorandThemeColor
        self.lblAge.textColor = borderColorandThemeColor
        self.lblGender.textColor = borderColorandThemeColor
        self.lblActivityFactor.textColor = borderColorandThemeColor
        self.txtHeight.font = globalTextFieldFont
        self.txtWight.font = globalTextFieldFont
        self.txtAge.font = globalTextFieldFont
        self.txtGender.font = globalTextFieldFont
        self.txtActivityFactor.font = globalTextFieldFont
        self.lblHeight.font  = lblTittleFont
        self.lblWeight.font  = lblTittleFont
        self.lblAge.font  = lblTittleFont
        self.lblGender.font  = lblTittleFont
        self.lblActivityFactor.font  = lblTittleFont
        
        self.txtHeight.textColor = textFieldTextColor
        self.txtWight.textColor = textFieldTextColor
        self.txtAge.textColor = textFieldTextColor
        self.txtGender.textColor = textFieldTextColor
        self.txtActivityFactor.textColor = textFieldTextColor
        
        self.lblHeight.isHidden = true
        self.lblWeight.isHidden = true
        self.lblAge.isHidden = true
        self.lblGender.isHidden = true
        self.lblActivityFactor.isHidden = true
        txtHeight.setLeftPaddingPoints(15.0)
        txtHeight.setRightPaddingPoints(5.0)
        txtWight.setLeftPaddingPoints(15.0)
        txtWight.setRightPaddingPoints(5.0)
        txtAge.setLeftPaddingPoints(15.0)
        txtAge.setRightPaddingPoints(5.0)
        txtGender.setLeftPaddingPoints(15.0)
        txtGender.setRightPaddingPoints(5.0)
        txtActivityFactor.setLeftPaddingPoints(15.0)
        txtActivityFactor.setRightPaddingPoints(5.0)
        
        txtHeight.attributedPlaceholder = NSAttributedString(string: Constants.heightPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtWight.attributedPlaceholder = NSAttributedString(string: Constants.weightPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtAge.attributedPlaceholder = NSAttributedString(string: Constants.agePlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtGender.attributedPlaceholder = NSAttributedString(string: Constants.genderTextPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        txtActivityFactor.attributedPlaceholder = NSAttributedString(string: Constants.activityFactorPlaceholder.localize(), attributes: [NSAttributedString.Key.foregroundColor: textPlaceHolder])
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtGender.inputView = pickerView
        txtActivityFactor.inputView = pickerView
        self.pickerView = pickerView
        
        bmiLabel.text  = Constants.bmi.localize()
        weightStatusLabel.text  = Constants.weightStatus.localize()
        belowLabel.text  = Constants.below.localize()
        underWeightLabel.text  = Constants.underweight.localize()
        healthyLabel.text  = Constants.healthy.localize()
        obeseLabel.text  = Constants.obese.localize()
        overweightLabel.text  = Constants.overweight.localize()
        aboveLabel.text  = Constants.above.localize()
        bmrLabel.text  = Constants.bmr.localize()
        bmilabel.text  = Constants.bmi.localize()
        metabolicRateLabel.text  = Constants.bmrDescription.localize()
        bmiDescriptionLabel.text  = Constants.bmiDescription.localize()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func calculateBMIButtonAction(_ sender: Any) {
        
        validateField(completion: { (success) in
                   if success{
                       //calculate the BMI and set the string and pass the date to clouser
                       let weight = NSString(string: txtWight.text!)
                       let height = NSString(string: txtHeight.text!)
                       
                       let normalWeight = BMIStruct(mass:  weight.doubleValue, height: height.doubleValue)
                       print(normalWeight.bmi)
                       print(normalWeight.description)
                       self.calculateBMIButtonPressed?(normalWeight.description)
                   }
               })
    }
    //MARK delegate method of picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if txtGender.isFirstResponder{
                return genderList.count
            }else if txtActivityFactor.isFirstResponder{
                return activityFactorList.count
            }
            return 0
        }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
 
            if txtGender.isFirstResponder{
                return genderList[row]
            }else if txtActivityFactor.isFirstResponder{
                return activityFactorList[row]
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
            }else if txtActivityFactor.isFirstResponder{
                txtActivityFactor.text =  activityFactorList[row]
                lblActivityFactor.isHidden = false
                lblActivityFactor.textColor = borderColorandThemeColor
                txtActivityFactor.setSelectedTextFieldBorderColor()
                self.txtActivityFactor.resignFirstResponder()
            }
        }
    
    //MARK:-  TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.returnKeyType = .next
        self.pickerView?.reloadAllComponents()
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
    
    func validateSingleField(textField:UITextField) -> Bool{
        if(textField == txtHeight) {
            if txtHeight.text == ""{
                lblHeight.isHidden = false
                lblHeight.textColor = errorBorderColor
                txtHeight.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtWight) {
            if txtWight.text == ""{
                lblWeight.isHidden = false
                lblWeight.textColor = errorBorderColor
                txtWight.setSelectedTextFieldErrorColor()
                return false
            }
        }
        if(textField == txtAge) {
            if txtAge.text == ""{
                lblAge.isHidden = false
                lblAge.textColor = errorBorderColor
                txtAge.setSelectedTextFieldErrorColor()
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
        
        if(textField == txtActivityFactor) {
            if txtActivityFactor.text == ""{
                lblActivityFactor.isHidden = false
                lblActivityFactor.textColor = errorBorderColor
                txtActivityFactor.setSelectedTextFieldErrorColor()
                return false
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == txtHeight {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtHeight) {
                if (newString.length > 0)  {
                    lblHeight.isHidden = false
                    lblHeight.textColor = borderColorandThemeColor
                    txtHeight.setSelectedTextFieldBorderColor()
                   
                } else {
                    lblHeight.isHidden = true
                    txtHeight.setDefaultBorderColor()
                }
                return count < 40
            }
        }else  if textField == txtWight {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtWight) {
                if (newString.length > 0) {
                    lblWeight.isHidden = false
                    lblWeight.textColor = borderColorandThemeColor
                    txtWight.setSelectedTextFieldBorderColor()
                    
                } else {
                    lblWeight.isHidden = true
                    txtWight.setDefaultBorderColor()
                }
                return count < 40
            }
        }else  if textField == txtAge {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtAge) {
                if (newString.length > 0) {
                    lblAge.isHidden = false
                    lblAge.textColor = borderColorandThemeColor
                    txtAge.setSelectedTextFieldBorderColor()
                    
                } else {
                    lblAge.isHidden = true
                    txtAge.setDefaultBorderColor()
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
        }
        else  if textField == txtActivityFactor {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            if(textField ==  txtActivityFactor) {
                if (newString.length > 0) {
                    lblActivityFactor.isHidden = false
                    lblActivityFactor.textColor = borderColorandThemeColor
                    txtActivityFactor.setSelectedTextFieldBorderColor()
                    
                } else {
                    lblActivityFactor.isHidden = true
                    txtActivityFactor.setDefaultBorderColor()
                }
                return count < 40
            }
        }
        return true
    }
    //MARK:- Validation of fields
    var validate : Bool = false
    
    func validateField(completion: (_ result: Bool) -> Void){
        var heightValidation : Bool = true
        var weightValidation : Bool = true
        var ageValidation : Bool = true
        var genderValidation : Bool = true
        var activityFactorValidation : Bool = true

        if txtHeight.text == ""{
            lblHeight.isHidden = false
            lblHeight.textColor = errorBorderColor
            txtHeight.setSelectedTextFieldErrorColor()
            heightValidation =  false
        } else {
            heightValidation =  true
        }
        if txtWight.text == ""{
            lblWeight.isHidden = false
            lblWeight.textColor = errorBorderColor
            txtWight.setSelectedTextFieldErrorColor()
            weightValidation =  false
        } else {
            weightValidation =  true
        }
        if txtAge.text == ""{
            lblAge.isHidden = false
            lblAge.textColor = errorBorderColor
            txtAge.setSelectedTextFieldErrorColor()
            ageValidation =  false
        } else {
            ageValidation =  true
        }
        if txtGender.text == ""{
            lblGender.isHidden = false
            lblGender.textColor = errorBorderColor
            txtGender.setSelectedTextFieldErrorColor()
            genderValidation =  false
        } else {
            genderValidation =  true
        }
        if txtActivityFactor.text == ""{
            lblActivityFactor.isHidden = false
            lblActivityFactor.textColor = errorBorderColor
            txtActivityFactor.setSelectedTextFieldErrorColor()
            activityFactorValidation =  false
        } else {
            activityFactorValidation =  true
        }
        
        if(heightValidation == true && weightValidation == true && ageValidation == true && genderValidation == true && activityFactorValidation == true ){
            validate = true
        } else {
            validate = false
        }
        print("Validate Value",validate)
       completion(validate)
    }
}
