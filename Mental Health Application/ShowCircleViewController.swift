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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let number = Int.random(in: 0..<10)
        name1.text = String(number)
    }
    
   
    
    
    
    
    
}
