//
//  RistrictUserLoginVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import UIKit

class RistrictUserLoginVC: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var termAndConditionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = Constants.restrictTitleLabel.localize()
        subTitleLabel.text = Constants.restrictSubTitleLabel.localize()
        loginButton.setTitle(Constants.loginButton.localize(), for: .normal)
        signupButton.setTitle(Constants.capSignUPButton.localize(), for: .normal)
        
        let termAndConditonAttributedTitle = NSAttributedString(string: Constants.termAndConditionButton.localize(), attributes:[.underlineStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.gray])
        
        termAndConditionButton.setAttributedTitle(termAndConditonAttributedTitle, for: .normal)
        self.customViewStyleMethod()
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
    //function for setup the design of the view.
    func customViewStyleMethod()
    {
        //set the space between the button text and image for facebook
        facebookButton.centerTextAndImage(spacing: 5.0)
    }
    
    //Custom Button Action which is used in the screen.
    @IBAction func closeButtonAction(_ sender: Any) {
        //set the back navigation
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func facebookLoginButtonAction(_ sender: Any) {
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let vc = kMainStoryboard.instantiateViewController(withIdentifier: loginVCSID) as? LoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        //Navigate to the signup screen.
        let vc = kMainStoryboard.instantiateViewController(withIdentifier: signupVCSID) as? SignUpVC
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    //termAndPrivacyButtonAction method.
    @IBAction func termAndPrivacyButtonAction(_ sender: Any) {
        //navigate or load the term and privacy policy.
        print("View More button clicked take the action and naviagte to the web page")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: thawaniPaymentVCSID) as? ThawaniPaymentVC
        vc?.payPalUrl = "https://lyftoman.com/terms-and-conditions"
        vc?.thawaniPaymentURLLoad = false
        self.navigationController?.pushViewController(vc!, animated: true)
   
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
