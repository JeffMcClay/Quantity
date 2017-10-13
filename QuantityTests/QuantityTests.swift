//
//  QuantityTests.swift
//  QuantityTests
//
//  Created by Jeff on 6/12/16.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import XCTest

class QuantityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreation() {
        let tenKilometers = Quantity(10.0, prefix:.kilo, unit:DistanceUnit.meter)
        XCTAssertNotNil(tenKilometers)
        XCTAssert(tenKilometers.value == 10)
        XCTAssertEqual(tenKilometers.roundedDescription(exactDigits: 3), "10.000 km")
        
        // Test conversion of SIPrefixes
        let manycms = tenKilometers --> PrefixedUnit(prefix: .centi, baseUnit: .meter)
        XCTAssert(tenKilometers == manycms)
        XCTAssertEqual(tenKilometers._value, manycms._value)
        XCTAssertEqual(manycms.roundedDescription(separators: false), "1000000 cm")
        
        let tenKmToMiles = tenKilometers --> .mile
        XCTAssert(tenKilometers == tenKmToMiles)
        XCTAssertEqual(tenKmToMiles.roundedDescription(exactDigits: 5), "6.21371 mi")
        XCTAssertEqual(tenKmToMiles.roundedDescription(), "6.21 mi")
        XCTAssertEqual(tenKmToMiles.roundedDescription(decimalPlaces: 3, minDigits: 2), "6.214 mi")
    }
    
    func testMath() {
        //Scalar addition
        
        //Quantity addition
        
        
    }
    
    func testAreas() {
        let a1 = Area(34, AreaUnit(.foot))
        let a2 = Area(34, AreaUnit(.meter))
        XCTAssertEqual(a1.roundedDescription(exactDigits: 5), "34.00000 ft²")
        XCTAssertEqual(a2.roundedDescription(exactDigits: 5), "34.00000 m²")
        XCTAssertNotEqual(a1, a2)
        
        // Test Scalar Multiplication of Distance
        let d1 = Distance(1111, .inch)
        let notArea = d1 * 3
        XCTAssert(notArea is Distance)
        XCTAssertFalse(notArea is Area)
        XCTAssertEqual(notArea.roundedDescription(exactDigits: 2, separators: false), "3333.00 in")
        
        // Test Multiplication Operator
        let a3 = Distance(13.6, .foot) * Distance(2.5, .foot)
        XCTAssertEqual(a3.roundedDescription(exactDigits: 5), "34.00000 ft²")
        XCTAssertEqual(a3, a1)
        XCTAssertTrue(a3 == a1)
        
        // Different Area Units
        let a4 = Distance(1.0, .chain) * Distance(1.0, .furlong)
        let a5 = Area(1.0, .areaUnit(.acre))
        XCTAssertEqual(a4.roundedDescription(exactDigits: 5), "10.00000 chain²")
        XCTAssertEqual(a5.roundedDescription(exactDigits: 5), "1.00000 ac")
        XCTAssertEqual(a4, a5)
        XCTAssertEqual(a5, a4)
        
        // Both areaUnit
        let a6 = Area(0.4046875, unit:PrefixedUnit(.hecto, AreaUnit(.are)))
        XCTAssertEqual(a6.roundedDescription(exactDigits: 8), "0.40468750 ha")
        XCTAssertEqual(a6, a5)
        XCTAssertEqual(a5, a6)
        
        // Both squareUnit
        let a7 = Area(43560, AreaUnit(.foot))
        XCTAssertEqual(a7.roundedDescription(exactDigits: 5, separators: false), "43560.00000 ft²")
        XCTAssertEqual(a7, a4)
        XCTAssertEqual(a4, a7)
    }
    
    func testRates() {
        
        // Test construction of velocities
        let v0 = Velocity(88, RateUnit(DistanceUnit.inch, per:TimeUnit.second))
        let v00 = Quantity(88, RateUnit(DistanceUnit.inch, per:TimeUnit.second))
        XCTAssertEqual(v0, v00)
        
        let v1 = Velocity(18, VelocityUnit(.mile, per:.hour))
        let v2 = Velocity(1584, VelocityUnit(.foot, per:.minute))
        XCTAssertEqual(v1.roundedDescription(exactDigits: 2), "18.00 mi/hr")
        XCTAssertEqual(v2.roundedDescription(exactDigits: 2, separators: false), "1584.00 ft/min")
        
        // Should not be equal
        XCTAssertNotEqual(v0, v1)
        XCTAssertNotEqual(v0, v2)
        
        let ne1 = Quantity(88, RateUnit(DistanceUnit.inch, per:TimeUnit.second))
        let ne2 = Quantity(88.1, RateUnit(DistanceUnit.inch, per:TimeUnit.second))
        XCTAssertNotEqual(ne1, ne2)
        
        let ne3 = Quantity(99, RateUnit(DistanceUnit.inch, per:TimeUnit.second))
        let ne4 = Quantity(99, RateUnit(DistanceUnit.inch, per:TimeUnit.minute))
        let ne5 = Quantity(99, RateUnit(DistanceUnit.yard, per:TimeUnit.minute))
        let ne6 = Quantity(99, RateUnit(DistanceUnit.yard, per:TimeUnit.day))
        XCTAssertNotEqual(ne3, ne4)
        XCTAssertNotEqual(ne3, ne5)
        XCTAssertNotEqual(ne3, ne6)
        XCTAssertNotEqual(ne4, ne5)
        XCTAssertNotEqual(ne4, ne6)
        XCTAssertNotEqual(ne5, ne6)
        
        // Test conversion
        let v1_conv = v1 --> VelocityUnit(.foot, per:.minute)
        let v2_conv = v2 --> VelocityUnit(.mile, per:.hour)
        XCTAssertEqual(v1_conv.roundedDescription(exactDigits: 2, separators: false), "1584.00 ft/min")
        XCTAssertEqual(v2_conv.roundedDescription(exactDigits: 2, separators: false), "18.00 mi/hr")
        
        // Test equality of two exactly equal velocities
        XCTAssertEqual(v1, v2)
        
        // Test division operator
        let d1 = Distance(9, .mile)
        let t1 = Time(0.5, .hour)
        let v1_2 = d1 / t1
        XCTAssertEqual(v1_2.roundedDescription(exactDigits: 2), "18.00 mi/hr")
        XCTAssertEqual(v1_2, v1)
        
        let v2_2 = Distance(36, .mile) / Time(2, .hour)
        XCTAssertEqual(v2_2.roundedDescription(exactDigits: 2, separators: false), "18.00 mi/hr")
        XCTAssertEqual(v2_2, v2)
        XCTAssertEqual(v1_2, v2_2)
    }
    
    func testFuelEff() {
        let eff1 = FuelEfficiency(21.45, FuelUnit(distance: .mile, perVol: .gallonUS))
        XCTAssertEqual(eff1.roundedDescription(exactDigits: 2), "21.45 mi/gal")
        
        // Test Conversions
        let eff1_km = eff1 --> FuelUnit(distance: PrefixedUnit(.kilo, DistanceUnit.meter), perVolume:PrefixedUnit(VolumeUnit.liter))
        XCTAssertEqual(eff1_km.roundedDescription(exactDigits: 5), "9.11933 km/L")
        
        let eff1_muk = eff1 --> FuelUnit(distance: .mile, perVol: .gallonImperial)
        XCTAssertEqual(eff1_muk.roundedDescription(exactDigits: 5), "25.76038 mi/gal")
        
        let eff1_lp100k = eff1 --> FuelUnit(volume: .liter, per: 100, PrefixedUnit(.kilo, DistanceUnit.meter))
        XCTAssertEqual(eff1_lp100k.roundedDescription(exactDigits: 5), "10.96571 L/100km")
        
        let eff1_lpk = eff1 --> FuelUnit(volume: .liter, perDistance: PrefixedUnit(.kilo, DistanceUnit.meter))
        XCTAssertEqual(eff1_lpk.roundedDescription(exactDigits: 7), "0.1096571 L/km")
        
        // Test Division Operator
        let d1 = Distance(346, .mile)
        let v1 = Quantity(13.654, VolumeUnit.gallonUS)
        let eff2 = d1 / v1
        XCTAssert(eff2 is FuelEfficiency)
        XCTAssertEqual(eff2.roundedDescription(exactDigits: 5), "25.34056 mi/gal")
        
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
