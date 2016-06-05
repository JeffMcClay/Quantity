//
//  DistanceUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum DistanceUnit: Double, LinearUnit {
    
    case Meter = 1609.344
    case Inch = 63360
    case Foot = 5280
    case Yard = 1760
    case Mile = 1.0
    case NauticalMile = 0.868976241900647948164146868250539956803455723542116630669
    
    public var symbol : String {
        switch self {
        case .Meter: return "m"
        case .Inch: return "in"
        case .Foot: return "ft"
        case .Yard: return "yd"
        case .Mile: return "mi"
        case .NauticalMile: return "NM"
        }
    }
}
