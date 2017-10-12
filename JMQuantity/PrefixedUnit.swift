//
//  PrefixedUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public struct PrefixedUnit<U: Unit> {
    let prefix: SIPrefix
    let baseUnit: U
    
    var symbol: String {
        return "\(prefix)\(baseUnit.symbol)"
    }
    
    public init(prefix: SIPrefix = .none, baseUnit: U) {
        self.prefix = prefix
        self.baseUnit = baseUnit
    }
    
    public init(_ prefix: SIPrefix = .none, _ baseUnit: U) {
        self.init(prefix: prefix, baseUnit: baseUnit)
    }
    
    public init(_ baseUnit: U) {
        self.init(prefix: .none, baseUnit: baseUnit)
    }
    
    func convert(_ quantity: Quantity<U>) -> Quantity<U> {
        return baseUnit.convert(quantity, toPrefixedUnit: self)
    }
}

extension PrefixedUnit: CustomStringConvertible {
    public var description:String {
        return "\(prefix.longName)\(baseUnit.name)"
    }
}

extension PrefixedUnit: Equatable {
    static public func == <U>(lhs: PrefixedUnit<U>, rhs: PrefixedUnit<U>) -> Bool {
        return (lhs.baseUnit == rhs.baseUnit) && (lhs.prefix == rhs.prefix)
    }
}
