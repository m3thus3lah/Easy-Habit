//
//  LocalFilesManager.swift
//  Easy Habit
//
//  Created by BJIT on 23/1/22.
//

import Foundation
import UIKit

final class LocalFileManager {
    
    static let shared = LocalFileManager()
    let folderName = "EasyHabit_Images"
    
    private init() {
        createFolderIfNeeded()
    }
    
    static var documentDirectoryURL: URL {
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL
    }
    
    func createFolderIfNeeded() {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("Success creating folder.")
            } catch let error {
                print("Error creating folder. \(error)")
            }
        }
    }
    
    func deleteFolder() {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Success deleting folder.")
        } catch let error {
            print("Error deleting folder. \(error)")
        }
    }
    
    func saveImage(image: UIImage) -> String? {
        
        let uniqueFileName = Utility.uniqueFileNameWithExtention(fileExtension: "jpg")
        
        guard
            let data = image.jpegData(compressionQuality: 1.0),
            let path = getPathForImage(name: uniqueFileName) else {
            return "Error getting data."
        }
        
        do {
            try data.write(to: path)
            print(path)
            print("Success saving!")
            return uniqueFileName
        } catch let error {
            print("Error saving. \(error)")
            return nil
        }
        
    }
    
    func getImage(named: String) -> UIImage? {
        guard
            let path = getPathForImage(name: named)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("Error getting path.")
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    func deleteImage(name: String) -> String {
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            return "Error getting path."
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return "Sucessfully deleted."
        } catch let error {
            return "Error deleting image. \(error)"
        }
        
    }
    
    func getPathForImage(name: String) -> URL? {
        
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .appendingPathComponent("\(name)") else {
            print("Error getting path.")
            return nil
        }
        
        return path
    }
    
}
