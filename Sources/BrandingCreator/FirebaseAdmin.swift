//
//  BrandingCreator.swift
//  OdiloRebrand
//
//  Created by csoler on 28/2/25.
//

import Foundation
import ArgumentParser
import FirebaseAdmin
import Utils

struct FirebaseAdmin: ParsableCommand {
    
    static let configuration = CommandConfiguration(abstract: "Manage firebase apps.", subcommands: [FirebaseAdmin.Create.self,
                                                                                                     FirebaseAdmin.Delete.self])
    
    // MARK: Subcommands
    
    struct Create: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Create a new Firebase project.")
        
        @Argument(help: "Name for the new firebase app.")
        var appName: String
        
        @Option(name: [.short, .customLong("xcConfigPath")], help: "Path to xcconfig file. Default is appName.xcconfig on root")
        var xcConfigPath: String?

        mutating func run() throws {
            let xcConfigPath = self.xcConfigPath ?? "./\(self.appName)/\(self.appName).xcconfig"
            let xcConfigProperties = XCConfigParser.parse(from: xcConfigPath)
            
            try FirebaseManager.createNewApp(self.appName, xcConfigProperties: xcConfigProperties)
        }
    }
    
    struct Delete: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Delete an existing Firebase project.")

        @Argument(help: "The ID of the project to delete.")
        var projectID: String

        mutating func run() throws {
//            try FirebaseManager.createNewApp(appName)
        }
    }
    
}
