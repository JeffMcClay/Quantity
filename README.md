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
```
// Verbose creation
let kilometers = PrefixedUnit(prefix: .Kilo, baseUnit: DistanceUnit.Meter)
let twoKilometers = Quantity(value: 2.0, unit: kilometers)

// Fast creation
let tenKilometers = Quantity(10.0, prefix:.Kilo, unit:DistanceUnit.Meter)
let twoFeet = Quantity(2.0, DistanceUnit.Foot)
```

### Arithmetic
```
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
```
let oneYard = threeFeet.convert(to: DistanceUnit.Yard)
let anotherYard = threeFeet --> .Yard
let centimeters = anotherYard --> PrefixedUnit(prefix: .Centi, baseUnit: .Meter)
```

### More Arithmetic (Comparison, Negation, Subtraction)
```
let equalYards = ( threeFeet == oneYard )
let isATenKLongerThanAMarathon = ( tenKilometers > fullMarathon )

let difference = (fullMarathon - tenKilometers) --> .Foot    // Subtraction
let runningTheWrongWay = -tenKilometers    // Negation
```

### Support for Custom Units!
```
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
```
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
