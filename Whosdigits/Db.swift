//
//  Db.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 10/31/15.
//  Copyright (c) 2015 Aldo Lugo. All rights reserved.
//

import Foundation
import SQLite

class Db {
    var databasePath: String?
    var database: Connection?
    var contactsArray: [String]
    var contactsTable: Table?
    
    let id = Expression<Int64>("id")
    let name = Expression<String?>("name")
    let phone = Expression<String>("phone")
    let location = Expression<String>("location")
    let tags = Expression<String>("tags")
    
    
    enum DatabaseOperatinoError: ErrorType{
        case ErrorSavingContact
        case ErrorConnectingToDatabase
    }
    
    init(){
        self.databasePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        self.contactsArray = ["Aldo", "Mark"]
    }
    
    func connectToDatabaseAndCreateTable(){
        do {
            self.database = try Connection("\(self.databasePath!)/db.sqlite3")
            self.contactsTable = Table("contacts_table")
            try! self.database!.run(self.contactsTable!.create(ifNotExists: true) { t in
                     t.column(self.id, primaryKey: .Autoincrement)
                     t.column(self.name)
//                     t.column(self.phone)
//                     t.column(self.location)
//                     t.column(self.tags)
            })
            //try! self.database!.run(self.contactsTable!.insert(name <- "Aldo"))
            //self.printContacts()
        } catch {
            print("Error with connection to Database")
        }
    }
    
  

    func saveContactToDatabase(){
        do{
             try self.database!.run(self.contactsTable!.insert(name <- "Aldo"))
        } catch {
            print("Error saving new contact")
        }
    }
    
    
    
    
    
    func printContacts(){
        for contact in self.database!.prepare(self.contactsTable!){
            print("Id: \(contact[id]) Name: \(contact[name]!)")
        }
    }

    
//    func getAllContacts() -> [(name: String, phone: String, location: String, tags: String)]{
//        var returnArray:[(name: String, phone: String, location: String, tags: String)] = []
//        
//        for contact in self.database!.prepare("contacts"){
//             returnArray.append(name: contact[self.name])
//        }
//        
////        for contact in self.database["contacts"]{
////            returnArray.append(name: contact[Expression<String?>("name")]!, phone: contact[Expression<String?>("phone")]!, location: contact[Expression<String?>("location")]!, tags: contact[Expression<String?>("tags")]!)
////        }
//        return returnArray
//    }
    
}