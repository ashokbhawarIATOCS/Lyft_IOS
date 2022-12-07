//
//  UpcomingScheduledTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 21/11/22.
//

import UIKit

class UpcomingScheduledTVC: UITableViewCell {
    
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
    
    @IBOutlet weak var reScheduledClassButton: RoundButton!
    @IBOutlet weak var cancelClassButton: RoundButton!
    
    //create your closure here
    var reScheduledClassButtonPressed : (() -> ()) = {}
    var cancelClassButtonPressed : (() -> ()) = {}
    
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
        // Configure the view for the selected state
    }
    
    @IBAction func reScheduledClassButtonAction(_ sender: Any) {
        reScheduledClassButtonPressed()
    }
    
    @IBAction func cancelClassButtonAction(_ sender: Any) {
        cancelClassButtonPressed()
    }
}
