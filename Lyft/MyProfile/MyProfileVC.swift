//
//  MyProfileVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 14/10/22.
//

import UIKit

class MyProfileVC: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var changePhotoButton: RoundButton!
    @IBOutlet weak var completeProfileButton: RoundButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundProfileImageView: UIImageView!
    
    @IBOutlet weak var firstNameLabel: PaddingLabel!
    @IBOutlet weak var firstNameValueLabel: PaddingLabel!
    
    @IBOutlet weak var lastNameLabel: PaddingLabel!
    @IBOutlet weak var lastNameValueLabel: PaddingLabel!
    
    @IBOutlet weak var memberTypeLabel: PaddingLabel!
    @IBOutlet weak var memberTypeValueLabel: PaddingLabel!
    
    @IBOutlet weak var emailLabel: PaddingLabel!
    @IBOutlet weak var emailValueLabel: PaddingLabel!
    
    @IBOutlet weak var mobileLabel: PaddingLabel!
    @IBOutlet weak var mobileValueLabel: PaddingLabel!
    
    @IBOutlet weak var nationalLabel: PaddingLabel!
    @IBOutlet weak var nationalValueLabel: PaddingLabel!
    
    @IBOutlet weak var joiningDateLabel: PaddingLabel!
    @IBOutlet weak var joiningDateValueLabel: PaddingLabel!
    
    @IBOutlet weak var cityLabel: PaddingLabel!
    @IBOutlet weak var cityValueLabel: PaddingLabel!
    
    @IBOutlet weak var occupationLabel: PaddingLabel!
    @IBOutlet weak var occupationValueLabel: PaddingLabel!
    
    @IBOutlet weak var dobLabel: PaddingLabel!
    @IBOutlet weak var dobValueLabel: PaddingLabel!
    
    @IBOutlet weak var emailVerifiedLabel: PaddingLabel!
    @IBOutlet weak var emailVerifiedValueLabel: PaddingLabel!
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    var profileDetails = [String:Any]()    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = Constants.myProfile.localize()
        
        firstNameLabel.text = Constants.firstNameLabel.localize()
        lastNameLabel.text = Constants.lastNameLabel.localize()
        emailLabel.text = Constants.emailLabel.localize()
        mobileLabel.text = Constants.phoneNumber.localize()
        nationalLabel.text = Constants.nationalIDLabel.localize()
        joiningDateLabel.text = Constants.joiningDateLabel.localize()
        dobLabel.text = Constants.dobLabel.localize()
        cityLabel.text =  Constants.cityLabel.localize()
        occupationLabel.text = Constants.occupationLabel.localize()
        emailVerifiedLabel.text = Constants.emailVerifiedLabel.localize()
        changePhotoButton.setTitle(Constants.changePhotoButton.localize(), for: .normal)
        completeProfileButton.setTitle(Constants.completeProfileButton.localize(), for: .normal)
        memberTypeLabel.text = Constants.membershipTypeLabel.localize()
        
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        baseBackgroundView()
        if UserDefaults.standard.string(forKey: kUserProfilePicture)  != nil {
            self.profileImageView?.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: kUserProfilePicture)! , PlaceHolderImage: UIImage.init(named: "userPlaceholder")!)
            self.backgroundProfileImageView?.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: kUserProfilePicture)! , PlaceHolderImage: UIImage.init(named: "userPlaceholder")!)
        }
       
       
        completeProfileButton.isHidden = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        
        let editProfileButtonItem = UIBarButtonItem(title:Constants.editProfile.localize(), style: .plain, target: self, action: #selector(editUserProfile))
            self.navigationItem.rightBarButtonItem  = editProfileButtonItem
        self.callingViewProfileAPI()
    }
    
    @objc func editUserProfile(){
        let vc = kMainStoryboard.instantiateViewController(withIdentifier: editProfileVCSID) as? BasicProfileVC
        vc?.cameFromScreen = "ProfileScreen"
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    
    func callingViewProfileAPI(){
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
                                    self.firstNameValueLabel.text = self.profileDetails["fname"] as? String
                                    self.lastNameValueLabel.text = self.profileDetails["lname"] as? String
                                   
                                    self.emailValueLabel.text = self.profileDetails["email"] as? String
                                    self.mobileValueLabel.text = self.profileDetails["phonenumber"] as? String
                                    self.nationalValueLabel.text = self.profileDetails["national_id_number"] as? String
                                    self.joiningDateValueLabel.text = self.profileDetails["created_at"] as? String
                                    self.cityValueLabel.text = self.profileDetails["city"] as? String
                                    self.occupationValueLabel.text = self.profileDetails["occupation"] as? String
                                    self.dobValueLabel.text = self.profileDetails["dob"] as? String
                                    self.emailVerifiedValueLabel.text = self.profileDetails["email_verified"] as? String
                                    self.backgroundProfileImageView?.imageFromServerURL(urlString: self.profileDetails["photo"] as! String, PlaceHolderImage: UIImage.init(named: "userPlaceholder")!)
                                    self.profileImageView?.imageFromServerURL(urlString: self.profileDetails["photo"] as! String, PlaceHolderImage: UIImage.init(named: "userPlaceholder")!)
                                    if(self.profileDetails["membership_id"] as? String != nil){
                                        self.memberTypeValueLabel.text = self.profileDetails["membership_id"] as? String
                                    }else{
                                        self.memberTypeValueLabel.text = Constants.memberShipDefaultMessage.localize()
                                    }
                                    if(self.profileDetails["reg_completed"] as? String == "0"){
                                        UserDefaults.standard.set(0, forKey: kRegCompleted)
                                        self.completeProfileButton.isHidden = false
                                    } else{
                                        UserDefaults.standard.set(1, forKey: kRegCompleted)
                                        self.completeProfileButton.isHidden = true
                                    }
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
    
    func uplaodProfilePictureAPI(image: UIImage){
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + uploadProfilePhotoAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            param["photo"]  =  convertImageToBase64String(img: image)
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            
                            UserDefaults.standard.set(jsondictionary["userid"], forKey: kUserId)
                            UserDefaults.standard.set(jsondictionary["photo "] as? String, forKey: kUserProfilePicture)
                            NotificationCenter.default.post(name: Notification.Name("loadProfileImageOnUpdate"), object: nil)
                            
                            DispatchQueue.main.async {
                               //code for the update profile picture
                                self.profileImageView.image = image
                                self.backgroundProfileImageView.image = image
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
    
    @IBAction func changePhotoButtonAction(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
                //here is the image
            self.uplaodProfilePictureAPI(image: image)
            }
    }
    
    @IBAction func completeProfileButtonAction(_ sender: Any) {
        //navigate to the complete profile screen
        let vc = kMainStoryboard.instantiateViewController(withIdentifier: editProfileVCSID) as? BasicProfileVC
        vc?.cameFromScreen = "CompleteProfile"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
