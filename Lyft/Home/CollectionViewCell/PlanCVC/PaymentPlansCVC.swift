//
//  PaymentPlansCVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 04/11/22.
//

import UIKit

class PaymentPlansCVC: UICollectionViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var planDescription1Label: UILabel!
    @IBOutlet weak var planDescription2Label: UILabel!
    @IBOutlet weak var planDescription3Label: UILabel!
    @IBOutlet weak var planDescription4Label: UILabel!
    @IBOutlet weak var planButton: RoundButton!
    @IBOutlet weak var planAmontLabel: UILabel!
    @IBOutlet weak var planView: UIView!
    
    @IBOutlet weak var tickImageView4: UIImageView!
    @IBOutlet weak var tickImageView3: UIImageView!
    @IBOutlet weak var tickImageView2: UIImageView!
    @IBOutlet weak var tickImageView1: UIImageView!
    
    //create your closure here
    var planButtonPressed : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func planButtonAction(_ sender: Any) {
        planButtonPressed()
    }
}
