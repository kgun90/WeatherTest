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
    func didUpdateForecast(data: [ForecastInfo])
    func didFailWithError(error: Error)
}
struct WeatherInfo {
    let temp: Float
    let city: String
    let condition: String
}
struct ForecastInfo {
    let temp: Float
    let condition: String
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
        static let forecastPath = "/data/2.5/forecast"
    }
    enum urlWFItem: String{
        case scheme = "http"
        case host = "api.openweathermap.org"
        case weatherPath = "/data/2.5/weather"
        case forecastPath = "/data/2.5/forecast"
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

        components.path = urlItem.forecastPath
        performForecastRequest(components)
 
       
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
        performRequest(components)
        
        components.path = urlItem.forecastPath
        performForecastRequest(components)
        
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
                    if let parsedData = self.parseWeatherJSON(safeData) {
                        self.delegate?.didUpdateWeather(data: parsedData)
                   }
                }
            }
            task.resume()
        }
    }
    func parseWeatherJSON(_ weatherData: Data) -> WeatherInfo?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            let city = decodedData.name 
            let condition = WeatherModel(conditionID: decodedData.weather[0].id)
            let weatherInfo = WeatherInfo(temp: temp, city: city, condition: condition.conditionName)
  
            return weatherInfo
        } catch {
            print("parsing error")
            return nil
        }
    }
    
    func performForecastRequest(_ urlComponents: URLComponents) {
        if let url = urlComponents.url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let parsedData = self.parseForecastJSON(safeData) {
                        self.delegate?.didUpdateForecast(data: parsedData)
                   }
                }
            }
            task.resume()
        }
    }
    func parseForecastJSON(_ weatherData: Data) -> [ForecastInfo]?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: weatherData)
            var forecastInfo:[ForecastInfo] = []
            var forcastCondition:[WeatherModel] = []
            for i in 0 ..< decodedData.list.count {
                if i % 8 == 3 {
                    forcastCondition.append(WeatherModel(conditionID: decodedData.list[i].weather[0].id))
                    forecastInfo.append(ForecastInfo(temp: decodedData.list[i].main.temp, condition: forcastCondition[Int(i/8)].conditionName))
                }
            }
            return forecastInfo
        } catch {
            print("parsing error")
            return nil
        }
    }
}
