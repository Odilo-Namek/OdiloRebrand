//
//  ZipManager.swift
//  OdiloRebrand
//
//  Created by csoler on 18/3/25.
//

import Foundation

public class ZipManager {
    
    public static func unzipFile(at sourceURL: URL, to destinationURL: URL) throws {
        try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        task.arguments = ["-o", sourceURL.path, "-d", destinationURL.path]
        try task.run()
        task.waitUntilExit()
        
        if task.terminationStatus != 0 {
            throw NSError(domain: NSCocoaErrorDomain, code: Int(task.terminationStatus), userInfo: nil)
        }
    }
    
}
