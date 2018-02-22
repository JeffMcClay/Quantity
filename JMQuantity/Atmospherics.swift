//
//  Atmospherics.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

/// Calculates pressure altitude (on earth), in feet.
public func pressureAltitude(_ ambientPressure: Pressure) -> Distance {
    let pressure = ambientPressure --> PrefixedUnit(prefix: .milli, baseUnit: PressureUnit.bar)
    let alt_ft = (1 - pow(pressure.value/1013.25,0.190284)) * 145366.45
    return Quantity(alt_ft, DistanceUnit.foot)
}

/**
 Calculates the density altitude, on earth.
 - parameter ambientPressure: The ambient or station pressure
 - parameter temperature: The ambient temperature
 - parameter dewpoint: The ambient dewpoint
 - returns: Density altitude, in feet
*/
public func densityAltitude(ambientPressure: Pressure, temperature: Temperature, dewpoint: Temperature) -> Distance {
    let pressure_mb = ambientPressure --> PrefixedUnit(prefix: .milli, baseUnit: PressureUnit.bar)
    let temp_c = temperature --> TemperatureUnit.celcius
    let dewp_c = dewpoint --> TemperatureUnit.celcius
    
    let vaporPressure = 6.11 * pow(10, (7.5 * dewp_c.value) / (237.7 + dewp_c.value))
    let temp_k = temp_c.value + 273.15;
    let virtual_temp_k = temp_k / (1 - (vaporPressure / pressure_mb.value) * (1-0.622) );
    
    let press_inHg = pressure_mb.value / (1013.25/29.92);
    let virtual_temp_r = (virtual_temp_k - 273.15) * 1.8 + 32 + 459.69;
    let da = 145366 * (1 - pow(17.326 * press_inHg / virtual_temp_r, 0.235));
    return Quantity(da, DistanceUnit.foot)
}

/**
 Calculates dewpoint, in celcius
 - parameter humidity: Humidity expressed as a percentage (ex: 50.0)
*/
public func dewpoint(temperature: Temperature, humidity: Double) -> Temperature {
    let temp_c = temperature --> TemperatureUnit.celcius

    let T = temp_c.value
    var RH = humidity
    if RH == 0 { RH = 0.00001 }
    let term1 = (log(RH/100) + ( (17.625*T)/(243.04+T) ))
    let term2 = (17.625-log(RH/100)-((17.625*T)/(243.04+T)))
    let dewpoint_c = 243.04 * term1 / term2
//    let dewpoint_c = 243.04 * (log(RH/100) + ( (17.625*T)/(243.04+T) )) / (17.625-log(RH/100)-((17.625*T)/(243.04+T)))
    return Quantity(dewpoint_c, TemperatureUnit.celcius)
}

/**
 Calculates humidity as a percentage
 - parameter temperature: Ambient temperature
 */
public func humidity(temperature: Temperature, dewpoint: Temperature) -> Double {
    let temp_c = temperature --> TemperatureUnit.celcius
    let dewp_c = dewpoint --> TemperatureUnit.celcius
    
    let TD = dewp_c.value
    let T = temp_c.value
    let rh = 100*(exp((17.625*TD)/(243.04+TD))/exp((17.625*T)/(243.04+T)));
    return rh
}

/**
 Calculates field elevation above MSL, in meters.
 - parameter ambientPressure: The ambient or station pressure
 - parameter barometricPressure: The barometeric or adjusted pressure
*/
public func fieldElevation(ambientPressure: Pressure, barometricPressure: Pressure) -> Distance {
    let pressure_mbar = ambientPressure --> PrefixedUnit(prefix: .milli, baseUnit: PressureUnit.bar)
    let altSetting = barometricPressure --> PrefixedUnit(prefix: .milli, baseUnit: PressureUnit.bar)
    
    let ps = pressure_mbar.value
    let pa = altSetting.value
    // elevation in meters
    let elevation = 0 - ( -1 + pow(ps/pa, 1/5.2561) ) * 288 / 0.0065;
    return Quantity(elevation, DistanceUnit.meter)
}

/**
 Calculates barometric (corrected) pressure, in Millibars
 - parameter ambientPressure: The ambient or station pressure
 - parameter fieldElevation: The field elevation above MSL
 */
public func barometricPressure(ambientPressure: Pressure, fieldElevation: Distance) -> Pressure {
    let pressure_mbar = ambientPressure --> PrefixedUnit(prefix: .milli, baseUnit: PressureUnit.bar)
    let elevation = fieldElevation --> DistanceUnit.meter
    
    let p = pressure_mbar.value
    let h = elevation.value
    let t1 = p - 0.3;
    let t2 = pow(1013.25,0.190284)*0.0065/288;
    let t3 = h / pow(p - 0.3, 0.190284);
    let alts = t1 * pow(1 + (t2 * t3), 1/0.190284 );
    return Quantity(alts, prefix: .milli, baseUnit: PressureUnit.bar)
    
}

/**
 Calculates ambient (station) pressure, in inches of mercury
 - parameter barometricPressure: The barometeric or adjusted pressure
 - parameter fieldElevation: The field elevation above MSL
 */
public func ambientPressure(barometricPressure: Pressure, fieldElevation: Distance) -> Pressure {
    let baro = barometricPressure --> PressureUnit.inchesOfHg
    let elev = fieldElevation --> DistanceUnit.meter
    
    let p = baro.value; let h = elev.value
    let stationpressure = p * pow( ( 288 - 0.0065 * h ) / 288, 5.2561 )
    return Quantity(stationpressure, PressureUnit.inchesOfHg)
}
