//
//  UTMHelpers.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/05.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

typealias UTMDouble = Double
typealias UTMGridZone = UInt

enum UTMHemisphere {
    case Northern
    case Southern
}

struct UTMCoordinates {
    let easting: UTMDouble
    let northing: UTMDouble
    let gridZone: UTMGridZone
    let band: String
    let hemisphere: UTMHemisphere
    
    func formattedString(digits: Int = 1) -> String {
        let f = NSNumberFormatter()
        f.maximumFractionDigits = digits
        f.minimumFractionDigits = digits
        
        let e = f.stringFromNumber(easting)!
        let n = f.stringFromNumber(northing)!
        
        return "\(gridZone)\(band) \(e)m E \(n)m N"
    }
}

struct TransverseMercatorCoordinates {
    let easting: UTMDouble
    let northing: UTMDouble
}

struct UTMDatum {
    let equitorialRadius: UTMDouble
    let polarRadius: UTMDouble
}

