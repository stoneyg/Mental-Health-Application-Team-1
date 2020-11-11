//
//  WeightsViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 11/8/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
//

import UIKit

class WeightsViewController: UIViewController {
    
    @IBOutlet weak var callValue: UILabel!
    @IBOutlet weak var textValue: UILabel!
    @IBOutlet weak var facetimeValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    @IBAction func callSlider(_ sender: UISlider) {
        let value = sender.value
        callValue.text = String(value)
    }
    
    @IBAction func textSlider(_ sender: UISlider) {
        let value = sender.value
        textValue.text = String(value)
    }
    
    @IBAction func facetimeSlider(_ sender: UISlider) {
        let value = sender.value
        facetimeValue.text = String(value)
    }
    
}
