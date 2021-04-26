//
//  ViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 9/22/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
// 

import UIKit
import UniformTypeIdentifiers
import Contacts

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
//var testValueArray = ["Gabrielle Stoney", "lsadkjf", "lskdjflaksdfj"]

// Dictionary to serve as the contact list
var contactDict: [String: Double] = [


    "Gabrielle Stoney": 0.0,

    "Seth Stoney": 0.0,

    "Simone Stoney": 0.0,

    "Colt Atwell": 0.0,

    "Lauren Atwell": 0.0,

    "Addison Salimi": 0.0,

    "Aiden Salimi": 0.0,

    "Joanne Salimi": 0.0,

    "Lena Azar": 0.0,

    "Nicole Gargano": 0.0,

    "Valerie Stoney": 0.0,

    "Harrison Dinius": 0.0,

    "Christen Atwell": 0.0,

    "James Atwell": 0.0,

    "Lily Smith": 0.0,

    "Aaron Feltcher": 0.0,

    "Jasmin Gomez": 0.0,

    "Anjali James": 0.0,

    "Kayla Rickey": 0.0,

    "Delina Biniam": 0.0,

]

class ViewController: UIViewController {
    var testValueArray = [""]
    
    var contactArray:[Dictionary<String,AnyObject>] = Array()
        
        //The ReactionElement variable
            var reaction = [ReactionElement]()
        // The comment variable (not the individual array, this stores name of original poster)
        var comment = [CommentElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // This function requests access to user contacts, then takes and stores necessary contact data in an array
    private func fetchContacts() {
        print("Attempting Contact Fetch")
                
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
        if let error = error {
            // The app failed to request access to contacts
            print("Acess Request Failed", error)
            return
        }
                    
        if granted {
            // User allowed app to access contacts, moving forward
            print("Access Granted")
                        
            // Use keys to identify what info the pull
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                        
            // Go through each contact and store the data with the FetchedContact "object" to store in an array
            do {
                try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                contactDict.updateValue(0.0, forKey: contact.givenName + " " + contact.familyName)
                //print(self.contactDict)
                })
            } catch let error {
                // Could not read one/all of the contacts
                print("Failed Contact Enumeration", error)
                }
            } else {
                // User denied the app permission to contacts
                print("Access Denied")
            }
        }
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
                        searchContacts(finalName:finalName, interactionValid:interactionValid, indexCount:indexCount)
                            indexCount = indexCount + 1
                           // print(finalName)
                    } else if (reaction.title.contains("liked")){
                        let fullTitle = reaction.title.components(separatedBy: "liked ")
                        let reactionName = fullTitle[1].components(separatedBy: "'s")
                        let finalName = reactionName[0]
                        interactionValid = true
                        searchContacts(finalName:finalName, interactionValid:interactionValid, indexCount:indexCount)
                        indexCount = indexCount + 1
                        //print(finalName)
                    } else {
                            let fullTitle = reaction.title.components(separatedBy: "reacted to ")
                            let reactionName = fullTitle[1].components(separatedBy: "'s")
                            let finalName = reactionName[0]
                            interactionValid = true
                        searchContacts(finalName:finalName, interactionValid:interactionValid, indexCount:indexCount)
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
                        searchContacts(finalName:finalName, interactionValid:interactionValid, indexCount:count)
                        count += 1
                    // If not, then it was a reply to another comment
                    } else {
                        interactionValid = true
                        let fullTitle = comment.title.components(separatedBy: "replied to ")
                        let replyName = fullTitle[1].components(separatedBy: "'s")
                        let finalName = replyName[0]
                        //print(finalName)
                        searchContacts(finalName:finalName, interactionValid:interactionValid, indexCount:count)
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
        if let localData = readLocalFile(forName: "posts_and_comments"){
            parse(jsonData: localData)
            
        }
        // Scan Facebook comments
        if let localData = readLocalFile(forName: "fake_comments"){
            parseComments(jsonData: localData)
        }
        //print(sortAlgorithm(arrOfContactList: arrOfContactInteractionList))
        
        let defaults = UserDefaults.standard
        defaults.set(arrOfContactInteractionList, forKey: "ContactList")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        for contact in testValueArray {
            if (contactDict[contact] != nil) {
                contactDict.removeValue(forKey: contact)
            }
        }
        if segue.identifier == "circle" {
            
            let destinationController = segue.destination as! ShowCircleViewController
            //destinationController.algList = sortAlgorithm(arrOfContactList: arrOfContactInteractionList)
            destinationController.algList = contactDict
        }
    }
    
    
}

func searchContacts(finalName:String, interactionValid:Bool, indexCount:Int){
    print("Final name: " + finalName + "\n")
    if contactDict[finalName] != nil{
        print("Final name was found as key\n")
        let trustVal = contactDict[finalName] ?? 0.0
        let trustValCalc = algorithmTrustCalculation(currentTrust: trustVal )
        contactDict[finalName] = trustValCalc
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
    
    //trustVal = (trustVal) - minWaning*((1+waningRate)-((trustVal)/(maxTrust)))
    return trustVal
}



