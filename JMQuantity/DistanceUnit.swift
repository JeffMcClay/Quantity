//
//  DistanceUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum DistanceUnit: Double, LinearUnit {
    
    case meter = 1609.344   //exact by international agreement in 1959
    case inch = 63360
    case foot = 5280
    case yard = 1760
    case mile = 1.0
    case nauticalMile = 0.868976241900647948164146868250539956803455723542116630669  // 1609.344/1852
    case rod = 320
    case chain = 80
    case furlong = 8
    
    public var symbol : String {
        switch self {
        case .meter: return "m"
        case .inch: return "in"
        case .foot: return "ft"
        case .yard: return "yd"
        case .mile: return "mi"
        case .nauticalMile: return "NM"
        case .rod: return "rod"
        case .chain: return "chain"
        case .furlong: return "fur"
        }
    }
}

