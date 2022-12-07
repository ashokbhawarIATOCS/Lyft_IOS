//
//  SettingsVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 14/10/22.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet var sideMenuBtn: UIBarButtonItem!

    @IBOutlet weak var settingTableView: UITableView!
    var skipSettingList = [ Constants.emailPreference.localize(), Constants.sMSPreference.localize(),Constants.remindClasses.localize()]
    var allSettingList = [Constants.emailPreference.localize(), Constants.sMSPreference.localize(),Constants.remindClasses.localize(),Constants.changePassword.localize(),Constants.accountDeletion.localize()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        self.navigationItem.title = Constants.setting.localize()
        self.settingTableView.backgroundColor = UIColor.clear
        // Register TableView Cell
        self.settingTableView.register(SettingTVC.nib, forCellReuseIdentifier: SettingTVC.identifier)
        settingTableView.allowsSelection = true
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
    func accountDeletionAlertCall(){
        let dialogMessage = UIAlertController(title: Constants.confirm.localize(), message: Constants.accountDeletionMessage.localize(), preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: Constants.oK.localize(), style: .default, handler: { (action) -> Void in
             self.accountDeletionApiCalling()
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: Constants.cancel.localize(), style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }

        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func accountDeletionApiCalling(){
        
        if Connectivity.isConnectedToInternet {

            let urlString =  kBaseURL + kAccountDeletionAPI;
            self.view.activityStartAnimating()

            var param = [String: Any] ()
            param["Accept"]  = "application/json"
            param["Authorization"]  = UserDefaults.standard.value(forKey: kSessionAccessToken) as? String
            self.view.isUserInteractionEnabled = false

            CustomAlmofire.dataTask_GET(Foundation.URL(string: urlString)!, method: .get, param: param) { response in

                DispatchQueue.main.async(execute: {() -> Void in

                    self.view.activityStopAnimating()
                    self.view.isUserInteractionEnabled = true
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                          //Navigate to the logion screen and clear the userdefault
                            resetAllUserDefaults()
                            let center = UNUserNotificationCenter.current()
                            center.removeAllDeliveredNotifications()
                            let vc = MainStoryboard.instantiateViewController(withIdentifier: loginVCSID) as? LoginVC
                            self.navigationController?.pushViewController(vc!, animated: true)
                        }
                        break
                    case .failure(let error):
                        if error.domain == "Timeout" {
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
    
    func callChangePasswordScreen(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: changePasswordScreenSID) as? ChangePasswordVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func callSwitchNotificationONOFFApi(typeOfService: String, serviceStatus: Bool){
        return
        // Code for the API calling for the SMS and and Pass the varibale for the parameter in the api calling.
        if Connectivity.isConnectedToInternet {
            let urlString =  kBaseURL + kForgotPasswordAPI;
            self.view.activityStartAnimating()
            var param = [String: Any] ()
            param["notificationType"]  = typeOfService
            param["Status"]  = serviceStatus
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.activityStopAnimating()
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            DispatchQueue.main.async {
                             //show the alert message of change the status.
                                self.alert(message: Constants.settingUpdatedStatus.localize())
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

// MARK: - UITableViewDelegate
extension SettingsVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
            return self.skipSettingList.count
        }else{
            return self.allSettingList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTVC.identifier, for: indexPath) as? SettingTVC else { fatalError("xib doesn't exist") }
        
        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
            cell.titleLabel.text = skipSettingList[indexPath.row]
            
            if(indexPath.row == 0){
                cell.nextArrowImageView.isHidden = true
                if (UserDefaults.standard.bool(forKey: settingEmailNotification) == true) {
                    cell.switchButton.isOn = true
                }else{
                    cell.switchButton.isOn = false
                }
                cell.switchButtonPressedON = { [self] in
                    UserDefaults.standard.set("true", forKey: settingEmailNotification)
                    //code for the On Button for the Email
                    self.callSwitchNotificationONOFFApi(typeOfService: "Email", serviceStatus: true)
                }
                cell.switchButtonPressedOFF = {
                    UserDefaults.standard.set("false", forKey: settingEmailNotification)
                    //code for the Off Button for the Email
                    self.callSwitchNotificationONOFFApi(typeOfService: "Email", serviceStatus: false)
                }
            }else  if(indexPath.row == 1){
                if (UserDefaults.standard.bool(forKey: settingSMSNotification) == true) {
                    cell.switchButton.isOn = true
                }else{
                    cell.switchButton.isOn = false
                }
                cell.nextArrowImageView.isHidden = true
                cell.switchButtonPressedON = {
                    UserDefaults.standard.set("true", forKey: settingSMSNotification)
                    //code for the On Button for the SMS
                    self.callSwitchNotificationONOFFApi(typeOfService: "SMS", serviceStatus: true)
                }
                cell.switchButtonPressedOFF = {
                    UserDefaults.standard.set("false", forKey: settingSMSNotification)
                    //code for the Off Button for the SMS
                    self.callSwitchNotificationONOFFApi(typeOfService: "SMS", serviceStatus: false)
                }
                
            } else {
                if (UserDefaults.standard.bool(forKey: settingRemindClassesNotification) == true) {
                    cell.switchButton.isOn = true
                }else{
                    cell.switchButton.isOn = false
                }
                cell.nextArrowImageView.isHidden = true
                cell.switchButtonPressedON = {
                    UserDefaults.standard.set("true", forKey: settingRemindClassesNotification)
                    //code for the On Button for the Remind my class
                    self.callSwitchNotificationONOFFApi(typeOfService: "Remind Classes", serviceStatus: true)
                }
                cell.switchButtonPressedOFF = {
                    UserDefaults.standard.set("false", forKey: settingRemindClassesNotification)
                    //code for the off Button for the Remind my class
                    self.callSwitchNotificationONOFFApi(typeOfService: "Remind Classes", serviceStatus: false)
                }
            }
        }else{
            cell.titleLabel.text = allSettingList[indexPath.row]
            if(indexPath.row == 0){
                if (UserDefaults.standard.bool(forKey: settingEmailNotification) == true) {
                    cell.switchButton.isOn = true
                }else{
                    cell.switchButton.isOn = false
                }
                cell.nextArrowImageView.isHidden = true
                cell.switchButtonPressedON = {
                    UserDefaults.standard.set("true", forKey: settingEmailNotification)
                    //code for the On Button for the Email
                    self.callSwitchNotificationONOFFApi(typeOfService: "Email", serviceStatus: true)
                }
                cell.switchButtonPressedOFF = {
                    UserDefaults.standard.set("false", forKey: settingEmailNotification)
                    //code for the Off Button for the Email
                    self.callSwitchNotificationONOFFApi(typeOfService: "Email", serviceStatus: false)
                }
            }else  if(indexPath.row == 1){
                if (UserDefaults.standard.bool(forKey: settingSMSNotification) == true) {
                    cell.switchButton.isOn = true
                }else{
                    cell.switchButton.isOn = false
                }
                cell.nextArrowImageView.isHidden = true
                cell.switchButtonPressedON = {
                    UserDefaults.standard.set("true", forKey: settingSMSNotification)
                    //code for the On Button for the SMS
                    self.callSwitchNotificationONOFFApi(typeOfService: "SMS", serviceStatus: true)
                }
                cell.switchButtonPressedOFF = {
                    UserDefaults.standard.set("false", forKey: settingSMSNotification)
                    //code for the Off Button for the SMS
                    self.callSwitchNotificationONOFFApi(typeOfService: "SMS", serviceStatus: false)
                } 
            } else if (indexPath.row == 2){
                 if (UserDefaults.standard.bool(forKey: settingRemindClassesNotification) == true) {
                     cell.switchButton.isOn = true
                 }else{
                     cell.switchButton.isOn = false
                 }
                cell.nextArrowImageView.isHidden = true
                cell.switchButtonPressedON = {
                    UserDefaults.standard.set("true", forKey: settingRemindClassesNotification)
                    //code for the On Button for the Remind my class
                    self.callSwitchNotificationONOFFApi(typeOfService: "Remind Classes", serviceStatus: true)
                }
                cell.switchButtonPressedOFF = {
                    UserDefaults.standard.set("false", forKey: settingRemindClassesNotification)
                    //code for the off Button for the Remind my class
                    self.callSwitchNotificationONOFFApi(typeOfService: "Remind Classes", serviceStatus: false)
                }
            }else if (indexPath.row == 3){
                cell.nextArrowImageView.isHidden = false
                cell.switchButton.isHidden = true
            }else if (indexPath.row == 4){
                cell.nextArrowImageView.isHidden = true
                cell.switchButton.isHidden = true
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (UserDefaults.standard.bool(forKey: skipUserLogin) == false) {
         if indexPath.row == 3{
                self.callChangePasswordScreen()
            } else if (indexPath.row == 4){
                self.accountDeletionAlertCall()
            }
        }
    }
}
