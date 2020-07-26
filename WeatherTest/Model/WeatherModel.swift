//
//  WeatherModel.swift
//  WeatherTest
//
//  Created by Geon Kang on 2020/07/12.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID : Int
    
    var conditionName : String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "cloud.fog"
        case 800 :
            return "sun.max"
         case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    var conditionLabel : String {
        switch conditionID {
        case 200...232:
            return "CLOUDY"
        case 300...321:
            return "DRIZZLE"
        case 500...531:
            return "RAIN"
        case 600...622:
            return "SNOW"
        case 701...781:
            return "FOG"
        case 800 :
            return "SUNNY"
         case 801...804:
            return "CLOUDY"
        default:
            return "CLOUDY"
        }
    }
}
