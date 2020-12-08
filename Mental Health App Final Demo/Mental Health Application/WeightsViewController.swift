//
//  WeightsViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 11/8/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
//

import UIKit

class WeightsViewController: UIViewController {
    
    var viewController:ViewController = ViewController(nibName: nil, bundle: nil)
    @IBOutlet weak var callValue: UILabel!
    @IBOutlet weak var textValue: UILabel!
    @IBOutlet weak var facetimeValue: UILabel!
    var callWeight:Float = 0.0
    var facetimeWeight:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func callSlider(_ sender: UISlider) {
        callWeight = sender.value
        callValue.text = String(callWeight)
        //viewController.setCallWeight(call: callWeight)
    }
    
    @IBAction func textSlider(_ sender: UISlider) {
        let value = sender.value
        textValue.text = String(value)
    }
    
    @IBAction func facetimeSlider(_ sender: UISlider) {
        facetimeWeight = sender.value
        facetimeValue.text = String(facetimeWeight)
    }
    
    func setFacetimeWeight(facetime:Float) {
        facetimeWeight = facetime
    }
    func setCallWeight(call:Float) {
        callWeight = call
    }
    
    
    @IBAction func saveSliderValues(_ sender: Any) {
        
        var data = readDataFromCSV(fileName: "Contact Data", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        var arrOfContactInfoFixed = [[String]]()
        var arrOfContactTrustFixed = [[String]]()
        
        
        for rows in csvRows.enumerated(){
            
            if rows.offset == csvRows.count-1{
                break
            }else{
                if rows.element[1] != "#VALUE!" || rows.element[1] == "" {
                    let typeOfCom = rows.element[0]
                    let name = rows.element[1]
                    let date = rows.element[2]
                    let duration = rows.element[3]
                    
                    
                    arrOfContactInfoFixed.append([typeOfCom, name, date, duration])
                }
            }
        }
        
        var weightCall:Float = 0.0
        var weightFacetime:Float = 0.0
        var duration:Float = 0.0
        var lastCom:Float = 0.0
        var trust:Float = 0.0
        var trust0:Float = 0.0
        var contactName = ""
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="EEEE MMM dd yyyy"
        
        for rows in arrOfContactInfoFixed.enumerated(){
            
            if arrOfContactTrustFixed.isEmpty{
                
                if rows.element[0].contains("F"){
                    
                    //Calculate Trust for first creation
                    weightFacetime = facetimeWeight
                    weightCall = callWeight
                    duration = Float(rows.element[3].secondFromString)/3600
                    trust = weightFacetime*duration
                    
                    //Change String to Date
                    let date = dfmatter.date(from: rows.element[2])
                    let dateStamp:TimeInterval = date!.timeIntervalSince1970
                    let calcuableDate:Double = Double(dateStamp)/3600
                    
                    //Setting Contact Name
                    contactName = rows.element[1]
                    
                    //Save Trust Information
                    arrOfContactTrustFixed.append([contactName, String(trust), String(calcuableDate), String(weightFacetime), String(weightCall)])
                    
                    
                }else if !rows.element[0].contains("X"){
                   
                    weightCall = callWeight
                    weightFacetime = facetimeWeight
                    duration = Float(rows.element[3].secondFromString)/3600
                    trust = weightCall*duration
                    
                    //Change String to Date
                    let date = dfmatter.date(from: rows.element[2])
                    let dateStamp:TimeInterval = date!.timeIntervalSince1970
                    let calcuableDate:Double = Double(dateStamp)/3600
                    
                    //Setting Contact Name
                    contactName = rows.element[1]
                    
                    //Save Trust Information
                    arrOfContactTrustFixed.append([contactName, String(trust), String(calcuableDate), String(weightFacetime), String(weightCall)])
                    
                }
                
                
            }else {
                
                var updatedContact:Bool = false
                
                for row in arrOfContactTrustFixed.enumerated(){
                    
                    if row.element[0].contains(rows.element[1]){
                        updatedContact = true
                        
                        if rows.element[0].contains("F"){
                           
                            //Change String to Date
                            let date = dfmatter.date(from: rows.element[2])
                            let dateStamp:TimeInterval = date!.timeIntervalSince1970
                            let calcuableDate:Float = Float(dateStamp)/3600
                                    
                            //Defining Trust Variables
                            weightFacetime = Float(row.element[3]) ?? facetimeWeight
                            weightCall = callWeight
                            duration = Float(rows.element[3].secondFromString)/3600
                            lastCom = (Float(row.element[2]) ?? 0) - calcuableDate
                            trust0 = Float(row.element[1]) ?? 0
                            contactName = rows.element[1]
                                    
                            //Calculating Trust Value
                                if lastCom <= 168 {
                                        
                                    trust = (weightFacetime*duration - 0.1) + trust0
                                }else if lastCom > 168 && lastCom <= 336{
                                
                                    trust = (weightFacetime*duration - 0.2) + trust0
                                }else if lastCom > 336 && lastCom <= 504{
                                        
                                    trust = (weightFacetime*duration - 0.3) + trust0
                                        
                                }else {
                                        
                                    trust = (weightFacetime*duration - 0.4) + trust0
                                        
                                }
                
                                    //Save trust information
                                
                                arrOfContactTrustFixed[row.offset][0] = contactName
                                arrOfContactTrustFixed[row.offset][1] = String(trust)
                                arrOfContactTrustFixed[row.offset][2] = String(calcuableDate)
                                arrOfContactTrustFixed[row.offset][3] = String(weightFacetime)
                                arrOfContactTrustFixed[row.offset][4] = row.element[4]
                                                    
                            }else if !rows.element[0].contains("X"){
                                    
                                    //Change String to Date
                                let date = dfmatter.date(from: rows.element[2])
                                    let dateStamp:TimeInterval = date!.timeIntervalSince1970
                                    let calcuableDate:Float = Float(dateStamp)/3600
                                    
                                    //Defining Trust Variables
                                    weightCall = Float(row.element[4]) ?? callWeight
                                    weightFacetime = facetimeWeight
                                    duration = Float(rows.element[3].secondFromString)/3600
                                    lastCom = (Float(row.element[2]) ?? 0) - calcuableDate
                                    trust0 = Float(row.element[1]) ?? 0
                                    contactName = rows.element[1]
                                    
                                    //Calculating Trust Value
                                    if lastCom <= 168 {
                                        
                                        trust = (weightCall*duration - 0.1) + trust0
                                    }else if lastCom > 168 && lastCom <= 336{
                                        
                                        trust = (weightCall*duration - 0.2) + trust0
                                    }else if lastCom > 336 && lastCom <= 504{
                                        
                                        trust = (weightCall*duration - 0.3) + trust0
                                        
                                    }else {
                                        
                                        trust = (weightCall*duration - 0.4) + trust0
                                        
                                    }
                                    
                                    //Save trust information
                                    arrOfContactTrustFixed[row.offset][0] = contactName
                                    arrOfContactTrustFixed[row.offset][1] = String(trust)
                                    arrOfContactTrustFixed[row.offset][2] = String(calcuableDate)
                                    arrOfContactTrustFixed[row.offset][3] = row.element[3]
                                    arrOfContactTrustFixed[row.offset][4] = String(weightCall)
                                }
                        break
                    }else if !row.element[0].contains(rows.element[1]){
                        
                        updatedContact = false
                    }
                    
                }
                
                if updatedContact != true {
                    if rows.element[0].contains("F"){
                            
                            //Change String to Date
                        let date = dfmatter.date(from: rows.element[2])
                            let dateStamp:TimeInterval = date!.timeIntervalSince1970
                            let calcuableDate:Float = Float(dateStamp)/3600
                            
                            //Defining Trust Variables
                            weightFacetime = facetimeWeight
                            weightCall  = callWeight
                            duration = Float(rows.element[3].secondFromString)/3600
                            contactName = rows.element[1]
                            
                            //Calculating Trust Value
                            trust = weightFacetime*duration
                            
                            //Save trust information
                            arrOfContactTrustFixed.append([contactName, String(trust),String(calcuableDate), String(weightFacetime), String(weightCall)])
                                            
                    }else if !rows.element[0].contains("X"){
                            
                            //Change String to Date
                        let date = dfmatter.date(from: rows.element[2])
                            let dateStamp:TimeInterval = date!.timeIntervalSince1970
                            let calcuableDate:Double = Double(dateStamp)/3600
                            
                            //Defining Trust Variables
                            weightCall =  callWeight
                            weightFacetime = facetimeWeight
                        duration = Float(rows.element[3].secondFromString)/3600
                        contactName = rows.element[1]
                          
                        //Calculating Trust Value
                        trust = weightCall*duration
                            
                            //Save trust information
                        arrOfContactTrustFixed.append([contactName, String(trust), String(calcuableDate),  String(weightFacetime), String(weightCall)])
                    }
                }
            }
        }
            
            let sFileName = "TrustCalculationFixed.csv"
            let output = OutputStream.toMemory()
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let documentURL = URL(fileURLWithPath: documentDirectory).appendingPathComponent(sFileName)
            
            let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
            
            //Create header for CSV File
            csvWriter?.writeField("Contact")
            csvWriter?.writeField("Trust Value")
            csvWriter?.writeField("Calcuable Date")
            /*csvWriter?.writeField("Facetime")
            csvWriter?.writeField("Call")*/
            csvWriter?.writeField("Facetime Weight ")
            csvWriter?.writeField("Call Weight")
            csvWriter?.finishLine()
            
            for(elements) in arrOfContactTrustFixed.enumerated(){
                
                //Contact Name
                csvWriter?.writeField(elements.element[0])
                
                //Contact Trust Value
                csvWriter?.writeField(elements.element[1])
                
                //Caclcuable Date
                csvWriter?.writeField(elements.element[2])
            
                /*//Contact Type: Facetime
                csvWriter?.writeField(elements.element[3])
                
                //Contact Type Call
                csvWriter?.writeField(elements.element[4])*/
                
                //Facetime Weight
                csvWriter?.writeField(elements.element[3])
                
                //Call Weight
                csvWriter?.writeField(elements.element[4])
                csvWriter?.finishLine()
            }
         
            csvWriter?.closeStream()
            
            let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
            
            do{
              
                try buffer.write(to: documentURL)
            } catch{
                
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
        //cleanFile = cleanFile.replacingOccurrences(of: "\"", with: "")
        cleanFile = cleanFile.replacingOccurrences(of: ",,", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
}
