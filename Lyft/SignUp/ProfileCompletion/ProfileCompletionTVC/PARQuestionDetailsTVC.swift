//
//  PARQuestionDetailsTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 03/12/22.
//

import UIKit

class PARQuestionDetailsTVC: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var parSegmentView: UISegmentedControl!
    
    var segmentSelectionValuePassedOnPress : ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        parSegmentView.setTitle(Constants.yes.localize(), forSegmentAt: 0)
        parSegmentView.setTitle(Constants.no.localize(), forSegmentAt: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func segmentViewAction(_ sender: Any) {
        
        switch parSegmentView.selectedSegmentIndex {
        case 0:
            self.segmentSelectionValuePassedOnPress!("Yes")
        case 1 :
            self.segmentSelectionValuePassedOnPress!("No")
        default:
            break
        }
    }
}
