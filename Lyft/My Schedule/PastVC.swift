//
//  PastVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 21/11/22.
//

import UIKit

class PastVC: UIViewController {
    @IBOutlet var pastTableView: UITableView!
    var pastScheduledList = [[String:Any]]()
    @IBOutlet weak var leftClassesLabel: UILabel!
    var remaininglass = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        pastTableView.delegate = self
        pastTableView.dataSource = self
        leftClassesLabel.text =  Constants.freeClassesLeft.localize() + remaininglass
        // Register TableView Cell
        self.pastTableView.register(PastScheduledTVC.nib, forCellReuseIdentifier: PastScheduledTVC.identifier)
        // Do any additional setup after loading the view.
    }
}
// MARK: - UITableViewDelegate
extension PastVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension PastVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.pastScheduledList.count == 0 {
            self.pastTableView.setEmptyMessage(Constants.noPastDataPresent.localize())
            } else {
                self.pastTableView.restore()
            }
        return self.pastScheduledList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PastScheduledTVC.identifier, for: indexPath) as? PastScheduledTVC else { fatalError("xib doesn't exist") }
        cell.classImageView?.imageFromServerURL(urlString: self.pastScheduledList[indexPath.row]["class_imgge"] as! String, PlaceHolderImage: UIImage.init(named: "AppLogoIcon")!)
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.classNameLabel.text = self.pastScheduledList[indexPath.row]["class_title_ar"] as? String
            cell.classNameValueLabel.text = self.pastScheduledList[indexPath.row]["activity_ar"] as? String
            
            cell.dateValueLabel.text = self.pastScheduledList[indexPath.row]["session_date"] as? String
            cell.dayValueLabel.text = self.pastScheduledList[indexPath.row]["weekday"] as? String
            
            cell.instructorValueLabel.text = self.pastScheduledList[indexPath.row]["instructor_name_ar"] as? String
            cell.durationValueLabel.text = self.pastScheduledList[indexPath.row]["duration"] as? String
            
            cell.startTimeValueLabel.text = self.pastScheduledList[indexPath.row]["start_time"] as? String
            cell.endTimeValueLabel.text = self.pastScheduledList[indexPath.row]["end_time"] as? String
        }else{
       
            cell.classNameLabel.text = self.pastScheduledList[indexPath.row]["class_title_en"] as? String
            cell.classNameValueLabel.text = self.pastScheduledList[indexPath.row]["activity_en"] as? String
            
            cell.dateValueLabel.text = self.pastScheduledList[indexPath.row]["session_date"] as? String
            cell.dayValueLabel.text = self.pastScheduledList[indexPath.row]["weekday"] as? String
            
            cell.instructorValueLabel.text = self.pastScheduledList[indexPath.row]["instructor_name_en"] as? String
            cell.durationValueLabel.text = self.pastScheduledList[indexPath.row]["duration"] as? String
            
            cell.startTimeValueLabel.text = self.pastScheduledList[indexPath.row]["start_time"] as? String
            cell.endTimeValueLabel.text = self.pastScheduledList[indexPath.row]["end_time"] as? String
            
        }
        return cell
    }

}
