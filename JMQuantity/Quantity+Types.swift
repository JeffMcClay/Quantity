//
//  Quantity+Types.swift
//  JMQuantity
//
//  Created by Jeff on 10/11/17.
//  Copyright © 2017 Jeff McClay. All rights reserved.
//

public typealias Time           = Quantity<TimeUnit>
public typealias Distance       = Quantity<DistanceUnit>
public typealias Pressure       = Quantity<PressureUnit>
public typealias Mass           = Quantity<MassUnit>
public typealias Temperature    = Quantity<TemperatureUnit>
public typealias Angle          = Quantity<AngleUnit>

public typealias Area           = Quantity<AreaUnit>
public typealias FuelEfficiency = Quantity<FuelUnit>

public typealias VelocityUnit   = RateUnit<DistanceUnit, TimeUnit>
public typealias Velocity       = Quantity<VelocityUnit>


