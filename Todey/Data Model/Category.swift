//
//  Category.swift
//  Todey
//
//  Created by Prince Bharti on 28/07/18.
//  Copyright © 2018 Prince Bharti. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var cellColor : String?
    let items = List<Item>()
}
