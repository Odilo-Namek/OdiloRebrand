//
//  GitManager.swift
//  OdiloRebrand
//
//  Created by csoler on 10/3/25.
//

import Foundation

public class GitWrapper {
    
    public static func cloneRepository(_ url: String) {
        print("Clonning repository...")
        Command.runCommand("git clone \(url)") // https://bitbucket.org/odilo-dev/odiloapp_v3_ios.git
    }
    
    public static func pull() {
        Command.runCommand("git pull")
    }
    
    public static func commit(_ message: String) {
        Command.runCommand("git commit -am \(message)")
    }
    
    public static func push() {
        Command.runCommand("git push")
    }
    
    public static func checkout(_ branch: String) {
        Command.runCommand("git checkout \(branch)")
    }
    
    public static func createBranch(_ branch: String) {
        Command.runCommand("git checkout -b \(branch)")
    }
    
    public static func add(_ fileName: String = ".") {
        Command.runCommand("git add \(fileName)")
    }
    
}
