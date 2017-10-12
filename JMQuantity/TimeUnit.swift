//
//  TimeUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum TimeUnit: Double, LinearUnit {

    case second =       604800.0
    case minute =       10080.0
    case hour =         168.0
    case day =          7.0
    case week =         1.0
    case julianYear =   52.17857142857142857142857142857142857142857142857142857142
    case siderealYear = 52.17948
    
    public var symbol: String {
        switch self {
        case .second: return "s"
        case .minute: return "min"
        case .hour: return "hour"
        case .day: return "day"
        case .week: return "week"
        case .julianYear,.siderealYear: return "yr"
        }
    }

}
