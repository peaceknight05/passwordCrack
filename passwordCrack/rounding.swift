//
//  rounding.swift
//  passwordCrack
//
//  Created by Jonathan Tan on 15/8/18.
//  Copyright © 2018 Jonathan Tan. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
