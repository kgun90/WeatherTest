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
    @IBOutlet weak var searchTextfField: UITextField!
    
    @IBOutlet weak var forecastStack: UIStackView!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        label.text = "Hello"
//        label.textColor = .black
//        label.backgroundColor = .clear
    
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextfField.delegate = self
   
//        forecastStack.backgroundColor = UIColor.trans
   
//        mainStack.axis = NSLayoutConstraint.Axis.vertical
//        mainStack.distribution = UIStackView.Distribution.fill
//        mainStack.alignment = UIStackView.Alignment.trailing
//        mainStack.contentMode = UIStackView.ContentMode.scaleToFill
//        mainStack.spacing = 10
//
//        self.view.addSubview(mainStack)
//        mainStack.addArrangedSubview(label)
//        mainStack.translatesAutoresizingMaskIntoConstraints = false
//        weatherManager.performRequest(cityName: "Seoul")
//
//        NSLayoutConstraint.activate([
//            mainStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            mainStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
//            mainStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
//            mainStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: mainStack.topAnchor),
//            label.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: -200),
//            label.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
//            label.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
//        ])


    }

    @IBAction func currentLocationButton(_ sender: UIButton) {
        
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
    func didUpdateWeather(data: WeatherInfo) {
        DispatchQueue.main.async {
//            self.label.text = "City: \(data.city)  temp: \(data.temp)'C"
            self.tempLabel.text = String(format: "%.0f", data.temp)
            self.cityLabel.text = data.city
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
//            let lat = 37.5097
//            let lon = 127.0615
            
            weatherManager.makeURLComponents(lat, lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error")
    }
}
