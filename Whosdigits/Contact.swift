//
//  Contact.swift
//  Whosdigits
//
//  Created by Aldo Lugo on 12/31/15.
//  Copyright © 2015 Aldo Lugo. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
    
     dynamic var id = ""
     dynamic var name = ""
     dynamic var location = ""
     dynamic var tags = ""
     dynamic var phone = ""
    
    
// Specify properties to ignore (Realm won't persist the dse)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
