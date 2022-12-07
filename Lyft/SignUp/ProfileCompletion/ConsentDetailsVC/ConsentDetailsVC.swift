//
//  ConsentDetailsVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 03/12/22.
//

import UIKit

class ConsentDetailsVC: UIViewController {

    @IBOutlet weak var consentTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    var contentConsent : NSDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        consentTableView.delegate = self
        consentTableView.dataSource = self
        self.consentTableView.register(ConsetTVC.nib, forCellReuseIdentifier: ConsetTVC.identifier)
        contentConsent = consentData["content"] as! NSDictionary

        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            titleLabel.text = contentConsent["title_ar"] as? String
        }else{
            titleLabel.text = contentConsent["title_en"] as? String
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            let touch = touches.first
            if touch?.view != self.view
            { self.dismiss(animated: true, completion: nil) }
        }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
// MARK: - UITableViewDelegate
extension ConsentDetailsVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 450
//    }
}

// MARK: - UITableViewDataSource
extension ConsentDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 8
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsetTVC.identifier, for: indexPath) as? ConsetTVC else { fatalError("xib doesn't exist") }

        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
        switch (indexPath.row) {
           case 0:
            cell.consentTitleLabel.text = contentConsent["notice_ar"] as? String
            return cell
           case 1:
            cell.consentTitleLabel.text = contentConsent["point1_ar"] as? String
            return cell
            case 2:
            cell.consentTitleLabel.text = contentConsent["point2_ar"] as? String
            return cell
            case 3:
            cell.consentTitleLabel.text = contentConsent["point3_ar"] as? String
            return cell
            case 4:
            cell.consentTitleLabel.text = contentConsent["point4_ar"] as? String
            return cell
            case 5:
            cell.consentTitleLabel.text = contentConsent["point5_ar"] as? String
            return cell
            case 6:
            cell.consentTitleLabel.text = contentConsent["point6_ar"] as? String
            return cell
            case 7:
            cell.consentTitleLabel.text = contentConsent["point7_ar"] as? String
            return cell
            
           default:
           return UITableViewCell()
        }
        }else{
        switch (indexPath.row) {
        case 0:
         cell.consentTitleLabel.text = contentConsent["notice_en"] as? String
         return cell
        case 1:
         cell.consentTitleLabel.text = contentConsent["point1_en"] as? String
         return cell
         case 2:
         cell.consentTitleLabel.text = contentConsent["point2_en"] as? String
         return cell
         case 3:
         cell.consentTitleLabel.text = contentConsent["point3_en"] as? String
         return cell
         case 4:
         cell.consentTitleLabel.text = contentConsent["point4_en"] as? String
         return cell
         case 5:
         cell.consentTitleLabel.text = contentConsent["point5_en"] as? String
         return cell
         case 6:
         cell.consentTitleLabel.text = contentConsent["point6_en"] as? String
         return cell
         case 7:
         cell.consentTitleLabel.text = contentConsent["point7_en"] as? String
         return cell

           default:
           return UITableViewCell()
        }
        }
    }

}
