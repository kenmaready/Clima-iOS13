//
//  WeatherManager.swift
//  Clima
//
//  Created by Ken Maready on 6/29/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_: WeatherModel)
    func didFailWithError(_: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?units=imperial"
    //appid=aaef9d25f5792262c0faef5eddf2a9d1
    let apiKey = ProcessInfo.processInfo.environment["owmApiKey"]!
    
    
    func fetchWeather(_ cityName: String) {
        let url = "\(baseURL)&appid=\(apiKey)&q=\(cityName)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let location = decodedData.name
            let temp = decodedData.main.temp
            let conditionId = decodedData.weather[0].id
            
            return WeatherModel(conditionId: conditionId, location: location, temp: temp)
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    

}
