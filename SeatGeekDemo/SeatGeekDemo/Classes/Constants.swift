//
//  Constants.swift
//  SeatGeekDemo
//
//  Created by Shelesh Rawat on 27/04/19.
//  Copyright © 2019 Shelesh Rawat. All rights reserved.
//

import Foundation



class Constants{
    
    private struct Domains{
        static let UAT:String = "https://192.168.0.50:2323"
        static let Production:String = "https://api.seatgeek.com"
    }
    
        private static let Domain = Domains.Production
        private static let Route = "/2"
    
    // https://api.seatgeek.com/2/events?client_id=<your client id>&q=Texas+Ranger
    public static var urlGetEventsSearch = Domain + Route + "/events"
    public static var urlGetPerformers = Domain + Route + "/performes"
}

class PreparedURL {
    
    static func perpareQueryString(params:[String:String]) -> String
    {
        var qs:String = ""
        for (_key, _value ) in params {
           let k = _key.replacingOccurrences(of: " ", with: "%20")
           let v = _value.replacingOccurrences(of: " ", with: "%20")
            qs +=  "&" + k + "=" + v
        }
        return qs
    }
}
class  ParameterValue {
    static let userId = "sheleshrawat@gmail.com"
    static let password = "Password$123"
    
    static let clientId = "MTYzODk5MzN8MTU3MTcyOTY5NS4zOA"
    static let appSecret = "559067543f89c4759a75581c6fb41e540d9f65f55d2c6433b03b72b22258c92e"
}
class  ParameterName {
    static let userId = ""
    static let password = ""
    
    static let clientId = "client_id"
    static let appName = "TESTAPP"
    static let appSecret = "Secret"
    static let query = "q"
}
