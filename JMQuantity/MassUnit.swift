//
//  MassUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/04.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum MassUnit: Double, LinearUnit {
    case gram = 1
    case metricTon = 1E-6
    case imperialShortTon = 1.1023113109243879036148690067251351692710351366800989E-6
    case imperialLongTon = 9.8420652761106062822756161314744211542056708632151689E-7
    case slug = 0.068521765561961046335582743012612869908755731760037051089E-3
    case pound = 2.204622621848775807229738013450270338542070273360197835779E-3
    case stone = 0.000157473044417769700516409858103590738467290733811442702
    case ounce = 0.035273961949580412915675808215204325416673124373763165372
    case troyOunce = 0.032150746568627980522100346029483109103738524819836218438
    
    public var symbol: String {
        switch self {
        case .gram: return "gm"
        case .metricTon: return "t"
        case .imperialShortTon: return "ton"
        case .imperialLongTon: return "lt"
        case .slug: return "sl"
        case .pound: return "lbm"
        case .stone: return "st"
        case .ounce: return "oz"
        case .troyOunce: return "troyoz"
        }
    }
    
}
