//
//  Item.swift
//  Todoey
//
//  Created by Akuoma Cyril-Obi on 04/08/2018.
//  Copyright © 2018 Akuoma Cyril-Obi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    
    @objc dynamic var done : Bool = false
    
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")     // reverse relationship
}
