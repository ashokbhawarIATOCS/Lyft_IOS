//
//  BookClassesTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 21/11/22.
//

import UIKit

class BookClassesTVC: UITableViewCell {
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var classImageView: UIImageView!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classNameValueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var dayValueLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var instructorValueLabel: UILabel!
    @IBOutlet weak var durationValueLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var startTimeValueLabel: UILabel!
    @IBOutlet weak var endTimeValueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var checkBoxIcon : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateLabel.text = Constants.dateLabel.localize()
        dayLabel.text = Constants.dayLabel.localize()
        durationLabel.text = Constants.durationLabel.localize()
        instructorLabel.text = Constants.instructorLabel.localize()
        startTimeLabel.text = Constants.startTimeLabel.localize()
        endTimeLabel.text = Constants.endTimeLabel.localize()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
//        checkBoxIcon.image = selected ? UIImage.init(named: "tickArrow") : UIImage.init(named: "radio_off")
        checkBoxIcon.tintColor = .white
        checkBoxIcon.image = (selected ? #imageLiteral(resourceName: "tickArrow") : #imageLiteral(resourceName: "radio_off")).withRenderingMode(.alwaysTemplate)
        // Configure the view for the selected state
    }
    
}
