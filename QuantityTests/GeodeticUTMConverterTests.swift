//
//  GeodeticUTMConverterTests.swift
//  QuantityTests
//
//  Created by Jeff on 3/28/19.
//  Copyright © 2019 Jeff McClay. All rights reserved.
//

import XCTest
import CoreLocation

class GeodeticUTMConverterTests: XCTestCase {

    func testUTMConversion1() {
        let deg = CLLocationCoordinate2D(latitude: 32.707941, longitude: -117.15703816590793)
        let utm = UTMCoordinates(easting: 485282, northing: 3618921, locator: "11S")!

        let utm_c = GeodeticUTMConverter.convertLocationToUTMCoordinates(deg)
        let deg_c = GeodeticUTMConverter.convertUTMToLatLon(utm)

        UTMCoordinates.assertEqual(utm, utm_c)
        CLLocationCoordinate2D.assertEqual(deg, deg_c)
    }

    func testUTMConversion2() {
        let deg = CLLocationCoordinate2D(latitude: 40.757459, longitude: -73.84582288064755)
        let utm = UTMCoordinates(easting: 597424, northing: 4512474, locator: "18T")!

        let utm_c = GeodeticUTMConverter.convertLocationToUTMCoordinates(deg)
        let deg_c = GeodeticUTMConverter.convertUTMToLatLon(utm)

        UTMCoordinates.assertEqual(utm, utm_c)
        CLLocationCoordinate2D.assertEqual(deg, deg_c)
    }

}

private extension UTMCoordinates {
    static func assertEqual(_ a: UTMCoordinates, _ b: UTMCoordinates) {
        XCTAssertEqual(a.easting, a.easting, accuracy: 0.1)
        XCTAssertEqual(a.northing, b.northing, accuracy: 0.1)
        XCTAssertEqual(a.hemisphere, b.hemisphere)
        XCTAssertEqual(a.band, b.band)
        XCTAssertEqual(a.gridZone, b.gridZone)
    }
}

private extension CLLocationCoordinate2D {
    static func assertEqual(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) {
        XCTAssertEqual(a.latitude, b.latitude, accuracy: 0.000001)
        XCTAssertEqual(a.longitude, b.longitude, accuracy: 0.000001)
    }
}
