//
//  ProfileCompletionVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 03/12/22.
//

import UIKit

class ProfileCompletionVC: UIViewController {
    var cameFromScreen = ""
    @IBOutlet var parTableView: UITableView!
    var parQuestion : NSDictionary = [:]
    var selectedResultDictionary  =  Dictionary<String, Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parTableView.delegate = self
        parTableView.dataSource = self
        parQuestion = parData["questions"] as! NSDictionary
        self.parTableView.register(ProfileCompletionHeaderTVC.nib, forCellReuseIdentifier: ProfileCompletionHeaderTVC.identifier)
        self.parTableView.register(PARQuestionDetailsTVC.nib, forCellReuseIdentifier: PARQuestionDetailsTVC.identifier)
        self.parTableView.register(ProfileCompletionBottomTVC.nib, forCellReuseIdentifier: ProfileCompletionBottomTVC.identifier)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
// MARK: - UITableViewDelegate
extension ProfileCompletionVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension ProfileCompletionVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return parQuestion.count/2
        }else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0){
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCompletionHeaderTVC.identifier, for: indexPath) as? ProfileCompletionHeaderTVC else { fatalError("xib doesn't exist") }
       
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.parTitleLabel.text = parData["title_ar"] as? String
            cell.parSubTitleLabel.text = parData["intro_ar"] as? String
            
            let questiondetails = parData["questions_header"] as! NSDictionary
            cell.questionHeaderLabel.text = questiondetails["question_ar"] as? String ?? ""
            cell.yesHeaderLabel.text = questiondetails["yes_ar"] as? String ?? ""
            cell.noHeaderLabel.text = questiondetails["no_ar"] as? String ?? ""
        }else{
            cell.parTitleLabel.text = parData["title_en"] as? String
            cell.parSubTitleLabel.text = parData["intro_en"] as? String
            
            let questiondetails = parData["questions_header"] as! NSDictionary
            cell.questionHeaderLabel.text = questiondetails["question_en"] as? String ?? ""
            cell.yesHeaderLabel.text = questiondetails["yes_en"] as? String ?? ""
            cell.noHeaderLabel.text = questiondetails["no_en"] as? String ?? ""
        }
        return cell
        }else  if (indexPath.section == 2){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCompletionBottomTVC.identifier, for: indexPath) as? ProfileCompletionBottomTVC else { fatalError("xib doesn't exist") }
            if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
                cell.bottom1Label.text = parData["bottom1_ar"] as? String
                cell.bottomBoldLabel.text =  parData["bottom2_head_ar"] as? String
                cell.botton2Label.text = parData["bottom2_ar"] as? String
                cell.bottomConsentLabel.text = parData["consent_ar"] as? String
                cell.bottomNoteLabel.text = parData["note_ar"] as? String
                
            }else{
       
                cell.bottom1Label.text = parData["bottom1_en"] as? String
                cell.bottomBoldLabel.text =  parData["bottom2_head_en"] as? String
                cell.botton2Label.text = parData["bottom2_en"] as? String
                cell.bottomConsentLabel.text = parData["consent_en"] as? String
                cell.bottomNoteLabel.text = parData["note_en"] as? String
            }
            cell.backButtonPressed = {
                self.navigationController?.popViewController(animated: true)
            }
            cell.nextButtonPressed = {
                let vc = kMainStoryboard.instantiateViewController(withIdentifier: imageUploadAndDetailsSID) as? ImageUploadAndDetails
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: Constants.backButtonTitle.localize(), style: .plain, target: nil, action: nil)
                vc?.cameFromScreen = self.cameFromScreen
                vc?.selectedParResultDictionary = self.selectedResultDictionary
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
            return cell
        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PARQuestionDetailsTVC.identifier, for: indexPath) as? PARQuestionDetailsTVC else { fatalError("xib doesn't exist") }
            
            cell.segmentSelectionValuePassedOnPress = {  [weak self] (value) in
                print(value)
                if(value == "Yes"){
                    self?.selectedResultDictionary["par\(indexPath.row + 1)"] = 1
                }else{
                    self?.selectedResultDictionary["par\(indexPath.row + 1)"] = 0
                }
//                print(self?.selectedResultDictionary)
            }
            if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
                switch (indexPath.row) {
                   case 0:
                    cell.questionLabel.text = parQuestion["par1_ar"] as? String
                    return cell
                   case 1:
                    cell.questionLabel.text = parQuestion["par2_ar"] as? String
                    return cell
                    case 2:
                    cell.questionLabel.text = parQuestion["par3_ar"] as? String
                    return cell
                    case 3:
                    cell.questionLabel.text = parQuestion["par4_ar"] as? String
                    return cell
                    case 4:
                    cell.questionLabel.text = parQuestion["par5_ar"] as? String
                    return cell
                    case 5:
                    cell.questionLabel.text = parQuestion["par6_ar"] as? String
                    return cell
                    case 6:
                    cell.questionLabel.text = parQuestion["par7_ar"] as? String
                    return cell
                    
                   default:
                   return UITableViewCell()
                }
            }else{
                switch (indexPath.row) {
                   case 0:
                    cell.questionLabel.text = parQuestion["par1_en"] as? String
                    return cell
                   case 1:
                    cell.questionLabel.text = parQuestion["par2_en"] as? String
                    return cell
                    case 2:
                    cell.questionLabel.text = parQuestion["par3_en"] as? String
                    return cell
                    case 3:
                    cell.questionLabel.text = parQuestion["par4_en"] as? String
                    return cell
                    case 4:
                    cell.questionLabel.text = parQuestion["par5_en"] as? String
                    return cell
                    case 5:
                    cell.questionLabel.text = parQuestion["par6_en"] as? String
                    return cell
                    case 6:
                    cell.questionLabel.text = parQuestion["par7_en"] as? String
                    return cell
                    
                   default:
                   return UITableViewCell()
                }
            }
            return cell
        }
    }

}
