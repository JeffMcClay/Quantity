//
//  PressureUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum PressureUnit: Double, LinearUnit {
    
    case Atmosphere = 1.0
    case Torr = 760
    case Pascal = 101325
    case Bar = 1.01325
    case InchesOfHg = 29.92125984251968503937007874015748031496062992126
    case PSI = 14.695948775513448725503472157154729689217877000033
    case TechnicalAtmosphere = 1.0332274527998857917841464720368321496127627681216
    
    public var symbol: String {
        switch self {
        case .Pascal: return "Pa"
        case .Bar: return "bar"
        case .InchesOfHg: return "inHg"
        case .PSI: return "PSI"
        case .Atmosphere: return "atm"
        case .Torr: return "Torr"
        case .TechnicalAtmosphere: return "at"
        }
    }
    
}