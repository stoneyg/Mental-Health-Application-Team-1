//
//  CL1ViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 3/24/21.
//  Copyright © 2021 Gardar Benediktsson. All rights reserved.
//

import UIKit


class CL1ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   /*
    let name = [
        "Chris",
        "Matt",
        "Natalie",
        "Anita",
        "Justin",
        "Scott",
        "Marie"
    ]
   */
    
    
     var name: Array<String> = [""]
   
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      print(name)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Yes it was selected")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = name[indexPath.row]

        
        return cell
    }

}
