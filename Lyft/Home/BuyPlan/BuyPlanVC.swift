//
//  BuyPlanVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 24/11/22.
//

import UIKit

class BuyPlanVC: UIViewController {

    @IBOutlet weak var sessionBaseView: UIView!
    @IBOutlet weak var buyPlanTableView: UITableView!
    @IBOutlet weak var buyPlanButton: UIButton!
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var planPriceLabel: UILabel!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var radioButtonForOnlineImageView: UIImageView!
    var descriptionArray : NSArray = []
    var packageID : Int = -1
    var isChecked = false
    var paymentMode : String = ""
    var selectedPlanList = [String:Any]()
    var paymentRequestRefrenceID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionBaseView.layer.cornerRadius =  30
        print("PackgaeID which is passed", packageID)
        packageID = self.selectedPlanList["id"]  as? Int ?? 0
        print("PackgaeID which is passed after reassign", packageID)
        buyPlanTableView.delegate = self
        buyPlanTableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        self.buyPlanTableView.register(BuyPlanTVC.nib, forCellReuseIdentifier: BuyPlanTVC.identifier)
        loadUI()
    }

    func loadUI(){
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            self.planTitleLabel.text = self.selectedPlanList["title_ar"] as? String ?? ""
             descriptionArray =  self.selectedPlanList["description_ar"] as! NSArray

        }else{
            self.planTitleLabel.text = self.selectedPlanList["title_en"] as? String ?? ""
             descriptionArray =  self.selectedPlanList["description_en"] as! NSArray
        }
        
        let durationVaLue = self.selectedPlanList["duration"] as? String ?? ""
        if(durationVaLue == Constants.monthly){
            self.planPriceLabel.text = "\(Constants.startingAt.localize()) OMR \(self.selectedPlanList["price"]as? String ?? "")/\(Constants.monthly.localize())"
        } else if(durationVaLue == Constants.quarterly){
            self.planPriceLabel.text = "\(Constants.startingAt.localize()) OMR \(self.selectedPlanList["price"]as? String ?? "")/\(Constants.quarterly.localize())"
        }else if(durationVaLue == Constants.yearly){
            self.planPriceLabel.text = "\(Constants.startingAt.localize()) OMR \(self.selectedPlanList["price"]as? String ?? "")/\(Constants.yearly.localize())"
        }else{
            self.planPriceLabel.text = "\(Constants.startingAt.localize()) OMR \(self.selectedPlanList["price"]as? String ?? "")/\(self.selectedPlanList["duration"] as? String ?? "")"
        }
        buyPlanButton.setTitle(Constants.buyButton.localize(), for: .normal)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            let touch = touches.first
            if touch?.view != self.sessionBaseView
            { self.dismiss(animated: true, completion: nil) }
        }
    
    @IBAction func buyPlanbuttonAction(_ sender: Any) {
        //call the session Buy and dismiss the view and update the session
        if(packageID != -1){
            callThawaniPaymentApi()
        }else{
            self.alert(message: "Please select Plan", title: Constants.warning.localize())
        }
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

    func callThawaniPaymentApi(){
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + thawaniTokenAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            param["token_for"]  = "membership_payment"
            param["package_id"]  = packageID
            
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
                                UserDefaults.standard.set(jsondictionary["membership_id"] as? String ?? "", forKey: memberShipID)
//                                self.buyPlanSubscriptionApiCalling()
                                let alertController = UIAlertController(title: Constants.success.localize() , message: Constants.subscriptionPurchasedMessage.localize(), preferredStyle: .alert)
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
    
    func buyPlanSubscriptionApiCalling(){
        
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + buyPlanAPI;
            self.view.activityStartAnimating()

            var param = [String: Any] ()
            param["name"]  = UserDefaults.standard.string(forKey: kLoginUserName)
            param["email"]  = UserDefaults.standard.string(forKey: kEmailLogin)
            param["phonenumber"]  = UserDefaults.standard.string(forKey: kMobileNumber)
            param["country"]  = "Oman"
            param["method"]  = "7"
            param["package_id"]  = packageID
            
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
                                let alertController = UIAlertController(title: Constants.success.localize() , message: Constants.subscriptionPurchasedMessage.localize(), preferredStyle: .alert)
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
extension BuyPlanVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension BuyPlanVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.descriptionArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BuyPlanTVC.identifier, for: indexPath) as? BuyPlanTVC else { fatalError("xib doesn't exist") }
        cell.selectionStyle = .none
        cell.planDescription1Label.text = descriptionArray[indexPath.row] as? String
        return cell
    }
}
