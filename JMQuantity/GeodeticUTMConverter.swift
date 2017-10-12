//
//  GeodeticUTMConverter.swift
//  JMQuantity
//
//  Created by Jeff McClay on 2016/06/05.
//
//
//
//  This class was adpated from GeodeticUTMConverter by Created by Cameron Lowell Palmer & Mariia Ruchko.
//  https://github.com/palmerc/GeodeticUTMConverter
//  It was originally an Objective-C port of Chuck Taylor's javascript
//
//          Created by Cameron Lowell Palmer & Mariia Ruchko on 19.06.12.
//          Copyright (c) 2012 Cameron Lowell Palmer & Mariia Ruchko. All rights reserved.
//
//          Code converted from Javascript as written by Chuck Taylor
//          http://home.hiwaay.net/~taylorc/toolbox/geography/geoutm.html
//          Reference: Hoffmann-Wellenhof, B., Lichtenegger, H., and Collins, J., GPS: Theory and Practice, 3rd ed.  New York: Springer-Verlag Wien, 1994.
//

import Foundation
import CoreLocation

typealias UTMDouble = Double
typealias UTMGridZone = UInt

enum UTMHemisphere {
    case northern
    case southern
}

struct UTMDatum {
    let equitorialRadius: UTMDouble
    let polarRadius: UTMDouble
}

struct UTMCoordinates {
    let easting: UTMDouble
    let northing: UTMDouble
    let gridZone: UTMGridZone
    let hemisphere: UTMHemisphere
    let band: UTMBand
}


class GeodeticUTMConverter {
    
    var utmDatum: UTMDatum
    fileprivate var utmScaleFactor: UTMDouble = 0.9996
    
    init () {
        let wgs84datum = UTMDatum(equitorialRadius: 6378137, polarRadius: 6356752.3142)
        self.utmDatum = wgs84datum
    }
    
    init (datum: UTMDatum) {
        self.utmDatum = datum
    }
    
    static func convertLocationToUTMCoordinates(_ latitudeLongitude: CLLocationCoordinate2D) -> UTMCoordinates {
        let converter = GeodeticUTMConverter()
        return converter.convertToUTMCoordinates(latitudeLongitude)
    }
    
    static func convertUTMToLatLon(_ utmCoordinates: UTMCoordinates) -> CLLocationCoordinate2D {
        let converter = GeodeticUTMConverter()
        return converter.convertToLatitudeLongitude(utmCoordinates: utmCoordinates)
    }
    
}

extension GeodeticUTMConverter {
    func convertToUTMCoordinates(_ latLonCoordinates: CLLocationCoordinate2D) -> UTMCoordinates {
        //TODO: Check this
        let z = floor((latLonCoordinates.longitude + 180.0) / 6.0) + 1.0
        let zone = UTMGridZone(z)
        
        var hemisphere: UTMHemisphere
        if (latLonCoordinates.latitude < 0) { hemisphere = .southern }
        else { hemisphere = .northern }
        
        let cmeridian = centralMeridian(gridZone: zone)
        
        let lat = degreesToRadians(latLonCoordinates.latitude)
        let lon = degreesToRadians(latLonCoordinates.longitude)
        let latLonRadians = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let tmCoordinates = transverseMercatorCoordinates(latLonRadians, centralMeridian: cmeridian)
        
        /* Adjust easting and northing for UTM system. */
        let x = tmCoordinates.easting * utmScaleFactor + 500000.0
        var y = tmCoordinates.northing * utmScaleFactor
        if y < 0.0 { y += 10000000.0 }
        
        let band = latitudeBand(latLonCoordinates.latitude)
        let utm = UTMCoordinates(easting: x, northing: y, gridZone: zone, band: band, hemisphere: hemisphere)
        return utm
    }
    
    func convertToLatitudeLongitude(utmCoordinates utm: UTMCoordinates) -> CLLocationCoordinate2D {
        var x = utm.easting;
        var y = utm.northing;
        let zone = utm.gridZone;
        let hemisphere = utm.hemisphere;
        
        x -= 500000.0;
        x /= utmScaleFactor;
        
        /* If in southern hemisphere, adjust y accordingly. */
        if (hemisphere == .southern) { y -= 10000000.0; }
        
        y /= utmScaleFactor;
        
        let tmCoords = TransverseMercatorCoordinates(easting: x, northing: y)
        let cmeridian = centralMeridian(gridZone: zone)
        
        let locationRads = latitudeLongitude(transverseMercatorCoordinates: tmCoords, centralMeridian: cmeridian)
        
        let latitude = radiansToDegrees(locationRads.latitude);
        let longitude = radiansToDegrees(locationRads.longitude);
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension GeodeticUTMConverter {
    
    fileprivate func degreesToRadians(_ degrees: Double) -> Double { return degrees / 180 * .pi }
    fileprivate func radiansToDegrees(_ radians: Double) -> Double { return radians * 180 / .pi }
    
    fileprivate func centralMeridian(gridZone zone: UTMGridZone) -> UTMDouble {
        return degreesToRadians(-183.0 + (Double(zone) * 6.0))
    }
    
    fileprivate func latitudeBand(_ latitude: UTMDouble) -> UTMBand {
        var latz = 0.0;
        if (latitude > -80 && latitude < 72) { latz = floor((latitude + 80)/8)+2 }
        if (latitude > 72 && latitude < 84){latz = 21;}
        if (latitude > 84){latz = 23;}
        
        let band = UTMBands[Int(latz)]
        return band
    }
    
    fileprivate func arcLengthOfMeridian(_ latitudeInRadians: UTMDouble) -> UTMDouble {
        let equitorialRadus = utmDatum.equitorialRadius;
        let polarRadius = utmDatum.polarRadius;
        
        /* Precalculate n */
        let n = (equitorialRadus - polarRadius) / (equitorialRadus + polarRadius);
        
        /* Precalculate alpha */
        let alpha = ((equitorialRadus + polarRadius) / 2.0) * (1.0 + (pow(n, 2.0) / 4.0) + (pow(n, 4.0) / 64.0));
        
        /* Precalculate beta */
        let beta = (-3.0 * n / 2.0) + (9.0 * pow(n, 3.0) / 16.0) + (-3.0 * pow(n, 5.0) / 32.0);
        
        /* Precalculate gamma */
        let gamma = (15.0 * pow(n, 2.0) / 16.0) + (-15.0 * pow(n, 4.0) / 32.0);
        
        /* Precalculate delta */
        let delta = (-35.0 * pow(n, 3.0) / 48.0) + (105.0 * pow(n, 5.0) / 256.0);
        
        /* Precalculate epsilon */
        let epsilon = (315.0 * pow(n, 4.0) / 512.0);
        
        /* Now calculate the sum of the series and return */
        //        let result = alpha * (latitudeInRadians + (beta * sin(2.0 * latitudeInRadians)) + (gamma * sin(4.0 * latitudeInRadians)) + (delta * sin(6.0 * latitudeInRadians)) + (epsilon * sin(8.0 * latitudeInRadians))   );
        let r1 = (epsilon * sin(8.0 * latitudeInRadians))
        let r2 = (delta * sin(6.0 * latitudeInRadians))
        let r3 = (gamma * sin(4.0 * latitudeInRadians))
        let r4 = (beta * sin(2.0 * latitudeInRadians))
        let result = alpha * (latitudeInRadians + r4 + r3 + r2 + r1)
        
        return result;
    }
    
    fileprivate func footpointLatitude(northingInMeters northing:UTMDouble) -> UTMDouble {
        let equitorialRadus = utmDatum.equitorialRadius;
        let polarRadius = utmDatum.polarRadius;
        
        /* Precalculate n (Eq. 10.18) */
        let n = (equitorialRadus - polarRadius) / (equitorialRadus + polarRadius);
        
        /* Precalculate alpha_ (Eq. 10.22) */
        /* (Same as alpha in Eq. 10.17) */
        let alpha = ((equitorialRadus + polarRadius) / 2.0) * (1 + (pow(n, 2.0) / 4) + (pow(n, 4.0) / 64));
        
        /* Precalculate y (Eq. 10.23) */
        let y = northing / alpha;
        
        /* Precalculate beta (Eq. 10.22) */
        let beta = (3.0 * n / 2.0) + (-27.0 * pow(n, 3.0) / 32.0) + (269.0 * pow(n, 5.0) / 512.0);
        
        /* Precalculate gamma (Eq. 10.22) */
        let gamma = (21.0 * pow(n, 2.0) / 16.0) + (-55.0 * pow(n, 4.0) / 32.0);
        
        /* Precalculate delta (Eq. 10.22) */
        let delta = (151.0 * pow(n, 3.0) / 96.0) + (-417.0 * pow(n, 5.0) / 128.0);
        
        /* Precalculate epsilon (Eq. 10.22) */
        let epsilon = (1097.0 * pow(n, 4.0) / 512.0);
        
        /* Now calculate the sum of the series (Eq. 10.21) */
//        let  footprintLatitudeInRadians = y + (beta * sin(2.0 * y)) + (gamma * sin(4.0 * y)) + (delta * sin(6.0 * y)) + (epsilon * sin(8.0 * y));
        let f1 = (beta * sin(2.0 * y))
        let f2 = (gamma * sin(4.0 * y))
        let f3 = (delta * sin(6.0 * y))
        let f4 = (epsilon * sin(8.0 * y))
        let footprintLatitudeInRadians = y + f1 + f2 + f3 + f4;
        
        return footprintLatitudeInRadians;
    }
    
    fileprivate func transverseMercatorCoordinates(_ latLonCoordinates: CLLocationCoordinate2D, centralMeridian lambda0: UTMDouble) -> TransverseMercatorCoordinates {
        var N, nu2, ep2, t, t2, l: UTMDouble
//        var tmp: UTMDouble
        
        let phi = latLonCoordinates.latitude     //radians??
        let lambda = latLonCoordinates.longitude //radians??
        
        let equitorialRadus = utmDatum.equitorialRadius;
        let polarRadius = utmDatum.polarRadius;
        
        /* Precalculate ep2 */
        ep2 = (pow(equitorialRadus, 2.0) - pow(polarRadius, 2.0)) / pow(polarRadius, 2.0);
    
        /* Precalculate nu2 */
        nu2 = ep2 * pow(cos(phi), 2.0);
    
        /* Precalculate N */
        N = pow(equitorialRadus, 2.0) / (polarRadius * sqrt(1 + nu2));
        
        /* Precalculate t */
        t = tan(phi);
        t2 = t * t;
//        tmp = (t2 * t2 * t2) - pow(t, 6.0);
        
        /* Precalculate l */
        l = lambda - lambda0;
        
        /* Precalculate coefficients for l**n in the equations below so a normal human being can read the expressions for easting and northing
        -- l**1 and l**2 have coefficients of 1.0 */
        let l3coef = 1.0 - t2 + nu2;
        let l4coef = 5.0 - t2 + 9 * nu2 + 4.0 * (nu2 * nu2);
        let l5coef = 5.0 - 18.0 * t2 + (t2 * t2) + 14.0 * nu2 - 58.0 * t2 * nu2;
        let l6coef = 61.0 - 58.0 * t2 + (t2 * t2) + 270.0 * nu2 - 330.0 * t2 * nu2;
        let l7coef = 61.0 - 479.0 * t2 + 179.0 * (t2 * t2) - (t2 * t2 * t2);
        let l8coef = 1385.0 - 3111.0 * t2 + 543.0 * (t2 * t2) - (t2 * t2 * t2);
        
        /* Calculate easting (x) */
//        let easting = N * cos(phi) * l + (N / 6.0 * pow(cos(phi), 3.0) * l3coef * pow(l, 3.0)) + (N / 120.0 * pow(cos(phi), 5.0) * l5coef * pow(l, 5.0)) + (N / 5040.0 * pow(cos(phi), 7.0) * l7coef * pow(l, 7.0));
        let e1 = N * cos(phi) * l
        let e2 = (N / 6.0 * pow(cos(phi), 3.0) * l3coef * pow(l, 3.0))
        let e3 = (N / 120.0 * pow(cos(phi), 5.0) * l5coef * pow(l, 5.0))
        let e4 = (N / 5040.0 * pow(cos(phi), 7.0) * l7coef * pow(l, 7.0))
        let easting = e1 + e2 + e3 + e4
        
        /* Calculate northing (y) */
//        let northing = [self arcLengthOfMeridian:phi] + (t / 2.0 * N * pow(cos(phi), 2.0) * pow(l, 2.0)) + (t / 24.0 * N * pow(cos(phi), 4.0) * l4coef * pow(l, 4.0)) + (t / 720.0 * N * pow(cos(phi), 6.0) * l6coef * pow(l, 6.0)) + (t / 40320.0 * N * pow(cos(phi), 8.0) * l8coef * pow(l, 8.0));
        let n1 = arcLengthOfMeridian(phi)
        let n2 = (t / 2.0 * N * pow(cos(phi), 2.0) * pow(l, 2.0))
        let n3 = (t / 24.0 * N * pow(cos(phi), 4.0) * l4coef * pow(l, 4.0))
        let n4 = (t / 720.0 * N * pow(cos(phi), 6.0) * l6coef * pow(l, 6.0))
        let n5 = (t / 40320.0 * N * pow(cos(phi), 8.0) * l8coef * pow(l, 8.0))
        let northing = n1 + n2 + n3 + n4 + n5;
        
//        var tmCoordinates = UTMCoordinates(easting: easting, northing: northing)
        return TransverseMercatorCoordinates(easting: easting, northing: northing)
    }
    
    fileprivate func latitudeLongitude(transverseMercatorCoordinates TMCoordinates: TransverseMercatorCoordinates, centralMeridian lambda0: UTMDouble) -> CLLocationCoordinate2D {
        let x = TMCoordinates.easting;
        let y = TMCoordinates.northing;
        let equitorialRadus = utmDatum.equitorialRadius;
        let polarRadius = utmDatum.polarRadius;
        
        /* Get the value of phif, the footpoint latitude. */
        let phif = footpointLatitude(northingInMeters: y)
        
        /* Precalculate ep2 */
        let ep2 = (pow(equitorialRadus, 2.0) - pow(polarRadius, 2.0)) / pow(polarRadius, 2.0);
        
        /* Precalculate cos (phif) */
        let cf = cos(phif);
        
        /* Precalculate nuf2 */
        let nuf2 = ep2 * pow(cf, 2.0);
        
        /* Precalculate Nf and initialize Nfpow */
        let Nf = pow(equitorialRadus, 2.0) / (polarRadius * sqrt(1 + nuf2));
        var Nfpow = Nf;
        
        /* Precalculate tf */
        let tf = tan(phif);
        let tf2 = tf * tf;
        let tf4 = tf2 * tf2;
        
        /* Precalculate fractional coefficients for x**n in the equations
        below to simplify the expressions for latitude and longitude. */
        let x1frac = 1.0 / (Nfpow * cf);
        
        Nfpow *= Nf;   /* now equals Nf**2) */
        let x2frac = tf / (2.0 * Nfpow);
        
        Nfpow *= Nf;   /* now equals Nf**3) */
        let x3frac = 1.0 / (6.0 * Nfpow * cf);
        
        Nfpow *= Nf;   /* now equals Nf**4) */
        let x4frac = tf / (24.0 * Nfpow);
        
        Nfpow *= Nf;   /* now equals Nf**5) */
        let x5frac = 1.0 / (120.0 * Nfpow * cf);
        
        Nfpow *= Nf;   /* now equals Nf**6) */
        let x6frac = tf / (720.0 * Nfpow);
        
        Nfpow *= Nf;   /* now equals Nf**7) */
        let x7frac = 1.0 / (5040.0 * Nfpow * cf);
        
        Nfpow *= Nf;   /* now equals Nf**8) */
        let x8frac = tf / (40320.0 * Nfpow);
        
        /* Precalculate polynomial coefficients for x**n.
        -- x**1 does not have a polynomial coefficient. */
        let x2poly = -1.0 - nuf2;
        let x3poly = -1.0 - 2 * tf2 - nuf2;
        let x4poly = 5.0 + 3.0 * tf2 + 6.0 * nuf2 - 6.0 * tf2 * nuf2 - 3.0 * (nuf2 * nuf2) - 9.0 * tf2 * (nuf2 * nuf2);
        let x5poly = 5.0 + 28.0 * tf2 + 24.0 * tf4 + 6.0 * nuf2 + 8.0 * tf2 * nuf2;
        let x6poly = -61.0 - 90.0 * tf2 - 45.0 * tf4 - 107.0 * nuf2 + 162.0 * tf2 * nuf2;
        let x7poly = -61.0 - 662.0 * tf2 - 1320.0 * tf4 - 720.0 * (tf4 * tf2);
        let x8poly = 1385.0 + 3633.0 * tf2 + 4095.0 * tf4 + 1575 * (tf4 * tf2);
        
        /* Calculate latitude */
        let latitude = phif + x2frac * x2poly * (x * x) + x4frac * x4poly * pow(x, 4.0) + x6frac * x6poly * pow(x, 6.0) + x8frac * x8poly * pow(x, 8.0);
        
        /* Calculate longitude */
        let longitude = lambda0 + x1frac * x + x3frac * x3poly * pow(x, 3.0) + x5frac * x5poly * pow(x, 5.0) + x7frac * x7poly * pow(x, 7.0);
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}






