//
//  main.swift
//  JMQuantity
//
//  Created by Jeff on 4/17/16.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

// Verbose creation
let kilometers = PrefixedUnit(prefix: .kilo, baseUnit: DistanceUnit.meter)
let twoKilometers = Quantity(value: 2.0, unit: kilometers)

// Fast creation
let tenKilometers = Quantity(10.0, prefix:.kilo, unit:DistanceUnit.meter)
let twoFeet = Quantity(2.0, DistanceUnit.foot)

// Addition
let threeFeet = twoFeet + 1.0
let fiveFeet = twoFeet + threeFeet

// Addition of different units
let almostMarathon = Quantity(26, DistanceUnit.mile)
let thoseLastFewYards = Quantity(325, DistanceUnit.yard)
let fullMarathon = almostMarathon + thoseLastFewYards

// Unit conversion
let oneYard = threeFeet.convert(to: DistanceUnit.yard)
let anotherYard = threeFeet --> .yard
let centimeters = anotherYard --> PrefixedUnit(prefix: .centi, baseUnit: .meter)

// Unit comparison
let equalYards = ( threeFeet == oneYard )
let isATenKLongerThanAMarathon = ( tenKilometers > fullMarathon )

// Subtraction
let difference = (fullMarathon - tenKilometers) --> .foot

// Negation
let runningTheWrongWay = -tenKilometers

// Custom Units
enum funkyUnit : Double, LinearUnit {
    case picture = 1
    case word = 1000
    
    var unitValue: Double { return self.rawValue }
    
    var symbol : String {
        switch self {
        case.picture: return "pics"
        case.word: return "wrds"
        }
    }
    var name: String { return "FunkyUnit" }
}

let aPicture = Quantity(1.0, funkyUnit.picture)
let words = aPicture --> .word

print("twoKilometers = \(twoKilometers)")
print("twoFeet = \(twoFeet) and threeFeet = \(threeFeet) and fiveFeet = \(fiveFeet)")
print("oneYard = \(oneYard) and anotherYard = \(anotherYard) which equals \(centimeters)")
print("Does oneYard == threeFeet?  \(equalYards)")
print("Is a 10K longer than a marathon? \(isATenKLongerThanAMarathon)")
print("Ok, how much longer is a marathon? \(difference.roundedDescription())")
print("How far will I go the other direction? \(runningTheWrongWay)")
print("How much is my picture worth? \(aPicture) = \(words)")


// Compile time error checking!
//let weird = aPicture --> DistanceUnit.Mile

print("")
let f59 = Quantity(59, TemperatureUnit.fahrenheit)
let c15 = f59 --> .celcius
print("I can convert nonlinear units too!  Like temperature: \(f59) = \(c15)")

let oneATM = Quantity(1.0, PressureUnit.atmosphere)
let mbars = PrefixedUnit(prefix: .milli, baseUnit: PressureUnit.bar)
let hpa = PrefixedUnit(prefix: .hecto, baseUnit: PressureUnit.pascal)
print("1 Atmosphere = \(oneATM --> .inchesOfHg), or \(oneATM --> .psi), or \(oneATM --> mbars), or \(oneATM --> hpa)")


/** Atmospherics */
print("")
print("ATMOSPHERIC CALCULATIONS:")

let ambientTemperature = Quantity(75.2, TemperatureUnit.fahrenheit)
let ambientPressure = Quantity(24.92, PressureUnit.inchesOfHg)
let humidity = 62.0
print("For an ambient temperature of \(ambientTemperature), a humidity of \(humidity)%, and station pressure of \(ambientPressure):")

// Dewpoint
let dewpoint_c = dewpoint(temperature: ambientTemperature, humidity: humidity)
print("  Dewpoint:          \(dewpoint_c --> .fahrenheit)")

// Pressure Altitude
let pressureAlt = pressureAltitude(ambientPressure)
print("  Pressure Altitude: \(pressureAlt)")

// Density Altitude
let densityAlt = densityAltitude(ambientPressure: ambientPressure, temperature: ambientTemperature, dewpoint: dewpoint_c)
print("  Density Altitude:  \(densityAlt)")

let baro = Quantity(30.12, PressureUnit.inchesOfHg)
let elev = fieldElevation(ambientPressure: ambientPressure, barometricPressure: baro)
print("Field Elevation for barometric pressure of \(baro): \(elev --> .foot)")

let baro_c = barometricPressure(ambientPressure: ambientPressure, fieldElevation: elev)
let ambp_c = ambientPressure(barometricPressure: baro, fieldElevation: elev)
print("  (\(baro_c --> .inchesOfHg))")
print("  (\(ambp_c --> .inchesOfHg))")


print("-----")


print("")
let squareFeet = Quantity(8.0, AreaUnit(unit: DistanceUnit.yard))
let squareYards = squareFeet --> AreaUnit(unit: DistanceUnit.foot)
print("\(squareFeet) = \(squareYards)")

let ftmin = Quantity(10560, VelocityUnit(.foot, per: .minute))
print("\(ftmin) = \(ftmin --> VelocityUnit(.mile, per: .hour))")


let km = PrefixedUnit(prefix: .kilo, baseUnit: DistanceUnit.meter)
let cm = PrefixedUnit(prefix: .centi, baseUnit: DistanceUnit.meter)

let ft = PrefixedUnit(baseUnit: DistanceUnit.foot)
let hr = PrefixedUnit(baseUnit: TimeUnit.hour)
let kph = Quantity(60, VelocityUnit(km, per: hr))
print(kph)

let mph1 =  kph --> RateUnit.rate(ft, PrefixedUnit(baseUnit: TimeUnit.minute))
print(mph1)

let kph2 = Quantity(60, VelocityUnit(.meter, per: .second))
let mph2 = kph2 --> VelocityUnit(.foot, per: .minute)
let kmph = kph2 --> PrefixedUnit(prefix: .kilo, baseUnit: RateUnit(DistanceUnit.foot, per: TimeUnit.minute))
print(kph2)
print(mph2)
print(kmph)




// All the ways to make a regular LinearUnit
let lu1 = DistanceUnit.foot

// All the ways to make a PrefixedUnit
let pu1 = PrefixedUnit(prefix: .kilo, baseUnit: DistanceUnit.meter)
let pu2 = PrefixedUnit(baseUnit: DistanceUnit.foot)
let pu3 = PrefixedUnit(.kilo, DistanceUnit.meter)
let pu4 = PrefixedUnit(DistanceUnit.foot)

// All the ways to make a Quantity
let q1 = Quantity(value: 6.3, unit:pu1)
let q2 = Quantity(6.3, prefix: .kilo, unit: DistanceUnit.meter)
let q3 = Quantity(3.0, unit: DistanceUnit.foot)
let q4 = Quantity(1.0, DistanceUnit.yard)

// All the ways to make an AreaUnit
let au0 = AreaUnit(.foot)
let au1 = AreaUnit(.acre)
let au2 = AreaUnit(PrefixedUnit(.kilo, DistanceUnit.meter))

let au00 = AreaUnit(unit: .foot)
let au11 = AreaUnit(areaUnit: .acre)
let au22 = AreaUnit(prefixedUnit: PrefixedUnit(.kilo, DistanceUnit.meter))

let au3 = AreaUnit.areaUnit(.acre)
let au4 = AreaUnit.squareUnit(PrefixedUnit(.foot))
let au5 = AreaUnit.squareUnit(PrefixedUnit(.kilo, DistanceUnit.meter))

// All the ways to make a RateUnit
let ru1 = RateUnit.rate(pu1, pu3)
let ru2 = RateUnit(unit: pu1, perUnit: pu3)
let ru3 = RateUnit(DistanceUnit.foot, per: TimeUnit.second)

// Shorcut for velocity
let vu1 = VelocityUnit(.mile, per: .hour)


import CoreLocation
let apple_latlon = CLLocationCoordinate2D(latitude: 37.331948, longitude: -122.029370)
let apple_utm = UTMCoordinates(easting: 585987, northing: 4132139, locator: "10S")

let converter = GeodeticUTMConverter()
let latlonConverted = converter.convertToUTMCoordinates(apple_latlon)
let utmConverted = converter.convertToLatitudeLongitude(utmCoordinates: apple_utm!)
print(latlonConverted.formattedString())
print(utmConverted)



let a6 = Area(0.4046875, unit:PrefixedUnit(.hecto, AreaUnit(.are)))
let a7 = Area(34.543, unit:PrefixedUnit(.mega, AreaUnit(.inch)))
print(a6, a7)
print(a7 --> PrefixedUnit(.giga, AreaUnit(.acre)))



let gals = Quantity(42, unit:PrefixedUnit(VolumeUnit.gallonUS))
print(gals --> .gallonImperial)

let fMile = PrefixedUnit(DistanceUnit.mile)
let fGal = PrefixedUnit(VolumeUnit.gallonUS)
let fGalUK = PrefixedUnit(VolumeUnit.gallonImperial)
let fKm = PrefixedUnit(.kilo, DistanceUnit.meter)
let fL = PrefixedUnit(VolumeUnit.liter)

let uMPG = FuelUnit(distance:fMile, perVolume: fGal)
let uMPU = FuelUnit(distance:fMile, perVolume: fGalUK)
let uKPL = FuelUnit(distance:fKm, perVolume: fL)
let uGPM0 = FuelUnit(volume:fGal, perDistance:fMile)
let uGPM = FuelUnit(volume:fGal, per:100, fMile)
let uLPK = FuelUnit(volume:fL, perDistance: fKm)
let uLP1K = FuelUnit(volume:fL, per:100, fKm)

let fuMPG = FuelUnit(distance: .mile, perVol: .gallonUS)
let eff1 = FuelEfficiency(21.45, fuMPG)

let fuLP100K = FuelUnit(volume: .liter, per: 100, PrefixedUnit(.kilo, DistanceUnit.meter))
let eff2 = FuelEfficiency(14.45, fuLP100K)
print(eff1)
print(eff2)


let tripDist = Distance(325, .mile)
let fuelVol = Volume(15.543, .gallonUS)
let feff = tripDist / fuelVol
print (feff)


