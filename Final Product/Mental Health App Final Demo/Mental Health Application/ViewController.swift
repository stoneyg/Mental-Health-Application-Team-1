//
//  ViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 9/22/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
// 

import UIKit
import UserNotifications
import UniformTypeIdentifiers


class ViewController: UIViewController, UIDocumentPickerDelegate {
    
    
    
    var firstContact = ""
    var secondContact = ""
    var thirdContact = ""
    var callWeight:Float = 0.0
    var facetimeWeight:Float = 0.0
    var blockedContact = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Asked for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
                })

        let content = UNMutableNotificationContent()
        content.title = "Go Check on yo' friend HONEY"
        content.subtitle = "Yo homie might be strugglin'"
        content.body = "No fo'real sista, DO IT"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
    }


    @IBAction func blockNrBtn(_ sender: Any) {
        print("Block btn clicked")
    }
    
    @IBAction func weightsBtn(_ sender: Any) {
        print("Weight btn clicked")
        
        
        
        
        
    }
    
    @IBAction func realBlockNum(_ sender: Any) {
        print("Real Block Nr clicked")
    
    }
    
    @IBAction func circleBtn(_ sender: Any) {
        print("See Circle btn clicked")
        
        var data = readDataFromCSV(fileName: "Contact Data", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        var arrOfContactInfo = [[String]]()
        var arrOfContactTrust = [[String]]()
        let blockThisContact = getBlockedContact()
        
        for rows in csvRows.enumerated(){
            
            if(rows.offset == csvRows.count-1){
                break
            }else {
                
                if rows.element[1] == blockedContact{
                    
                }else {
                    if rows.element[1] != "#VALUE!" || rows.element[1] == "" {
                        let typeOfCom = rows.element[0]
                        let name = rows.element[1]
                        let date = rows.element[2]
                        let duration = rows.element[3]
                        
                        arrOfContactInfo.append([typeOfCom, name, date, duration])
                    }
                    
                }
                
            }
        }
        
        //Defining Algorithm Variables
        var typeCall = 0.0
        var weightCall = 0.0
        var typeFacetime = 0.0
        var weightFacetime = 0.0
        var totalContacts = 0.0
        var duration = 0.0
        var lastCom:Double = 0.0
        var trust = 0.0
        var trust0 = 0.0
        var contactName = ""
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="EEEE MMM dd yyyy"
        
        
        //Calculating Trust Algorithm
        for rows in arrOfContactInfo.enumerated(){
            
            if arrOfContactTrust.isEmpty{
                
                if rows.element[0].contains("F"){
                    
                    //Calculate Trust for first creation
                    weightFacetime = 0.3
                    duration = Double(rows.element[3].secondFromString)/3600
                    trust = weightFacetime*duration
                    
                    //Change String to Date
                    let date = dfmatter.date(from: rows.element[2])
                    let dateStamp:TimeInterval = date!.timeIntervalSince1970
                    let calcuableDate:Double = Double(dateStamp)/3600
                    
                    //Setting Contact Name
                    contactName = rows.element[1]
                    
                    //Calculating Facetime Weight for next round
                    typeFacetime += 1
                    totalContacts = typeCall + typeFacetime
                    weightFacetime = typeFacetime/totalContacts
                    
                    //Save Trust Information
                    arrOfContactTrust.append([contactName, String(trust), String(calcuableDate), String(typeFacetime), String(typeCall), String(weightFacetime), String(weightCall)])
                    
                    
                }else if !rows.element[0].contains("X"){
                   
                    weightCall = 0.3
                    duration = Double(rows.element[3].secondFromString)/3600
                    trust = weightCall*duration
                    
                    //Change String to Date
                    let date = dfmatter.date(from: rows.element[2])
                    let dateStamp:TimeInterval = date!.timeIntervalSince1970
                    let calcuableDate:Double = Double(dateStamp)/3600
                    
                    //Setting Contact Name
                    contactName = rows.element[1]
                    
                    //Calculating Call Weight for next round
                    typeCall += 1
                    totalContacts = typeCall + typeFacetime
                    weightCall = typeCall/totalContacts
                    
                    //Save Trust Information
                    arrOfContactTrust.append([contactName, String(trust), String(calcuableDate), String(typeFacetime), String(typeCall), String(weightFacetime), String(weightCall)])
                    
                }
                
                
            }else {
                
                var updatedContact:Bool = false
                for row in arrOfContactTrust.enumerated(){
                   
                    if row.element[0].contains(rows.element[1]){
                        updatedContact = true
                        if rows.element[0].contains("F"){
                           
                            //Change String to Date
                            let date = dfmatter.date(from: rows.element[2])
                            let dateStamp:TimeInterval = date!.timeIntervalSince1970
                            let calcuableDate:Double = Double(dateStamp)/3600
                                    
                            //Defining Trust Variables
                            weightFacetime = Double(row.element[5]) ?? 0.3
                            duration = Double(rows.element[3].secondFromString)/3600
                            lastCom = (Double(row.element[2]) ?? 0) - calcuableDate
                            trust0 = Double(row.element[1]) ?? 0
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
                                    
                                //Calculating Call Weight for next round
                                typeFacetime = (Double(row.element[3]) ?? 0) + 1
                                typeCall = Double(row.element[4]) ?? 0
                                totalContacts = typeFacetime + typeCall
                                weightFacetime = typeFacetime / totalContacts
                                    
                                    //Save trust information
                                
                            arrOfContactTrust[row.offset][0] = contactName
                                arrOfContactTrust[row.offset][1] = String(trust)
                                arrOfContactTrust[row.offset][2] = String(calcuableDate)
                                arrOfContactTrust[row.offset][3] = String(typeFacetime)
                                arrOfContactTrust[row.offset][4] = String(typeCall)
                                arrOfContactTrust[row.offset][5] = String(weightFacetime)
                                arrOfContactTrust[row.offset][6] = row.element[6]
                                                    
                            }else if !rows.element[0].contains("X"){
                                    
                                    //Change String to Date
                                let date = dfmatter.date(from: rows.element[2])
                                    let dateStamp:TimeInterval = date!.timeIntervalSince1970
                                    let calcuableDate:Double = Double(dateStamp)/3600
                                    
                                    //Defining Trust Variables
                                    weightCall = Double(row.element[6]) ?? 0.3
                                    duration = Double(rows.element[3].secondFromString)/3600
                                    lastCom = (Double(row.element[2]) ?? 0) - calcuableDate
                                    trust0 = Double(row.element[1]) ?? 0
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
                                    
                                    //Calculating Call Weight for next round
                                    typeCall = (Double(row.element[4]) ?? 0) + 1
                                    typeFacetime = Double(row.element[3]) ?? 0
                                    totalContacts = typeFacetime + typeCall
                                    weightCall = typeCall / totalContacts
                                    
                                    //Save trust information
                                
                                
                                    arrOfContactTrust[row.offset][0] = contactName
                                    arrOfContactTrust[row.offset][1] = String(trust)
                                    arrOfContactTrust[row.offset][2] = String(calcuableDate)
                                    arrOfContactTrust[row.offset][3] = String(typeFacetime)
                                    arrOfContactTrust[row.offset][4] = String(typeCall)
                                    arrOfContactTrust[row.offset][5] = row.element[5]
                                    arrOfContactTrust[row.offset][6] = String(weightCall)
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
                            let calcuableDate:Double = Double(dateStamp)/3600
                            
                            //Defining Trust Variables
                            weightFacetime = 0.3
                            duration = Double(rows.element[3].secondFromString)/3600
                            contactName = rows.element[1]
                            
                            //Calculating Trust Value
                            trust = weightFacetime*duration
                            
                            //Calculating Call Weight for next round
                            typeFacetime += 1
                            typeCall = 0
                            totalContacts = typeFacetime + typeCall
                            weightFacetime = typeFacetime / totalContacts
                            
                            //Save trust information
                            arrOfContactTrust.append([contactName, String(trust),String(calcuableDate), String(typeFacetime), String(typeCall), String(weightFacetime), String(weightCall)])
                                            
                    }else if !rows.element[0].contains("X"){
                            
                            //Change String to Date
                        let date = dfmatter.date(from: rows.element[2])
                            let dateStamp:TimeInterval = date!.timeIntervalSince1970
                            let calcuableDate:Double = Double(dateStamp)/3600
                            
                            //Defining Trust Variables
                            weightCall =  0.3
                        duration = Double(rows.element[3].secondFromString)/3600
                        contactName = rows.element[1]
                          
                        //Calculating Trust Value
                        trust = weightCall*duration
                            
                          
                            //Calculating Call Weight for next round
                            typeCall += 1
                            typeFacetime = 0
                            totalContacts = typeFacetime + typeCall
                            weightCall = typeCall / totalContacts
                            
                            //Save trust information
                        arrOfContactTrust.append([contactName, String(trust), String(calcuableDate), String(typeFacetime), String(typeCall), String(weightFacetime), String(weightCall)])
                    }
                }
            }
        }
        
        let sFileName = "TrustCalculation.csv"
        let output = OutputStream.toMemory()
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let documentURL = URL(fileURLWithPath: documentDirectory).appendingPathComponent(sFileName)
        
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
        //Create header for CSV File
        csvWriter?.writeField("Contact")
        csvWriter?.writeField("Trust Value")
        csvWriter?.writeField("Calcuable Date")
        csvWriter?.writeField("Facetime")
        csvWriter?.writeField("Call")
        csvWriter?.writeField("Facetime Weight ")
        csvWriter?.writeField("Call Weight")
        csvWriter?.finishLine()
        
        for(elements) in arrOfContactTrust.enumerated(){
            
            //Contact Name
            csvWriter?.writeField(elements.element[0])
            
            //Contact Trust Value
            csvWriter?.writeField(elements.element[1])
            
            //Caclcuable Weight
            csvWriter?.writeField(elements.element[2])
        
            //Contact Type: Facetime
            csvWriter?.writeField(elements.element[3])
            
            //Contact Type Call
            csvWriter?.writeField(elements.element[4])
            
            //Facetime Weight
            csvWriter?.writeField(elements.element[5])
            
            //Call Weight
            csvWriter?.writeField(elements.element[6])
            csvWriter?.finishLine()
        }
     
        csvWriter?.closeStream()
        
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        
        do{
          
            try buffer.write(to: documentURL)
        } catch{
            
        }
        
        
        let supportedFiles : [UTType] = [UTType.data]
        
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedFiles, asCopy: true)
        controller.delegate = self
        controller.allowsMultipleSelection = false
        
        present(controller, animated: true, completion: nil)

    }
    
    func documentPicker(_ controller:UIDocumentPickerViewController, didPickDocumentAt url:URL){
        
        print("A file was selected")
        var sortContacts = [[String]]()
        
        let rows = NSArray(contentsOfCSVURL: url, options: CHCSVParserOptions.sanitizesFields)!
        
        for row in rows {
            
            sortContacts.append(row as! [String])
            
            //print(row)
        }
        
        var first = 0.0
        var second = 0.0
        var third = 0.0
        var firstContactChange = ""
        var secondContactChange = ""
        var thirdContactChange = ""
        
        for sorted in sortContacts.enumerated() {
            
            if(sorted.element[0] != "Contact"){
                let trustVal = Double(sorted.element[1])
                
                
                
                if trustVal ?? 0 > first {
                    first = trustVal!
                    thirdContactChange = secondContactChange
                    secondContactChange = firstContactChange
                    firstContactChange = sorted.element[0]
                }else if trustVal ?? 0 >= second && trustVal! <= first{
                    second = trustVal!
                    thirdContactChange = secondContactChange
                    secondContactChange = sorted.element[0]
                }else if trustVal ?? 0 >= third && trustVal ?? 0 < second {
                    third = trustVal!
                    thirdContactChange = sorted.element[0]
                }
            }
        }
        
        setFirstContact(firstSet: firstContactChange)
        setSecondContact(secondSet: secondContactChange)
        setThirdContact(thirdSet: thirdContactChange)
//        
        
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
    
    
    func setFirstContact(firstSet:String) {
        firstContact = firstSet
    }
    func setSecondContact(secondSet:String){
        secondContact = secondSet
    }
    func setThirdContact(thirdSet:String){
        thirdContact = thirdSet
    }
    func getFirstContact() -> String {
        return firstContact
    }
    func getSecondContact() -> String {
        return secondContact
    }
    func getThirdContact() -> String{
        return thirdContact
    }
    func setBlockedContact(contact:String){
        blockedContact = contact
    }
    func getBlockedContact() -> String{
        return blockedContact
    }
}

extension String{
    
    var integer: Int {
            return Int(self) ?? 0
    }

    var secondFromString : Int{
        let components: Array = self.components(separatedBy: ":")
        
        if components.count == 2{
            let minutes = components[0].integer
            let seconds = components[1].integer
            
            return Int((minutes * 60) + seconds)
            
            
        }else {
            let hours = components[0].integer
            let minutes = components[1].integer
            let seconds = components[2].integer
            return Int((hours * 60 * 60) + (minutes * 60) + seconds)
        }
        
    }
}
