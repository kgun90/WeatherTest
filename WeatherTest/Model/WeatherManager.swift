//
//  WeatherManager.swift
//  WeatherTest
//
//  Created by Geon Kang on 2020/06/10.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(data: WeatherInfo)
    func didFailWithError(error: Error)
}
struct WeatherInfo {
    let temp: Float
    let city: String
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid="
    let apiKey = "e47a27876b64e5c8ffcae64e68e06dae"
    let units = "metric"
    
    var delegate: WeatherManagerDelegate?
    
    struct urlItem {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5/weather"
    }

    
    func makeURLComponents(_ cityName: String){
        var components = URLComponents()
        components.host = urlItem.host
        components.scheme = urlItem.scheme
        components.path = urlItem.path
       
        components.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "q", value: cityName)
        ]
    
        performRequest(components)
    }
    func makeURLComponents(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees){
        var components = URLComponents()
        components.host = urlItem.host
        components.scheme = urlItem.scheme
        components.path = urlItem.path
       
        components.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude))
        ]
        print(components.url)
        performRequest(components)
        
    }
    func performRequest(_ urlComponents: URLComponents) {
        if let url = urlComponents.url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let parsedData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(data: parsedData)
                        print(response!)
                   }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherInfo?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            let city = decodedData.name
            let weatherInfo = WeatherInfo(temp: temp, city: city)
            print(decodedData)
            return weatherInfo
        } catch {
            print("parsing error")
            return nil
        }
    }
}
