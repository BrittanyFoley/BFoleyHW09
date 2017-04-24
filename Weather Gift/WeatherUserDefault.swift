//
//  WeatherUserDefault.swift
//  Weather Gift
//
//  Created by Brittany Foley on 4/20/17.
//  Copyright © 2017 Brittany Foley. All rights reserved.
//

import Foundation

class weatherUserDefault: NSObject, NSCoding {
    
    var name = ""
    var coordinates = ""
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        name = aDecoder.decodeObject(forKey: "name") as! String
        coordinates = aDecoder.decodeObject(forKey: "coordinates") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(coordinates, forKey: "coordinates")
    }
    
}
