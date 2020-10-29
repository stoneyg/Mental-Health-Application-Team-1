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
    var trustCalculation:[Double] = []
    var dct = Dictionary<String,AnyObject>()
    var contactLogData:[[String:String]] = []
    var contactLogTitles:[String] = []
    var trust:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func readContactLogData(_ sender: Any) {
        
        
        
        var data = readDataFromCSV(fileName: "MHA - Contact Log", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        
        for rows in csvRows {
    
            //let name = rows[0]
            //let number = rows[1]
            let formOfCom:String = rows[2]
            var formOfComNum1 = 0.0
            var formOfComNum2 = 0.0
            var formOfComNum3 = 0.0
            /*let duration = rows[3]
            var durationNum = 0.0
            let impact = rows[4]
            var impactNum:Double = Double(impact) ?? 0.0
            let experience = rows[5]
            var experienceNum:Double = Double(experience) ?? 0
            let time = rows[6]
            var timeNum = 0.0*/
            var formOfComCall = 0.0
            var formOfComFT = 0.0
            var formOfComTxt = 0.0
            var formOfComTotal = 0.0
            
            if formOfCom.contains("Call"){
                (formOfComNum1 = formOfComNum1)
                formOfComCall += 1
            } else if formOfCom.contains("Facetime"){
                (formOfComNum2 = formOfComNum2)
                formOfComFT += 1
            }else {
                (formOfComNum3 = formOfComNum3)
                formOfComTxt += 1
            }
            
            trust = formOfComNum1+formOfComNum2+formOfComNum3
            
            formOfComTotal = formOfComFT + formOfComCall + formOfComCall
            formOfComNum1 = formOfComCall/formOfComTotal
            formOfComNum2 = formOfComFT/formOfComTotal
            formOfComNum3 = formOfComTxt/formOfComTotal
            
            trustCalculation.append(trust)
            
           /* if name.contains("Contact Name"){
                break
            }else {*/
                dct.updateValue(rows as AnyObject, forKey: "Name")
                dct.updateValue(rows as AnyObject, forKey: "Trust")
                algorithm.append(dct)
            //}
            
            print("Tracking People's Trust Algorithm: \(algorithm)")
            
           /*var nameVal = dct["Name"]
            
            if name == nameVal as! String{
                
                dct.updateValue(rows as AnyObject, forKey: "Trust")
                algorithm.append(dct)
                
            }else {
            
                
            }*/
            
        }
        createCSV(from: algorithm)
        
        trustCalculation.sort()
        print("Trust Calculation: \(trustCalculation)")
    
       var algorithmData = readDataFromCSV(fileName: "Algorithm", fileType: "csv")
        algorithmData = cleanRows(file: algorithmData!)
        let algorithmCalc = csv(data: algorithmData ?? "Nothing here")
        
        /*for algRows in algorithmRows {
            trustCalculation.append(Double(algRows[1])!)
           
        }*/
        
       // trustCalculation.sort()
    }
    
    func createCSV(from recArray:[Dictionary<String,AnyObject>]) {
        
        var CSVString = "\("Contact Name"), \("Trust Value")"
        
        
        for dct in recArray {
            
            CSVString = CSVString.appending("\(String(describing: dct["Name"]!)), \(String(describing:dct["Trust"]!))\n")
            
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
            
            let colums = row.components(separatedBy: ",")
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
