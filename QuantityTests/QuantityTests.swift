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
        XCTAssertEqual(manycms.roundedDescription(), "1000000 cm")
        
        let tenKmToMiles = tenKilometers --> .mile
        XCTAssert(tenKilometers == tenKmToMiles)
        XCTAssertEqual(tenKmToMiles.roundedDescription(exactDigits: 5), "6.21371 mi")
        XCTAssertEqual(tenKmToMiles.roundedDescription(), "6.21 mi")
        XCTAssertEqual(tenKmToMiles.roundedDescription(decimalPlaces: 3, minDigits: 2), "6.214 mi")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
