//
//  SIPrefix.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum SIPrefix : Double, CustomStringConvertible {
    case yocto  = 1E-24
    case zepto  = 1E-21
    case atto   = 1E-18
    case femto  = 1E-15
    case pico   = 1E-12
    case nano   = 1E-9
    case micro  = 1E-6
    case milli  = 1E-3
    case centi  = 1E-2
    case deci   = 1E-1
    case none   = 1
    case deca   = 1E1
    case hecto  = 1E2
    case kilo   = 1E3
    case mega   = 1E6
    case giga   = 1E9
    case tera   = 1E12
    case peta   = 1E15
    case exa    = 1E18
    case zetta  = 1E21
    case yotta  = 1E24

    public var description : String {
        switch self {
        case .yocto:    return "y"
        case .zepto:    return "z"
        case .atto:     return "a"
        case .femto:    return "f"
        case .pico:     return "p"
        case .nano:     return "n"
        case .micro:    return "µ"
        case .milli:    return "m"
        case .centi:    return "c"
        case .deci:     return "d"
        case .none:     return ""
        case .deca:     return "da"
        case .hecto:    return "h"
        case .kilo:     return "k"
        case .mega:     return "M"
        case .giga:     return "G"
        case .tera:     return "T"
        case .peta:     return "P"
        case .exa:      return "E"
        case .zetta:    return "Z"
        case .yotta:    return "Y"
        }
    }
    
    public var longName : String {
        switch self {
        case .yocto:    return "yocto"
        case .zepto:    return "zepto"
        case .atto:     return "atto"
        case .femto:    return "femto"
        case .pico:     return "pico"
        case .nano:     return "nano"
        case .micro:    return "micro"
        case .milli:    return "milli"
        case .centi:    return "centi"
        case .deci:     return "deci"
        case .none:     return ""
        case .deca:     return "deca"
        case .hecto:    return "hecto"
        case .kilo:     return "kilo"
        case .mega:     return "mega"
        case .giga:     return "giga"
        case .tera:     return "tera"
        case .peta:     return "peta"
        case .exa:      return "exa"
        case .zetta:    return "zetta"
        case .yotta:    return "yotta"
        }
    }
}
