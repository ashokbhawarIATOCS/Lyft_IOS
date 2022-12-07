//
//  AllTrainersVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 14/10/22.
//

import UIKit

class AllTrainersVC: UIViewController {

    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var trainerTableView: UITableView!
    var allTrainerList = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trainerTableView.delegate = self
        trainerTableView.dataSource = self
        self.navigationItem.title = Constants.allTrainers.localize()
        // Register TableView Cell
        self.trainerTableView.register(AllTrainersTVC.nib, forCellReuseIdentifier: AllTrainersTVC.identifier)
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        callAllTrainerListAPI()
        
    }
//    MARK: - API calling For Training
    func callAllTrainerListAPI() {
        if Connectivity.isConnectedToInternet {

            let urlString =  kBaseURL + kAllTrainerListAPI;
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
                            self.allTrainerList = jsondictionary["team"] as! [[String : Any]]
                                DispatchQueue.main.async {
                                    self.trainerTableView.reloadData()
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
}

// MARK: - UITableViewDelegate
extension AllTrainersVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension AllTrainersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return self.allTrainerList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllTrainersTVC.identifier, for: indexPath) as? AllTrainersTVC else { fatalError("xib doesn't exist") }
        cell.trainerProfileImageView?.imageFromServerURL(urlString: self.allTrainerList[indexPath.row]["trainer_img"] as! String, PlaceHolderImage: UIImage.init(named: "AppLogoIcon")!)
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.lblTrainerName.text = self.allTrainerList[indexPath.row]["name_ar"] as? String ?? ""
            cell.lblTrainerSpeciality.text = self.allTrainerList[indexPath.row]["rank_ar"] as? String ?? ""
            cell.lblTrainerQualification.text = self.allTrainerList[indexPath.row]["qualification_ar"] as? String ?? ""
            cell.lblTrainerExperienceDetails.text = self.allTrainerList[indexPath.row]["coach_word_ar"] as? String ?? ""
        }else{
        cell.lblTrainerName.text = self.allTrainerList[indexPath.row]["name_en"] as? String ?? ""
        cell.lblTrainerSpeciality.text = self.allTrainerList[indexPath.row]["rank_en"] as? String ?? ""
        cell.lblTrainerQualification.text = self.allTrainerList[indexPath.row]["qualification_en"] as? String ?? ""
        cell.lblTrainerExperienceDetails.text = self.allTrainerList[indexPath.row]["coach_word_en"] as? String ?? ""
        }
        cell.shareButtonPressed = {
            let facebookUrlString = self.allTrainerList[indexPath.row]["facebook"] as? String ?? "" + "\n"
            let twitterUrlString = self.allTrainerList[indexPath.row]["twitter"] as? String ?? "" + "\n"
            let instagramUrlString = self.allTrainerList[indexPath.row]["instagram"] as? String ?? "" + "\n"
            let linkedinUrlString = self.allTrainerList[indexPath.row]["linkedin"] as? String ?? "" + "\n"

            let linkToShare = [facebookUrlString ,twitterUrlString , instagramUrlString, linkedinUrlString]
               let activityController = UIActivityViewController(activityItems: linkToShare, applicationActivities: nil)
               self.present(activityController, animated: true, completion: nil)
        }
        return cell
    }

}
