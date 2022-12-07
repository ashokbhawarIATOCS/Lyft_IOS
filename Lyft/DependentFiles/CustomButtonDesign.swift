//
//  CustomButtonDesign.swift
//  ClinTrial
//
//  Created by Ideaqu on 14/02/19.
//  Copyright © 2019 Ideaqu. All rights reserved.
//

import UIKit

@IBDesignable public class CustomButtonDesign: UIButton {
    
    //Setting the button border color
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
     //Setting the button border width
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
      //Setting the button corner radius
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
}
