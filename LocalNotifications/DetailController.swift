//
//  DetailController.swift
//  LocalNotifications
//
//  Created by Bruno Omella Mainieri on 11/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class DetailController: UIViewController {

    var notification:UNNotification?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let notification = notification {
            titleLabel.text = notification.request.content.title
        }
        // Do any additional setup after loading the view.
    }

}
