//
//  StudentController.swift
//  Students
//
//  Created by Stephanie Bowles on 5/21/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation


class StudentController {
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else {return nil}
        return URL(fileURLWithPath: filePath)
    }
    
    func loadFromPersistentStore(completion: @escaping ([Student]?, Error?) -> Void ) {
        let bgQueue = DispatchQueue(label: "students", attributes: .concurrent)
        
        bgQueue.async {
            let fm = FileManager.default
            guard let url = self.persistentFileURL,
                fm.fileExists(atPath: url.path) else {return}
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let students = try decoder.decode([Student].self, from: data)
                completion(students, nil)
            } catch {
                print("Error loading students data: \(error)")
                completion(nil, error)
            }
        }
    }
}
