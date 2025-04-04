//
//  FirebaseManager.swift
//  OdiloRebrand
//
//  Created by csoler on 05/3/25.
//

import Foundation
import Utils

public class FirebaseManager {
    
    public static func createNewApp(_ appName: String, xcConfigProperties: [XCConfigProperties: Any]?) throws {
        guard let token = self.loginFirebase() else {
            return
        }
        
        var projectForNewApp: FirebaseProject?
        let firebaseProjects = try self.fetchFirebaseProjects(token)
        if let notFullProject = try self.fetchNotFullProject(projects: firebaseProjects, token) {
            projectForNewApp = notFullProject
        } else if let iOSProjectLastNumber = firebaseProjects.compactMap({$0.displayName.components(separatedBy: "-").last}).max(),
                  let iOSProjectNumber = Int(iOSProjectLastNumber) {
            let newProjectName = "odilo-ios-\(iOSProjectNumber + 1)"
            projectForNewApp = try self.createFirebaseProject(projectName: newProjectName, token)
        }
        
        guard let projectForNewApp else {
            return
        }
        
        if let bundleID = xcConfigProperties?[.bundleID] as? String,
           let newApp = try self.createFirebaseApp(project: projectForNewApp, appName: appName, bundleID: bundleID, token),
           let bundleID = newApp.bundleID,
           let appID = newApp.appID {
//            self.configurePushNotifications(bundleID: bundleID, projectID: projectID, appID: appID, token)
            try self.downloadGoogleServiceInfo(projectID: projectForNewApp.projectID, targetName: appName, appID: appID, token)
        }
    }
    
    public static func loginFirebase() -> String? {
        let loginOutput = Command.runCommand("firebase login:ci")
        
        let texts = loginOutput.components(separatedBy: "\n").filter({!$0.isEmpty})
        
        guard let tokenIndex = texts.firstIndex(where: {$0.lowercased().contains("success")}),
              let token = texts[safe: tokenIndex + 1] else {
            return nil
        }
        
        return token
    }
    
    public static func fetchFirebaseProjects(_ token: String) throws -> [FirebaseProject] {
        let output = Command.runCommand("firebase projects:list --json --token \(token)")
        
        do {
            let data = output.data(using: .utf8)!
            let decodedResponse = try JSONDecoder().decode(FirebaseProjectResponse.self, from: data)
            return decodedResponse.result.filter({$0.name.lowercased().contains("ios")})
        } catch {
            throw(error)
        }
    }
    
    private static func fetchNotFullProject(projects: [FirebaseProject], _ token: String) throws -> FirebaseProject? {
        for project in projects {
            let output = Command.runCommand("firebase apps:list --project \(project.projectID) --json")
            
            do {
                guard let data = output.data(using: .utf8) else {
                    return nil
                }
                
                let decodedResponse = try JSONDecoder().decode(FirebaseAppResponse.self, from: data)
                
                let iosAppCount = decodedResponse.result.filter({ $0.platform?.lowercased() == "ios" }).count
                if iosAppCount < 30 {
                    return project
                }
            } catch {
                throw error
            }
        }
        
        return nil
    }
    
    private static func createFirebaseProject(projectName: String, _ token: String) throws -> FirebaseProject? {
        let output = Command.runCommand("firebase projects:create \(projectName) --display-name \(projectName) --json --token \(token)")
        print(output)
        do {
            guard let data = output.data(using: .utf8) else {
                return nil
            }
            
            let decodedResponse = try JSONDecoder().decode(FirebaseProjectResponse.self, from: data)
            return decodedResponse.result.first
        } catch {
            throw(error)
        }
    }
    
    private static func createFirebaseApp(project: FirebaseProject, appName: String, bundleID: String, _ token: String) throws -> FirebaseApp? {
        let output = Command.runCommand("firebase apps:create IOS \(appName) --project \(project.projectID) -b \(bundleID) --json --non-interactive")
        
        do {
            guard let data = output.data(using: .utf8) else {
                return nil
            }
            
            let decodedResponse = try JSONDecoder().decode(FirebaseCreateAppResponse.self, from: data)
            return decodedResponse.result
        } catch {
            throw(error)
        }
    }
    
    private static func configurePushNotifications(bundleID: String, projectID: String, appID: String, _ token: String) { // Not working
        Command.runCommand("firebase ios apps credentials update-apns-auth-key --project=\(projectID) --app=\(appID) --key=./AuthKey_QNMATQXKSG.p8 --key-id=QNMATQXKSG --team-id=4QABX4ZBNU")
    }
    
    private static func downloadGoogleServiceInfo(projectID: String, targetName: String, appID: String, _ token: String) throws {
        print("Downloading GoogleServiceInfo...")
        
        Command.runCommand("firebase apps:sdkconfig --project \(projectID) --out GoogleService-Info_\(targetName.lowercased()) IOS \(appID) --token \(token)")
        
        let rootURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let plistURL = rootURL.appendingPathComponent("GoogleService-Info_\(targetName.lowercased())")
        let brandingFolder = rootURL.appendingPathComponent(targetName).appendingPathComponent("GoogleService-Info_\(targetName.lowercased())")
        try FileManager.default.moveItem(at: plistURL, to: brandingFolder)
    }
    
}
