//
//  CustomController.swift
//  LocalNotifications
//
//  Created by Bruno Omella Mainieri on 12/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//


import UIKit
import UserNotifications

class CustomController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var soundToggle: UISwitch!
    @IBOutlet weak var badgeToggle: UISwitch!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var secondsPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(moveToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        secondsPicker.delegate = self
        secondsPicker.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    //    @objc func moveToForeground(){
    //        if let allowed = (UIApplication.shared.delegate as! AppDelegate).notificationsAllowed{
    //            sendButton.isEnabled = allowed
    //        } else {
    //            sendButton.isEnabled = false
    //        }
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let allowed = (UIApplication.shared.delegate as! AppDelegate).notificationsAllowed{
            sendButton.isEnabled = allowed
        } else {
            sendButton.isEnabled = false
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            secondsLabel.text = "\((row + 1).description) segundo"
        } else {
            secondsLabel.text = "\((row + 1).description) segundos"
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (row + 1).description
    }
    
    var secondsCellExpanded:Bool = false
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                secondsCellExpanded = !secondsCellExpanded
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if (indexPath.row == 0 && secondsCellExpanded) {
                return 244
            } else {
                return 44
            }
        }
        return 44
    }
    
    @IBAction func sendButton(_ sender: Any) {
        var title = self.titleTextField.text ?? "Titulo"
        if title.count < 1 {
            title = "Titulo"
        }
        var desc = self.descTextField.text ?? "Descricao"
        if desc.count < 1 {
            desc = "Descricao"
        }
        let soundOn = self.soundToggle.isOn
        let badgeOn = self.badgeToggle.isOn
        let seconds = TimeInterval(self.secondsPicker.selectedRow(inComponent: 0) + 1)
        let notificationCenter = UNUserNotificationCenter.current()
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: desc, arguments: nil)
                if soundOn {
                    content.sound = UNNotificationSound.default
                }
                if badgeOn {
                    content.badge = currentBadgeNumber + 1 as NSNumber
                }
                content.categoryIdentifier = "custom"
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
                
                let request = UNNotificationRequest(identifier: "custom", content: content, trigger: trigger)
                
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == "custom" {
            if response.actionIdentifier == "repeat"{
                print("Again!")
                center.add(response.notification.request) { (error) in
                    print(error?.localizedDescription)
                }
            } else if response.actionIdentifier == "ok"{
                //Navigate to detail screen
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "notificationDetail") as! DetailController
                vc.notification = response.notification
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
