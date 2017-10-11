//
//  PressureUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum PressureUnit: Double, LinearUnit {
    
    case atmosphere = 1.0
    case torr = 760
    case pascal = 101325
    case bar = 1.01325
    case inchesOfHg = 29.92125984251968503937007874015748031496062992126
    case psi = 14.695948775513448725503472157154729689217877000033
    case technicalAtmosphere = 1.0332274527998857917841464720368321496127627681216
    
    public var symbol: String {
        switch self {
        case .pascal: return "Pa"
        case .bar: return "bar"
        case .inchesOfHg: return "inHg"
        case .psi: return "PSI"
        case .atmosphere: return "atm"
        case .torr: return "Torr"
        case .technicalAtmosphere: return "at"
        }
    }
    
}
