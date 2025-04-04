//
//  Command.swift
//  OdiloRebrand
//
//  Created by csoler on 11/3/25.
//

import Foundation

public struct Command {
    
    @discardableResult public static func runCommand(_ command: String) -> String {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", command]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        
        var outputData = Data()
        let outputQueue = DispatchQueue(label: "com.output.queue")
        
        outputPipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            outputQueue.async {
                outputData.append(data)
                let text = String(data: data, encoding: .utf8) ?? ""
                print(text, terminator: "")
            }
        }
        
        errorPipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            let text = String(data: data, encoding: .utf8) ?? ""
        }
        
        task.launch()
        task.waitUntilExit()
        
        outputPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
        
        return String(data: outputData, encoding: .utf8) ?? ""
    }
    
}
