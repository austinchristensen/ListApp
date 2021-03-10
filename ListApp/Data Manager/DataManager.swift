//
//  DataManager.swift
//  ListApp
//
//  Created by Austin Christensen on 1/20/21.
//

import Foundation

public class DataManager {
    
    static private func getDirectoryURL(path: String? = nil) -> URL? {
        guard let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get directory URL")
            return nil
        }
        
        guard let pathToAppend = path else {
            return baseUrl
        }
        
        return baseUrl.appendingPathComponent(pathToAppend, isDirectory: false)
    }
    
    static func load <T: Decodable> (name: String, type: T.Type) -> T? {
        guard let url = getDirectoryURL(path: name) else { return nil }
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("No file at path: \(url.path)")
            return nil
        }
        
        guard let file = FileManager.default.contents(atPath: url.path) else {
            print("Could not find data for path: \(url.path)")
            return nil
        }
        
        do {
            let object = try JSONDecoder().decode(type, from: file)
            return object
        } catch {
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    static func loadAll <T: Decodable> (type: T.Type) -> [T]? {
        guard let path = getDirectoryURL()?.path else { return nil }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            
            var objects = [T]()
            
            files.forEach { file in
                guard let object = load(name: file, type: type) else { return }
                objects.append(object)
            }
            
            return objects
        } catch {
            print("Could not find any files in path: \(path)")
            return nil
        }
    }
    
    static func save <T: Encodable> (object: T, name: String) {
        guard let url = getDirectoryURL(path: name) else { return }
        
        do {
            let data = try JSONEncoder().encode(object)
            
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    static func delete (name: String) {
        guard let url = getDirectoryURL(path: name), FileManager.default.fileExists(atPath: url.path) else {
            print("Cannot delete, no file found")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            NSLog(error.localizedDescription)
        }
    }
}
