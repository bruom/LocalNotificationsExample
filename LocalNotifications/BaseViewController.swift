//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Bruno Omella Mainieri on 22/05/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import UserNotifications

class BaseViewController: UIViewController {

    @IBOutlet weak var notifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setInitialInterface), name: NSNotification.Name(rawValue: "permissionDidChange"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            self.handleNotificationPermission(allowed: settings.authorizationStatus == .authorized)
        }
    }
    
    @objc func setInitialInterface(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            self.handleNotificationPermission(allowed: settings.authorizationStatus == .authorized)
        }
    }
    
    func handleNotificationPermission(allowed:Bool){
        DispatchQueue.main.async {
            if allowed{
                self.notifyButton.setTitle("Me lembre", for: .normal)
                self.notifyButton.isHidden = false
                self.notifyButton.isEnabled = true
            } else {
                self.notifyButton.setTitle("Notificações desabilitadas :(", for: .normal)
                self.notifyButton.isHidden = false
                self.notifyButton.isEnabled = false
            }
        }
    }
    
    @objc func moveToForeground(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            self.handleNotificationPermission(allowed: settings.authorizationStatus == .authorized)
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    @IBAction func notifyMe(_ sender: Any) {
        let notificationCenter = UNUserNotificationCenter.current()
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Lembre-se", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "Você se lembrou", arguments: nil)
                content.sound = UNNotificationSound.default
                
                content.badge = currentBadgeNumber + 1 as NSNumber
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let request = UNNotificationRequest(identifier: "5seconds", content: content, trigger: trigger)

                let center = UNUserNotificationCenter.current()
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            } else {
                print("Impossível mandar notificação - permissão negada")
            }
        }
    }
}

