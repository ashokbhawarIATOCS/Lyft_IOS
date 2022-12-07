//
//  ActivityAndClassesCVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/11/22.
//

import UIKit

class ActivityCVC: UICollectionViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
