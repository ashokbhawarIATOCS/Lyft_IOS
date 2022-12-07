//
//  PlanPackageShowVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 23/11/22.
//

import UIKit

class PlanPackageShowVC: UIViewController {
    @IBOutlet weak var planPackageTableView: UITableView!
    var allPlanList = [[String:Any]]()
    var planID : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Constants.planPackage.localize()
        self.planPackageTableView.register(PlanTVC.nib, forCellReuseIdentifier: PlanTVC.identifier)
        accountDeletionApiCalling()
        // Do any additional setup after loading the view.
    }
    
    func accountDeletionApiCalling(){
        
        if Connectivity.isConnectedToInternet {

            let urlString =  kBaseURL + planDetailsAPI;
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
                            self.allPlanList = jsondictionary["all_packages"] as! [[String : Any]]
                                DispatchQueue.main.async {
                                    self.planPackageTableView.reloadData()
                                }
                        }else{
                            self.alert(message: dictionary["message"] as? String ?? "")
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
    
}
// MARK: - UITableViewDelegate
extension PlanPackageShowVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension PlanPackageShowVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       return 3
            return self.allPlanList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanTVC.identifier, for: indexPath) as? PlanTVC else { fatalError("xib doesn't exist") }
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.planTitleLabel.text = self.allPlanList[indexPath.row]["title_ar"] as? String ?? ""
            
            let durationVaLue = self.allPlanList[indexPath.row]["duration"] as? String ?? ""
            if(durationVaLue == Constants.monthly){
                cell.planAmontLabel.text = "\(Constants.startingAt.localize()) OMR \(self.allPlanList[indexPath.row]["price"] ?? "")/\(Constants.monthly.localize())"
            } else if(durationVaLue == Constants.quarterly){
                cell.planAmontLabel.text = "\(Constants.startingAt.localize()) OMR \(self.allPlanList[indexPath.row]["price"] ?? "")/\(Constants.quarterly.localize())"
            }else if(durationVaLue == Constants.yearly){
                cell.planAmontLabel.text = "\(Constants.startingAt.localize()) OMR \(self.allPlanList[indexPath.row]["price"] ?? "")/\(Constants.yearly.localize())"
            }else{
                cell.planAmontLabel.text = "\(Constants.startingAt.localize()) OMR \(self.allPlanList[indexPath.row]["price"] ?? "")/\(self.allPlanList[indexPath.row]["duration"] ?? "")"
            }
            
            let descriptionArray =  self.allPlanList[indexPath.row]["description_ar"] as! NSArray
            if (descriptionArray.count == 1){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.isHidden = true
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView2.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            } else if (descriptionArray.count == 2){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            } else if (descriptionArray.count == 3){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.text = descriptionArray[2] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription4Label.isHidden = true
                cell.tickImageView4.isHidden = true
            }else if (descriptionArray.count == 0){
                cell.planDescription1Label.text = Constants.emptyDescriptionForPlan.localize()
                cell.planDescription2Label.isHidden = true
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView2.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            }else{
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.text = descriptionArray[2] as? String
                cell.planDescription4Label.text = descriptionArray[3] as? String
            }
        } else {
        cell.planTitleLabel.text = self.allPlanList[indexPath.row]["title_en"] as? String ?? ""
        cell.planAmontLabel.text = "Starting at OMR. \(self.allPlanList[indexPath.row]["price"] ?? "")/\(self.allPlanList[indexPath.row]["duration"] ?? "")"
            
            let descriptionArray =  self.allPlanList[indexPath.row]["description_en"] as! NSArray
            
            if (descriptionArray.count == 1){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.isHidden = true
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView2.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
                
            } else if (descriptionArray.count == 2){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            } else if (descriptionArray.count == 3){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.text = descriptionArray[2] as? String
                cell.planDescription4Label.isHidden = true
                cell.tickImageView4.isHidden = true
            }else if (descriptionArray.count == 0){
                cell.planDescription1Label.text = Constants.emptyDescriptionForPlan.localize()
                cell.planDescription2Label.isHidden = true
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView2.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            }else{
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.text = descriptionArray[2] as? String
                cell.planDescription4Label.text = descriptionArray[3] as? String
            }
        }
        cell.planButton.setTitle(Constants.buyButton.localize(), for: .normal)
        cell.buyPlanButtonPressed = {
           //code for buy plan
            self.planID = self.allPlanList[indexPath.row]["id"] as? Int ?? 0
            print("Plan ID \(self.planID)")

            if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
                       let vc = kMainStoryboard.instantiateViewController(withIdentifier: ristrictUserLoginSID) as? RistrictUserLoginVC
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.backButtonTitle.localize(), style: .plain, target: nil, action: nil)
                       self.navigationController?.pushViewController(vc!, animated: true)
            }
            else{
                if(UserDefaults.standard.integer(forKey: kRegCompleted) == 0){
                    //flow for the registration Completed screen.
                    let vc = kMainStoryboard.instantiateViewController(withIdentifier: editProfileVCSID) as? BasicProfileVC
                    vc?.cameFromScreen = "CompleteProfileFromPlan"
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: buyPlanSID) as? BuyPlanVC
                    vc?.packageID = self.planID
                    vc?.selectedPlanList = self.allPlanList[indexPath.row]
                    vc?.modalPresentationStyle = .popover
                    self.present(vc!, animated: true, completion: nil)
                }
            }
        }
        cell.planView.layer.borderWidth = 8
        cell.planView.layer.borderColor = borderColorandThemeColor.cgColor
        return cell
    }
}
