//
//  ImagePageViewCVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 04/11/22.
//

import UIKit

class ImagePageViewCVC: UICollectionViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var boldTitleLabel: UILabel!
    @IBOutlet weak var scrollListImageView: UIImageView!
    @IBOutlet weak var buyNowButton: RoundButton!
    @IBOutlet weak var bottomTextLabel: UILabel!
    
    //create your closure here
    var planButtonPressed : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buyButtonAction(_ sender: Any) {
        planButtonPressed()
    }
}
