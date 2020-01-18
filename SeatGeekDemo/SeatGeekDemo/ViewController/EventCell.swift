//
//  EventCell.swift
//  SeatGeekDemo
//
//  Created by Shelesh Rawat on 27/04/19.
//  Copyright © 2019 Shelesh Rawat. All rights reserved.
//

import Foundation
import UIKit

class EventCell : UITableViewCell
{
    @IBOutlet weak var imgEvent:NetImageView!
    @IBOutlet weak var imgFav:UIImageView!
    @IBOutlet weak var lblEventTitle:UILabel!
    @IBOutlet weak var lblEventSubTitle:UILabel!
    @IBOutlet weak var lblEventSubTitle1:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        self.imgEvent.layer.masksToBounds = true
        self.imgEvent.layer.cornerRadius = 10.0
    }
}
