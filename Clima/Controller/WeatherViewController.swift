//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var manager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        manager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - UITextFieldDelegate
// adopt UITextFieldDelegate Protocol by extension
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func handleSearch(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != "" {
            return true
        } else {
            searchField.placeholder = "Please type a location"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let location = searchField.text {
            manager.fetchWeather(location)
        }
        searchField.text = ""
    }
}

// MARK: - WeatherManagerDelegate
// adopt WeatherManagerDelegate Protocol by extension
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel) {
        print("weather updated: \(weather)")
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.icon)
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.location
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("error occurred in obtaining weather: \(error)")
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        print("The locationManager has updated its location.")
        print("The number of locations is now: \(locations.count)")
        print("The first location is: \(userLocation)")
    }
}

