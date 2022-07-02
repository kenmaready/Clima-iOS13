//
//  WeatherModel.swift
//  Clima
//
//  Created by Ken Maready on 6/30/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    // stored properties
    let conditionId: Int
    let location: String
    let temp: Double
    
    // computed properties
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var icon: String {
        switch conditionId {
        case 801...899:
            return "cloud"
        case 800:
            return "sun.max"
        case 700...799:
            return "aqi.medium"
        case 600...699:
            return "snowflake"
        case 500...599:
            return "cloud.rain"
        case 300...399:
            return "cloud.drizzle"
        case 200...299:
            return "cloud.bolt.rain.fill"
        default:
            return "questionmark.circle"
        }
    }
}
