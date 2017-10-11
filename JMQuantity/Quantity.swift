//
//  Quantity.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public typealias Distance = Quantity<DistanceUnit>
public typealias Pressure = Quantity<PressureUnit>
typealias Temperature = Quantity<TemperatureUnit>
typealias Angle = Quantity<AngleUnit>

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
    let _value: Double
    
    public var description: String { get {
        return value.description + " " + unit.symbol
        }
    }
    
    public func roundedDescription(_ decimalPlaces: Int) -> String {
        let f = NumberFormatter()
        f.maximumFractionDigits = decimalPlaces
        return f.string(from: NSNumber(value: value))! + " " + unit.symbol
    }
    
    //MARK: - Initialization
    /// Init with a PrefixedUnit.
    init(value: Double, unit:PrefixedUnit<U>) {
        self.unit = unit
        self._value = value * Double(unit.prefix.rawValue)
    }
    
    init(_ value: Double, unit:PrefixedUnit<U>) {
        self.unit = unit
        self._value = value * Double(unit.prefix.rawValue)
    }
    
    /// Init with a Unilinear unit, with no (none) prefix.
    init(_ value: Double, _ unit:U) {
        let pu = PrefixedUnit(prefix: .none, baseUnit: unit)
        self.init(value: value, unit:pu)
    }
    
    /// Init with a prefix and unit.
    init(_ value: Double, prefix: SIPrefix = .none, unit: U) {
        let pu = PrefixedUnit(prefix: prefix, baseUnit: unit)
        self.init(value: value, unit:pu)
    }
    
    //MARK: - Conversion
    func convert(to toPrefixedUnit: PrefixedUnit<U>) -> Quantity {
        return toPrefixedUnit.convert(self)
    }
    func convert(to toUnit: U) -> Quantity {
        let pu = PrefixedUnit(baseUnit: toUnit)
        return pu.convert(self)
    }
}

//MARK: - Operators
infix operator --> //{associativity left}
func --><U: Unit>(lhs: Quantity<U>, rhs: PrefixedUnit<U>) -> Quantity<U> { return lhs.convert(to: rhs) }
func --><U: Unit>(lhs: Quantity<U>, rhs: U) -> Quantity<U> { return lhs.convert(to: PrefixedUnit(baseUnit: rhs)) }

func ==<U: Unit>(lhs: Quantity<U>, rhs: Quantity<U>) -> Bool {
    if (lhs.unit == rhs.unit) {
        return lhs._value == rhs._value
    } else {
        let rhsConverted = rhs.convert(to: lhs.unit)
        return lhs._value == rhsConverted._value
    }
}

func <<U: Unit>(lhs: Quantity<U>, rhs: Quantity<U>) -> Bool {
    if (lhs.unit == rhs.unit) {
        return lhs._value < rhs._value
    } else {
        let rhsConverted = rhs.convert(to: lhs.unit)
        return lhs._value < rhsConverted._value
    }
}

func ><U: Unit>(lhs: Quantity<U>, rhs: Quantity<U>) -> Bool {
    if (lhs.unit == rhs.unit) {
        return lhs._value > rhs._value
    } else {
        let rhsConverted = rhs.convert(to: lhs.unit)
        return lhs._value > rhsConverted._value
    }
}

prefix func -<U: Unit>(q: Quantity<U>) -> Quantity<U> { return Quantity(value: -q.value, unit: q.unit) }

func -<U: Unit>(lhs: Quantity<U>, rhs: Quantity<U>) -> Quantity<U> {
    if (lhs.unit == rhs.unit) {
        return Quantity(value:lhs.value - rhs.value, unit: lhs.unit)
    } else {
        let rhsConverted = rhs.convert(to: lhs.unit)
        return Quantity(value: lhs.value - rhsConverted.value, unit: lhs.unit)
    }
}

func +<U: Unit>(lhs: Quantity<U>, rhs: Quantity<U>) -> Quantity<U> {
    if (lhs.unit == rhs.unit) {
        return Quantity(value:lhs.value + rhs.value, unit: lhs.unit)
    } else {
        let rhsConverted = rhs.convert(to: lhs.unit)
        return Quantity(value: lhs.value + rhsConverted.value, unit: lhs.unit)
    }
}

func +<U: Unit>(lhs: Quantity<U>, rhs: Double) -> Quantity<U> { return Quantity(value:lhs.value + rhs, unit: lhs.unit) }
