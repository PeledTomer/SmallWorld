//
//  Extensions.swift
//  SmallWorld
//
//  Created by Tomer Peled on 8/18/18.
//  Copyright © 2018 Tomer Peled. All rights reserved.
//

import Foundation

//Floats are more readable this way for the common users
//[No "e+06"]
extension Float {
    var my_avoidNotation: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}
