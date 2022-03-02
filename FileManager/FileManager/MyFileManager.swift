//
//  MyFileManager.swift
//  FileManager
//
//  Created by Dmitrii Lobanov on 18.02.2022.
//

import Foundation

class MyFileManager {
    
    static let shared = MyFileManager()
    static var filesListArray: [String] = []
    private let fileManager = FileManager.default
    
    // метод получения массива названий файлов в директории
    func getListFiles() {
        
        MyFileManager.filesListArray = []
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let contents = try? fileManager.contentsOfDirectory(atPath: url.path)
        
        guard let contents = contents else { return }
        
        for file in contents {
            MyFileManager.filesListArray.append(file)
        }
    }
    
    
    // метод создания файла
    func createFile(data: Data) {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let userDefaults = UserDefaults.standard
        
        var number: Int
        
        if userDefaults.bool(forKey: "isStarted") == true {
            number = userDefaults.object(forKey: "imageNumber") as! Int
        } else {
            number = 1
            userDefaults.set(number, forKey: "imageNumber")
            userDefaults.set(true, forKey: "isStarted")
        }
        
        let fileUrl = url.appendingPathComponent("image\(number).jpg")
        
        fileManager.createFile(atPath: fileUrl.path, contents: data, attributes: nil)
        
        number += 1
        
        userDefaults.set(number, forKey: "imageNumber")
    }
    
    // метод удаления файла
    func removeFile(name: String) {
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name) else { return }
        
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print(error)
        }
    }
}
