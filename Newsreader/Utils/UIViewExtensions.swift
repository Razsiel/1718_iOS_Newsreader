//
//  UIViewExtensions.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 11/3/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
