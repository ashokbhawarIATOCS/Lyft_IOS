//
//  BookClassesVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 21/11/22.
//

import UIKit

class BookClassesVC: UIViewController {

    @IBOutlet var bookClassesTableView: UITableView!
    @IBOutlet weak var leftClassesLabel: UILabel!
    @IBOutlet weak var bookClassesButton: CustomButtonDesign!
    @IBOutlet weak var buyMoreButton: CustomButtonDesign!
    
    var allSessionList = [[String:Any]]()
    var classID: String = ""
    var previousPurchaseClassID: String = ""
    var remaininglass = ""
    var freeClasses = ""
    var selectedSessionArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.callBookClassesApiAgain), name: Notification.Name("callBookclassesApi"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        getClassesApiCalling()
        bookClassesButton.isHidden =  true
        buyMoreButton.isHidden = true
        bookClassesTableView.delegate = self
        bookClassesTableView.dataSource = self
        self.bookClassesTableView.allowsMultipleSelection = true
        self.bookClassesTableView.allowsMultipleSelectionDuringEditing = true
        // Register TableView Cell
        self.bookClassesTableView.register(BookClassesTVC.nib, forCellReuseIdentifier: BookClassesTVC.identifier)
        // Do any additional setup after loading the view.
        buyMoreButton.setTitle(Constants.buyMoreButton.localize(), for: .normal)
        bookClassesButton.setTitle(Constants.bookClassesButton.localize(), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        remaininglass = ""
        selectedSessionArray = []
        classID = ""
    }
    
    //MARK: - - - - - Method for receiving Data through Post Notificaiton - - - - -
        @objc func callBookClassesApiAgain(notification: Notification) {
            getClassesApiCalling()
        }
    
    @IBAction func bookClassesButtonAction(_ sender: Any) {
        
        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
            let vc = kMainStoryboard.instantiateViewController(withIdentifier: ristrictUserLoginSID) as? RistrictUserLoginVC
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.backButtonTitle.localize(), style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else{
            if(freeClasses != "0"){
                if(!selectedSessionArray.isEmpty){
                    if(selectedSessionArray.count <= Int(remaininglass)!){
                    self.bookSessionApiCalling( sessionIdWithCommaSeprated: selectedSessionArray)
                    }else{
                        self.alert(message:"\(Constants.moreSessionMessage.localize()) \(remaininglass)", title: Constants.warning.localize())
                    }
                }else{
                    self.alert(message: Constants.selectSessionMessage.localize(), title: Constants.warning.localize())
                }
            }else{
                if UserDefaults.standard.string(forKey: memberShipID)  != nil {
                    if(!selectedSessionArray.isEmpty){
                        if(selectedSessionArray.count <= Int(remaininglass)!){
                        self.bookSessionApiCalling( sessionIdWithCommaSeprated: selectedSessionArray)
                        }else{
                            self.alert(message:"\(Constants.moreSessionMessage.localize()) \(remaininglass)", title: Constants.warning.localize())
                        }
                    }else{
                        self.alert(message: Constants.selectSessionMessage.localize(), title: Constants.warning.localize())
                    }
                }else{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: planPackageSID) as? PlanPackageShowVC
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
           
        }
    }

    @IBAction func buyMoreButtonAction(_ sender: Any) {

        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
            let vc = kMainStoryboard.instantiateViewController(withIdentifier: ristrictUserLoginSID) as? RistrictUserLoginVC
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.backButtonTitle.localize(), style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else{
            if UserDefaults.standard.value(forKey: memberShipID) as? String != nil{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: buySessionSID) as? BuySessionVC
            vc?.modalPresentationStyle = .popover
            present(vc!, animated: true, completion: nil)
            }else{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: planPackageSID) as? PlanPackageShowVC
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    func bookSessionApiCalling(sessionIdWithCommaSeprated: [String]){
            if Connectivity.isConnectedToInternet {
                let urlString =  kBaseURL + bookSessionApi;
                self.view.activityStartAnimating()
                
                var param = [String: Any] ()
                param["session_ids"]  =  sessionIdWithCommaSeprated.joined(separator: ",")
                self.view.isUserInteractionEnabled = false
                CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.activityStopAnimating()
                        switch response {
                        case .success(let dictionary as [String: Any]):
                            if (dictionary["status"] as? Int == 200) {
                                let jsondictionary = dictionary["results"] as! NSDictionary
                                DispatchQueue.main.async {
                                    //handle the book classes successfully messsage
                                    let alertController = UIAlertController(title: Constants.success.localize() , message: Constants.bookedMessage.localize(), preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: Constants.oK.localize(), style: UIAlertAction.Style.default, handler: { _ in
                                        self.getClassesApiCalling()
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                    self.present(alertController, animated: true, completion:nil)
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
    func getClassesApiCalling(){
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + getClassesAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            param["class_id"]  = classID
            param["previous_session_purchase_id"]  = previousPurchaseClassID
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            DispatchQueue.main.async {
//                                if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
//                                    self.remaininglass = String(jsondictionary["free_sessions_left"] as! Int)
//                                }else{
                                
//                                    let remainingCount = jsondictionary["free_sessions_left"] as! String
//                                    self.remaininglass = remainingCount
//                                    self.freeClasses = remainingCount
                                
                                self.remaininglass = String(jsondictionary["free_sessions_left"] as! Int)
                                self.freeClasses =  self.remaininglass
//
//                                }
                                self.leftClassesLabel.text =  Constants.freeClassesLeft.localize() + self.remaininglass
                                self.buyMoreButton.isHidden = false
                                self.allSessionList = jsondictionary["classes"] as! [[String : Any]]
                                if( self.allSessionList.count > 0){
                                    self.bookClassesButton.isHidden =  false
                                }else{
                                    self.bookClassesButton.isHidden =  true
                                }
                                self.bookClassesTableView.reloadData()
                                
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
extension BookClassesVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension BookClassesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.allSessionList.count == 0 {
            self.bookClassesTableView.setEmptyMessage(Constants.emptySessionMessage.localize())
            } else {
                self.bookClassesTableView.restore()
            }
        return self.allSessionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookClassesTVC.identifier, for: indexPath) as? BookClassesTVC else { fatalError("xib doesn't exist") }
        
        cell.classImageView?.imageFromServerURL(urlString: self.allSessionList[indexPath.row]["class_image"] as! String, PlaceHolderImage: UIImage.init(named: "AppLogoIcon")!)
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.instructorValueLabel.text = self.allSessionList[indexPath.row]["instructor_name_ar"] as? String ?? ""
            cell.descriptionLabel.text = self.allSessionList[indexPath.row]["summary_ar"] as? String ?? ""
        }else{
            cell.instructorValueLabel.text = self.allSessionList[indexPath.row]["instructor_name_en"] as? String ?? ""
            cell.descriptionLabel.text = self.allSessionList[indexPath.row]["summary_en"] as? String ?? ""
        }
        cell.endTimeValueLabel.text = self.allSessionList[indexPath.row]["end_time"] as? String ?? ""
        cell.startTimeValueLabel.text = self.allSessionList[indexPath.row]["start_time"] as? String ?? ""
        cell.durationValueLabel.text = self.allSessionList[indexPath.row]["duration"] as? String ?? ""
        cell.dayValueLabel.text = self.allSessionList[indexPath.row]["day"] as? String ?? ""
        cell.dateValueLabel.text = self.allSessionList[indexPath.row]["date"] as? String ?? ""
        
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSessionArray.append(self.allSessionList[indexPath.row]["session_id"] as? String ?? "")
        print("Selected Session ID:-  \(String(describing: selectedSessionArray))")
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if (selectedSessionArray.contains(self.allSessionList[indexPath.row]["session_id"] as? String ?? "")) {
            let index = selectedSessionArray.firstIndex(of: self.allSessionList[indexPath.row]["session_id"] as? String ?? "")
            selectedSessionArray.remove(at: index!)
            print("Removed Selected Session ID:-  \(String(describing: selectedSessionArray))")
        }
        
    }
   
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
