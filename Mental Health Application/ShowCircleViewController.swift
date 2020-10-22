//
//  ShowCircleViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 10/19/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
// 

import UIKit

class ShowCircleViewController: UIViewController {

    
    @IBOutlet weak var name1: UILabel!
    
    @IBOutlet weak var name2: UILabel!
    
    @IBOutlet weak var name3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let number1 = Int.random(in: 0..<10)
        name1.text = String(number1)
        
        let number2 = Int.random(in: 0..<10)
        name2.text = String(number2)
        
        let number3 = Int.random(in: 0..<10)
        name3.text = String(number3)
    }
    
   
    
    
    
    
    
}
