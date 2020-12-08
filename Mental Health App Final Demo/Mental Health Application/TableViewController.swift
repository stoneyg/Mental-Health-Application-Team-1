//
//  TableViewController.swift
//  Mental Health Application
//
//  Created by Garðar Benediktsson on 10/28/20.
//  Copyright © 2020 Gardar Benediktsson. All rights reserved.
//

import UIKit
import Contacts

class TableViewController: UITableViewController {

    // Create an array to store the contact info
    var contacts = [FetchedContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchContacts()
    }
    
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
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                // Go through each contact and store the data with the FetchedContact "object" to store in an array
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        print(contact.givenName)
                        self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? ""))
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
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Only one section in the table view
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of rows is equal to number of items in the contacts array
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Creates a a new/reusable cell for each contact
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Takes the contact info and stores it to the respective labels in the cell
        cell.textLabel?.text = contacts[indexPath.row].firstName + " " + contacts[indexPath.row].lastName
        cell.detailTextLabel?.text = contacts[indexPath.row].phoneNumber
        
        return cell
    }

}
