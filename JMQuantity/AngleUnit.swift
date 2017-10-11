//
//  AngleUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/04.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

enum AngleUnit: Double, LinearUnit {
    case turn = 1.0
    case quandrant = 4.0
    case sextant = 6.0
    case hexacontade = 60.0
    case degree = 360.0
    case grad = 400.0
    case minuteOfAngle = 21600.0
    case secondAngle = 1296000.0
    case radian = 6.283185307179586476925286766559005768394338798750211641949       // 1 milliradian = 1 USMC mRad
    case milNATO = 6400     // ARMY Mils
    
    var symbol: String {
        switch self {
        case .turn: return "turn"
        case .quandrant: return "quandrant"
        case .sextant: return "sextant"
        case .hexacontade: return "hexacontade"
        case .degree: return "°"
        case .grad: return "grad"
        case .minuteOfAngle: return "MOA"
        case .secondAngle: return "″"
        case .radian: return "rad"
        case .milNATO: return "mil"
        }
    }
}
