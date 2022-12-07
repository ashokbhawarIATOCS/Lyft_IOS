//
//  PasswordChangedVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import UIKit

class PasswordChangedVC: UIViewController {

    var newPassword : String!
    var userEmailId : String!

    @IBOutlet weak var backToLoginButton: CustomButtonDesign!
    @IBOutlet weak var changePasswordTitleLabel: UILabel!
    @IBOutlet weak var changePasswordSubTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changePasswordTitleLabel.text = Constants.passwordChangedTitleLabel.localize()
        changePasswordSubTitleLabel.text = Constants.passwordChangedSubTitleLabel.localize()
        backToLoginButton.setTitle(Constants.backToLoginButton.localize(), for: .normal)
        // Do any additional setup after loading the view.
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
    
    @IBAction func backToLoginButtonAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: passwordEmailSendNotificationKey), object: nil, userInfo: ["userEmailId":userEmailId!, "newPassword": newPassword!])
        
        _ = self.navigationController?.backToViewController(vc: LoginVC.self)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: passwordEmailSendNotificationKey), object: nil, userInfo: ["userEmailId":userEmailId!, "newPassword": newPassword!])
         _ = self.navigationController?.backToViewController(vc: LoginVC.self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
