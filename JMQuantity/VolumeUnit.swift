//
//  VolumeUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum VolumeUnit: Double, LinearUnit {
    case Liter = 1.0
    case Gallon = 0.26417205235814841538
    
    public var symbol : String {
        switch self {
        case.Liter: return "L"
        case.Gallon: return "gal"
        }
    }

}