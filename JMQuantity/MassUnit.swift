//
//  MassUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/04.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

enum MassUnit: Double, LinearUnit {
    case Gram = 1
    case MetricTon = 1E-6
    case ImperialShortTon = 1.1023113109243879036148690067251351692710351366800989E-6
    case ImperialLongTon = 9.8420652761106062822756161314744211542056708632151689E-7
    case Slug = 0.068521765561961046335582743012612869908755731760037051089E-3
    case Pound = 2.204622621848775807229738013450270338542070273360197835779E-3
    case Stone = 0.000157473044417769700516409858103590738467290733811442702
    case Ounce = 0.035273961949580412915675808215204325416673124373763165372
    case TroyOunce = 0.032150746568627980522100346029483109103738524819836218438
    
    var symbol: String {
        switch self {
        case .Gram: return "gm"
        case .MetricTon: return "t"
        case .ImperialShortTon: return "ton"
        case .ImperialLongTon: return "lt"
        case .Slug: return "sl"
        case .Pound: return "lbm"
        case .Stone: return "st"
        case .Ounce: return "oz"
        case .TroyOunce: return "troyoz"
        }
    }
    
}