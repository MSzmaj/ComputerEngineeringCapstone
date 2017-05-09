//
//  JSONParser.swift
//  RCBB
//
//  Created by Michal Szmaj on 2017-03-08.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import Foundation

class JSONParser {
    /**
     Parses JSON strings into a MSRCBBData object.
     If cannot parse - this can be the case when the device isn't responding with appropriate values,
     we catch the error and return nil. Otherwise we deserialise it and send it off to the mapped to a MSRCBBData object.
    */
    static func Decode (data: String) -> RCBBData? {
        let formattedData = data.components(separatedBy: "\n")[0]
        if formattedData.lowercased().range(of: "\0") == nil {
            let jsonData = formattedData.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: String]
                if let RCBBData = RCBBData(json: json) {
                    return RCBBData
                }
            } catch {
                print("Failed to parse.")
            }
        }
        return nil
    }
}
