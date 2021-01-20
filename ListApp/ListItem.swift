//
//  DataModel.swift
//  ListApp
//
//  Created by Austin Christensen on 1/20/21.
//

import Foundation

struct ListItem : Codable {
    var title: String
    var createdAt: Date
    var itemIdentifier: UUID
    
    func saveItem() {
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }
}
