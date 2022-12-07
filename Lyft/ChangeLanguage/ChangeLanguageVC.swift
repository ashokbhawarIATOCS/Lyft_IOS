//
//  ChangeLanguageVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 14/10/22.
//

import UIKit


class ChangeLanguageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var changeLanguageTableView: UITableView!
    
    private let changeLanguage = 0
    private var selectedLanguage : Language = .arabic {
        didSet{
              setLocalization(language: selectedLanguage)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeLanguageTableView.delegate = self
        changeLanguageTableView.dataSource = self
        self.navigationItem.title = Constants.changeLanguage.localize()
        self.changeLanguageTableView.register(ChangeLanguageTVC.nib, forCellReuseIdentifier: ChangeLanguageTVC.identifier)
        
        if let lang = UserDefaults.standard.value(forKey: klanguage) as? String, let language = Language(rawValue: lang) {
            selectedLanguage = language
        }
        self.navigationController?.title = Constants.changeLanguage
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Language.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChangeLanguageTVC.identifier, for: indexPath) as? ChangeLanguageTVC else { fatalError("xib doesn't exist") }
        
            
            if (selectedLanguage == .english && Language.allCases[indexPath.row].title.localize() == "Arabic"){
                cell.labelTitle.text = Constants.english.localize()
            }else {
                cell.labelTitle.text = Language.allCases[indexPath.row].title.localize()
            }
        cell.imageViewIcon.tintColor = borderColorandThemeColor
        cell.imageViewIcon.image = (self.selectedLanguage == Language.allCases[indexPath.row] ? #imageLiteral(resourceName: "tickArrow") : #imageLiteral(resourceName: "radio_off")).withRenderingMode(.alwaysTemplate)
        cell.selectionStyle = .none
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let language = Language.allCases[indexPath.row]
        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
            //Navigate to the ResetPassword screen.
            UserDefaults.standard.set(language.code, forKey: klanguage)
            setLocalization(language: language)
            UserDefaults.standard.set(self.selectedLanguage.code, forKey: klanguage)
            self.selectedLanguage = Language.allCases[indexPath.row]
            self.changeLanguageTableView.reloadRows(at: (0..<Language.allCases.count).map({IndexPath(row: $0, section: self.changeLanguage)}), with: .automatic)

            guard let transitionView = self.navigationController?.view else {return}
            UIView.beginAnimations("anim", context: nil)
            UIView.setAnimationDuration(0.8)
            UIView.setAnimationCurve(.easeInOut)
            UIView.setAnimationTransition(self.selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
            UIView.commitAnimations()
            NotificationCenter.default.post(name: Notification.Name("reloadTheMainViewController"), object: nil)
        }else{
           
           //call the api for language Update
            if Connectivity.isConnectedToInternet {
                
                let urlString =  kBaseURL + kChangeLanguageAPI;
                self.view.activityStartAnimating()
                
                var param = [String: Any] ()
                    param["lan"]  = language.code
            
                self.view.isUserInteractionEnabled = false
                
                CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                        self.view.activityStopAnimating()
                        
                        switch response {
                        case .success(let dictionary as [String: Any]):
                            if (dictionary["status"] as? Int == 200) {
                                _ = dictionary["results"] as! NSDictionary
                                
                                DispatchQueue.main.async {
                                    //Navigate to the ResetPassword screen.
                                    UserDefaults.standard.set(self.selectedLanguage.code, forKey: klanguage)
                                    self.selectedLanguage = Language.allCases[indexPath.row]
                                    self.changeLanguageTableView.reloadRows(at: (0..<Language.allCases.count).map({IndexPath(row: $0, section: self.changeLanguage)}), with: .automatic)

                                    if language == .arabic {
                                        self.selectedLanguage = .arabic
                                        setLocalization(language: .arabic)
                                        self.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
                                        UIView.appearance().semanticContentAttribute = .forceRightToLeft

                                    }else{
                                        self.selectedLanguage = .english
                                        setLocalization(language: .english)
                                        self.navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
                                        UIView.appearance().semanticContentAttribute = .forceLeftToRight
                                    }

                                    guard let transitionView = self.navigationController?.view else {return}
                                    UIView.beginAnimations("anim", context: nil)
                                    UIView.setAnimationDuration(0.8)
                                    UIView.setAnimationCurve(.easeInOut)
                                    UIView.setAnimationTransition(self.selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
                                    UIView.commitAnimations()
                                    
                                    NotificationCenter.default.post(name: Notification.Name("reloadTheMainViewController"), object: nil)
                                    
//                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: mainHomeForMenuVCSID) as? MainViewController
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
        
        
    }
    
    
}
