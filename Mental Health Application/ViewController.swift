//
//  ViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 9/22/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
// 

import UIKit
import UniformTypeIdentifiers

// JSON file structure
//The entire json is an array of reactions
struct LikesData: Codable {
    var reactions: [ReactionElement]
}
struct ReactionElement: Codable {
    var timestamp: Int
    var data: [Datum]
    var title: String
}
struct Datum: Codable {
    var reaction: DatumReaction
}
struct DatumReaction: Codable {
    var reaction, actor: String
}

// JSON file structure
// The entire JSON is an array of comments
struct RepliesData: Codable {
    var comments: [CommentElement]
}
struct CommentElement: Codable {
    var timestamp: Int
    var data: [CDatum]?
    var title: String
}
struct CDatum: Codable {
    var comment: CommentArray
}
struct CommentArray: Codable {
    //As far as I can tell this timestamp is the same as the one above
    var timestamp: Int
    var comment: String?
    var author: String
}

var maxTrust = 100.0
var minCompressionRatio = 0.0
var maxCompressionRatio = 10.0
var arrOfContactInteractionList = [[String]]()

class ViewController: UIViewController {

    var contactArray:[Dictionary<String,AnyObject>] = Array()
        
        //The ReactionElement variable
            var reaction = [ReactionElement]()
        // The comment variable (not the individual array, this stores name of original poster)
        var comment = [CommentElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    
    @IBAction func accountLinkBtn(_ sender: Any) {
        print("AccountLink btn clicked")
    }
    
    
    @IBAction func blockNrBtn(_ sender: Any) {
        print("Block btn clicked")
    }
    
    @IBAction func weightsBtn(_ sender: Any) {
        print("Weight btn clicked")
    }
    
    
    @IBAction func circleBtn(_ sender: Any) {
        print("See Circle btn clicked")
        
        func readLocalFile(forName name: String) -> Data? {
            do {
                if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                    let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8){
                    return jsonData
                }
            } catch {
                print(error)
            }
                return nil
            }
        
        //Parsing the json file
        func parse(jsonData: Data) {
            var indexCount = 0
            do {
                let decodedData = try JSONDecoder().decode(LikesData.self, from: jsonData)
                reaction = decodedData.reactions
                var interactionValid:Bool = false
                var indexCount = 0
                for reaction in reaction{
                    let timestamp = reaction.timestamp
                    //print(timestamp)
                    if(reaction.title.contains("likes")) {
                        let fullTitle = reaction.title.components(separatedBy: "likes ")
                        let reactionName = fullTitle[1].components(separatedBy: "'s")
                        let finalName = reactionName[0]
                        interactionValid = true
                        readOrWrite(finalName: finalName, interactionValid: interactionValid, indexCount: indexCount)
                            indexCount = indexCount + 1
                           // print(finalName)
                    } else if (reaction.title.contains("liked")){
                        let fullTitle = reaction.title.components(separatedBy: "liked ")
                        let reactionName = fullTitle[1].components(separatedBy: "'s")
                        let finalName = reactionName[0]
                        interactionValid = true
                        readOrWrite(finalName: finalName, interactionValid: interactionValid, indexCount: indexCount)
                        indexCount = indexCount + 1
                        //print(finalName)
                    } else {
                            let fullTitle = reaction.title.components(separatedBy: "reacted to ")
                            let reactionName = fullTitle[1].components(separatedBy: "'s")
                            let finalName = reactionName[0]
                            interactionValid = true
                            readOrWrite(finalName: finalName, interactionValid: interactionValid, indexCount: indexCount)
                            indexCount = indexCount + 1
                            //print(finalName)
                    }
                    //print("**********")
                }
                    
            } catch {
                //print("Decoding error")
            }
        }
        
        func parseComments(jsonData: Data) {
            print("Started comments function\n\n")
            var interactionValid:Bool = false
            var count = 0
            do {
                // Decode the JSON data and store it in the array defined at beginning of class
                let decodedData = try JSONDecoder().decode(RepliesData.self, from: jsonData)
                
                comment = decodedData.comments
                // Iterate through every comment in the array and extract the timestamp and poster name
                for comment in comment{
                    let timestamp = comment.timestamp
                    //print(Date(timeIntervalSince1970: Double(timestamp)))
                    // If it was just a comment, then the string will reflect that as seen below
                    if(comment.title.contains("commented"))
                    {
                        interactionValid = true
                        let fullTitle = comment.title.components(separatedBy: "commented on ")
                        let replyName = fullTitle[1].components(separatedBy: "'s")
                        let finalName = replyName[0]
                        //print(finalName)
                        readOrWrite(finalName:finalName, interactionValid:interactionValid, indexCount:count)
                        count += 1
                    // If not, then it was a reply to another comment
                    } else {
                        interactionValid = true
                        let fullTitle = comment.title.components(separatedBy: "replied to ")
                        let replyName = fullTitle[1].components(separatedBy: "'s")
                        let finalName = replyName[0]
                        //print(finalName)
                        readOrWrite(finalName:finalName, interactionValid:interactionValid, indexCount:count)
                        count += 1
                    }
                    //print("**********")
                }
                print("All done")
            } catch {
                print(error)
            }
        }
        
        // Do any additional setup after loading the view.
        if let localData = readLocalFile(forName: "data"){
            parse(jsonData: localData)
        }
        // Scan Facebook comments
        if let localData = readLocalFile(forName: "comments"){
            parseComments(jsonData: localData)
        }
        print(sortAlgorithm(arrOfContactList: arrOfContactInteractionList))
        
        let defaults = UserDefaults.standard
        defaults.set(arrOfContactInteractionList, forKey: "ContactList")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "circle" {
            
            let destinationController = segue.destination as! ShowCircleViewController
            destinationController.algList = sortAlgorithm(arrOfContactList: arrOfContactInteractionList)
        }
    }
    
    
}

func readOrWrite(finalName:String, interactionValid:Bool, indexCount:Int) {
    
    var arrOfContactInteractions = [[String]]()
    var name:String = ""
    var interaction:Int = 0
    var trustVal:String = ""
            
    if indexCount == 0{
        //print("Print second time of name: ", finalName, "\n")
        name = finalName
        if interactionValid == true{
            interaction = interaction + 1
        }
        
        trustVal = "0"
        
        let trustValCalc = algorithmTrustCalculation(currentTrust: Double(trustVal) ?? 0.0)
        arrOfContactInteractionList.append([name, String(interaction), String(trustValCalc)])
    
    } else{
    
        //print("exectured start of rows\n")
                
        var updatedContact:Bool = false
        var countForLoop = 0
                    
        for row in arrOfContactInteractionList.enumerated(){
                    
            if row.element[0].contains(finalName){
                updatedContact = true
                trustVal = row.element[2]
                           
                let trustValCalc = algorithmTrustCalculation(currentTrust: Double(trustVal) ?? 0.0)
                           
                if interactionValid == true{
                    interaction = Int(row.element[1]) ?? 0 + 1
                }
                            
                arrOfContactInteractionList[row.offset][0] = finalName
                arrOfContactInteractionList[row.offset][1] = String(interaction)
                arrOfContactInteractionList[row.offset][2] = String(trustValCalc)
                        
                break
            }else {
                            
                updatedContact = false
                            
            }
                countForLoop = countForLoop + 1
        }
                    
        if updatedContact != true{
                        
            name = finalName
            //print("Last print of name: ", finalName, "\n")
                        
            if interactionValid == true{
                interaction = interaction + 1
            }
                        
            trustVal = "0"
                        
            let trustValCalc = algorithmTrustCalculation(currentTrust: Double(trustVal) ?? 0.0)
                arrOfContactInteractionList.append([name, String(interaction), String(trustValCalc)])
        }
    }
}
    
func algorithmCompression(maxTrust:Double, maxCompressionRatio:Double, minCompressionRatio:Double) -> Double{

    var compressionRatio:Double = (maxCompressionRatio - minCompressionRatio)/maxTrust
    
    return compressionRatio
}

func algorithmTrustCalculation(currentTrust:Double) -> Double{
    
    //print("Current Trust: ", currentTrust, "\n")
    var compressionRatio = algorithmCompression(maxTrust: maxTrust, maxCompressionRatio: maxCompressionRatio, minCompressionRatio: minCompressionRatio)
    var trustVal = currentTrust
    var deltaTrust = 0.0
    var minWaning = 0.0
    var waningRate = 0.0
    
    deltaTrust = maxCompressionRatio - (compressionRatio*currentTrust)
    trustVal = (trustVal + deltaTrust)
    
    /*
     
     trustVal = (trustVal) - minWaning*((1+waningRate)-((trustVal)/(maxTrust)))
     
     //I am not sure what t-1 value is suppose to be. I also figured out for the demo why the mnumbers were all the same...the previous trust value was not actually being used throughout the process.
     */
    
    //print("New Trust: ", trustVal, "\n")
    return trustVal
}

func createInteractionCSV(from recArray:[Dictionary<String, AnyObject>]){

    var titleString = "\("Contact Name"), \("Facebook Interaction Count"), \("Facebook Trust Value")\n\n"
    
    for dct in recArray{
        
        titleString = titleString.appending("\(String(describing: dct["Name"]!)), \(String(describing: dct["Interaction"]!)), \(String(describing: dct["Trust"]!))\n")
    }

    let fileManager = FileManager.default
    do{
        
        let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
        let fileURL = path.appendingPathComponent("Contact Interaction List.csv")
        try titleString.write(to: fileURL, atomically: true, encoding: .utf8)
    } catch{
        print("Error Occured")
    }
}

func sortAlgorithm(arrOfContactList:[[String]]) -> [[String]]{
    print("Sort function did run: \n")
    print("Number of contacts in contact list: ", arrOfContactList.count, "\n")
    var sortedContactList = arrOfContactList
    let last_position = arrOfContactList.count - 1
    var swap = true
    while swap == true {
        swap = false
        for i in 0..<last_position {
            if arrOfContactList[i][2] < arrOfContactList[i + 1][2] {
                let temp = arrOfContactList[i]
                sortedContactList[i] = sortedContactList[i+1]
                sortedContactList[i+1] = temp
            }
        }
        swap = false
    }
    //print(sortedContactList)
    return sortedContactList
    
}


