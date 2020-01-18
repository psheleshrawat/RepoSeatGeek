//
//  EventsViewController.swift
//  SeatGeekDemo
//
//  Created by Shelesh Rawat on 27/04/19.
//  Copyright © 2019 Shelesh Rawat. All rights reserved.
//


import UIKit


class EventsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblViewEvent: UITableView!
    
    var event:Event?
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //-------------------------
        event = Event()
        
        self.searchBarSearchButtonClicked(self.searchBar)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tblViewEvent.reloadData()
    }
    
    //MARK: - Other action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueForEventDetails"){
           
            print("Select Row is:\(tblViewEvent.indexPathForSelectedRow!)")
            //---------------- Prepare Data for Details ---------------
            guard let obj = self.event!.eventsForQuery?[tblViewEvent.indexPathForSelectedRow!.row] as? Dictionary<String, AnyObject>  else{
                return;
            }
            
            
            
            
           /*
            let obj:[String:String] = ["image":"stadium",
                                       "title":"MON, 13 JUN 2016 07:05 PM",
                                       "subtitle": "Oakland, CA",
                                       "favourite":"true"
            ]
 */
            //------------------------------------------------------------
            
            if let vc = segue.destination as? EventDetailsViewController {
                vc.details = obj
            }
        }
    }
    
    
}
//MARK: - UISearchBarDelegate
extension EventsViewController : UISearchBarDelegate{
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) // called when keyboard search button pressed
    {
        searchBar.resignFirstResponder()
        
       if let searchText = searchBar.text {
        
        let activity = UIActivityIndicatorView(style: .gray)
        activity.hidesWhenStopped = true
        activity.center = self.view.center
        self.view.addSubview(activity)
        self.view.bringSubviewToFront(activity)
        activity.startAnimating()
        
        self.event?.getEventsForSearchQuery(query: searchText, eventHandler: {(eventName:String, success:Bool, error:Error?) in
            
            
            DispatchQueue.main.async {
            if success == false {
                let alert = UIAlertController(title: "", message: "Failed to load data from network.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    // OK button clicked
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else if self.event!.eventsForQuery!.count <= 0 {
                let alert = UIAlertController(title: "", message: "No result found.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    // OK button clicked
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
                activity.stopAnimating()
                activity.removeFromSuperview()
                self.tblViewEvent.reloadData()
            }
            
        })
        
        
        }
    }
     public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when cancel button pressed
    {
        searchBar.text = ""
        self.event?.eventsForQuery = nil
        self.tblViewEvent.reloadData()
    }
}

//MARK: - UITableViewDelegate
extension EventsViewController : UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        print("Cell \(indexPath.row) did select.")
        
        self.performSegue(withIdentifier: "segueForEventDetails", sender: nil)
    }
}
//MARK: - UITableViewDataSource
extension EventsViewController: UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        //return 20
        if let c = self.event?.eventsForQuery?.count{
            return c
        }else{
            return 0
        }
}
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //---------------- Iniitialize Cell View -------------
        let cellIdentifier = "EventCellIdentifier"
        let cell:EventCell? = self.tblViewEvent.dequeueReusableCell(withIdentifier: cellIdentifier) as? EventCell
        
        if cell == nil {
            print("!!!! CELL NOT FOUND !!!!")
        } else {
            cell!.imgEvent?.image = nil
            //cell!.imgEvent!.cancelUrlSession()
        }
        
        
        //---------------- Prepare Data for Cell --------------
        guard let obj = self.event!.eventsForQuery?[indexPath.row]  else{
            return cell!;
        }
        let dataFormatter = DateFormatter.init()
        dataFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dataFormatter.date(from: obj["datetime_local"] as! String)//"2019-04-27T15:07:00")
        dataFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm a"
        let strDateTime = dataFormatter.string(from: date!)
        
        var flag = false
        if let ar = obj.value(forKey: "performers") as? [Dictionary<String, AnyObject>] {
            if ar.count > 0 {
                
                if let dic = ar[0] as? Dictionary<String, AnyObject> {
                    if let imageUrlStr = dic["image"] as? String {
                        cell!.imgEvent?.cacheImageWithURL(urlString: imageUrlStr)
                        flag = true
                }
            }
            }
        }
        if (flag == false){
            cell!.imgEvent.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "NoImage", ofType: "png")!)
        }
        //---------------- SETUP Fav Icon ----------------
        let eId = obj["id"] as! Int
        let eventId = "\(eId)"
        if true == FavouriteData.isEventFavourite(eventId: eventId){
            let img = UIImage(contentsOfFile: Bundle.main.path(forResource: "fav", ofType: "png")!)
            cell!.imgFav?.image = img
        }
        else{
            cell!.imgFav?.image = nil
        }
        //-------------------------------------------------
    /*    if let img = UIImage(contentsOfFile: Bundle.main.path(forResource: "temp", ofType: "png")!) {
            cell.imgEvent?.image = img;
        }
        
        if (indexPath.row % 2 == 0){
            if let img = UIImage(contentsOfFile: Bundle.main.path(forResource: "fav", ofType: "png")!) {
                cell.imgFav?.image = img;
            }
        }
    */
        
        
        
        cell!.lblEventTitle!.text = obj["title"] as? String //"Texas Rangers at Oakland"
        cell!.lblEventSubTitle!.text = obj["short_title"] as? String //"Oakland, CA"
        cell!.lblEventSubTitle1!.text = strDateTime //"MON, 13 JUN 2016 07:05 PM"
        
        return cell!
    }
}
