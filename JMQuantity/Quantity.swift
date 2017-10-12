//
//  Quantity.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation


public struct Quantity<U: Unit>: CustomStringConvertible {
    //MARK: - Properties
    
    /// A PrefixedUnit struct containing an SIPrefix and a Unilinear unit enum.
    let unit: PrefixedUnit<U>
    
    /// Returns the value of the quantity, expressed in the quantity's PrefixedUnit.
    var value : Double {
        get { return _value / Double(unit.prefix.rawValue) }
    }
    
    /// Stores Quantity's value converted to no prefix.
    ///  Example: For a 2 Kilometer quantity, _value = 2000
    ///  Exmpale: For a 100 centimeter quantity, _value = 1
    internal let _value: Double
    
    public var description: String { get {
        return value.description + " " + unit.symbol
        }
    }
    
    public func roundedDescription(decimalPlaces: Int = 2, minDigits: Int = 0, separators: Bool = true) -> String {
        let f = NumberFormatter()
        f.maximumFractionDigits = decimalPlaces
        f.minimumFractionDigits = minDigits
        if separators {f.numberStyle = .decimal}
        //f.localizesFormat = true
        return f.string(from: NSNumber(value: value))! + " " + unit.symbol
    }
    
    public func roundedDescription(exactDigits d: Int) -> String {
        return roundedDescription(decimalPlaces: d, minDigits: d)
    }
    
    //MARK: - Initialization
    /// Init with a PrefixedUnit.
    public init(value: Double, unit:PrefixedUnit<U>) {
        self.unit = unit
        self._value = value * Double(unit.prefix.rawValue)
    }
    
    public init(_ value: Double, unit:PrefixedUnit<U>) {
        self.init(value: value, unit: unit)
    }
    
    /// Init with a Unilinear unit, with no (none) prefix.
    public init(_ value: Double, _ unit:U) {
        let pu = PrefixedUnit(prefix: .none, baseUnit: unit)
        self.init(value: value, unit:pu)
    }
    
    /// Init with a prefix and unit.
    public init(_ value: Double, prefix: SIPrefix = .none, unit: U) {
        let pu = PrefixedUnit(prefix: prefix, baseUnit: unit)
        self.init(value: value, unit:pu)
    }
    
    //MARK: - Conversion
    public func convert(to toPrefixedUnit: PrefixedUnit<U>) -> Quantity {
        return toPrefixedUnit.convert(self)
    }
    public func convert(to toUnit: U) -> Quantity {
        let pu = PrefixedUnit(baseUnit: toUnit)
        return pu.convert(self)
    }
}


