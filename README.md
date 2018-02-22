# Quantity
A Swift value-type for keeping track of and converting units, measurements, dimensions, etc.

## Built-In Units
Quantity has built-in support for many types of units including:
* Distance
* Time
* Pressure
* Mass
* Angle
* Temperature

Custom units are fully supported, and can be implemented easily.  (See FunkyUnit example, below)

## Examples

### Creating Quantities
```swift
// Verbose creation
let kilometers = PrefixedUnit(prefix: .kilo, baseUnit: DistanceUnit.meter)
let twoKilometers = Quantity(value: 2.0, unit: kilometers)

// Fast creation
let tenKilometers = Quantity(10.0, prefix:.kilo, baseUnit:DistanceUnit.meter)
let twoFeet = Quantity(2.0, DistanceUnit.foot)
```

### Arithmetic
```swift
// Between quantities and primitives
let threeFeet = twoFeet + 1.0

// Between two quantities
let fiveFeet = twoFeet + threeFeet
let sameTwoFeet = fiveFeet - threeFeet

// Between quantities of different units
let almostMarathon = Quantity(26, DistanceUnit.Mile)
let thoseLastFewYards = Quantity(325, DistanceUnit.Yard)
let fullMarathon = almostMarathon + thoseLastFewYards

// Between quantities of different unit types (Compile time error checking!)
let fourFeet = Quantity(4.0, DistanceUnit.Foot)
let temp59 = Quantity(59, TemperatureUnit.Fahrenheit)
let huh = fourFeet + temp59  // Causes compiler error
```

### Unit Conversion
```swift
let oneYard = threeFeet.convert(to: DistanceUnit.Yard)
let anotherYard = threeFeet --> .Yard
let centimeters = anotherYard --> PrefixedUnit(prefix: .Centi, baseUnit: .Meter)
```

### More Arithmetic (Comparison, Negation, Subtraction)
```swift
let equalYards = ( threeFeet == oneYard )
let isATenKLongerThanAMarathon = ( tenKilometers > fullMarathon )

let difference = (fullMarathon - tenKilometers) --> .Foot    // Subtraction
let runningTheWrongWay = -tenKilometers    // Negation
```

### Support for Custom Units!
```swift
// Custom Units
enum FunkyUnit : Double, LinearUnit {
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

let aPicture = Quantity(1.0, FunkyUnit.Picture)
let words = aPicture --> .Word
```


### Example output
```swift
print("twoKilometers = \(twoKilometers)")
print("twoFeet = \(twoFeet) and threeFeet = \(threeFeet) and fiveFeet = \(fiveFeet)")
print("oneYard = \(oneYard) and anotherYard = \(anotherYard) which equals \(centimeters)")
print("Does oneYard == threeFeet?  \(equalYards)")
print("Is a 10K longer than a marathon? \(isATenKLongerThanAMarathon)")
print("Ok, how much longer is a marathon? \(difference)")
print("How far will I go the other direction? \(runningTheWrongWay)")
print("How much is my picture worth? \(aPicture) = \(words)")
```
Output:
```
twoKilometers = 2.0 km
twoFeet = 2.0 ft and threeFeet = 3.0 ft and fiveFeet = 5.0 ft
oneYard = 1.0 yd and anotherYard = 1.0 yd which equals 91.44 cm
Does oneYard == threeFeet?  true
Is a 10K longer than a marathon? false
Ok, how much longer is a marathon? 105446.601049869 ft
How far will I go the other direction? -10.0 km
How much is my picture worth? 1.0 pics = 1000.0 wrds
```

#### More examples:
```swift
// All the ways to make a regular LinearUnit
let lu1 = DistanceUnit.foot

// All the ways to make a PrefixedUnit
let pu1 = PrefixedUnit(prefix: .kilo, baseUnit: DistanceUnit.meter)
let pu2 = PrefixedUnit(baseUnit: DistanceUnit.foot)

// All the ways to make a Quantity
let q1 = Quantity(value: 6.3, unit:pu1)
let q2 = Quantity(6.3, prefix: .kilo, baseUnit: DistanceUnit.meter)
let q3 = Quantity(3.0, baseUnit: DistanceUnit.foot)
let q4 = Quantity(1.0, DistanceUnit.yard)
let q5 = Distance(2.0, .mile)

// All the ways to make an AreaUnit
let au0 = AreaUnit(.foot)
let au1 = AreaUnit(.acre)
let au2 = AreaUnit(PrefixedUnit(prefix: .kilo, baseUnit: DistanceUnit.meter))

let au00 = AreaUnit(unit: .foot)
let au11 = AreaUnit(areaUnit: .acre)
let au22 = AreaUnit(prefixedUnit: PrefixedUnit(prefix: .kilo, baseUnit: DistanceUnit.meter))

let au3 = AreaUnit.areaUnit(.acre)
let au4 = AreaUnit.squareUnit(PrefixedUnit(baseUnit: .foot))
let au5 = AreaUnit.squareUnit(PrefixedUnit(prefix: .kilo, baseUnit: DistanceUnit.meter))

// All the ways to make a RateUnit
let ru1 = RateUnit.rate(pu1, pu2)
let ru2 = RateUnit(unit: pu1, perUnit: pu2)
let ru3 = RateUnit(DistanceUnit.foot, per: TimeUnit.second)

// Shorcut for velocity
let vu1 = VelocityUnit(.mile, per: .hour)
```

## Atmospheric Calculations
Quantity also has basic support for some atmospheric calculations, like Pressure and Density Altitudes.

```swift
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
```
```
For an ambient temperature of 75.2 F, a humidity of 62.0%, and station pressure of 24.92 inHg:
  Dewpoint:          61.2900552954857 F
  Pressure Altitude: 4972.11734257331 ft
  Density Altitude:  7406.61952829162 ft
Field Elevation for barometric pressure of 30.12 inHg: 5148.09445387503 ft
  (30.1017821422665 inHg)
  (24.92 inHg)
```

## Support for compound units (Like Area, Volume, Speed, etc)
```swift
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
```
```
8.0 yd² = 72.0 ft²
10560.0 ft/min = 120.0 mi/hour
60.0 km/hour
3280.83989501312 ft/min
60.0 m/s
11811.0236220472 ft/min
11.8110236220472 kft/min
```

## Latitude/Longitude, UTM, GPS
Support for geographic coordinates in both Latitude/Longitude (degrees) format, and UTM format.
```swift
let apple_latlon = CLLocationCoordinate2D(latitude: 37.331948, longitude: -122.029370)
let apple_utm = UTMCoordinates(easting: 585987, northing: 4132139, locator: "10S")

let converter = GeodeticUTMConverter()
let latlonConverted = converter.convertToUTMCoordinates(apple_latlon)
let utmConverted = converter.convertToLatitudeLongitude(utmCoordinates: apple_utm!)
print(latlonConverted.formattedString())
print(utmConverted)
```
```
10S 585987.1m E 4132139.2m N
CLLocationCoordinate2D(latitude: 37.331946317344212, longitude: -122.02937069495992)
```
