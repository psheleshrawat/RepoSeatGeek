//
//  FavouriteData.swift
//  SeatGeekDemo
//
//  Created by Shelesh Rawat on 28/04/19.
//  Copyright © 2019 Shelesh Rawat. All rights reserved.
//

import Foundation

class FavouriteData{
    static func setFavouriteToEvent(eventId:String){
        var flag = false
         var favData =  UserDefaults.standard.value(forKey: "FAVOURITE_DATA") as? [String]
        if(favData == nil)
        {
            favData = [String]()
        }
        
        for ev in favData! {
            if ev == eventId{
                flag = true
                break
            }
        }
        if flag == false{
            favData?.append(eventId)
         
        }
   UserDefaults.standard.set(favData, forKey: "FAVOURITE_DATA")
}
    static func isEventFavourite(eventId:String)-> Bool{
        if var favData =  UserDefaults.standard.value(forKey: "FAVOURITE_DATA") as? [String]{
          for ev in favData {
            if ev == eventId{
                return true
            }
            }
        }
        return false
    }
    static func removeFavouriteToEvent(eventId:String){
        var flag = false
        if var favData =  UserDefaults.standard.value(forKey: "FAVOURITE_DATA") as? [String]{
             var c = 0
            for ev in favData {
            
              if ev == eventId{
                flag = true
                break
              }
              c+=1
           }
        
        if flag == true{
            favData.remove(at: c)
            UserDefaults.standard.set(favData, forKey: "FAVOURITE_DATA")
            
            }
            
        }
    }
}
