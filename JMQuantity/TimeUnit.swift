//
//  TimeUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

enum TimeUnit: Double, LinearUnit {
//    case Second =       1.0
//    case Minute =       1.666666666666666666666E-2
//    case Hour =         2.777777777777777777777E-4
//    case Day =          1.157407407407407407407E-5
//    case Week =         1.6534391534391534391534391534391534391534391534391534E-6
//    case JulianYear =   3.1688087814028950237026896848936547772961188430045377E-9
//    case SiderealYear = 3.1687535786877787892025204561613546088525280228232390E-9

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