//
//  Style.swift
//  PitchPerfect
//
//  Created by Runa Alam on 17/8/18.
//  Copyright © 2018 Runa Alam. All rights reserved.
//

import UIKit

extension UIView {
    
    func glowShadow() {
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 15 
    }
    
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
    }
}
