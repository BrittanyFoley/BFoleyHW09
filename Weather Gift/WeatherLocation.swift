//
//  WeatherLocation.swift
//  Weather Gift
//
//  Created by Brittany Foley on 3/28/17.
//  Copyright © 2017 Brittany Foley. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class weatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = -999999.9
    var dailySummary = ""
    
    func getWeather(completed: @escaping () -> ()) {
        
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    print("Temp inside getWeather =\(temperature)")
                    self.currentTemp = temperature
                } else {
                    print("Could not return a temperature!") }
                   if let summary = json["daily"]["summary"].string {
                    print("Summary inside getWeather =\(summary)")
                    self.dailySummary = summary
                } else {
                    print("Could not return a temperature!")
                }            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}


