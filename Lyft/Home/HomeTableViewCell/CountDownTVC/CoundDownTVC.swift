//
//  CoundDownTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 04/11/22.
//

import UIKit

class CoundDownTVC: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var timerShowView: UIView!
    @IBOutlet weak var registerShowView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var endInLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var hrsLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    
    @IBOutlet weak var registerTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    //create your closure here
    var registerButtonPressed : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        registerButtonPressed()
    }
}
