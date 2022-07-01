//
//  Item.swift
//  TaskListRealm
//
//  Created by Alexandra on 30.06.2022.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
}
