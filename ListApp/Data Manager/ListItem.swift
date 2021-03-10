//
//  DataModel.swift
//  ListApp
//
//  Created by Austin Christensen on 1/20/21.
//

import Foundation

struct ListItem : Codable {
    var title: String
    var isCompleted: Bool = false
    var itemIdentifier: UUID
    var index: Int
    var detailItems: [String]?
    
    func saveItem() {
        DataManager.save(object: self, name: itemIdentifier.uuidString)
    }
    
    func deleteItem() {
        DataManager.delete(name: itemIdentifier.uuidString)
    }
}
