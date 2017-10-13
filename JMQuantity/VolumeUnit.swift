//
//  VolumeUnit.swift
//  JMQuantity
//
//  Created by Jeff on 2016/06/02.
//  Copyright © 2016 Jeff McClay. All rights reserved.
//

import Foundation

public enum VolumeUnit: Double, LinearUnit {
//    case liter = 1.0
//    case gallonUS = 0.2641720523581484        //alpha sig figs
//    case gallonImperial = 0.219969248299087788   //alpha sig figs
    
    case liter = 1.0
    case gallonUS = 0.264172052358148415379899921609162507959266182703889421822     // 1/3.785411784
    case gallonImperial = 0.219969248299087787527303682945124271626826569645563550215   // 1/4.54609
    
    public var symbol : String {
        switch self {
        case .liter: return "L"
        case .gallonUS: return "gal"
        case .gallonImperial: return "gal"
        }
    }

}
