//
//  BlockNrViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 10/21/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
//

import UIKit

class BlockNrViewController: UIViewController {

    var blockList = [""]
    
    @IBOutlet weak var blockField: UITextField!
    
    @IBOutlet weak var blockBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            }
    
    @IBAction func clickBlockBtn(_ sender: Any) {
        
        if blockList[0] == "" {
            blockList[0] = blockField.text!
        }
        else {
        blockList.append(blockField.text!)
        }
        
        if let name = blockField.text {
            print("\(name)")
        }
        print(blockList)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "back" {
            
            print("this is block segue")
            
            let destinationController = segue.destination as! ViewController
            //destinationController.algList = sortAlgorithm(arrOfContactList: arrOfContactInteractionList)
            destinationController.testValueArray = blockList
            
        }
    }
    
    
    
}
