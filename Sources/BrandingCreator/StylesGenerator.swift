//
//  StylesGenerator.swift
//  OdiloRebrand
//
//  Created by csoler on 9/5/25.
//

import ArgumentParser
import Utils

struct ThemeGenerator: AsyncParsableCommand {
    
    static let configuration = CommandConfiguration(abstract: "Theme manager.",
                                                    subcommands: [ThemeGenerator.Styles.self,
                                                                  ThemeGenerator.Assets.self])
    
    // MARK: Subcommands
    
    struct Styles: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generate styles.yml from online theme.")
        
        @Argument(help: "Name of the app to create styles for.")
        var appName: String
        
        @Option(name: [.short, .customLong("xcConfigPath")], help: "Path to xcconfig file. Default is appName.xcconfig on root")
        var xcConfigPath: String?
        
        mutating func run() async throws {
            let xcConfigPath = self.xcConfigPath ?? "./\(self.appName)/\(self.appName).xcconfig"
            let xcConfigProperties = XCConfigParser.parse(from: xcConfigPath)
            
            try await AssetsManager.generateTheme(self.appName, xcConfigProperties: xcConfigProperties, themeGenerators: [.styles])
        }
        
    }
    
    struct Assets: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generate assets from online theme.")
        
        @Argument(help: "Name of the app to create assets for.")
        var appName: String
        
        @Option(name: [.short, .customLong("xcConfigPath")], help: "Path to xcconfig file. Default is appName.xcconfig on root")
        var xcConfigPath: String?
        
        mutating func run() async throws {
            let xcConfigPath = self.xcConfigPath ?? "./\(self.appName)/\(self.appName).xcconfig"
            let xcConfigProperties = XCConfigParser.parse(from: xcConfigPath)
            
            try await AssetsManager.generateTheme(self.appName, xcConfigProperties: xcConfigProperties, themeGenerators: [.assets])
        }
    }
    
}
