//
//  ViewController.swift
//  Senior Design Algorithm
//
//  Created by Gabrielle Stoney on 10/6/20.
//

import UIKit


class ViewController: UIViewController {

    var contactLogData:[[String:String]] = []
    var contactLogTitles:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readContactLogData(_ sender: Any) {
        
        printCSVData()
    }
    
    @IBOutlet weak var textView: UITextView!
    
    // Cleans the rows for proper layout
    func cleanRows(_ file:String)->String{
        
        var cleanFile = file
        
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        
        return cleanFile
    
    }
   
    // converts data into a csv file
    func convertCSV(file:String){
            
        let rows = cleanRows(file).components(separatedBy: "\n")
        
        if(rows.count > 0){
            
            contactLogData = []
            contactLogTitles = getStringFieldsForRow(row: rows.first!, delimiter: ",")
            
            for row in rows {
                
                let fields = getStringFieldsForRow(row: row, delimiter: ",")
                if(fields.count != contactLogTitles.count) {continue}
                
                    var dataRow = [String:String]()
                    for(index,field) in fields.enumerated(){
                        
                        let fieldName = contactLogTitles[index]
                        dataRow[fieldName] = field
                    
                    }
                    contactLogData += [dataRow]
                    
                }
            } else {
            
            print("No data in file")
            
            }
                
        }
        
    // Reads the file
    func getStringFieldsForRow(row:String, delimiter:String)->[String]{
        
        return row.components(separatedBy: delimiter)
    }
    
    // Prints out data to prove we printed correct values
    func printCSVData() {
    
        convertCSV(file: textView.text)
       // convertCSV(file: "Contact Log - MHA.txt")
        
        var tableString = ""
        var rowString = ""
        
        print("Contact Log Data: \(contactLogData)")
        
        for row in contactLogData{
            
            rowString = ""
            for fieldName in contactLogTitles{
                
                guard let field = row[fieldName]
                else {
                    print("Field not foune: \(fieldName)")
                    continue
                }
                rowString += String(format: "%@", field)
            }
            
            tableString += rowString + "\n"
        }
        textView.text = tableString
    }
                
}

