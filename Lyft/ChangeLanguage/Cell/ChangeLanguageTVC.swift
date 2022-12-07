//
//  ChangeLanguageTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 18/11/22.
//

import UIKit

class ChangeLanguageTVC: UITableViewCell {

    
    @IBOutlet var labelTitle : UILabel!
    @IBOutlet var imageViewIcon : UIImageView!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
