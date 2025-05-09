//
//  AssetsManager.swift
//  OdiloRebrand
//
//  Created by csoler on 14/3/25.
//

import Foundation
import Yams

public class AssetsManager {
    
    private static func getClientInfo(_ clientCode: String) async throws -> Client? {
        guard let url = URL(string: "https://odiloid.odilo.us/ClientId") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        
        let config = URLSessionConfiguration.default
        config.httpShouldSetCookies = true
        config.httpShouldUsePipelining = true
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let session = URLSession(configuration: config)
        
        do {
            let (data, response) = try await session.data(for: request)
            return try JSONDecoder().decode([Client].self, from: data).first { $0.clientId == clientCode }
        } catch {
            throw error
        }
    }
    
    public static func createAssets(_ appName: String, xcConfigProperties: [XCConfigProperties : Any]?) async throws {
        guard let clientCode = xcConfigProperties?[.clientCode] as? String,
              let client = try await getClientInfo(clientCode),
              let logoURL = client.logo,
              let themeURL = URL(string: logoURL)?.deletingLastPathComponent() else {
            throw NSError(domain: "AssetsManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cliente o URL no válidos"])
        }
        
        let assetsURL = themeURL.appendingPathComponent("iOS.zip")
        let stylesURL = themeURL.appendingPathComponent("variables.xlsx")
        print("ASSETS URL: \(assetsURL.absoluteString)")
        print("STYLES URL: \(stylesURL.absoluteString)")
        
        let rootURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let brandingFolderURL = rootURL.appendingPathComponent("\(appName)")
        let assetsDirectory = brandingFolderURL.appendingPathComponent("\(appName).xcassets")
        
        let assetsZipURL = brandingFolderURL.appending(path: "assets.zip")
        let stylesFileURL = brandingFolderURL.appendingPathComponent("variables.xlsx")
        
        let (assetsTempURL, assetsResponse) = try await URLSession.shared.download(from: assetsURL)
        let (stylesTempURL, stylesResponse) = try await URLSession.shared.download(from: stylesURL)
        
        try FileManager.default.moveItem(at: assetsTempURL, to: assetsZipURL)
        try FileManager.default.moveItem(at: stylesTempURL, to: stylesFileURL)
        try ZipManager.unzipFile(at: assetsZipURL, to: assetsDirectory)
        try FileManager.default.removeItem(atPath: assetsZipURL.path)
        
        try FileManager.default.removeFiles(containing: "itunes", in: assetsDirectory)
        
        let launchLogoURL = brandingFolderURL.appendingPathComponent("\(appName).xcassets").appendingPathComponent("AppIcon").appendingPathComponent("launchlogo.png")
        let destinationURL = brandingFolderURL.appendingPathComponent("launchlogo.png")
        try FileManager.default.moveItem(at: launchLogoURL, to: destinationURL)
        
        let folders = try FileManager.default.contentsOfDirectory(atPath: assetsDirectory.path).filter { !$0.contains("iTunes") && !$0.contains("launchlogo") }
        try folders.forEach { folder in
            let newFolderName = folder.contains("AppIcon") ? "\(folder).appiconset" : "\(folder).imageset"
            try FileManager.default.moveItem(at: assetsDirectory.appendingPathComponent(folder), to: assetsDirectory.appendingPathComponent(newFolderName))
        }
        
        if let launchLogoName = try FileManager.default.contentsOfDirectory(atPath: assetsDirectory.path).first(where: { $0.lowercased().contains("launchlogo") }) {
            let launchLogoURL = assetsDirectory.appendingPathComponent(launchLogoName)
            let destinationURL = brandingFolderURL.appendingPathComponent(launchLogoName)
            
            try FileManager.default.moveItem(at: launchLogoURL, to: destinationURL)
        }
        
        let darkMode = xcConfigProperties?[.darkMode] as? Bool ?? false
        try self.createAssetsImages(darkMode, assetsDirectory: assetsDirectory)
        
        try self.createStyles(appName: appName, brandingURL: brandingFolderURL)
        
        let odiloProjectFolder = rootURL.appendingPathComponent("odiloapp_v3_ios")
        let odiloRebrandingsFolder = odiloProjectFolder.appendingPathComponent("Rebrandings").appendingPathComponent(appName)
        
        try FileManager.default.removeFiles(containing: "variables", in: brandingFolderURL)
        try FileManager.default.moveItem(at: brandingFolderURL, to: odiloRebrandingsFolder)
        
        print("Assets creados correctamente")
    }
    
    private static func createAssetsImages(_ darkMode: Bool, assetsDirectory: URL) throws {
        let redColor = darkMode ? "00" : "FF"
        let greenColor = darkMode ? "00" : "FF"
        let blueColor = darkMode ? "00" : "FF"
        
        let loginLogoSet = ImageSet(images: [
            ImageSet.Image(idiom: "universal", filename: "login_logo.png", scale: "1x", platform: nil, size: nil),
            ImageSet.Image(idiom: "universal", filename: "login_logo@2x.png", scale: "2x", platform: nil, size: nil),
            ImageSet.Image(idiom: "universal", filename: "login_logo@3x.png", scale: "3x", platform: nil, size: nil)
        ], info: Info())
        
        let appIconSet = ImageSet(images: [
            ImageSet.Image(idiom: "universal", filename: "ico_1024x1024.png", scale: nil, platform: "ios", size: "1024x1024")
        ], info: Info())
        
        let colorSet = ColorSet(
            colors: [
                ColorSet.ColorEntry(
                    color: ColorSet.Color(
                        colorSpace: "display-p3",
                        components: ColorSet.ColorComponent(
                            alpha: "1.000",
                            blue: "0x\(blueColor)",
                            green: "0x\(greenColor)",
                            red: "0x\(redColor)"
                        )
                    ),
                    idiom: "universal",
                    appearances: nil
                ),
                ColorSet.ColorEntry(
                    color: ColorSet.Color(
                        colorSpace: "display-p3",
                        components: ColorSet.ColorComponent(
                            alpha: "1.000",
                            blue: "0x\(blueColor)",
                            green: "0x\(greenColor)",
                            red: "0x\(redColor)"
                        )
                    ),
                    idiom: "universal",
                    appearances: [ColorSet.Appearance(appearance: "luminosity", value: "dark")]
                )
            ],
            properties: ColorSet.Properties(localizable: true)
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let colorJsonData = try encoder.encode(colorSet)
        let appIconSetData = try encoder.encode(appIconSet)
        let loginLogoSetData = try encoder.encode(loginLogoSet)
        let infoData = try encoder.encode(InfoData())
        
        var fileURL = assetsDirectory.appendingPathComponent("launchbackground.colorset")
        
        if let colorJsonString = String(data: colorJsonData, encoding: .utf8) {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
            }
            try colorJsonString.write(to: fileURL.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
        }
        
        if let appIconSetString = String(data: appIconSetData, encoding: .utf8) {
            try appIconSetString.write(to: assetsDirectory.appendingPathComponent("AppIcon.appiconset").appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
        }
        
        if let loginLogoSetString = String(data: loginLogoSetData, encoding: .utf8) {
            try loginLogoSetString.write(to: assetsDirectory.appendingPathComponent("Login-Logo.imageset").appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
        }
        
        if let infoString = String(data: infoData, encoding: .utf8) {
            try infoString.write(to: assetsDirectory.appendingPathComponent("Contents.json"), atomically: true, encoding: .utf8)
        }
    }
    
    private static func createStyles(appName: String, brandingURL: URL) throws {
        let excelURL = brandingURL.appendingPathComponent("variables.xlsx")
        let colors = try XMLManager.generateStylesYML(filePath: excelURL)
        
        let encoder = YAMLEncoder()
        encoder.options.indent = 2
        let yamlString = try encoder.encode(colors)
        
        let yamlURL = brandingURL.appendingPathComponent("styles.yml")
        try yamlString.write(to: yamlURL, atomically: true, encoding: .utf8)
        
        print("Archivo YAML creado en: \(yamlURL.path)")
    }
    
}
