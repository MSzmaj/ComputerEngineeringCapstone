//
//  Constants.swift
//  RCBB
//
//  Created by Michal Szmaj on 01/04/2017.
//  Copyright © 2017 Michal Szmaj. All rights reserved.
//

import Foundation

struct Constants {
    /**
     Connection constants
    */
    struct Connection {
        //static let address = "172.16.153.136"
        static let address = "192.168.1.1"
        static let port = 3000
        static let pollRate = 0.5
    }
    /**
     Connection Status constants
    */
    struct ConnectionStatus {
        static let connect = "Connect"
        static let connecting = "Connecting"
        static let connected = "Connected"
        static let retry = "Retry"
        static let disconnect = "Disconnect"
    }
    /**
     Command constants
     */
    struct Command {
        static let latest = "L"
        static let all = "A"
        static let today = "T"
        static let clearData = "D"
        static let demo = "DE"
    }
    /**
     Approximate distance constants
     */
    struct Distance {
        static let maximumDifference = 0.000003
    }
}
