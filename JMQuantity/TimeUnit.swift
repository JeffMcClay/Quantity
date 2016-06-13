//
//  TimeUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

enum TimeUnit: Double, LinearUnit {

    case Second =       604800.0
    case Minute =       10080.0
    case Hour =         168.0
    case Day =          7.0
    case Week =         1.0
    case JulianYear =   52.17857142857142857142857142857142857142857142857142857142
    case SiderealYear = 52.17948
    
    var symbol: String {
        switch self {
        case .Second: return "s"
        case .Minute: return "min"
        case .Hour: return "hour"
        case .Day: return "day"
        case .Week: return "week"
        case .JulianYear,.SiderealYear: return "yr"
        }
    }

}