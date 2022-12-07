//
//  ProfileCompletionHeaderTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 03/12/22.
//

import UIKit

class ProfileCompletionHeaderTVC: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var parTitleLabel: UILabel!
    @IBOutlet weak var parSubTitleLabel: UILabel!
    @IBOutlet weak var questionHeaderLabel: UILabel!
    @IBOutlet weak var yesHeaderLabel: UILabel!
    @IBOutlet weak var noHeaderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stepLabel.text = Constants.step2of3.localize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
