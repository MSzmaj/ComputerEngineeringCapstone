//
//  RCBBData.swift
//  RCBB
//
//  Created by Michal Szmaj on 2017-03-08.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import Foundation

struct RCBBData {
    //Public variables
    var date: String
    var x: String
    var y: String
    var z: String
    var temperature: String
    var pressure: String
    var altitude: String
    var latitude: String
    var latitudeDirection: String
    var longitude: String
    var longitudeDirection: String
    var quality: String
    var satellites: String
    var speed: String
    
    /**
     Initialiser. Assigns the appropriate values using key/value pairs from a JSON string
    */
    init? (json: [String: Any]) {
        self.date = json["date"] as! String
        self.x = json["x"] as! String
        self.y = json["y"] as! String
        self.z = json["z"] as! String
        self.temperature = json["temperature"] as! String
        self.pressure = json["pressure"] as! String
        self.altitude = json["altitude"] as! String
        self.latitude = json["latitude"] as! String
        self.latitudeDirection = json["latDir"] as! String
        self.longitude = json["longitude"] as! String
        self.longitudeDirection = json["longDir"] as! String
        self.quality = json["quality"] as! String
        self.satellites = json["satellites"] as! String
        self.speed = json["speed"] as! String
    }
    
    /**
     Compiles the data into one human readable string. Used for debugging purposes only
    */
    func asString () -> String {
        return "Date: " + date + ", X: " + x + ", Y: " + y + ", Z: " + z + ", Temp: " + temperature + ", Pressure: " + pressure + ", Altitude: " + altitude + ", Lat: " + latitude + ", LatDir: " + latitudeDirection + ", Long: " + longitude + ", LongDir: " + longitudeDirection + ", Quality: " + quality + ", Sat: " + ", Speed: " + speed
    }
}


