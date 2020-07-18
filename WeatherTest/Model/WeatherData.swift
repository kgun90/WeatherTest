//
//  WeatherData.swift
//  WeatherTest
//
//  Created by Geon Kang on 2020/06/10.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let cod: Int
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Codable {
    let temp: Float
}
struct Weather: Codable {
    let id: Int
}
