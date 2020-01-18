//
//  EventDetailsViewController.swift
//  SeatGeekDemo
//
//  Created by Shelesh Rawat on 27/04/19.
//  Copyright © 2019 Shelesh Rawat. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgViewFull:NetImageView!
    @IBOutlet weak var lblEventDate:UILabel!
    @IBOutlet weak var lblEventSubtitle:UILabel!
    
    var details:Dictionary <String,AnyObject>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        //imageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "fav", ofType: "png")!)
        
    
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        btn.addTarget(self, action: #selector(rightBarButtonAction(sender:)), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = rightBarButton

        
        //self.navigationItem.title = "Texas Rangers at Oakland Athletics"
        //self.imgViewFull.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "stadium", ofType: "png")!)
       // self.lblEventDate.text = "MON, 13 JUN 2016 07:05 PM"
       // self.lblEventSubtitle.text = "Oakland, CA"
      
        self.updateData()
    }
    func updateData() {
        /*
        guard let obj = self.event!.eventsForQuery?[indexPath.row]  else{
            return cell;
        }
        */
        let dataFormatter = DateFormatter.init()
        dataFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dataFormatter.date(from: details!["datetime_local"] as! String)   //"2019-04-27T15:07:00"
        dataFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm a"
        let strDateTime = dataFormatter.string(from: date!)
        
        if let ar = details!["performers"] as? [Dictionary<String, AnyObject>] {
            if ar.count > 0 {
                
                if let dic = ar[0] as? Dictionary<String, AnyObject> {
                    if let imageUrlStr = dic["image"] as? String {
                        self.imgViewFull.cacheImageWithURL(urlString: imageUrlStr)
                        
                    }
                }
            }
        }
        
        self.navigationItem.title = details!["title"] as? String
        
        self.lblEventDate!.text = strDateTime
        self.lblEventSubtitle!.text = details!["short_title"] as? String
        
        let btn = self.navigationItem.rightBarButtonItem?.customView as? UIButton
        let eId = details!["id"] as! Int
        let eventId = "\(eId)"
        if true == FavouriteData.isEventFavourite(eventId: eventId){
           
            let img = UIImage(contentsOfFile: Bundle.main.path(forResource: "fav", ofType: "png")!)
            btn!.setImage(img, for: .normal)
            btn!.setImage(img, for: .selected)
            
        }else{
            
            //btn!.setImage(nil, for: .normal)
            //btn!.setImage(nil, for: .selected)
            
            btn!.setImage(UIImage(named: "fav_not_selected"), for: .normal)
            btn!.setImage(UIImage(named: "fav_not_selected"), for: .selected)
        }
    }
    @IBAction func rightBarButtonAction(sender:Any){
        print("Button Clicked")
       // let btn = sender as UIButton
        let btn = sender as! UIButton
        
        let eId = details!["id"] as! Int
        let eventId = "\(eId)"
        if true == FavouriteData.isEventFavourite(eventId: eventId){
            FavouriteData.removeFavouriteToEvent(eventId: eventId)
            
            btn.setImage(UIImage(named: "fav_not_selected"), for: .normal)
            btn.setImage(UIImage(named: "fav_not_selected"), for: .selected)
        }else{
            FavouriteData.setFavouriteToEvent(eventId: eventId)
            let img = UIImage(contentsOfFile: Bundle.main.path(forResource: "fav", ofType: "png")!)
            btn.setImage(img, for: .normal)
            btn.setImage(img, for: .selected)
        }
    }
}
