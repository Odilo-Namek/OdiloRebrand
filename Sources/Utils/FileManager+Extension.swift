//
//  FileManager+Extension.swift
//  OdiloRebrand
//
//  Created by csoler on 21/3/25.
//

import Foundation

extension FileManager {
    
    func removeFiles(containing keyword: String, in directory: URL) throws {
        let contents = try contentsOfDirectory(atPath: directory.path)
        for file in contents where file.lowercased().contains(keyword) {
            let filePath = directory.appendingPathComponent(file)
            try removeItem(at: filePath)
        }
    }
    
}
