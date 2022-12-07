//
//  BuySessionVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 24/11/22.
//

import UIKit

class BuySessionVC: UIViewController {

    @IBOutlet weak var sessionBaseView: UIView!
    @IBOutlet weak var selectPaymentModeLabel: UILabel!
    @IBOutlet weak var selectSessionslabel: UILabel!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var radioButtonForOnlineImageView: UIImageView!
    @IBOutlet weak var buyButton: CustomButtonDesign!
    @IBOutlet weak var sessionTableView: UITableView!
    var allSessionList = [[String:Any]]()
    var selectedCell = false
    var isChecked = false
    var indexpathRow: Int = 0
    var paymentRequestRefrenceID : String = ""
    var paymentMode : String = ""
    var purcahseSession : String = ""
    var purcahsePrice : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionTableView.delegate = self
        sessionTableView.dataSource = self
        sessionBaseView.layer.cornerRadius =  30
        self.navigationController?.isNavigationBarHidden = true
        self.sessionTableView.register(BuySessionTVC.nib, forCellReuseIdentifier: BuySessionTVC.identifier)
        
        selectSessionslabel.text = Constants.selectNoOfSessionLabel.localize()
        selectPaymentModeLabel.text = Constants.buyMoreSessionLabel.localize()
//        radioButtonForOnlineImageView.image = UIImage.init(named: "radio_on")
//        paymentMode = "Online"
//        isChecked = true
        buyButton.setTitle(Constants.buyButton.localize(), for: .normal)
        
        callGetSessionListAPI()
        // Do any additional setup after loading the view.
    }
    
//    MARK: - API calling For Training
    func callGetSessionListAPI() {
        if Connectivity.isConnectedToInternet {

            let urlString =  kBaseURL + getSessionPriceAPI;
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
                            self.allSessionList = jsondictionary["sessionsPrices"] as! [[String : Any]]
                                DispatchQueue.main.async {
                                    self.sessionTableView.reloadData()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            let touch = touches.first
            if touch?.view != self.sessionBaseView
            { self.dismiss(animated: true, completion: nil) }
        }

        @IBAction func btnOnlineAction(_ sender: UIButton) {
            isChecked = !isChecked
            if isChecked {
                radioButtonForOnlineImageView.image = UIImage.init(named: "radio_on")
                paymentMode = "Online"
            } else {
                radioButtonForOnlineImageView.image = UIImage.init(named: "radio_off")
                paymentMode = "Cash"
            }
        }

    @IBAction func buySessionbuttonAction(_ sender: Any) {
        if(!purcahseSession.isEmpty){
            callThawaniPaymentApi()
        }else{
            self.alert(message: Constants.sessionAlertMessage.localize(), title: Constants.warning.localize())
        }
    }
    
    func callThawaniPaymentApi(){
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + thawaniTokenAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            param["token_for"]  = "session_payment"
            param["sessions"]  = purcahseSession
            
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            DispatchQueue.main.async {
                              //navigate to Payment Screen
                                self.paymentRequestRefrenceID =  jsondictionary["reference"] as? String ?? ""
                                
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: thawaniPaymentVCSID) as? ThawaniPaymentVC
                                vc?.payPalUrl = jsondictionary["url"] as? String ?? ""
                                vc?.thawaniPaymentURLLoad = true
                                vc?.payMentSuccessCompletion = { [weak self] (idValue,paymentId) in
                                    
                                    guard let self = self else {
                                        return
                                            }
                                    self.handleThawaniRetrunApiCalling(idValue: idValue!, paymentId: paymentId!)
                                }
                                vc?.modalPresentationStyle = .popover
                                self.present(vc!, animated: true, completion: nil)
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
    
    func handleThawaniRetrunApiCalling(idValue:String , paymentId:String){

        if Connectivity.isConnectedToInternet {
            let urlString =  kBaseURL + thawaniReturnAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            param["reference"]  = paymentRequestRefrenceID
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            DispatchQueue.main.async {
                              //call the successAPI
                                self.dismiss(animated: true) {
                                    NotificationCenter.default.post(name: Notification.Name("callBookclassesApi"), object: nil)
                                }
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
    
    func buySessionApiCalling(){
        
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + sessionPurchaseAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            param["name"]  = UserDefaults.standard.string(forKey: kLoginUserName)
            param["email"]  = UserDefaults.standard.string(forKey: kEmailLogin)
            param["phonenumber"]  = UserDefaults.standard.string(forKey: kMobileNumber)
            param["country"]  = "Oman"
            param["payment_method"]  = "7"
            param["total_sessions"]  = purcahseSession
            
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            DispatchQueue.main.async {
                              //navigate to home screen
                                let alertController = UIAlertController(title: Constants.success.localize() , message: Constants.sessionPurcahseMessage.localize(), preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: Constants.oK.localize(), style: UIAlertAction.Style.default, handler: { _ in
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
}

// MARK: - UITableViewDelegate
extension BuySessionVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension BuySessionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.allSessionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BuySessionTVC.identifier, for: indexPath) as? BuySessionTVC else { fatalError("xib doesn't exist") }
        cell.selectionStyle = .none
        let price = self.allSessionList[indexPath.row]["price"] as? String ?? ""
        let session = self.allSessionList[indexPath.row]["sessions"] as? String ?? ""
       
        if(self.selectedCell == true && indexPath.row == indexpathRow){
            cell.radioImageView.image = UIImage.init(named: "radio_on")
            }else{
                cell.radioImageView.image = UIImage.init(named: "radio_off")
            }

        cell.buySessionLabel.text = session  + " \(Constants.sessionFor.localize()) " + price + " OMR"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("table view cell selected index path \(indexPath.row) ")
        selectedCell = true
        purcahseSession = self.allSessionList[indexPath.row]["sessions"] as? String ?? ""
        purcahsePrice = self.allSessionList[indexPath.row]["price"] as? String ?? ""
        indexpathRow = indexPath.row
        sessionTableView.reloadData()
    }
}
