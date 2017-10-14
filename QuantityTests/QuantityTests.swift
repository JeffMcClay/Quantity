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
    
    func testDistanceConversions() {
        // test all conversion factors
        let meter1 = Distance(100.0, .meter)
        XCTAssertEqual((meter1.convert(to: .inch).roundedDescription(exactDigits: 5, separators: false)), "3937.00787 in")
        XCTAssertEqual((meter1.convert(to: .foot).roundedDescription(exactDigits: 5, separators: false)), "328.08399 ft")
        XCTAssertEqual((meter1.convert(to: .yard).roundedDescription(exactDigits: 5, separators: false)), "109.36133 yd")
        XCTAssertEqual((meter1.convert(to: .mile).roundedDescription(exactDigits: 9, separators: false)), "0.062137119 mi")
        XCTAssertEqual((meter1.convert(to: .nauticalMile).roundedDescription(exactDigits: 9, separators: false)), "0.053995680 NM")
        XCTAssertEqual((meter1.convert(to: .rod).roundedDescription(exactDigits: 5, separators: false)), "19.88388 rd")
        XCTAssertEqual((meter1.convert(to: .chain).roundedDescription(exactDigits: 5, separators: false)), "4.97097 ch")
        XCTAssertEqual((meter1.convert(to: .furlong).roundedDescription(exactDigits: 6, separators: false)), "0.497097 fur")
        XCTAssertEqual((meter1.convert(to: .fathom).roundedDescription(exactDigits: 5, separators: false)), "54.68066 fathom")
        
        let inches = Distance(10000, .inch)
        XCTAssertEqual((inches.convert(to: .meter).roundedDescription(exactDigits: 5)), "254.00000 m")
        XCTAssertEqual((inches.convert(to: .foot).roundedDescription(exactDigits: 5)), "833.33333 ft")
        XCTAssertEqual((inches.convert(to: .yard).roundedDescription(exactDigits: 5)), "277.77778 yd")
        XCTAssertEqual((inches.convert(to: .mile).roundedDescription(exactDigits: 7)), "0.1578283 mi")
        XCTAssertEqual((inches.convert(to: .nauticalMile).roundedDescription(exactDigits: 6)), "0.137149 NM")
        XCTAssertEqual((inches.convert(to: .rod).roundedDescription(exactDigits: 5)), "50.50505 rd")
        XCTAssertEqual((inches.convert(to: .chain).roundedDescription(exactDigits: 6)), "12.626263 ch")
        XCTAssertEqual((inches.convert(to: .furlong).roundedDescription(exactDigits: 6)), "1.262626 fur")
        XCTAssertEqual((inches.convert(to: .fathom).roundedDescription(exactDigits: 5)), "138.88889 fathom")
    }
    
    func testScalarMath() {
        
        let dkm1 = Distance(12.4, unit:PrefixedUnit(.kilo, .meter))
        let d1 = Distance(8.34, .inch)
        let d2 = Distance(14.34, .inch)
        
        // Scalar subtraction
        let d3 = Distance(6.22, .inch)
        let d1_3 = d2 - 8.12
        XCTAssertEqual(d1_3.roundedDescription(exactDigits: 2), "6.22 in")
        XCTAssertEqual(d3, d1_3)
        XCTAssertEqual(d1_3, d3)
        
        // Scalar Multiplication
        let d4 = d1 * 2
        let d1_double = Distance(16.68, .inch)
        XCTAssertEqual(d4.roundedDescription(exactDigits: 2), "16.68 in")
        XCTAssertEqual(d4, d1_double)
        XCTAssertEqual(d1_double, d4)
        
        let dkm1mult = dkm1 * 3
        let dkm3 = Distance(37.2, unit: PrefixedUnit(.kilo, .meter))
        XCTAssertEqual(dkm1mult.roundedDescription(exactDigits: 2), "37.20 km")
        XCTAssertEqual(dkm1mult, dkm3)
        XCTAssertEqual(dkm3, dkm1mult)
        
        // Scalar Division
        let d5 = d2 / 4
        let d5_4 = Distance(3.585, .inch)
        XCTAssertEqual(d5.roundedDescription(exactDigits: 4), "3.5850 in")
        XCTAssertEqual(d5, d5_4)
        XCTAssertEqual(d5_4, d5)
        
        let d6 = d2 / 7
        let d6_7 = Distance(2.0485714286, .inch)
        XCTAssertEqual(d6.roundedDescription(exactDigits: 4), "2.0486 in")
        XCTAssertEqual(d6, d6_7)
        XCTAssertEqual(d6_7, d6)
        
        let dkm1div = dkm1 / 5
        let dkm4 = Distance(2.48, unit: PrefixedUnit(.kilo, .meter))
        XCTAssertEqual(dkm1div.roundedDescription(exactDigits: 2), "2.48 km")
        XCTAssertEqual(dkm1div, dkm4)
        XCTAssertEqual(dkm4, dkm1div)
        
    }
    
    func testScalarAddition() {
        // Distance non prefixed
        let din1 = Distance(8.34, .inch)
        let din2 = Distance(14.34, .inch)
        let d1_2 = din1 + 6
        XCTAssertEqual(d1_2.roundedDescription(exactDigits: 2), "14.34 in")
        XCTAssertEqual(d1_2, din2)
        XCTAssertEqual(din2, d1_2)
        
        // Same prefixed units
        let dkm1 = Distance(12.4, unit:PrefixedUnit(.kilo, .meter))
        let dkm2 = Distance(18, unit:PrefixedUnit(.kilo, .meter))
        let dkm1plus = dkm1 + 5.6
        XCTAssertEqual(dkm1plus.roundedDescription(exactDigits: 2), "18.00 km")
        XCTAssertEqual(dkm1plus, dkm2)
        XCTAssertEqual(dkm2, dkm1plus)
    }
    
    func testQuantityAddition() {
        // Same non-prefixed units
        let din1 = Distance(8.34, .inch)
        let din2 = Distance(14.34, .inch)
        let din1_din2 = din1 + din2
        XCTAssertEqual(din1_din2.roundedDescription(exactDigits: 2), "22.68 in")
        XCTAssertEqual(din1_din2, Distance(22.68, .inch))
        
        // Different non-prefixed units
        let dft1 = Distance(2.5, .foot)
        let din3 = din1 + dft1
        let dft2 = dft1 + din1
        XCTAssertEqual(din3.roundedDescription(exactDigits: 4), "38.3400 in")
        XCTAssertEqual(dft2.roundedDescription(exactDigits: 4), "3.1950 ft")
        XCTAssertEqual(din3, dft2)
        XCTAssertEqual(dft2, din3)
        
        // Same prefixed units
        let dkm1 = Distance(12.4, unit:PrefixedUnit(.kilo, .meter))
        let dkm2 = Distance(18, unit:PrefixedUnit(.kilo, .meter))
        let dkm3 = Distance(30.4, unit:PrefixedUnit(.kilo, .meter))
        let dkm1_dkm2 = dkm1 + dkm2
        XCTAssertEqual(dkm1_dkm2.roundedDescription(exactDigits: 2), "30.40 km")
        XCTAssertEqual(dkm1_dkm2, Distance(30.4, unit:PrefixedUnit(.kilo, .meter)))
        XCTAssertEqual(dkm1_dkm2, dkm3)
        XCTAssertEqual(dkm3, dkm1_dkm2)
        
        // Different prefixed units
        let pum = PrefixedUnit(.milli, DistanceUnit.mile)
        let dmmi = Distance(543.0, unit:pum)
        let dx = dmmi + dkm1
        let dy = dkm1 + dmmi
        XCTAssertEqual(dx.roundedDescription(exactDigits: 4, separators:false), "8248.0028 mmi")
        XCTAssertEqual(dy.roundedDescription(exactDigits: 4), "13.2739 km")
        XCTAssertEqual(dx, dy)
        XCTAssertEqual(dy, dx)
        
        let pukmi = PrefixedUnit(.kilo, DistanceUnit.mile)
        let dkmi = Distance(543.0, unit:pukmi)
        let dxx = dkmi + dkm1
        let dyy = dkm1 + dkmi
        XCTAssertEqual(dxx, dyy)
        XCTAssertEqual(dyy, dxx)        //fails with a difference ~1E-7
    }
    
    func testQuantityMath() {
        
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
        XCTAssertEqual(a4.roundedDescription(exactDigits: 5), "10.00000 ch²")
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

