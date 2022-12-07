//
//  TrainerCVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 04/11/22.
//

import UIKit

class TrainerCVC: UICollectionViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var trainerProfileImageView: UIImageView!
    @IBOutlet weak var lblTrainerName: UILabel!
    @IBOutlet weak var lblTrainerSpeciality: UILabel!
    @IBOutlet weak var lblTrainerQualification: UILabel!
    @IBOutlet weak var lblTrainerExperienceDetails: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    //create your closure here
    var shareButtonPressed : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func shareButtonAction(_ sender: Any) {
        shareButtonPressed()
    }
    
}
