//
//  Category.swift
//  Todoey
//
//  Created by Akuoma Cyril-Obi on 04/08/2018.
//  Copyright © 2018 Akuoma Cyril-Obi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    
    let items = List<Item>()                                    //forward relationship
}
