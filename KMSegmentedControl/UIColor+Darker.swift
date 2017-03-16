//
//  UIColor+Darker.swift
//  KMSegmentedControl
//
//  Created by Kamil Mazurek on 02/06/16.
//  Copyright © 2016 KamilMazurek. All rights reserved.
//

import UIKit

extension UIColor {

  func darkerColor() -> UIColor {
    let amount: CGFloat = 0.8
    let rgba = UnsafeMutablePointer<CGFloat>.allocate(capacity: 4)

    self.getRed(&rgba[0], green: &rgba[1], blue: &rgba[2], alpha: &rgba[3])
    let darkerColor = UIColor(red: amount*rgba[0], green: amount*rgba[1], blue: amount*rgba[2], alpha: rgba[3])

    rgba.deinitialize()
    rgba.deallocate(capacity: 4)
    return darkerColor
  }
}
