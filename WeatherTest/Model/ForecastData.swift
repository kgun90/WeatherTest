//
//  ForecastData.swift
//  WeatherTest
//
//  Created by Geon Kang on 2020/07/13.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import Foundation

struct ForecastData: Codable {
    let list: [forecastList]
}
struct forecastList: Codable {
    let main: forecastMain
    let weather: [forecastWeather]
}
struct forecastMain: Codable {
    let temp: Float
}
struct forecastWeather: Codable {
    let id: Int
}
