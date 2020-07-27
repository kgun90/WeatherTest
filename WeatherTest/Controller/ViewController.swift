//
//  ViewController.swift
//  WeatherTest
//
//  Created by Geon Kang on 2020/06/08.
//  Copyright © 2020 Geon Kang. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var searchTextfField: UITextField!
    
    @IBOutlet weak var forecastStack: UIStackView!
    
    @IBOutlet weak var forecastImageLabel: UIStackView!
    
    var cityName = ""
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    let date = Date()
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
      
        if CLLocationManager.locationServicesEnabled(){ locationManager.requestLocation() }
        searchTextfField.delegate = self
        searchTextfField.placeholder = "Type City Name"
        
    }

    @IBAction func currentLocationButton(_ sender: UIButton) {
       locationManager.requestLocation()
    }
    
}
//MARK: - UITextfieldDelegate

extension ViewController: UITextFieldDelegate {
    @IBAction func serachButtonPressed(_ sender: UIButton) {
        searchTextfField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextfField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
//            textField.placeholder = "Type City Name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextfField.text {
            weatherManager.makeURLComponents(city)
            // makeURLComponents 함수명 명확하고 구분 가능하게 수정
        }
        searchTextfField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    
    func didUpdateForecast(data: [ForecastInfo]) {
        dateFormatter.dateFormat = "EEE"
        dateFormatter.locale = Locale(identifier: "kr_KR")
        let today = dateFormatter.string(from: date).uppercased()
        // Parsing data 중 날짜 자료를 받아서 가공 후 출력하는 식으로 수정
        
        DispatchQueue.main.async {
//            for i in 0 ..< self.forecastImageLabel.subviews.count {
//                self.forecastImageLabel.subviews[i]
            self.forecastImageLabel.subviews.forEach{
                    ($0.subviews[0] as! UIImageView).image = UIImage(systemName: data[$0.tag].condition)
                    ($0.subviews[1] as! UILabel).text = String(format: "%.0f", data[$0.tag].temp)
                    ($0.subviews[2] as! UILabel).text = today
                    // subviews[] as!, tag 사용 문법은 위험하니 수정
                }
        }
    }
        
    func didUpdateWeather(data: WeatherInfo) {
        DispatchQueue.main.async {
            self.tempLabel.text = String(format: "%.0f", data.temp)
            self.cityLabel.text = data.city
            self.weatherImage.image = UIImage(systemName: data.condition)
            self.weatherLabel.text = data.conditionLabel
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.makeURLComponents(lat, lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error")
    }
}
