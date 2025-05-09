//
//  AssetsModel.swift
//  OdiloRebrand
//
//  Created by csoler on 14/3/25.
//

import Foundation

// MARK: Client

struct Client: Codable {
    let id: String?
    let clientId: String?
    let name: String?
    let url: String?
    let country: String?
    let appsId: [String]?
    let logo: String?
    let favicon: String?
    let logo_carnet: String?
}

// MARK: Assets

struct InfoData: Codable {
    let info = Info()
    
    enum CodingKeys: CodingKey {
        case info
    }
}

struct Info: Codable {
    let author: String = "xcode"
    let version: Int = 1
    
    enum CodingKeys: CodingKey {
        case author
        case version
    }
}

struct ImageSet: Codable {
    struct Image: Codable {
        let idiom: String
        let filename: String
        let scale: String?
        let platform: String?
        let size: String?
    }
    
    let images: [Image]
    let info: Info
}

struct ColorSet: Codable {
    struct ColorComponent: Codable {
        let alpha: String
        let blue: String
        let green: String
        let red: String
    }
    
    struct Color: Codable {
        let colorSpace: String
        let components: ColorComponent
    }
    
    struct Appearance: Codable {
        let appearance: String
        let value: String
    }
    
    struct ColorEntry: Codable {
        let color: Color
        let idiom: String
        let appearances: [Appearance]?
    }
    
    struct Properties: Codable {
        let localizable: Bool
    }
    
    let colors: [ColorEntry]
    let properties: Properties
    let info = Info()
    
    enum CodingKeys: CodingKey {
        case colors
        case properties
    }
}

// MARK: Colors

public struct StylesYML: Codable {
    var styles: [String: Color]
}

public struct Color: Codable {
    let light: ColorValue
    let dark: ColorValue
    
    enum CodingKeys: String, CodingKey {
        case light
        case dark
    }
}

public struct ColorValue: Codable {
    let hex: String
    let alpha: String
}

enum StyleType: String, Codable {
    case h4
    case h5Bold
    case h5
    case h6
    case h6Bold
    case subtitle1
    case subtitle2
    case subtitle3
    case body1
    case body2
    case body3
    case body4
    case body5
    case caption1
    case caption2
    case caption3
    case button
    
    case color01
    case color02
    case color03
    case color04
    case color05
    case color06
    case color07
    case color08
    case color09
    case color10
    case color11
    case color12
    case color13
    case color14
    case color15
    case color16
    case color17
    case color18
    case color19
    case color20
    case color21
    case color22
    case color23
    case color24
    case color25
    case color26
    case color27
    case color28
    case color29
    case color30
    case color31
    case color32
    case color33
    case color34
    case color35
    case color36
    case color37
    case color38
    case color39
    case color40
    case color41
    case color43
    case color101
    case color102
    case color103
    case color104
    case color105
    case color106
    case color107
    case color108
    case color109
    case color110
    case color111
    case color112
    case color113
    case color114
    case color115
    case color116
    case color117
    case color118
    case color119
    case color120
    
    case shadow01
    case shadow02
    case shadow03
    case shadow04
}

struct AssetsStylesGenerator {
    let appName: String
    let rootURL: URL
    let themeURL: URL
    let brandingFolderURL: URL
    let assetsFolderURL: URL
    let xcConfigProperties: [XCConfigProperties : Any]
}

public enum ThemeGenerator {
    case assets
    case styles
}
