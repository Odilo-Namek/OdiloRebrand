//
//  BitriseModel.swift
//  OdiloRebrand
//
//  Created by csoler on 11/3/25.
//

import Foundation
import Yams

struct BitriseConfig: Codable {
    let defaultStepLibSource: String
    let formatVersion: String
    let projectType: String
    let app: App
    let meta: Meta
    var workflows: [String: Workflow]
    
    enum CodingKeys: String, CodingKey {
        case defaultStepLibSource = "default_step_lib_source"
        case formatVersion = "format_version"
        case projectType = "project_type"
        case app
        case meta
        case workflows
    }
}

struct App: Codable {
    let envs: [Environment]
}

struct Meta: Codable {
    let bitriseIO: BitriseIO
    let steps: [[String: Step]]
    
    enum CodingKeys: String, CodingKey {
        case bitriseIO = "bitrise.io"
        case steps
    }
}

struct BitriseIO: Codable {
    let stack: String
    let machineTypeID: String
    
    enum CodingKeys: String, CodingKey {
        case stack
        case machineTypeID = "machine_type_id"
    }
}

struct Workflow: Codable {
    let envs: [Environment]?
    let steps: String? = "*commonSteps"

    enum CodingKeys: CodingKey {
        case envs
        case steps
    }
}

struct Environment: Codable {
    let key: EnvironmentVariable
    let value: EnvironmentValue
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dictionary = try container.decode([String: EnvironmentValue].self)
        
        guard let (keyString, value) = dictionary.first else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Formato de entorno inválido")
        }
        
        guard let key = EnvironmentVariable(rawValue: keyString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Clave desconocida: \(keyString)")
        }
        
        self.key = key
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([key.rawValue: value])
    }
}

struct Step: Codable {
    let name: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            self.name = stringValue
        } else {
            self.name = nil
        }
    }
}

enum EnvironmentVariable: String, Codable {
    case bitriseScheme = "BITRISE_SCHEME"
    case targetName = "TARGET_NAME"
    case snapshotSchemeName = "SNAPSHOT_SCHEME_NAME"
    case bitriseExportMethod = "BITRISE_EXPORT_METHOD"
    case projectPath = "APP_PROJECT_PATH"
    case appVersion = "APP_VERSION"
    case appID = "APP_IDENTIFIER"
    case plistPath = "PLIST_PATH"
    case supportUrl = "SUPPORT_URL"
    case teamID = "TEAM_ID"
    case itcTeamID = "ITC_TEAM_ID"
    case isRelease = "IS_RELEASE"
    case isReleaseBool = "IS_RELEASE_BOOL"

    case appNameES = "APP_NAME_ES"
    case appNameEN = "APP_NAME_EN"
    case appNameEN_AU = "APP_NAME_EN_AU"
    case appNamePT = "APP_NAME_PT_PT"
    case appNamePT_BR = "APP_NAME_PT"
    case appNameFR = "APP_NAME_FR"
    case appNameZH = "APP_NAME_ZH"
    case appNameCA = "APP_NAME_CA"
    case appNameNL = "APP_NAME_NL"

    case descriptionES = "DESCRIPTION_ES"
    case descriptionEN = "DESCRIPTION_EN"
    case descriptionEN_AU = "DESCRIPTION_EN_AU"
    case descriptionPT = "DESCRIPTION_PT_PT"
    case descriptionPT_BR = "DESCRIPTION_PT"
    case descriptionFR = "DESCRIPTION_FR"
    case descriptionZH = "DESCRIPTION_ZH"
    case descriptionCA = "DESCRIPTION_CA"
    case descriptionNL = "DESCRIPTION_NL"

    case keywordsES = "KEYWORDS_ES"
    case keywordsEN = "KEYWORDS_EN"
    case keywordsEN_AU = "KEYWORDS_EN_AU"
    case keywordsPT = "KEYWORDS_PT_PT"
    case keywordsPT_BR = "KEYWORDS_PT"
    case keywordsFR = "KEYWORDS_FR"
    case keywordsZH = "KEYWORDS_ZH"
    case keywordsCA = "KEYWORDS_CA"
    case keywordsNL = "KEYWORDS_NL"

    case demoUser = "DEMO_USER"
    case demoPass = "DEMO_PASS"
    case notes = "NOTES"

    case releaseNotesES = "RELEASE_NOTES_ES"
    case releaseNotesEN = "RELEASE_NOTES_EN"
    case releaseNotesEN_AU = "RELEASE_NOTES_EN_AU"
    case releaseNotesPT = "RELEASE_NOTES_PT_PT"
    case releaseNotesPT_BR = "RELEASE_NOTES_PT"
    case releaseNotesFR = "RELEASE_NOTES_FR"
    case releaseNotesZH = "RELEASE_NOTES_ZH"
    case releaseNotesCA = "RELEASE_NOTES_CA"
    case releaseNotesNL = "RELEASE_NOTES_NL"

    case privacyUrlES = "PRIVACY_URL_ES"
    case privacyUrlEN = "PRIVACY_URL_EN"
    case privacyUrlEN_AU = "PRIVACY_URL_EN_AU"
    case privacyUrlPT = "PRIVACY_URL_PT_PT"
    case privacyUrlPT_BR = "PRIVACY_URL_PT"
    case privacyUrlFR = "PRIVACY_URL_FR"
    case privacyUrlZH = "PRIVACY_URL_ZH"
    case privacyUrlCA = "PRIVACY_URL_CA"
    case privacyUrlNL = "PRIVACY_URL_NL"
}

enum EnvironmentValue: Codable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.typeMismatch(EnvironmentValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Tipo no soportado"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .string(let value): try container.encode(value)
            case .bool(let value): try container.encode(value)
            case .int(let value): try container.encode(value)
            case .double(let value): try container.encode(value)
        }
    }
}
