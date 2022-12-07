//
//  SettingTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 18/11/22.
//

import UIKit

class SettingTVC: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var nextArrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    //create your closure here
    var switchButtonPressedON : (() -> ()) = {}
    var switchButtonPressedOFF : (() -> ()) = {}
    
    var switchFlag: Bool = false {
            didSet{               //This will fire everytime the value for switchFlag is set
                print(switchFlag) //do something with the switchFlag variable
            }
        }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    
    @IBAction func switchButtonAction(_ sender: Any) {
        if self.switchButton.isOn{
                switchFlag = true
                switchButtonPressedON()
        }else{
                switchFlag = false
                switchButtonPressedOFF()
        }
    }
}
