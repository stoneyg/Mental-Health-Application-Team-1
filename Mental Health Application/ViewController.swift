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
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
                })

        
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

