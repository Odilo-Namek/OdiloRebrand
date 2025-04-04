//
//  XMLParser.swift
//  OdiloRebrand
//
//  Created by csoler on 25/3/25.
//

import Foundation
import CoreXLSX

public struct XMLManager {
    
    
    @discardableResult public static func generateStylesYML(filePath: URL) throws -> StylesYML {
        guard let xlFile = XLSXFile(filepath: filePath.path) else {
            throw NSError(domain: "ExcelError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se pudo abrir el archivo Excel"])
        }
        
        let sharedStrings = try xlFile.parseSharedStrings()
        var extractedData: [[String]] = []
        var isFirstRow = true
        
        for path in try xlFile.parseWorksheetPaths() {
            let worksheet = try xlFile.parseWorksheet(at: path)
            
            for row in worksheet.data?.rows ?? [] {
                if isFirstRow {
                    isFirstRow = false
                    continue
                }
                
                var rowData: [String] = []
                for (index, cell) in row.cells.enumerated() {
                    if let value = cell.value {
                        var cellValue: String
                        
                        if cell.type == .sharedString, let sharedIndex = Int(value), let sharedText = sharedStrings?.items[sharedIndex].text {
                            cellValue = sharedText
                        } else {
                            cellValue = value
                        }
                        
                        if cellValue.contains("=") {
                            cellValue = "100.0"
                        }
                        
                        if cellValue.lowercased().contains("Alpha %") || cellValue.lowercased().contains("ios") || cellValue.lowercased().contains("android") {
                            continue
                        }
                        
                        rowData.append(cellValue)
                    }
                }
                
                extractedData.append(rowData)
            }
        }
        
        return parseColors(from: extractedData)
    }
    
    private static func parseColors(from data: [[String]]) -> StylesYML {
        var result = StylesYML(styles: [:])
        var totalParsed = 0
        var skippedColors = 0
        
        for row in data {
            guard row.count >= 2,
                  let name = row.first,
                  let hexString = row[safe: 1], !hexString.isEmpty else {
                skippedColors += 1
                continue
            }
            
            let alphaStr = (row.count >= 3 && !(row[2].isEmpty)) ? row[2] : "100.0"
            let styleName = name.lowercased().replacingOccurrences(of: " ", with: "")
            
            if styleName.lowercased() == "color" {
                continue
            }
            
            result.styles[styleName] = Color(light: ColorValue(hex: hexString, alpha: alphaStr),
                                             dark: ColorValue(hex: hexString, alpha: alphaStr))
            
            totalParsed += 1
        }
        
        return result
    }
    
}
