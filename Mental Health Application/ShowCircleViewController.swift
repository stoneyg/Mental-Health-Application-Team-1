//
//  ShowCircleViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 10/19/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
// 

import UIKit


let array = ["Eg",
             "Er",
             "Kongurinn"]
 



var array1 = [""]


class ShowCircleViewController: UIViewController {

    @IBOutlet weak var outerNum: UILabel!
    
    @IBOutlet weak var middleNum: UILabel!
    
    @IBOutlet weak var innerNum: UILabel!
    
    
    @IBOutlet weak var innerCircleBtn: UIButton!
    
    @IBOutlet weak var middleCircleBtn: UIButton!
    
    @IBOutlet weak var outerCircleBtn: UIButton!
    
    var algList = [[""]]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here you are after you have moved it for the 2nd time")
        print(algList)
        print("")
        //Create the new list with only the right spots
        array1 = createArrays(list: algList)
        
       // let randNum1 = Int.random(in: 0..<10)
       // let randNum2 = Int.random(in: 0..<10)
        
       // let number1 = ((2*5)/2)+4
       // name1.text = String(number1)
        outerNum.text = String("12")
        
       // let number2 = randNum1*randNum2
       // name2.text = String(number2)
        middleNum.text = String("7")
        
       // let number3 = Int.random(in: 0..<10)
       // name3.text = String(number3)
        innerNum.text = String("3")
        
        
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
    
    //Move the array from one view to the other
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "middleCircle" {
            
            let destinationController = segue.destination as! CL1ViewController
            destinationController.name = array1
        }
        if segue.identifier == "innerCircle" {
            
            let destinationController = segue.destination as! CircleListViewController
            destinationController.name = array1
        }
        else if segue.identifier == "outerCircle" {
            
            let destinationController = segue.destination as! CL2ViewController
            destinationController.name = array1
        }
    }
    
    
    
    
    
    func setupButtonStyle(button : UIButton, color: UIColor){
       button.layer.cornerRadius = 0.5 * button.bounds.size.width
       button.clipsToBounds = true
       button.backgroundColor = color
    }
    
    
    func createArrays(list: Array<Array<String>>) -> Array<String>{
        let array1 = [list[0][0], list[1][0], list[2][0]]
        
        print(array1)
        return array1
    }
                
            
        
         
        
    
     

    
}



