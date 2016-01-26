//
//  RealmDatabase.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 12/31/15.
//  Copyright © 2015 Aldo Lugo. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDatabase {
    
    enum RealmErrors: ErrorType{
        case ErrorAddingContact
        case ErrorFetchingContacts
    }
    
    var contactsRealm:Realm!

    func addNewContact(){
        let newContact = Contact()
        newContact.name = "Joe"
        newContact.id = "1"
        newContact.location = "Katy Trail"
        newContact.tags = "Nothing"
        newContact.phone = "332-777-7777"
        
        do{
            self.contactsRealm = try Realm()
        } catch let error {
            print(error)
        }
        
        do{
            try self.contactsRealm.write { () -> Void in
                self.contactsRealm.add(newContact)
            }
        } catch let error{
            print(error)
            print("Error adding new contact to realm")
        }

    }
    
    func getAllContacts(){
        let results = self.contactsRealm.objects(Contact)
        for contact in results{
            print("Name: \(contact.name)")
        }
    }

}
