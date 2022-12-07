//
//  ProfileCompletionBottomTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 03/12/22.
//

import UIKit

class ProfileCompletionBottomTVC: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var backButton: RoundButton!
    @IBOutlet weak var nextButton: RoundButton!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var bottom1Label: UILabel!
    @IBOutlet weak var bottomBoldLabel: UILabel!
    @IBOutlet weak var botton2Label: UILabel!
    @IBOutlet weak var bottomConsentLabel: UILabel!
    @IBOutlet weak var bottomNoteLabel: UILabel!
    
    var backButtonPressed : (() -> ()) = {}
    var nextButtonPressed : (() -> ()) = {}
    
    var camefrom = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nextButton.setTitle(Constants.nextButton.localize(), for: .normal)
        backButton.setTitle(Constants.backButtonTitle.localize(), for: .normal)
        checkBoxImageView.tintColor = borderColorandThemeColor
        checkBoxImageView.image = (#imageLiteral(resourceName: "emptyCheckBox")).withRenderingMode(.alwaysTemplate)
        nextButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func backBuutonAction(_ sender: Any) {
       //handle Button Action
        backButtonPressed()
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        nextButtonPressed()
    }
    
    @IBAction func checkBoxButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkBoxImageView.tintColor = borderColorandThemeColor
        checkBoxImageView.image = (sender.isSelected ? #imageLiteral(resourceName: "checked") : #imageLiteral(resourceName: "emptyCheckBox")).withRenderingMode(.alwaysTemplate)
        
            if sender.isSelected {
                nextButton.isUserInteractionEnabled = true
            } else {
                nextButton.isUserInteractionEnabled = false
            }
    }
}
