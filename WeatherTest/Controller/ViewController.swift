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
//    let mainStack = UIStackView()
//
//    var label = UILabel()
    
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var searchTextfField: UITextField!
    
    @IBOutlet weak var forecastStack: UIStackView!
    
    @IBOutlet weak var forecastImageLabel: UIStackView!
    
    var cityName = ""
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
      
        if CLLocationManager.locationServicesEnabled(){ locationManager.requestLocation() }
        searchTextfField.delegate = self
   
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
            textField.placeholder = "Type City Name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextfField.text {
            weatherManager.makeURLComponents(city)
        }
        searchTextfField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    func didUpdateForecast(data: [ForecastInfo]) {
    
        DispatchQueue.main.async {
                self.forecastImageLabel.subviews.forEach {
                    ($0.subviews[0] as! UIImageView).image = UIImage(systemName: data[$0.tag].condition)
                    ($0.subviews[1] as! UILabel).text = String(format: "%.0f", data[$0.tag].temp)
                }
        }
    }
        
    func didUpdateWeather(data: WeatherInfo) {
        DispatchQueue.main.async {
            self.tempLabel.text = String(format: "%.0f", data.temp)
            self.cityLabel.text = data.city
            self.weatherImage.image = UIImage(systemName: data.condition)
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
