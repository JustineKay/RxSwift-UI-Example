//
//  UITextField+RxSwiftExample.swift
//  RxSwiftExample
//
//  Created by Justine Kay on 8/28/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func inputFieldStyle () {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(white: 1.0, alpha: 0.4).CGColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: frame.size.height)
        
        border.borderWidth = width
        layer.addSublayer(border)
        layer.masksToBounds = true
        
        textColor = .whiteColor()
        tintColor = .whiteColor()
        
        if let ph = placeholder {
            attributedPlaceholder = NSAttributedString(string: ph,
                                                       attributes: [NSForegroundColorAttributeName : UIColor(white: 1.0, alpha: 0.6), NSFontAttributeName : UIFont(name: "Avenir", size: 13.0)!])
        }

    }
}
