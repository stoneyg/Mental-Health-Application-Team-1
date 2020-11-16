//
//  ViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 9/22/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
// 

import UIKit
import UserNotifications

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Asked for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
                })

        let content = UNMutableNotificationContent()
        content.title = "Go Check on yo' friend HONEY"
        content.subtitle = "Yo homie might be strugglin'"
        content.body = "No fo'real sista, DO IT"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
    }


    @IBAction func blockNrBtn(_ sender: Any) {
        print("Block btn clicked")
    }
    
    @IBAction func weightsBtn(_ sender: Any) {
        print("Weight btn clicked")
    }
    
    @IBAction func circleBtn(_ sender: Any) {
        print("See Circle btn clicked")
    }
    
    
}

