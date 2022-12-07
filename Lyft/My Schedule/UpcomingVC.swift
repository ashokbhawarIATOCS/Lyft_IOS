//
//  UpcomingVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 21/11/22.
//

import UIKit
import FSCalendar

class UpcomingVC: UIViewController,FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet var upcomingTableView: UITableView!
    @IBOutlet weak var leftClassesLabel: UILabel!
    var customView : UIView!
    var calendar: FSCalendar!
    var doneButton: UIButton!
    var cancelButton: UIButton!
    private var datesRange: [String] = []
    var upcomingScheduledList = [[String:Any]]()
    var remaininglass = ""
    var reScheuledId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        leftClassesLabel.text =  Constants.freeClassesLeft.localize() + remaininglass
        self.upcomingTableView.register(UpcomingScheduledTVC.nib, forCellReuseIdentifier: UpcomingScheduledTVC.identifier)
        // Do any additional setup after loading the view.
    }
    
    func cancelClassesApiCalling(id:String){
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + cancelClassesAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            param["session_purchase_id"]  = id
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            DispatchQueue.main.async {
                                self.upcomingTableView.reloadData()
                                self.alert(message: Constants.cancelClassesMessage.localize())
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
    
    func reScheduledClassesApiCalling(id:String, dateStringCommaSepreted: [String]){
        if Connectivity.isConnectedToInternet {
            
            let urlString =  kBaseURL + reScheduleClasessAPI;
            self.view.activityStartAnimating()
            
            var param = [String: Any] ()
            param["session_purchase_id"]  = id
            param["date"]  =  dateStringCommaSepreted.joined(separator: ",")
            self.view.isUserInteractionEnabled = false
            
            CustomAlmofire .dataTask_POST(Foundation.URL(string: urlString)!, method: .post, param: param) { (response) in
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    self.view.activityStopAnimating()
                    
                    switch response {
                    case .success(let dictionary as [String: Any]):
                        if (dictionary["status"] as? Int == 200) {
                            let jsondictionary = dictionary["results"] as! NSDictionary
                            DispatchQueue.main.async {
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: bookclassesSID) as? BookClassesVC
                                vc?.classID = ""
                                vc?.previousPurchaseClassID =  self.reScheuledId
                                self.navigationController?.pushViewController(vc!, animated: true)
//                                self.remaininglass = jsondictionary["free_sessions_left"] as! String
//                                self.leftClassesLabel.text =  Constants.freeClassesLeft.localize() + self.remaininglass
//                                self.upcomingTableView.reloadData()
//                                self.alert(message: dictionary["message"] as? String ?? "")
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
    
    func loadClanderViewAsBottomPopup(){
        customView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 500, width: self.view.frame.width, height: 380))
        customView.backgroundColor = .white
        self.view.addSubview(customView)
        
        calendar = FSCalendar(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scrollDirection = .vertical
        calendar.locale = Locale(identifier: (UserDefaults.standard.value(forKey: klanguage) as? String)!)
        calendar.backgroundColor = .white
        self.customView.addSubview(calendar)
        
        doneButton = UIButton(frame: CGRect(x: self.view.frame.width - 130, y: 10, width: 100, height: 40))
        doneButton.backgroundColor = .black
        doneButton.setTitle(Constants.done.localize(), for: .normal)
        doneButton.layer.cornerRadius = 5
        doneButton.addTarget(self, action: #selector(self.onClickDoneButton), for: .touchUpInside)
        self.customView.addSubview(doneButton)
        
        cancelButton = UIButton(frame: CGRect(x:30, y: 10, width: 100, height: 40))
        cancelButton.backgroundColor = .black
        cancelButton.setTitle(Constants.cancel.localize(), for: .normal)
        cancelButton.layer.cornerRadius = 5
        cancelButton.addTarget(self, action: #selector(self.onClickCancelButton), for: .touchUpInside)
        self.customView.addSubview(cancelButton)
        
        calendar.allowsMultipleSelection = true
    }
    
    @objc func onClickDoneButton() {
        customView.removeFromSuperview()
        self.view.endEditing(true)
        //Code for handling the done button action
        if(!datesRange.isEmpty){
            if(datesRange.count <= Int(remaininglass)! + 1){
            self.reScheduledClassesApiCalling(id:reScheuledId , dateStringCommaSepreted: datesRange)
            }else{
                self.alert(message: "\(Constants.buyMoreSession.localize()) \(remaininglass)", title: Constants.warning.localize())
            }
        }else{
            self.alert(message: Constants.selectMessage.localize(), title: Constants.warning.localize() )
        }
        datesRange = []
        //code for the r
    }
    @objc func onClickCancelButton() {
        self.view.endEditing(true)
        datesRange = []
        //Code for handling the done button action
        customView.removeFromSuperview()
    }
    
    //MARK delagate method of the FSCalendar view
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: date)
        
        datesRange.append(myString)
        print("datesRange contains: \(String(describing: datesRange))")
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: date)
        
        if (datesRange.contains(myString)) {
            let index = datesRange.firstIndex(of: myString)
            datesRange.remove(at: index!)
            print("datesRange contains: \(String(describing: datesRange))")
        }
    }
    
}

// MARK: - UITableViewDelegate
extension UpcomingVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension UpcomingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.upcomingScheduledList.count == 0 {
            self.upcomingTableView.setEmptyMessage(Constants.noUpcomingDataPresent.localize())
            } else {
                self.upcomingTableView.restore()
            }
        return self.upcomingScheduledList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingScheduledTVC.identifier, for: indexPath) as? UpcomingScheduledTVC else { fatalError("xib doesn't exist") }
        
        cell.classImageView?.imageFromServerURL(urlString: self.upcomingScheduledList[indexPath.row]["class_imgge"] as! String, PlaceHolderImage: UIImage.init(named: "AppLogoIcon")!)
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.classNameLabel.text = self.upcomingScheduledList[indexPath.row]["class_title_ar"] as? String
            cell.classNameValueLabel.text = self.upcomingScheduledList[indexPath.row]["activity_ar"] as? String
            cell.dateValueLabel.text = self.upcomingScheduledList[indexPath.row]["session_date"] as? String
            cell.dayValueLabel.text = self.upcomingScheduledList[indexPath.row]["weekday"] as? String
            cell.instructorValueLabel.text = self.upcomingScheduledList[indexPath.row]["instructor_name_ar"] as? String
            cell.durationValueLabel.text = self.upcomingScheduledList[indexPath.row]["duration"] as? String
            cell.startTimeValueLabel.text = self.upcomingScheduledList[indexPath.row]["start_time"] as? String
            cell.endTimeValueLabel.text = self.upcomingScheduledList[indexPath.row]["end_time"] as? String
            
        }else{
       
            cell.classNameLabel.text = self.upcomingScheduledList[indexPath.row]["class_title_en"] as? String
            cell.classNameValueLabel.text = self.upcomingScheduledList[indexPath.row]["activity_en"] as? String
            
            cell.dateValueLabel.text = self.upcomingScheduledList[indexPath.row]["session_date"] as? String
            cell.dayValueLabel.text = self.upcomingScheduledList[indexPath.row]["weekday"] as? String
            
            cell.instructorValueLabel.text = self.upcomingScheduledList[indexPath.row]["instructor_name_en"] as? String
            cell.durationValueLabel.text = self.upcomingScheduledList[indexPath.row]["duration"] as? String
            cell.startTimeValueLabel.text = self.upcomingScheduledList[indexPath.row]["start_time"] as? String
            cell.endTimeValueLabel.text = self.upcomingScheduledList[indexPath.row]["end_time"] as? String
            
        }
        cell.reScheduledClassButtonPressed = {
            print("resecheduled button clicked",indexPath.row)
            self.loadClanderViewAsBottomPopup()
            self.reScheuledId = self.upcomingScheduledList[indexPath.row]["class_purchase_id"] as? String ?? ""
        }
        cell.cancelClassButtonPressed = {
            print("CanceledbuttonClicked",indexPath.row)
            self.cancelClassesApiCalling(id:  self.upcomingScheduledList[indexPath.row]["class_purchase_id"] as? String ?? "")
        }
        //handled the cancel and rescheduled action
        if (self.upcomingScheduledList[indexPath.row]["is_cancelled"] as? String == "0"){
            cell.reScheduledClassButton.isHidden = false
            cell.cancelClassButton.setTitle(Constants.capCancel.localize(), for: .normal)
        }else{
            cell.cancelClassButton.isEnabled = false
            cell.cancelClassButton.isUserInteractionEnabled = false
            cell.cancelClassButton.setTitle(Constants.capCancelled.localize(), for: .normal)
            cell.cancelClassButton.backgroundColor =  UIColor(red: 0.72, green: 0.58, blue: 0.26, alpha: 0.50)
            cell.reScheduledClassButton.isHidden = true
        }
        return cell
    }
}
