//
//  ShowCircleViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 10/19/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
// 

import UIKit

class ShowCircleViewController: UIViewController, UIDocumentPickerDelegate {

  
    var viewController:ViewController = ViewController(nibName: nil, bundle: nil)
    @IBOutlet weak var name1: UILabel!
    
    @IBOutlet weak var name2: UILabel!
    
    @IBOutlet weak var name3: UILabel!
    
    @IBOutlet weak var getNameOfContact: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   
    @IBAction func orderContacts(_ sender: Any) {
        
        print("Order contacts button pressed")
        
        let first = viewController.getFirstContact()
        let second = viewController.getSecondContact()
        let third = viewController.getThirdContact()
        
        name1.text = first
        name2.text = second
        name3.text = third
    }
    
   
    @IBAction func saveContactName(_ sender: Any) {
        
        let contactName = getNameOfContact
        //viewController.setBlockedContact(contact: contactName)
        
    }
    
    
    
    
    
}
