//
//  ForecastData.swift
//  WeatherTest
//
//  Created by Geon Kang on 2020/07/13.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import Foundation

struct ForecastData: Codable {
    let list: [ForecastList]
}
struct ForecastList: Codable {
    let main: ForecastMain
    let weather: [ForecastWeather]
}
struct ForecastMain: Codable {
    let temp: Float
}
struct ForecastWeather: Codable {
    let id: Int
}
