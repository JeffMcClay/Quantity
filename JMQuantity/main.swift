//
//  main.swift
//  JMQuantity
//
//  Created by Jeff on 4/17/16.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

// Verbose creation
let kilometers = PrefixedUnit(prefix: .Kilo, baseUnit: DistanceUnit.Meter)
let twoKilometers = Quantity(value: 2.0, unit: kilometers)

// Fast creation
let tenKilometers = Quantity(10.0, prefix:.Kilo, unit:DistanceUnit.Meter)
let twoFeet = Quantity(2.0, DistanceUnit.Foot)

// Addition
let threeFeet = twoFeet + 1.0
let fiveFeet = twoFeet + threeFeet

// Addition of different units
let almostMarathon = Quantity(26, DistanceUnit.Mile)
let thoseLastFewYards = Quantity(325, DistanceUnit.Yard)
let fullMarathon = almostMarathon + thoseLastFewYards

// Unit conversion
let oneYard = threeFeet.convert(to: DistanceUnit.Yard)
let anotherYard = threeFeet --> .Yard
let centimeters = anotherYard --> PrefixedUnit(prefix: .Centi, baseUnit: .Meter)

// Unit comparison
let equalYards = ( threeFeet == oneYard )
let isATenKLongerThanAMarathon = ( tenKilometers > fullMarathon )

// Subtraction
let difference = (fullMarathon - tenKilometers) --> .Foot

// Negation
let runningTheWrongWay = -tenKilometers

// Custom Units
enum funkyUnit : Double, LinearUnit {
    case Picture = 1
    case Word = 1000
    
    var unitValue: Double { return self.rawValue }
    
    var symbol : String {
        switch self {
        case.Picture: return "pics"
        case.Word: return "wrds"
        }
    }
    var name: String { return "FunkyUnit" }
}

let aPicture = Quantity(1.0, funkyUnit.Picture)
let words = aPicture --> .Word

print("twoKilometers = \(twoKilometers)")
print("twoFeet = \(twoFeet) and threeFeet = \(threeFeet) and fiveFeet = \(fiveFeet)")
print("oneYard = \(oneYard) and anotherYard = \(anotherYard) which equals \(centimeters)")
print("Does oneYard == threeFeet?  \(equalYards)")
print("Is a 10K longer than a marathon? \(isATenKLongerThanAMarathon)")
print("Ok, how much longer is a marathon? \(difference)")
print("How far will I go the other direction? \(runningTheWrongWay)")
print("How much is my picture worth? \(aPicture) = \(words)")


// Compile time error checking!
//let weird = aPicture --> DistanceUnit.Mile

print("")
let f59 = Quantity(59, TemperatureUnit.Fahrenheit)
let c15 = f59 --> .Celcius
print("I can convert nonlinear units too!  Like temperature: \(f59) = \(c15)")

let oneATM = Quantity(1.0, PressureUnit.Atmosphere)
let mbars = PrefixedUnit(prefix: .Milli, baseUnit: PressureUnit.Bar)
let hpa = PrefixedUnit(prefix: .Hecto, baseUnit: PressureUnit.Pascal)
print("1 Atmosphere = \(oneATM --> .InchesOfHg), or \(oneATM --> .PSI), or \(oneATM --> mbars), or \(oneATM --> hpa)")


/** Atmospherics */
print("")
print("ATMOSPHERIC CALCULATIONS:")

let ambientTemperature = Quantity(75.2, TemperatureUnit.Fahrenheit)
let ambientPressure = Quantity(24.92, PressureUnit.InchesOfHg)
let humidity = 62.0
print("For an ambient temperature of \(ambientTemperature), a humidity of \(humidity)%, and station pressure of \(ambientPressure):")

// Dewpoint
let dewpoint_c = dewpoint(temperature: ambientTemperature, humidity: humidity)
print("  Dewpoint:          \(dewpoint_c --> .Fahrenheit)")

// Pressure Altitude
let pressureAlt = pressureAltitude(ambientPressure)
print("  Pressure Altitude: \(pressureAlt)")

// Density Altitude
let densityAlt = densityAltitude(ambientPressure: ambientPressure, temperature: ambientTemperature, dewpoint: dewpoint_c)
print("  Density Altitude:  \(densityAlt)")

let baro = Quantity(30.12, PressureUnit.InchesOfHg)
let elev = fieldElevation(ambientPressure: ambientPressure, barometricPressure: baro)
print("Field Elevation for barometric pressure of \(baro): \(elev --> .Foot)")

let baro_c = barometricPressure(ambientPressure: ambientPressure, fieldElevation: elev)
let ambp_c = ambientPressure(barometricPressure: baro, fieldElevation: elev)
print("  (\(baro_c --> .InchesOfHg))")
print("  (\(ambp_c --> .InchesOfHg))")


print("-----")


print("")
let squareFeet = Quantity(8.0, AreaUnit(unit: DistanceUnit.Yard))
let squareYards = squareFeet --> AreaUnit(unit: DistanceUnit.Foot)
print("\(squareFeet) = \(squareYards)")

let ftmin = Quantity(10560, VelocityUnit(.Foot, per: .Minute))
print("\(ftmin) = \(ftmin --> VelocityUnit(.Mile, per: .Hour))")


let km = PrefixedUnit(prefix: .Kilo, baseUnit: DistanceUnit.Meter)
let cm = PrefixedUnit(prefix: .Centi, baseUnit: DistanceUnit.Meter)

let ft = PrefixedUnit(baseUnit: DistanceUnit.Foot)
let hr = PrefixedUnit(baseUnit: TimeUnit.Hour)
let kph = Quantity(60, VelocityUnit(km, per: hr))
print(kph)

let mph1 =  kph --> RateUnit.Rate(ft, PrefixedUnit(baseUnit: TimeUnit.Minute))
print(mph1)

let kph2 = Quantity(60, VelocityUnit(.Meter, per: .Second))
let mph2 = kph2 --> VelocityUnit(.Foot, per: .Minute)
let kmph = kph2 --> PrefixedUnit(prefix: .Kilo, baseUnit: RateUnit(DistanceUnit.Foot, per: TimeUnit.Minute))
print(kph2)
print(mph2)
print(kmph)




// All the ways to make a PrefixedUnit
let pu1 = PrefixedUnit(prefix: .Kilo, baseUnit: DistanceUnit.Meter)
let pu2 = PrefixedUnit(baseUnit: DistanceUnit.Foot)
let pu3 = PrefixedUnit(.Kilo, DistanceUnit.Meter)
let pu4 = PrefixedUnit(DistanceUnit.Foot)

// All the ways to make a Quantity
let q1 = Quantity(value: 6.3, unit:pu1)
let q2 = Quantity(6.3, prefix: .Kilo, unit: DistanceUnit.Meter)
let q3 = Quantity(3.0, unit: DistanceUnit.Foot)
let q4 = Quantity(1.0, DistanceUnit.Yard)

// All the ways to make a regular LinearUnit
let lu1 = DistanceUnit.Foot

// All the ways to make a RateUnit
let ru1 = RateUnit.Rate(pu1, pu3)
let ru2 = RateUnit(unit: pu1, perUnit: pu3)
let ru3 = RateUnit(DistanceUnit.Foot, per: TimeUnit.Second)

// Shorcut for velocity
let vu1 = VelocityUnit(.Mile, per: .Hour)
