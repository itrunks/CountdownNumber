//
//  UIButton+Extension.swift
//  Algorithm
//
//  Created by trioangle on 03/09/19.
//  Copyright © 2019 Trioangle. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class RoundButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
