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

@main struct BrandingCreator: AsyncParsableCommand {
    
    static let configuration = CommandConfiguration(abstract: "Client brandings manager.",
                                                    subcommands: [BrandingCreator.Create.self,
                                                                  BrandingCreator.Delete.self,
                                                                  FirebaseAdmin.self,
                                                                  ThemeGenerator.self])
    
    // MARK: Subcommands
    
    struct Create: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Create new branding.")
        
        @Argument(help: "Name for the new branding.")
        var appName: String
        
        @Option(name: [.short, .customLong("xcConfigPath")], help: "Path to xcconfig file. Default is appName.xcconfig on root")
        var xcConfigPath: String?
        
        @Option(name: [.short, .customLong("bitriseYMLPath")], help: "Path to bitrise.yml file. Default is appName.yml on root")
        var bitriseYMLPath: String?
        
        mutating func run() async throws {
            let projectYML = "./odiloapp_v3_ios/project.yml"
            let bitriseYML = self.bitriseYMLPath ?? "./\(self.appName)/\(self.appName).yml"
            let xcConfigPath = self.xcConfigPath ?? "./\(self.appName)/\(self.appName).xcconfig"
            let xcConfigProperties = XCConfigParser.parse(from: xcConfigPath)
            
            try FirebaseManager.createNewApp(self.appName, xcConfigProperties: xcConfigProperties)
            GitWrapper.cloneRepository("https://bitbucket.org/odilo-dev/odiloapp_v3_ios.git")
            
            try YMLManager.addTargetToProject(self.appName, for: projectYML)
            try YMLManager.createWorkflow(self.appName, for: bitriseYML)
            try await AssetsManager.generateTheme(self.appName, xcConfigProperties: xcConfigProperties)
            
            let rootURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            let odiloProjectFolder = rootURL.appendingPathComponent("odiloapp_v3_ios")
            Command.runCommand("chmod 777 odiloapp_v3_ios")
            
            FileManager.default.changeCurrentDirectoryPath(odiloProjectFolder.path)
            
            GitWrapper.createBranch("branding_\(self.appName.lowercased())")
            GitWrapper.add()
            GitWrapper.commit("Finished branding \(self.appName)")
//            GitWrapper.push()
            
            try FileManager.default.removeItem(atPath: odiloProjectFolder.path)
            
            print("Recuerda añadir manualmente el appItunesID en el xcconfig una vez que este la ficha creada en el AppStoreConnect")
            print("Recuerda subir las imagenes a la tienda manualmente")
            print("Recuerda provocar el crash para que conecte con Crashlytics")
            print("Recuerda añadir el deeplinking al repositorio de Orion")
            print("Recuerda mergear la rama branding_\(self.appName.lowercased()) en master")
        }
    }
    
    struct Delete: AsyncParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Delete existing branding.")
        
        @Argument(help: "Name of the branding to remove.")
        var appName: String
        
        mutating func run() async throws {
//            try FirebaseManager.createNewApp("")
        }
    }
    
}
