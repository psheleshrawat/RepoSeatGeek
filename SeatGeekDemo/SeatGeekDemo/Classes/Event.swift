//
//  Event.swift
//  SeatGeekDemo
//
//  Created by Shelesh Rawat on 27/04/19.
//  Copyright © 2019 Shelesh Rawat. All rights reserved.
//

import Foundation

class Event {
    
    //let callBack:(eventName:String, success:Bool, error:Error) -> ()
    var eventsForQuery:Array<NSDictionary>? = nil
    
    public init(){
        
        
    }
    
    internal func getEventsForSearchQuery(query:String, eventHandler:@escaping (String, Bool, Error?) -> ()){
        let parameter = [ParameterName.clientId:ParameterValue.clientId,
                         "q":query
                        ]
        //==============================
        let url = Constants.urlGetEventsSearch + "?" + PreparedURL.perpareQueryString(params: parameter)
        var urlRequest = URLRequest(url: URL(string: url)!)
        //------------------------
        // add header in urlRequest
        urlRequest.addValue("GET", forHTTPHeaderField: "method")
        urlRequest.addValue("text/json", forHTTPHeaderField: "content-type")
        //------------------------
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler:{(data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil
            else
            {
                self.eventsForQuery = []
                eventHandler("getEventsForSearchQuery", false, nil)
                return
            }
            
            do{
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>{
                    //print(json)
                    self.eventsForQuery =  json["events"] as? Array
   
                }
            }catch let e {
                print(e.localizedDescription)
            }
            
            //print("RESULT:\(String(describing: response))")
            eventHandler("getEventsForSearchQuery", true, nil)
            })
        
        dataTask.resume()
        
    }
}
