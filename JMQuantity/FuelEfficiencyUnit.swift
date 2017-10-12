//
//  FuelEfficiencyUnit.swift
//  JMQuantity
//
//  Created by Jeff on 10/11/17.
//  Copyright © 2017 Jeff McClay. All rights reserved.
//

import Foundation

typealias ScalarType = Int

enum FuelUnit<DistanceUnit: LinearUnit, VolumeUnit: LinearUnit>: Unit {
    
    case distPerVol(PrefixedUnit<DistanceUnit>, PrefixedUnit<VolumeUnit>, ScalarType)
    case volPerDist(PrefixedUnit<VolumeUnit>, PrefixedUnit<DistanceUnit>, ScalarType)
    
    init(distance: PrefixedUnit<DistanceUnit>, per: ScalarType, _ vol: PrefixedUnit<VolumeUnit>) {
        self = FuelUnit.distPerVol(distance, vol, per)
    }
    init(volume: PrefixedUnit<VolumeUnit>, per: ScalarType, _ dist: PrefixedUnit<DistanceUnit>) {
        self = FuelUnit.volPerDist(volume, dist, per)
    }
    
    init(distance: PrefixedUnit<DistanceUnit>, perVolume vol: PrefixedUnit<VolumeUnit>) {
        self.init(distance:distance, per:1, vol)
    }
    init(volume: PrefixedUnit<VolumeUnit>, perDistance dist: PrefixedUnit<DistanceUnit>) {
        self.init(volume:volume, per:1, dist)
    }
    
    var symbol: String {
        switch self {
        case .distPerVol(let dist, let vol, let scalar):
            if scalar == 1 { return "\(dist.symbol)/\(vol.symbol)" }
            else { return "\(dist.symbol)/\(scalar)\(vol.symbol)" }
        case .volPerDist(let vol, let dist, let scalar):
            if scalar == 1 { return "\(vol.symbol)/\(dist.symbol)" }
            else { return "\(vol.symbol)/\(scalar)\(dist.symbol)" }
        }
    }
    var name: String {
        switch self {
        case .distPerVol(let dist, let vol, _):
            return dist.symbol + " per " + vol.symbol
        case .volPerDist(let vol, let dist, _):
            return vol.symbol + " per " + dist.symbol
        }
    }
    
    func convert(_ quantity: Quantity<FuelUnit>, toPrefixedUnit: PrefixedUnit<FuelUnit>) -> Quantity<FuelUnit> {
        if quantity.unit == toPrefixedUnit { return quantity }
        
        switch quantity.unit.baseUnit {
        case .distPerVol(let mainFrom, let changeFrom, let scalarFrom):
            switch toPrefixedUnit.baseUnit {
            case .distPerVol(let mainTo, let changeTo, let scalarTo):
                // Convert the numerator
                let num_pu = PrefixedUnit(prefix: mainFrom.prefix, baseUnit: mainFrom.baseUnit)
                let numerator = Quantity(value: quantity.value, unit: num_pu)
                let num_c = numerator --> mainTo
                
                // Convert the denominator
                let den_pu = PrefixedUnit(prefix: changeFrom.prefix, baseUnit: changeFrom.baseUnit)
                let denominator = Quantity(value: 1, unit: den_pu)
                let den_c = denominator --> changeTo
                
                // Finish the conversion, and apply the prefix
                let nonPrefixedValue = num_c.value / den_c.value / toPrefixedUnit.prefix.rawValue / Double(scalarFrom/scalarTo)
                let q = Quantity(value: nonPrefixedValue, unit: toPrefixedUnit)
                return q
                
            case .volPerDist(let mainTo, let changeTo, let scalarTo):
                // Convert the numerator
                let num_pu = PrefixedUnit(prefix: mainFrom.prefix, baseUnit: mainFrom.baseUnit)
                let den_pu = PrefixedUnit(prefix: changeFrom.prefix, baseUnit: changeFrom.baseUnit)
                
                let denominator = Quantity(value: 1, unit: den_pu)
                let numerator = Quantity(value: quantity.value, unit: num_pu)
                
                let num_c = denominator --> mainTo
                let den_c = numerator --> changeTo
                
                // Finish the conversion, and apply the prefix
                let nonPrefixedValue = num_c.value / den_c.value / toPrefixedUnit.prefix.rawValue * Double(scalarTo/scalarFrom)//good
                let q = Quantity(value: nonPrefixedValue, unit: toPrefixedUnit)
                return q
            }
        case .volPerDist(let mainFrom, let changeFrom, let scalarFrom):
            switch toPrefixedUnit.baseUnit {
            case .volPerDist(let mainTo, let changeTo, let scalarTo):
                // Convert the numerator
                let num_pu = PrefixedUnit(prefix: mainFrom.prefix, baseUnit: mainFrom.baseUnit)
                let numerator = Quantity(value: quantity.value, unit: num_pu)
                let num_c = numerator --> mainTo
                
                // Convert the denominator
                let den_pu = PrefixedUnit(prefix: changeFrom.prefix, baseUnit: changeFrom.baseUnit)
                let denominator = Quantity(value: 1, unit: den_pu)
                let den_c = denominator --> changeTo
                
                // Finish the conversion, and apply the prefix
                let nonPrefixedValue = num_c.value / den_c.value / toPrefixedUnit.prefix.rawValue / Double(scalarFrom/scalarTo)
                let q = Quantity(value: nonPrefixedValue, unit: toPrefixedUnit)
                return q
                
            case .distPerVol(let mainTo, let changeTo, let scalarTo):
                // Convert the numerator
                let num_pu = PrefixedUnit(prefix: mainFrom.prefix, baseUnit: mainFrom.baseUnit)
                let den_pu = PrefixedUnit(prefix: changeFrom.prefix, baseUnit: changeFrom.baseUnit)
                
                let denominator = Quantity(value: 1, unit: den_pu)
                let numerator = Quantity(value: quantity.value, unit: num_pu)
                
                let num_c = denominator --> mainTo
                let den_c = numerator --> changeTo
                
                // Finish the conversion, and apply the prefix
                let nonPrefixedValue = num_c.value / den_c.value / toPrefixedUnit.prefix.rawValue * Double(scalarFrom/scalarTo) //good
                let q = Quantity(value: nonPrefixedValue, unit: toPrefixedUnit)
                return q
            }
        }
    }
    
}
