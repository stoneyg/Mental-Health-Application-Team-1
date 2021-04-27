//
//  ShowCircleViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 10/19/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
// 

import UIKit

var array1 = [""]
var array2 = [""]
var array3 = [""]


class ShowCircleViewController: UIViewController {

    @IBOutlet weak var outerNum: UILabel!
    
    @IBOutlet weak var middleNum: UILabel!
    
    @IBOutlet weak var innerNum: UILabel!
    
    
    @IBOutlet weak var innerCircleBtn: UIButton!
    
    @IBOutlet weak var middleCircleBtn: UIButton!
    
    @IBOutlet weak var outerCircleBtn: UIButton!
    
    var algList: [String: Double] = [:]
    
    
    
    override func viewDidLoad() {
        
        //print(sortedDict)
        super.viewDidLoad()
        print("here you are after you have moved it for the 2nd time")
        print(algList)
        print("")
        //Create the new list with only the right spots
        array1 = createArrays(dict: algList, index: 1)
        array2 = createArrays(dict: algList, index: 2)
        array3 = createArrays(dict: algList, index: 3)
        
        outerNum.text = String(algList.count - 8)

        middleNum.text = String("5")

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
        
        if segue.identifier == "innerCircle" {
            
            let destinationController = segue.destination as! CircleListViewController
            destinationController.name = array1
        }
        if segue.identifier == "middleCircle" {
            
            let destinationController = segue.destination as! CL1ViewController
            destinationController.name = array2
        }
        else if segue.identifier == "outerCircle" {
            
            let destinationController = segue.destination as! CL2ViewController
            destinationController.name = array3
        }
    }

    
    func setupButtonStyle(button : UIButton, color: UIColor){
       button.layer.cornerRadius = 0.5 * button.bounds.size.width
       button.clipsToBounds = true
       button.backgroundColor = color
    }
    
    func createArrays(dict: Dictionary<String, Double>, index: Int) -> Array<String>{
        var count = 0
        var array1 = [""]
        let sortedDict = dict.sorted{
            return $0.value > $1.value
        }
        
        if index == 1 {
            for (key, value) in sortedDict {
                
                if count == 0 {
                    array1[0] = key
                }
                
                if count > 0 && count < 3 {
                    array1.append((key))
                }
                count+=1
            }
        }
        
        else if index == 2 {
            for (key, value) in sortedDict {
                
                if count == 3 {
                    array1[0] = key
                }
                
                if count > 3 && count < 8 {
                    array1.append((key))
                }
                count+=1
            }
        }
        else {
            for (key, value) in sortedDict {
                
                if count == 8 {
                    array1[0] = key
                }
                
                if count > 8 {
                    array1.append((key))
                }
                count+=1
            }
        }
        
        print(array1)
        return array1
    }
 
}



