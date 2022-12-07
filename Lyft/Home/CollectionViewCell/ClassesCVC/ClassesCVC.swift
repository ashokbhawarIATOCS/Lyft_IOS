//
//  ClassesCVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 29/11/22.
//

import UIKit

class ClassesCVC: UICollectionViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var classesImageView: UIImageView!
    @IBOutlet weak var classNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
