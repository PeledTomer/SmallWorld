//
//  Country.swift
//  SmallWorld
//
//  Created by Tomer Peled on 8/17/18.
//  Copyright © 2018 Tomer Peled. All rights reserved.
//

import UIKit

class Country: Decodable {
    
    var name: String?
    var nativeName: String?
    var capital: String?
    var alpha3Code: String?
    var borders: [String]?
    var region: String?
    var population: Float?
    var area: Float?
    var callingCodes: [String]?
    var flag: String?
}
