//
//  Category.swift
//  TaskListRealm
//
//  Created by Alexandra on 30.06.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String?
    @objc dynamic var dateCreated: Date = Date()
    var tasks = List<Task>()
}
