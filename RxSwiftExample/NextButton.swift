//
//  NextButton.swift
//  DatePickerCustomization
//
//  Created by Justine Kay on 8/20/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import UIKit

class NextButton: UIButton {
    override var enabled: Bool {
        didSet{
            alpha = enabled ? 1.0 : 0.3
        }
    }
}
