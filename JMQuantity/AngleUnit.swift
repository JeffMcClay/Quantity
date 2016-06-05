//
//  AngleUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/04.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

enum AngleUnit: Double, LinearUnit {
    case Turn = 1.0
    case Quandrant = 4.0
    case Sextant = 6.0
    case Hexacontade = 60.0
    case Degree = 360.0
    case Grad = 400.0
    case MinuteOfAngle = 21600.0
    case SecondAngle = 1296000.0
    case Radian = 6.283185307179586476925286766559005768394338798750211641949       // 1 milliradian = 1 USMC mRad
    case MilNATO = 6400     // ARMY Mils
    
    var symbol: String {
        switch self {
        case Turn: return "turn"
        case Quandrant: return "quandrant"
        case Sextant: return "sextant"
        case Hexacontade: return "hexacontade"
        case Degree: return "°"
        case Grad: return "grad"
        case MinuteOfAngle: return "MOA"
        case SecondAngle: return "″"
        case Radian: return "rad"
        case MilNATO: return "mil"
        }
    }
}