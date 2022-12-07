//
//  CountryListTableViewCell.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import UIKit

class CountryListTableViewCell: UITableViewCell {

  
    @IBOutlet weak var lineViewHeight: NSLayoutConstraint!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryDialCodeLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
     var heightOfLine : CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        heightOfLine = lineView.frame.height
        lineViewHeight.constant = heightOfLine

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        lineView.backgroundColor = borderColorandThemeColor
//        self.lineView.frame = CGRect(x: lineView.frame.origin.x, y: lineView.frame.origin.y, width: self.frame.width, height: 2)
         lineViewHeight.constant = 2.0
        debugPrint("Selected Cell of country")
        
        // Configure the view for the selected state
    }
    
    override var isSelected: Bool
        {
        didSet{
            if (isSelected)
            {
                countryCodeLabel?.font = globalTextFieldFont
                countryDialCodeLabel?.font = globalTextFieldFont
                countryNameLabel?.font = globalTextFieldFont
                
                countryCodeLabel?.textColor = UIColor.black
                countryDialCodeLabel?.textColor = UIColor.black
                countryDialCodeLabel?.textColor = UIColor.black
                 lineView.backgroundColor = borderColorandThemeColor
                 lineViewHeight.constant = 2.0
            }
            else
            {
                countryCodeLabel?.font = globalTextFieldFont
                countryDialCodeLabel?.font = globalTextFieldFont
                countryNameLabel?.font = globalTextFieldFont
                countryCodeLabel?.textColor = UIColor.black
                countryDialCodeLabel?.textColor = subTitleColorCode
                 lineView.backgroundColor = borderColorandThemeColor
                  lineViewHeight.constant = 1.0
//                countryDialCodeLabel?.textColor = UIColor.lightGray
            }
        }
    }
}
