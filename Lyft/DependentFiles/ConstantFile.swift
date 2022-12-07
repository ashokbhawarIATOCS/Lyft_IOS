//
//  ConstantFile.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import Foundation
import UIKit

let loginVCSID = "loginVCSID"
let signupVCSID = "signupVCSID"
let homeVCSID = "homeVCSID"
let mainHomeForMenuVCSID = "MainViewController"
let countryListPopUpSID: String = "countryListPopUpSID"
let forgotPasswordScreenSID: String = "forgotPasswordScreenSID"
let termAndConditionAndPrivacySID: String = "termAndConditionAndPrivacySID"
let passwordChangeSubmitScreenSID: String = "passwordChangeSubmitScreenSID"
let verifyAccountScreenSID: String = "verifyAccountScreenSID"
let resetPasswordScreenSID: String = "resetPasswordScreenSID"
let changePasswordScreenSID: String = "changePasswordScreenSID"
let ristrictUserLoginSID: String =  "ristrictUserLoginSID"
let forgotPasswordRequestSubmittedScreenSID: String = "forgotPasswordRequestSubmittedScreenSID"
let thawaniPaymentVCSID : String = "ThawaniPaymentVCSID"
let planPackageSID: String = "planPackageSID"
let bookclassesSID: String = "bookclassesSID"
let buySessionSID: String = "buySessionSID"
let buyPlanSID: String = "buyPlanSID"
let editProfileVCSID: String = "editProfileVCSID"
let forgotPasswordSegue: String = "forgotPasswordSegue"
let profileCompletionVCSID: String = "profileCompletionVCSID"
let imageUploadAndDetailsSID: String = "imageUploadAndDetailsSID"
let consentDetailsVCSID: String = "consentDetailsVCSID"
////  Mark: - BaseURL for Production
let kBaseURL = "https://lyftoman.com"
//// Mark: - BaseURL for Testing(NEW Production Staging)
//let kBaseURL = "https://gym.lyftoman.com"


let kAllTrainerListAPI = "/api/get-team/"                             //All Trainer API
let kLoginAPI = "/api/login"                                          // LoginAPI
let kLogoutAPI = "/api/logout"                                        // LogoutAPI
let kForgotPasswordAPI = "/api/reset-password-email"                   // Forgot Password
let kScheduledClass =  "/api/user-booked-classes"                        //schedulded class Api
let kVerifyOTPAPI = "/api/verify-otp"                                   // verifyOTP API
let kResendAPI = "/api/resend-otp"                                     // Resend OTP API
let kResetPassordAPI = "/api/reset-password"                          //  Reset Password
let kChangePassordAPI = "/api/change-password"                        //  Change Password
let kAccountDeletionAPI = "/api/remove-account"                      //  Account Deletion
let kChangeLanguageAPI = "/api/store-lan"                            //Change Language
let kHomeAPI = "/api/home"                                          //  Home API
let myScheduledAPI = "/api/user-booked-classes"                    //My Scheduled API
let cancelClassesAPI = "/api/cancel-class"                         //Cancel classes API
let reScheduleClasessAPI = "/api/reschedule-class"                //ReSchedule Clasess API
let viewProfileApi = "/api/view-profile"                           //View Profile API
let basicreghistrationAPI = "/api/create-user"                      //Basics registration
let uploadProfilePhotoAPI = "/api/upload-photo"                         //Upload Profile Photo API
let planDetailsAPI = "/api/get-packages"                        //Plan package API
let getSessionPriceAPI = "/api/get-sessions-prices"               //Get Session price API
let sessionPurchaseAPI = "/api/purchase-sessions"                  //Purchase Session API
let getClassesAPI = "/api/get-classes"                              //Get Classes API
let getSessionDetailAPI = "/api/get-session-details"                     //Get Session details API
let bookSessionApi = "/api/book-class"                                //Book Session API
let completedProfileAPI = "/api/complete-registration"                // completed profile screen 
let buyPlanAPI = "/api/subscribe-membership"                        // Buy Subscribe Membership API
let updateProfileAPI = "/api/update-profile"                        //Update Profile API put api
//Thawani payment API
let thawaniTokenAPI = "/api/thawanipay/token"   //get the token and naviagte to the web page for the payment.
let thawaniReturnAPI = "/api/thawanipay/return/"    // hanled the success and failure response from thawani payment.

let kKeyvalidEmailMessage = "Please enter valid Email"
let kKeyEmptyEmailMobileMessage = "Please email address"
let kInternetAccessAlertMessage = "No internet connection"
let kKeyEmptyPasswordMessage = "Password must contain 6 characters, at least 1 Upper case, 1 lower case and 1 digit."
let kKeyEmptyPassword = "Please enter new password"
let kKeyEmptyResetOTP = "Please enter otp which you received on mail"
let kKeyPasswordNotMatchMessage = "Both the password do not match"
let kKeyPasswordEmptyMessage = "Please enter password"
let kKeyEmptyVerifyAccountMessage = "Please enter six digit OTP"
//let kCodeResentAlertMessage = "Code sent successfully"

//MainStoryboard
let kMainStoryboard = UIStoryboard(name: "Main", bundle: nil)

// Get UDID of deveice
let strUDID = UIDevice.current.identifierForVendor?.uuidString

//constants for the notification name
let passwordEmailSendNotificationKey = "SendingEmailAndPasswordThroughNotification"

//CustomCellIdentifier
let countryCell : String = "countryCell"
//Constant for App Name
let appName : String = "LYFT"
//App Delegate constant
let appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
//MainStoryboard
let MainStoryboard = UIStoryboard(name: "Main", bundle: nil)

//Color constant used in the project
let blueClorCodeForTitles: UIColor = UIColor(red:0.22, green:0.38, blue:0.63, alpha:1.0)
let lightGrayColorCode: UIColor = UIColor(red:0.87, green:0.87, blue:0.89, alpha:1.0)
let headerTextColorCode: UIColor = UIColor(hex: "#172043") ?? UIColor.black
let subTitleColorCode: UIColor = UIColor(hex: "#6A6F7C") ?? UIColor.lightGray
let defaultLineGrayColorCode: UIColor = UIColor(hex: "#949AAC") ?? UIColor.lightGray
let maxLength = 15
// email and mobile text chart min count
let emailMobileTextCharMinCount = 1
var countryCodeButton: UIButton = UIButton()
var defaultCounrtyCode : String  = "+" + getCountryPhonceCode(((Locale.current as NSLocale).object(forKey: .countryCode) as? String)!)
var launchTo : String = ""
//Country Code array of String
let countryCode = ["AU","AD","AE","AF","AG","AI","AL","AM","AO","AQ","AR","AS","AT","AW","AX","AZ","BA","BB","BD","BE","BF","BG","BH","BI","BJ","BL","BM","BN","BO","BQ","BR","BS","BT","BV","BW","BY","BZ","CA","CC","CD","CF","CG","CH","CI","CK","CL","CM","CN","CO","CR","CU","CV","CW","CX","CY","CZ","DE","DJ","DK","DM","DO","DZ","EC","EE","EG","EH","ER","ES","ET","FI","FJ","FK","FM","FO","FR","GA","GB","GD","GE","GF","GG","GH","GI","GL","GM","GN","GP","GQ","GR","GS","GT","GU","GW","GY","HK","HM","HN","HR","HT","HU","ID","IE","IL","IM","IN","IO","IQ","IR","IS","IT","JE","JM","JO","JP","KE","KG","KH","KI","KM","KN","KP","KR","KW","KY","KZ","LA","LB","LC","LI","LK","LR","LS","LT","LU","LV","LY","MA","MC","MD","ME","MF","MG","MH","MK","ML","MM","MN","MO","MP","MQ","MR","MS","MT","MU","MV","MW","MX","MY","MZ","NA","NC","NE","NF","NG","NI","NL","NO","NP","NR","NU","NZ","OM","PA","PE","PF","PG","PH","PK","PL","PM","PN","PR","PS","PT","PW","PY","QA","RE","RO","RS","RU","RW","SA","SB","SC","SD","SE","SG","SH","SI","SJ","SK","SL","SM","SN","SO","SR","SS","ST","SV","SX","SY","SZ","TC","TD","TF","TG","TH","TJ","TK","TL","TM","TN","TO","TR","TT","TV","TW","TZ","UA","UG","UM","US","UY","UZ","VA","VC","VE","VG","VI","VN","VU","WF","WS","XK","YE","YT","ZA","ZM","ZW"]
//Country Name array of String
let countryName = ["Australia","Andorra","United Arab Emirates","Afghanistan","Antigua and Barbuda","Anguilla","Albania","Armenia","Angola","Antarctica","Argentina","American Samoa","Austria","Aruba","Aland Islands","Azerbaijan","Bosnia and Herzegovina","Barbados","Bangladesh","Belgium","Burkina Faso","Bulgaria","Bahrain","Burundi","Benin","Saint Barthelemy","Bermuda","Brunei Darussalam","Bolivia,Plurinational State of","Bonaire","Brazil","Bahamas","Bhutan","Bouvet Island","Botswana","Belarus","Belize","Canada","Cocos (Keeling) Islands","Congo,The Democratic Republic of the","Central African Republic","Congo","Switzerland","Ivory Coast","Cook Islands","Chile","Cameroon","China","Colombia","Costa Rica","Cuba","Cape Verde","Curacao","Christmas Island","Cyprus","Czech Republic","Germany","Djibouti","Denmark","Dominica","Dominican Republic","Algeria","Ecuador","Estonia","Egypt","Western Sahara","Eritrea","Spain","Ethiopia","Finland","Fiji","Falkland Islands (Malvinas)","Micronesia,Federated States of","Faroe Islands","France","Gabon","United Kingdom","Grenada","Georgia","French Guiana","Guernsey","Ghana","Gibraltar","Greenland","Gambia","Guinea","Guadeloupe","Equatorial Guinea","Greece","South Georgia and the South Sandwich Islands","Guatemala","Guam","Guinea-Bissau","Guyana","Hong Kong","Heard Island and McDonald Islands","Honduras","Croatia","Haiti","Hungary","Indonesia","Ireland","Israel","Isle of Man","India","British Indian Ocean Territory","Iraq","Iran,Islamic Republic of","Iceland","Italy","Jersey","Jamaica","Jordan","Japan","Kenya","Kyrgyzstan","Cambodia","Kiribati","Comoros","Saint Kitts and Nevis","North Korea","South Korea","Kuwait","Cayman Islands","Kazakhstan","Lao People's Democratic Republic","Lebanon","Saint Lucia","Liechtenstein","Sri Lanka","Liberia","Lesotho","Lithuania","Luxembourg","Latvia","Libyan Arab Jamahiriya","Morocco","Monaco","Moldova,Republic of","Montenegro","Saint Martin","Madagascar","Marshall Islands","Macedonia,The Former Yugoslav Republic of","Mali","Myanmar","Mongolia","Macao","Northern Mariana Islands","Martinique","Mauritania","Montserrat","Malta","Mauritius","Maldives","Malawi","Mexico","Malaysia","Mozambique","Namibia","New Caledonia","Niger","Norfolk Island","Nigeria","Nicaragua","Netherlands","Norway","Nepal","Nauru","Niue","New Zealand","Oman","Panama","Peru","French Polynesia","Papua New Guinea","Philippines","Pakistan","Poland","Saint Pierre and Miquelon","Pitcairn","Puerto Rico","Palestinian Territory,Occupied","Portugal","Palau","Paraguay","Qatar","Reunion","Romania","Serbia","Russia","Rwanda","Saudi Arabia","Solomon Islands","Seychelles","Sudan","Sweden","Singapore","Saint Helena,Ascension and Tristan Da Cunha","Slovenia","Svalbard and Jan Mayen","Slovakia","Sierra Leone","San Marino","Senegal","Somalia","Suriname","South Sudan","Sao Tome and Principe","El Salvador","Sint Maarten","Syrian Arab Republic","Swaziland","Turks and Caicos Islands","Chad","French Southern Territories","Togo","Thailand","Tajikistan","Tokelau","East Timor","Turkmenistan","Tunisia","Tonga","Turkey","Trinidad and Tobago","Tuvalu","Taiwan","Tanzania,United Republic of","Ukraine","Uganda","U.S. Minor Outlying Islands","United States","Uruguay","Uzbekistan","Holy See (Vatican City State)","Saint Vincent and the Grenadines","Venezuela,Bolivarian Republic of","Virgin Islands,British","Virgin Islands,U.S.","Vietnam","Vanuatu","Wallis and Futuna","Samoa","Kosovo","Yemen","Mayotte","South Africa","Zambia","Zimbabwe"]
//Country Dial Code array of String
let counrtyDialCode = [ "+61","+376","+971","+93","+1","+1","+355","+374","+244","+672","+54","+1","+43","+297","+358","+994","+387","+1","+880","+32","+226","+359","+973","+257","+229","+590","+1","+673","+591","+599","+55","+1","+975","+47","+267","+375","+501","+1","+61","+243","+236","+242","+41","+225","+682","+56","+237","+86","+57","+506","+53","+238","+599","+61","+357","+420","+49","+253","+45","+1","+1","+213","+593","+372","+20","+212","+291","+34","+251","+358","+679","+500","+691","+298","+33","+241","+44","+1","+995","+594","+44","+233","+350","+299","+220","+224","+590","+240","+30","+500","+502","+1","+245","+595","+852","+000","+504","+385","+509","+36","+62","+353","+972","+44","+91","+246","+964","+98","+354","+39","+44","+1","+962","+81","+254","+996","+855","+686","+269","+1","+850","+82","+965","+345","+7","+856","+961","+1","+423","+94","+231","+266","+370","+352","+371","+218","+212","+377","+373","+382","+590","+261","+692","+389","+223","+95","+976","+853","+1","+596","+222","+1","+356","+230","+960","+265","+52","+60","+258","+264","+687","+227","+672","+234","+505","+31","+47","+977","+674","+683","+64","+968","+507","+51","+689","+675","+63","+92","+48","+508","+872","+1","+970","+351","+680","+595","+974","+262","+40","+381","+7","+250","+966","+677","+248","+249","+46","+65","+290","+386","+47","+421","+232","+378","+221","+252","+597","+211","+239","+503","+1","+963","+268","+1","+235","+262","+228","+66","+992","+690","+670","+993","+216","+676","+90","+1","+688","+886","+255","+380","+256","+1","+1","+598","+998","+379","+1","+58","+1","+1","+84","+678","+681","+685","+383","+967","+262","+27","+260","+263"]
func isValidEmail(emailStr:String) -> Bool {
//    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
    let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
        "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
    "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: emailStr)
}
// Mark: - Varibale for genrating fourdigit otp.
var fourDigitNumber: String {
    var result = ""
    repeat {
        // Create a string with a random number 0...9999
        result = String(format:"%04d", arc4random_uniform(10000) )
    } while result.count < 4
    return result
}

var consentData: NSDictionary = [:]
var parData: NSDictionary = [:]

struct Constants {
    
    static let arabic = "Arabic"
    static let english = "English"
    static let first = "First Name"
    static let last = "Last Name"
    static let backButtonTitle = "Back"
    static let phoneNumber = "Phone Number"
    static let changeLanguage = "Change Language"
    static let buyButton  = "Buy"
    static let yes = "Yes"
    static let no = "No"
    static let done = "Done"
    //Plan package constants
    static let startingAt = "Starting at"
    static let monthly = "monthly"
    static let quarterly = "quarterly"
    static let yearly = "yearly"
    //sliderView constants
    static let home = "Home"
    static let allTrainers = "All Trainers"
    static let planPackage = "Plan Package"
    static let setting = "Setting"
    static let signIn = "SignIn"
    static let myProfile = "My Profile"
    static let logout = "Logout"
    static let mySchedule = "My Schedule"
    static let guest = "Guest"
    static let skip = "SKIP"
    static let logoutMessage = "Are you sure you want to Logout?"
    //setting Screen constants
    static let emailPreference = "Email Preference"
    static let sMSPreference = "SMS Preference"
    static let remindClasses = "Remind me about my classes"
    static let changePassword = "Change Password"
    static let accountDeletion = "Account Deletion"
    static let confirm = "Confirm"
    static let accountDeletionMessage = "Are you sure you want to Delete the account from our system?"
    static let oK = "OK"
    static let cancel = "Cancel"
    static let capCancel = "CANCEL"
    static let capCancelled = "CANCELLED"
    static let somethingWentWrong = "Something went wrong, please try again"
    static let settingUpdatedStatus = "Setting is Updated"
    static let timeOutMessage = "Problem with Internet Connection, Please try using 4G."
    //Myscheduled Screen Constants
    static let capUpcoming = "UPCOMING"
    static let capPast = "PAST"
    static let freeClassesLeft = "Free Classes Left : "
    static let noPastDataPresent = "There is no past data present"
    static let cancelClassesMessage = "Class is cancelled successfully"
    static let selectMessage = "Please select the date"
    static let warning = "Warning"
    static let buyMoreSession = "Please buy more session your remaining session is "
    static let noUpcomingDataPresent = "There is no upcoming data present"
    static let dateLabel = "Date"
    static let dayLabel = "Day"
    static let durationLabel = "Duration"
    static let instructorLabel = "Instructor"
    static let startTimeLabel = "Start Time"
    static let endTimeLabel = "End Time"
    
    //Home Screen constants
    static let videoNotPlayMessage = "Video could not play"
    static let whatBMItitle = "WHAT IS BMI"
    static let whatBMImessage = "Body mass index (BMI) is a measure of body fat based on height and weight that applies to adult men and women."
    static let workingHourTitle = "WORKING HOURS & CLASSES"
    static let workingHourMessage = "Strength, Yoga, Dance Fitness, HRX"
    static let noClassesMessage = "There is no class for selected activity"
    static let male = "Male"
    static let female = "Female"
    static let activityFactor1 = "Little or no Exercise / desk job"
    static let activityFactor2 = "Light exercise / sports 1 – 3 days/ week"
    static let activityFactor3 = "Moderate Exercise, sports 3 – 5 days / week"
    static let activityFactor4 = "Heavy Exercise / sports 6 – 7 days / week"
    static let heightPlaceholder = "Height in cm"
    static let weightPlaceholder = "Weight in KG"
    static let agePlaceholder = "Age"
    static let genderTextPlaceholder = "Gender";
    static let activityFactorPlaceholder = "Selet an Activity Factor"
    static let genderLabelPlaceholder = "Select Gender"
    static let calculatBMIButtonTitle = "Calculate BMI"
    static let yourBMIText = "Your BMI is "
    static let thereforeYouAre = "therefore you are "
    static let underweight = "Underweight"
    static let healthy = "Healthy"
    static let overweight = "Overweight"
    static let obese = "Obese"
    static let bmiErrormessage = "Please give valid input for BMI report"
    static let bmi = "BMI"
    static let weightStatus = "WEIGHT STATUS"
    static let below = "Below 18.5"
    static let above = "30.0 & above"
    static let bmr = "BMR"
    static let bmrDescription = "Metabolic Rate"
    static let bmiDescription = "Body Mass Index"
    //Book Classes constants
    static let buyMoreButton = "BUY MORE"
    static let bookClassesButton = "BOOK CLASS"
    static let moreSessionMessage = "Please buy more session your remaining session is "
    static let selectSessionMessage = "Please select at least one session"
    static let success = "Success"
    static let bookedMessage = "Your session is booked"
    static let sessionPurcahseMessage = "Session purchase is completed"
    static let subscriptionPurchasedMessage = "Your subscription completed"
    static let signUpCompletionMessage = "Your registration is successful Please wait for approval from admin to login"
    static let emptySessionMessage = "No Session Found for selected Class"
    static let emptyDescriptionForPlan = "There is no Description"
    static let sessionAlertMessage = "Please select session"
    static let sessionFor = "Session for"
    
    static let selectNoOfSessionLabel = "Select no of sessions"
    static let buyMoreSessionLabel = "Buy More Session"
    //changePassword screen constants
    static let enterOldPasswordLabel = "Old password"
    static let newPasswordLabel = "New Password"
    static let confirmPasswordLabel = "Confirm New Password"
    static let changePasswordTitleLabel = "Change Password"
    static let changePasswordSubTitleLabel = "Enter details below to change your password."
    //ResetPassword screem  constants
    static let resetPasswordTitleLabel =  "Reset Password"
    static let resetPasswordSubTitleLabel = "Enter details below to reset your password."
    static let saveChangesButton  = "SAVE CHANGES"
    static let enterOTP = "Enter OTP"
    //password Changed screen Password
    static let passwordChangedSubTitleLabel = "You can now login into your account with your new password."
    static let passwordChangedTitleLabel =  "Password Changed"
    static let backToLoginButton = "BACK TO LOGIN"
    //restrict User Screen constants
    static let restrictTitleLabel = "Welcome to LYFT"
    static let restrictSubTitleLabel = "Unlock additional features on the LYFT app by creating an account or logging back in."
    static let termAndConditionButton =  "Terms of Service and Privacy Policy"
    static let loginButton = "LOGIN"
    static let signUpButton = "Signup"
    //verify Account Screen Constants
    static let verifyAccountTitleLabel = "Verify Account"
    static let verifyAccountSubTitleLabel = "Confirm your account by entering in the 6 digit code sent to your Email. It may take around 1-5 minutes."
    static let resendButton = "Resend Code"
    static let sixDigitCodelabel = "6 Digit Code"
    static let verifyAccountTextPlaceholder = "Enter verification code"
    static let capConfirmButton = "CONFIRM"
    //forgotPassword screen constants
    static let forgotPasswordTitleLabel = "Forgot Password"
    static let forgotPasswordButton = "Forgot Password ?"
    static let forgotPasswordSubTitleLabel = "Enter details below to reset your password"
    static let sbumitButton = "SUBMIT REQUEST"
    static let enterEmailPlaceholder = "Enter Email"
    static let emailLabel = "Email"
    //Login screen Constants
    static let loginTitleLabel = "Sign In to continue"
    static let usernameLabelPlaceholder = "Username"
    static let emailErrorLabel = "Email Error"
    static let passwordLabelPlaceholder = "Password"
    static let passwordErrorLabel = "Minimum 6 characters"
    static let signUpButtonForLogin = "NEW USER? SIGN UP"
    static let signInButton = "SIGN IN"
    static let capSignUPButton = "SIGN UP"
    static let nextButton = "NEXT"
    static let emailLoginErrorMessage = "Please enter valid email or mobile number"
    static let passwordCharLimitErrorMessage = "Password must contain 6 characters."
    //Register or signup screen constants
    static let signUpTitleLabel = "Register to enroll in to Lyft"
    static let firstNameLabel = "First Name"
    static let firstNameLabelError = "Please enter first name"
    static let lastNameLabel = "Last Name"
    static let lastNameLabelError = "Please enter last name"
    static let mailIdLabel = "Mail Id"
    static let mailIDLabelError = "Please enter valid mail id"
    static let phoneNumberLabelError = "Please enter phone number"
    static let emergencyLabel = "Emergency Phone Number"
    static let emergencyLabelError = "Please enter emergency phone number"
    static let cityLabel = "City"
    static let cityLabelError = "Please enter city"
    static let nationalIDLabel = "National Id"
    static let nationalIDLabelError = "Please enter national id"
    static let maritalStatusLabel = "Marital Status"
    static let selectMaritalStatusLabel = "Select Marital Status"
    static let occupationLabel = "Occupation"
    static let selectOccupationLabel = "Select Occupation"
    static let dobLabel = "DOB"
    static let entertDobLabel = "Enter DOB"
    static let passwordLabelError = "Password Error"
    static let confirmPasswordLabelError = "Confirm Password Error"
    static let validPhoneNumberError = "Please enter valid phone number"
    static let validemergencyPhoneNumberError = "Please enter valid emergency phone number"
    static let passwordCharLimitError = "Password must contain 6 characters"
    static let passwordContainOneDigitLimitError = "Password must contain atleast one digit"
    static let passwordMismatchError = "Password mismatch"
    static let enterConfirmMessageError = "Please enter confirm password"
    static let signUpTitle  = "Create Account"
    static let married = "Married"
    static let unMarried = "UnMarried"
    static let artist = "Artist"
    static let civil = "Civil"
    static let designers = "Designers"
    static let engineering = "Engineering"
    static let entrepreneur = "Entrepreneur"
    static let legal = "Legal"
    static let management = "Management"
    static let medical = "Medical"
    static let student = "Student"
    static let other = "Other"
    //My profile Screen constants
    static let  chooseImageLabel = "Choose Image"
    static let  cameraLabel = "Camera"
    static let  galleryLabel = "Gallery"
    static let cameraErrorMessage = "You don't have camera"
    static let joiningDateLabel = "Joining Date"
    static let emailVerifiedLabel = "Email Verified"
    static let changePhotoButton = "Change Photo"
    static let completeProfileButton = "Complete Profile"
    static let membershipTypeLabel = "Membership Type"
    static let memberShipDefaultMessage = "You don't have any membership yet, Please Purchase"
    static let basicInformationTitle = "Basic Information"
    static let editProfile = "Edit Profile"
    static let updateProfile = "Update Profile"
    static let step1of3 = "Steps 1 of 3"
    static let step2of3 = "Steps 2 of 3"
    static let step3of3 = "Steps 3 of 3"
    static let uploadPhoto = "Upload Photo"
    static let uploadButton = "Upload"
    static let submit = "Submit"
    static let parentDOBLabel = "Parent's Date of Birth"
    static let viewConsent = "View Consent"
}

struct ThawaniPay {
    var is_paid : Int?
    var request_id : Int?
    var payment_mode : String?
    var amount : Double?
}

enum  PaymentType : String, Codable {
    
    case CASH = "CASH"
    case THAWANI = "thawani"
    
    var image : UIImage? {
        var name = "ic_error"
        switch self {
        case .CASH:
            name = "money_icon"
        case .THAWANI:
            name = "money_icon"
        }
      return UIImage(named: name)
   }
}

//use of the thawani payment
//var thawani = ThawaniPay()
//thawani.is_paid = self.currentRequest?.paid
//thawani.amount = self.currentRequest?.payment?.total
//thawani.request_id = self.currentRequest?.id
//thawani.payment_mode = PaymentType.THAWANI.rawValue
//self.presenter?.post(api: .thawaniPayment, data: thawani.toData())


//MARK BMI Calculator

struct BMIStruct: CustomStringConvertible {
    let mass: Double
    let height: Double
    var bmi: Double {
        return ((mass / height / height) *  10000).round(to: 1)
    }

    // This is a var to conform to the CustomStringCovertible protocol
    var description: String {
        switch bmi {
        case 0..<18.5:
            return String(format: "\(Constants.yourBMIText.localize()) %.1f, \(Constants.thereforeYouAre.localize()) \(Constants.underweight.localize())", bmi)
        case 18.5..<24.9:
//            return String(format: "Your BMI is %.1f, therefore you are of Healthy", bmi)
            return String(format: "\(Constants.yourBMIText.localize()) %.1f, \(Constants.thereforeYouAre.localize()) \(Constants.healthy.localize())", bmi)
        case 25..<29.9:
//            return String(format: "Your BMI is %.1f, therfor you are Overweight", bmi)
            return String(format: "\(Constants.yourBMIText.localize()) %.1f, \(Constants.thereforeYouAre.localize()) \(Constants.overweight.localize())", bmi)
        case 30...:
//            return String(format: "Your BMI is %.1f, therfor you are Obese", bmi)
            return String(format: "\(Constants.yourBMIText.localize()) %.1f, \(Constants.thereforeYouAre.localize()) \(Constants.obese.localize())", bmi)
        default:
            return Constants.bmiErrormessage.localize() // this is to shut up the compiler
        }
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
