//
//  HomeVC.swift
//  XpanxionCovidUpdate
//
//  Created by Diwakar Garg on 10/08/20.
//  Copyright © 2020 Diwakar Garg. All rights reserved.
//

import UIKit
import AVFoundation
class HomeVC: UIViewController {
    private var sideMenuViewController: SideMenuViewController!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var homeTableView: UITableView!
    var sliderObject : NSArray = []
    var sliderDictonaryObject = [[String:Any]]()
    var whoWeAreDictonary: NSDictionary = [:]
    var offerSectionDictonary: NSDictionary = [:]
    var videoSectionDictonary: NSDictionary = [:]
    var trainerSectionDictonary : NSDictionary  = [:]
    var planDictonary : NSDictionary  = [:]
    var allActivityList = [[String:Any]]()
    var allClassesList = [[String:Any]]()
        override func viewDidLoad() {
            super.viewDidLoad()
            // Menu Button Tint Color
//            let imageView = UIImageView()
//               imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//               imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
//            imageView.image = UIImage.init(named: "AppLogoBlackBackground")
//               let titleLabel = UILabel()
//               titleLabel.text = "Home"
//                titleLabel.textColor = .white
//               let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
//               stackView.spacing = 5
//               stackView.alignment = .center
//
//               // This will assing your custom view to navigation title.
//               navigationItem.titleView = stackView
//
//
            navigationController?.navigationBar.tintColor = .white
            homeTableView.delegate = self
            homeTableView.dataSource = self
            self.navigationItem.title = Constants.home.localize()
            // Register TableView Cell
            self.homeTableView.register(ImageTVC.nib, forCellReuseIdentifier: ImageTVC.identifier)
            self.homeTableView.register(WhoWeAreTVC.nib, forCellReuseIdentifier: WhoWeAreTVC.identifier)
            self.homeTableView.register(CoundDownTVC.nib, forCellReuseIdentifier: CoundDownTVC.identifier)
            self.homeTableView.register(VideoPlayerTVC.nib, forCellReuseIdentifier: VideoPlayerTVC.identifier)
            self.homeTableView.register(CustomTableViewheaderTVC.nib, forCellReuseIdentifier: CustomTableViewheaderTVC.identifier)
            self.homeTableView.register(TrainerTVC.nib, forCellReuseIdentifier: TrainerTVC.identifier)
            self.homeTableView.register(PlanPackageTVC.nib, forCellReuseIdentifier: PlanPackageTVC.identifier)
            self.homeTableView.register(BMICalcultorTVC.nib, forCellReuseIdentifier: BMICalcultorTVC.identifier)
            self.homeTableView.register(ActivityTVC.nib, forCellReuseIdentifier: ActivityTVC.identifier)
            self.homeTableView.register(CheckClassesTVC.nib, forCellReuseIdentifier: CheckClassesTVC.identifier)
            
            sideMenuBtn.target = revealViewController()
            sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
            callHomePageAPI()
        }
    
//    MARK: - API calling For Training
    func callHomePageAPI() {
        if Connectivity.isConnectedToInternet {

            let urlString =  kBaseURL + kHomeAPI;
            self.view.activityStartAnimating()

            var param = [String: Any] ()
            param["Accept"]  = "application/json"
            self.view.isUserInteractionEnabled = false

            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
           
                DispatchQueue.main.async(execute: {() -> Void in

                    self.view.activityStopAnimating()
                    self.view.isUserInteractionEnabled = true
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                                DispatchQueue.main.async {
                                    self.sliderDictonaryObject = jsondictionary["slider"] as! [[String : Any]]
                                    self.whoWeAreDictonary = jsondictionary["who_we_are"] as! NSDictionary
                                    self.offerSectionDictonary = jsondictionary["offer_section"] as! NSDictionary
                                    self.videoSectionDictonary = jsondictionary["video_section"] as! NSDictionary
                                    self.trainerSectionDictonary = jsondictionary["trainers"] as! NSDictionary
                                    self.planDictonary = jsondictionary["packages"] as! NSDictionary
                                    self.allActivityList = jsondictionary["activities"] as! [[String : Any]]
                                    parData = jsondictionary["par"] as! NSDictionary
                                    consentData = jsondictionary["consent"] as! NSDictionary
                                    print("Activity Array Count \(self.allActivityList.count)")
                                    self.homeTableView.reloadData()
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
    
    func viewMoreButtonAction(url: String){
        print("View More button clicked take the action and naviagte to the web page")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: thawaniPaymentVCSID) as? ThawaniPaymentVC
        vc?.payPalUrl = url
        vc?.thawaniPaymentURLLoad = false
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    func registerButtonAction(url: String){
        print("View More button clicked take the action and naviagte to the web page \n \(url)")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: planPackageSID) as? PlanPackageShowVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func planBuyButtonAction(indexpathCount: Int){
        print("Plan \(indexpathCount)")
        
        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
                    let vc = kMainStoryboard.instantiateViewController(withIdentifier: ristrictUserLoginSID) as? RistrictUserLoginVC
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.backButtonTitle.localize(), style: .plain, target: nil, action: nil)
                    self.navigationController?.pushViewController(vc!, animated: true)
        }
        else{
            if(UserDefaults.standard.integer(forKey: kRegCompleted) == 0){
                //flow for the registration Completed screen.
                let vc = kMainStoryboard.instantiateViewController(withIdentifier: editProfileVCSID) as? BasicProfileVC
                vc?.cameFromScreen = "CompleteProfileFromHome"
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
                   let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: buyPlanSID) as? BuyPlanVC
                   let allPlanDetails = planDictonary["packages"] as! [[String : Any]]
                   vc?.packageID = allPlanDetails[indexpathCount]["id"] as? Int ?? 0
                   vc?.selectedPlanList = allPlanDetails[indexpathCount]
                   vc?.modalPresentationStyle = .popover
                   present(vc!, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTVC.identifier, for: indexPath) as? ImageTVC else { fatalError("xib doesn't exist") }
            cell.sliderDictonaryObject = self.sliderDictonaryObject
            cell.buyButtonDataHandlingOnPress = {[weak self] (buttonType,buttonLink) in
            print("button Type handle for navigation\(buttonType) \n Link to navigate\(buttonLink)")
                if(buttonType == "package"){
                    self?.registerButtonAction(url: buttonLink)
                }else{
                    self?.viewMoreButtonAction(url: buttonLink)
                }
            }
            cell.reloadCollectionView()
        return cell
        }
        else if indexPath.row == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WhoWeAreTVC.identifier, for: indexPath) as? WhoWeAreTVC else { fatalError("xib doesn't exist") }
           
            cell.backgroundImageView?.imageFromServerURL(urlString: self.whoWeAreDictonary["image"] as? String ?? "" , PlaceHolderImage: UIImage.init(named: "HomeImage2")!)
            
            if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
                if(self.whoWeAreDictonary.count > 0){
                    cell.titleLabel.text =  self.whoWeAreDictonary["header_ar"] as? String
                    cell.descriptionLabel.text = self.whoWeAreDictonary["content_ar"] as? String
                    let buttonDict = self.whoWeAreDictonary["button_ar"]  as! NSDictionary
                    cell.viewMoreButton.setTitle(buttonDict["text"] as? String, for: .normal)
                    cell.viewMoreButtonPressed = {
                        self.viewMoreButtonAction(url: buttonDict["link"] as? String ?? "")
                    }
                }
            }else{
                if(self.whoWeAreDictonary.count > 0){
                    cell.titleLabel.text =  self.whoWeAreDictonary["header_en"] as? String
                    cell.descriptionLabel.text = self.whoWeAreDictonary["content_en"] as? String
                    let buttonDict = self.whoWeAreDictonary["button_en"] as! NSDictionary
                    cell.viewMoreButton.setTitle(buttonDict["text"] as? String, for: .normal)
                    cell.viewMoreButtonPressed = {
                        self.viewMoreButtonAction(url: buttonDict["link"] as! String)
                    }
                }
            }
            return cell
        }
        else if indexPath.row == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CoundDownTVC.identifier, for: indexPath) as? CoundDownTVC else { fatalError("xib doesn't exist") }
            cell.backgroundImageView?.imageFromServerURL(urlString: self.offerSectionDictonary["image"] as? String ?? "" , PlaceHolderImage: UIImage.init(named: "HomeImage3")!)
            
            if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
                
                if(self.offerSectionDictonary.count > 0){
                    let offerDict = self.offerSectionDictonary["offer_plugin"] as! NSDictionary
                    let buttonDict = offerDict["button_ar"] as! NSDictionary
                    if(buttonDict.count > 0){
                        cell.timerShowView.isHidden = true
                        cell.registerShowView.isHidden =  false
                        cell.registerTitleLabel.text =  offerDict["title_ar"] as? String
                        let descriptionArray = offerDict["text_ar"] as? NSArray
                        cell.descriptionLabel.text = descriptionArray?.componentsJoined(by: "\n")
                        cell.registerButton.setTitle(buttonDict["text"] as? String, for: .normal)
                        cell.registerButtonPressed = {
                            self.registerButtonAction(url: buttonDict["link"] as! String)
                        }
                    }else{
                        cell.timerShowView.isHidden = false
                        cell.registerShowView.isHidden =  true
                        cell.titleLabel.text =  offerDict["title_ar"] as? String
                        //                        cell.
                            //code for the timer triggering and Update it
                    }
                }
            }else{
                if(self.offerSectionDictonary.count > 0){
                    let offerDict = self.offerSectionDictonary["offer_plugin"] as! NSDictionary
                    let buttonDict = offerDict["button_en"] as! NSDictionary
                    if(buttonDict.count > 0){
                        cell.timerShowView.isHidden = true
                        cell.registerShowView.isHidden =  false
                        cell.registerTitleLabel.text =  offerDict["title_en"] as? String
                        let descriptionArray = offerDict["text_en"] as? NSArray
                        cell.descriptionLabel.text = descriptionArray?.componentsJoined(by: "\n")
                        cell.registerButton.setTitle(buttonDict["text"] as? String, for: .normal)
                        cell.registerButtonPressed = {
                            self.registerButtonAction(url: buttonDict["link"] as! String)
                        }
                    }else{
                        cell.timerShowView.isHidden = false
                        cell.registerShowView.isHidden =  true
                        cell.titleLabel.text =  offerDict["title_en"] as? String
                        //                        cell.
                            //code for the timer triggering and Update it
                    }
                }
            }
            return cell
        }
        else if indexPath.row == 3{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoPlayerTVC.identifier, for: indexPath) as? VideoPlayerTVC else { fatalError("xib doesn't exist") }
        //play video by URL
            if(videoSectionDictonary.count > 0){
                cell.pausePalyButtonPressed = {
                   let videoURL =  self.videoSectionDictonary["link"] as? String
                    cell.videoPlayerItem = AVPlayerItem.init(url: URL(string: videoURL!)!)
//                    cell.videoPlayerItem = AVPlayerItem.init(url: URL(string: "https://lyftoman.com/assets/front/video/home/C5244.mp4?autoplay=1")!)
//                    cell.videoPlayerItem = AVPlayerItem.init(url: URL(string: "https://www.youtube.com/watch?v=Eppn8jQhTVI")!)
                    cell.startPlayback()
                }
            }else{
                self.alert(message: Constants.videoNotPlayMessage.localize())
                print("Video could not play")
            }
            return cell
        }
        else if indexPath.row == 4{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewheaderTVC.identifier, for: indexPath) as? CustomTableViewheaderTVC else { fatalError("xib doesn't exist") }
            cell.selectionStyle = .none
            if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
                cell.titleLabel.text = trainerSectionDictonary["title_ar"] as? String
                cell.descriptionLabel.text = trainerSectionDictonary["subtext_ar"] as? String
            }else{
                cell.titleLabel.text = trainerSectionDictonary["title_en"] as? String
                cell.descriptionLabel.text = trainerSectionDictonary["subtext_en"] as? String
            }
            return cell
        }
        else if indexPath.row == 5{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrainerTVC.identifier, for: indexPath) as? TrainerTVC else { fatalError("xib doesn't exist") }
            let trainerDetails = trainerSectionDictonary["team"] as! [[String : Any]]
            cell.allTrainerList = trainerDetails
            cell.reloadCollectionView()
            cell.shareButtonDataPassing = { [weak self] (value) in
                print(value)
                let activityController = UIActivityViewController(activityItems: value, applicationActivities: nil)
                self?.present(activityController, animated: true, completion: nil)
            }
            return cell
        }
        else if indexPath.row == 6{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewheaderTVC.identifier, for: indexPath) as? CustomTableViewheaderTVC else { fatalError("xib doesn't exist") }
            cell.selectionStyle = .none
            if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
                cell.titleLabel.text = planDictonary["title_ar"] as? String
                cell.descriptionLabel.text = planDictonary["subtext_ar"] as? String
            }else{
                cell.titleLabel.text = planDictonary["title_en"] as? String
                cell.descriptionLabel.text = planDictonary["subtext_en"] as? String
            }
            return cell
        }
        else if indexPath.row == 7{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanPackageTVC.identifier, for: indexPath) as? PlanPackageTVC else { fatalError("xib doesn't exist") }
            let allPlanDetails = planDictonary["packages"] as! [[String : Any]]
            cell.allPlanList = allPlanDetails
            cell.reloadCollectionView()
            if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
                cell.buyButtonName = (planDictonary["button_ar"] as? String)!
            }else{
                cell.buyButtonName = (planDictonary["button_en"] as? String)!
            }
            //handle the buy button action
            cell.buyButtonDataPassing = { [weak self] (value) in
                print(value)
               //call the buy button Action
                self?.planBuyButtonAction(indexpathCount: value)
            }
            return cell
        }
        else if indexPath.row == 8{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BMICalcultorTVC.identifier, for: indexPath) as? BMICalcultorTVC else { fatalError("xib doesn't exist") }
            cell.titleLabel.text = Constants.whatBMItitle.localize()
            cell.descriptionLabel.text = Constants.whatBMImessage.localize()
            cell.calculateBMIButtonPressed = {  [weak self] (value) in
                print(value)
                cell.BMIDetailStackView.isHidden = false
                cell.BMIResultView.isHidden = false
                cell.bmiResultValueLabel.text = value
                self!.homeTableView.reloadData()
//                let indexPosition = IndexPath(row:indexPath.row , section: 0)
//                self?.homeTableView.reloadRows(at: [indexPosition], with: .none)
            }
            return cell
        }
        else if indexPath.row == 9{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewheaderTVC.identifier, for: indexPath) as? CustomTableViewheaderTVC else { fatalError("xib doesn't exist") }
            cell.selectionStyle = .none
            cell.titleLabel.text = Constants.workingHourTitle.localize()
            cell.descriptionLabel.text = Constants.workingHourMessage.localize()
            return cell
        } else if indexPath.row == 10{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTVC.identifier, for: indexPath) as? ActivityTVC else { fatalError("xib doesn't exist") }
            cell.allActivityList = self.allActivityList
            self.allClassesList =  self.allActivityList[0]["classes"] as! [[String : Any]]
            cell.selectedActivityIndexPassing =  { [weak self] (value) in
                print(value)
                self?.allClassesList =  self?.allActivityList[value]["classes"] as! [[String : Any]]
                guard let cell1 = tableView.dequeueReusableCell(withIdentifier: CheckClassesTVC.identifier, for: indexPath) as? CheckClassesTVC else { fatalError("xib doesn't exist") }
                cell1.allClassList =  self!.allClassesList
                
                let indexPosition = IndexPath(row: 11, section: 0)
                self?.homeTableView.reloadRows(at: [indexPosition], with: .none)

            }
            cell.reloadCollectionView()
            return cell
        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckClassesTVC.identifier, for: indexPath) as? CheckClassesTVC else { fatalError("xib doesn't exist") }
            cell.allClassList =  self.allClassesList
            cell.selectedClassIndexPassing =  { [weak self] (value) in
                          print(value)
                          let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: bookclassesSID) as? BookClassesVC
                          vc?.classID = value
                          self?.navigationController?.pushViewController(vc!, animated: true)
                      }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
            print("end = \(indexPath)")
            if let videoCell = cell as? VideoPlayerTVC {
                videoCell.videoPlayerButton.isHidden = false
                videoCell.thumnailImageView.isHidden = false
                videoCell.stopPlayback()
            }
        }
   
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("table view cell selected index path \(indexPath.row) ")
//        if indexPath.row == 3{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoPlayerTVC.identifier, for: indexPath) as? VideoPlayerTVC else { fatalError("xib doesn't exist") }
//            if( self.videoPlayState == true){
//                cell.videoPlayerButton.isHidden = false
//                cell.thumnailImageView.isHidden = false
//                self.videoPlayState = false
//                cell.stopPlayback()
//
//            }else{
//                cell.videoPlayerButton.isHidden = true
//                cell.thumnailImageView.isHidden = true
//                cell.startPlayback()
//            }
//        }
//    }
    func playVideoOnTheCell(cell : VideoPlayerTVC, indexPath : IndexPath){
            cell.startPlayback()
        }

        func stopPlayBack(cell : VideoPlayerTVC, indexPath : IndexPath){
            cell.stopPlayback()
        }
}
