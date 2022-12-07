//
//  WhoWeAreTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 04/11/22.
//

import UIKit

class WhoWeAreTVC: UITableViewCell {
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //create your closure here
    var viewMoreButtonPressed : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewMoreButtonAction(_ sender: Any) {
        viewMoreButtonPressed()
    }
}
