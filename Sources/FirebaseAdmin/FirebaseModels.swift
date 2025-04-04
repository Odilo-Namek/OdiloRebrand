//
//  File.swift
//  OdiloRebrand
//
//  Created by csoler on 5/3/25.
//

import Foundation

public struct FirebaseProjectResponse: Codable {
    let status: String
    let result: [FirebaseProject]
}

public struct FirebaseProject: Codable {
    let projectID: String
    let projectNumber: String
    let displayName: String
    let name: String
    let resources: FirebaseProjectResources
    let state: String
    let etag: String
    
    private enum CodingKeys: String, CodingKey {
        case projectID = "projectId"
        case projectNumber
        case displayName
        case name
        case resources
        case state
        case etag
    }
}

public struct FirebaseProjectResources: Codable {
    let hostingSite: String?
    let realtimeDatabaseInstance: String?
    let locationId: String?
    
    private enum CodingKeys: String, CodingKey {
        case hostingSite
        case realtimeDatabaseInstance = "realtimeDatabaseInstance"
        case locationId
    }
}

public struct FirebaseAppResponse: Codable {
    let status: String
    let result: [FirebaseApp]
}

public struct FirebaseCreateAppResponse: Codable {
    let status: String
    let result: FirebaseApp
}

public struct FirebaseApp: Codable {
    let name: String
    let displayName: String
    let platform: String?
    let projectID: String?
    let bundleID: String?
    let appID: String?
    let namespace: String?
    let apiKeyID: String?
    let state: String
    let expireTime: String
    let etag: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case displayName
        case platform
        case projectID = "projectId"
        case bundleID = "bundleId"
        case appID = "appId"
        case namespace
        case apiKeyID
        case state
        case expireTime
        case etag
    }
}
