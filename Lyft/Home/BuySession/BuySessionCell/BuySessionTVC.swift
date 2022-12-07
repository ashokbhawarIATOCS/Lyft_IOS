//
//  BuySessionTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 24/11/22.
//

import UIKit

class BuySessionTVC: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var buySessionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
