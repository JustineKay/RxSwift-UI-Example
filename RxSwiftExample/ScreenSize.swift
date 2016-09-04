//
//  ScreenSize.swift
//  RxSwiftExample
//
//  Created by Justine Kay on 9/4/16.
//  Copyright © 2016 Justine Kay. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize {
    static let deviceHeight = UIWindow(frame: UIScreen.mainScreen().bounds).bounds.height
    static var isIPhone4: Bool { return deviceHeight <= 480 }
    static var isIPhone5: Bool { return (deviceHeight > 480) && (deviceHeight <= 568) }
}

