//
//  UTMHelpers.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/05.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

//  Some of this code was ported from GeodeticUTMConverter by Created by Cameron Lowell Palmer & Mariia Ruchko.
//  https://github.com/palmerc/GeodeticUTMConverter
//  It was originally an Objective-C port of Chuck Taylor's javascript

import Foundation
import CoreLocation

extension UTMCoordinates {
    
    init(easting: UTMDouble, northing: UTMDouble, gridZone: UTMGridZone, band: UTMBand, hemisphere: UTMHemisphere) {
        self.easting = easting
        self.northing = northing
        self.gridZone = gridZone
        self.band = band
        self.hemisphere = hemisphere
    }
    
    /// Creates a new UTMCoordinate given a locator string
    ///  - parameter locator: A string containing the grid zone and utm band for the coordinate
    init?(easting: UTMDouble, northing: UTMDouble, locator: String) {
        let f = NSNumberFormatter()
        f.maximumFractionDigits = 0
        var _locator = locator
        
        // Find the 1 or 2 digit zone number
        var zone = ""
        for c in locator.characters {
            let tmp = zone + String(c)
            if let _ = f.numberFromString(tmp) { zone = tmp }
            else { break }
        }
        
        // convert the zone string into a double
        let zoneNum = f.numberFromString(zone)?.unsignedIntegerValue
        
        // strip the zone from the locator
        if let rng = _locator.rangeOfString(zone) { _locator.removeRange(rng) }
        else { return nil }
        
        // there should only be a single char left in _locator so check it for memberhsip in UTMBands
        var band: Character? = nil
        for c in _locator.uppercaseString.characters {
            if UTMBands.contains(c) {
                band = c
                break
            }
        }
        
        guard zoneNum != nil && band != nil else { return nil }
        
        let idx = UTMBands.indexOf(band!)
        if idx > 11 && idx < UTMBands.count { self.hemisphere = .Northern }
        else if idx <= 11 { self.hemisphere = .Southern }
        else { return nil }
        
        self.easting = easting
        self.northing = northing
        self.gridZone = zoneNum!
        self.band = band!        
    }
    
    func hemisphereForBand(band: UTMBand) -> UTMHemisphere? {
        let idx = UTMBands.indexOf(band)
        if idx > 11 && idx < UTMBands.count { return .Northern }
        else if idx <= 11 { return .Southern }
        return nil
    }
    
    func latitudeBand(latitude: UTMDouble) -> UTMBand {
        var latzone = 0.0;
        if (latitude > -80 && latitude < 72) { latzone = floor((latitude + 80)/8)+2 }
        if (latitude > 72 && latitude < 84) { latzone = 21 }
        if (latitude > 84) { latzone = 23 }
        
        let band = UTMBands[Int(latzone)]
        return band
    }
    
    func formattedString(digits: Int = 1) -> String {
        let f = NSNumberFormatter()
        f.maximumFractionDigits = digits
        f.minimumFractionDigits = digits
        
        let e = f.stringFromNumber(easting)!
        let n = f.stringFromNumber(northing)!
        
        return "\(gridZone)\(band) \(e)m E \(n)m N"
    }
    
    func latitudeAndLongitude() -> CLLocationCoordinate2D {
        return GeodeticUTMConverter.convertUTMToLatLon(self)
    }
}

struct TransverseMercatorCoordinates {
    let easting: UTMDouble
    let northing: UTMDouble
}

typealias UTMBand = Character
let UTMBands: [Character] = ["A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z"]

