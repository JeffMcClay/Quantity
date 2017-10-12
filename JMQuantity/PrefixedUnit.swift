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
    
    init(prefix: SIPrefix = .none, baseUnit: U) {
        self.prefix = prefix
        self.baseUnit = baseUnit
    }
    
    init(_ prefix: SIPrefix = .none, _ baseUnit: U) {
        self.prefix = prefix
        self.baseUnit = baseUnit
    }
    
    init(_ baseUnit: U) {
        self.prefix = .none
        self.baseUnit = baseUnit
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
