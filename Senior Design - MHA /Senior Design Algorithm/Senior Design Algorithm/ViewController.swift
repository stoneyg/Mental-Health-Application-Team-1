//
//  ViewController.swift
//  Senior Design Algorithm
//
//  Created by Gabrielle Stoney on 10/6/20.
//

import UIKit
import Foundation




class ViewController: UIViewController {

    var algorithm:[Dictionary<String,AnyObject>] = Array()
    var dct = Dictionary<String,AnyObject>()
    var contactLogData:[[String:String]] = []
    var contactLogTitles:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readContactLogData(_ sender: Any) {
        
        //printCSVData()
        
        var data = readDataFromCSV(fileName: "Contact Log - MHA", fileType: ".csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        var name1 = "Simone Stoney"
        var name2 = "Laurie Stoney"
        
        for rows in csvRows {
           
            //var dct1 = Dictionary<String,AnyObject>()
            
            let name = rows[0]
            let number = rows[1]
            let formOfCom:String = [2]
            var formOfComNum1 = 0.0
            var formOfComNum2 = 0.0
            var formOfComNum3 = 0.0
            let duration = rows[3]
            var durationNum = 0.0
            let impact = rows[4]
            var impactNum = 0.0
            let experience = rows[5]
            var experienceNum = 0.0
            let time = rows[6]
            var timeNum = 0.0
            var formOfComCall = 0.0
            var formOfComFT = 0.0
            var formOfComTxt = 0.0
            var formOfComTotal = 0.0
            
            formOfComTotal = formOfComFT + formOfComCall + formOfComCall
            formOfComNum1 = formOfComCall/formOfComTotal
            formOfComNum2 = formOfComFT/formOfComTotal
            formOfComNum3 = formOfComTxt/formOfComTotal
            
            if impact.contains("Pos"){
                impactNum = 1
            }else {
                impactNum = -1
            }
            
            if formOfCom.contains("Call"){
                formOfComNum1 = formOfComNum1
                formOfComCall += 1
            } else if formOfCom.contains("Facetime"){
                (formOfComNum2 = formOfComNum2)
                formOfComFT += 1
            }else {
                formOfComNum3 = formOfComNum3
                formOfComTxt += 1
            }
            
            
           
            if rows == dct["Name"] as! [String]{
                
                let trust =
                
                dct.updateValue(rows as AnyObject, forKey: "Name")
            }
           
            
            dct.updateValue(rows as AnyObject, forKey: "Name")
            dct.updateValue(rows as AnyObject, forKey: "")
            
            
            
        }
        
    }
    
    @IBOutlet weak var textView: UITextView!
    
    func createCSV(from recArray:[Dictionary<String,AnyObject>]) {
        
        var CSVString = "\("Contact Name"), \("Form and Duration of Communication"), \("Impact and Experience"), \("Duration of Last Communication")"
        
        
        for dct in recArray {
            
            CSVString = CSVString.appending("\(String(describing: dct["Name"]!)), \(String(describing:dct["FormOfCom"]!)), \(String(describing: dct ["Impression"])), \(String(describing: dct["Time"]!))\n")
            
        }
        
        let fileManager = FileManager.default
        do {
            
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("Algorithm.csv")
            try CSVString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch{
                
                print("Error Creating File")
        }
    }
    
    func readDataFromCSV(fileName:String, fileType:String) -> String! {
        
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileType)
        else {
            return nil
        }
        do {
            
            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
                return contents
            
        } catch {
            
            print("File Read Error for File \(filePath)")
            return nil
        }
    }

    func csv(data: String) -> [[String]]{
        
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        
        for row in rows {
            
            let colums = row.components(separatedBy: ";")
            result.append(colums)
        }
        return result
    }

    func cleanRows(file:String) -> String{
        
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with:    "\n")
        return cleanFile
    }

}
