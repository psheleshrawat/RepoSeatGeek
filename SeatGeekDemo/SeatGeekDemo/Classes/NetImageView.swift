//
//  NetImageView.swift
//  SeatGeekDemo
//
//  Created by Shelesh Rawat on 28/04/19.
//  Copyright © 2019 Shelesh Rawat. All rights reserved.
//

import Foundation
import UIKit



class NetImageView:UIImageView{
    
    private static let imageToCache = NSCache<AnyObject, AnyObject>()
    private var strUrl = ""
    //private var urlSessionDataTask:URLSessionDataTask? = nil
    
    static func cleanCache(){
        imageToCache.removeAllObjects()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage(notification:)), name:NSNotification.Name.init("ImageDownloadNotification"), object: nil)
    }
    
    @objc func updateImage(notification:Notification){
        print("updateImage");
        let url = (notification.object as! URL).absoluteString
        if url.elementsEqual(self.strUrl){
            print("url equal:\(url)")
            
            if let  image = NetImageView.imageToCache.object(forKey: self.strUrl as AnyObject) as? UIImage {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            
            
        }else{
            print("url not equal:\(url)")
        }
        //        if self.image == nil
        //        {
        //            if let  image = NetImageView.imageToCache.object(forKey: self.strUrl as AnyObject) as? UIImage {
        //                DispatchQueue.main.async {
        //                    self.image = image
        //
        //                }
        //                return
        //            }
        //        }
    }
    
    func cacheImageWithURL(urlString:String){
     self.strUrl = urlString
        if let  image = NetImageView.imageToCache.object(forKey: urlString as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                self.image = image
            }
            return
        }
        let url = URL(string: urlString)
        let session = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            guard error != nil
            else
            {
                let img =  UIImage(data:data!)
                NetImageView.imageToCache.setObject(img!, forKey: url!.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    //self.cacheImageWithURL(urlString: url!.absoluteString)
                    //self.image = img
                    NotificationCenter.default.post(name: NSNotification.Name.init("ImageDownloadNotification"), object: url)
                }
                return
            }
            
            // Error exist in image loading
            print("Failed to load image from:\n\(url!.absoluteString)")
            
        })
        session.resume()
    }
    func cancelUrlSession() {
      // self.urlSessionDataTask?.cancel()
        //self.urlSessionDataTask = nil
    }
    deinit {
       
        NotificationCenter.default.removeObserver(self)
    }
}

