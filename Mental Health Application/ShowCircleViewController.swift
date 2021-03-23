//
//  ShowCircleViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 10/19/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
// 

import UIKit

class ShowCircleViewController: UIViewController {

    @IBOutlet weak var outerNum: UILabel!
    
    @IBOutlet weak var middleNum: UILabel!
    
    @IBOutlet weak var innerNum: UILabel!
    
    
    @IBOutlet weak var innerCircleBtn: UIButton!
    
    @IBOutlet weak var middleCircleBtn: UIButton!
    
    @IBOutlet weak var outerCircleBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let randNum1 = Int.random(in: 0..<10)
       // let randNum2 = Int.random(in: 0..<10)
        
       // let number1 = ((2*5)/2)+4
       // name1.text = String(number1)
        outerNum.text = String("25")
        
       // let number2 = randNum1*randNum2
       // name2.text = String(number2)
        middleNum.text = String("10")
        
       // let number3 = Int.random(in: 0..<10)
       // name3.text = String(number3)
        innerNum.text = String("5")
        
        
        setupButtonStyle(button: innerCircleBtn, color: UIColor.yellow)
        setupButtonStyle(button: middleCircleBtn, color: UIColor.orange)
        setupButtonStyle(button: outerCircleBtn, color: UIColor.red)
   
    }
    
    @IBAction func clickInnerBtn(_ sender: Any) {
        print("Inner btn clicked")
    }
    
    @IBAction func clickMiddleBtn(_ sender: Any) {
        print("Middle btn clicked")
    }
    
    @IBAction func clickOuterBtn(_ sender: Any) {
        print("Outer btn clicked")
    }
    
   
    
    
    func setupButtonStyle(button : UIButton, color: UIColor){
       button.layer.cornerRadius = 0.5 * button.bounds.size.width
       button.clipsToBounds = true
       button.backgroundColor = color
    }
    
    
}
