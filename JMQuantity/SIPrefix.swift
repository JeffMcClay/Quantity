//
//  SIPrefix.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum SIPrefix : Double, CustomStringConvertible {
    case Pico =  1E-12
    case Nano =  1E-9
    case Micro = 1E-6
    case Milli = 1E-3
    case Centi = 1E-2
    case Deci =  1E-1
    case none =  1
    case Deca =  1E1
    case Hecto = 1E2
    case Kilo =  1E3
    case Mega =  1E6
    case Giga =  1E9
    case Tera =  1E12
    case Peta =  1E15
    case Exa =   1E18
    case Zetta = 1E21
    case Yotta = 1E24
    
    public var description : String {
        switch self {
        case .Pico: return "p"
        case .Nano: return "n"
        case .Micro: return "µ"
        case .Milli: return "m"
        case .Centi: return "c"
        case .Deci: return "d"
        case .none: return ""
        case .Deca: return "da"
        case .Hecto: return "h"
        case .Kilo: return "k"
        case .Mega: return "M"
        case .Giga: return "G"
        case .Tera: return "T"
        case .Peta: return "P"
        case .Exa: return "E"
        case .Zetta: return "Z"
        case .Yotta: return "Y"
        }
    }
}