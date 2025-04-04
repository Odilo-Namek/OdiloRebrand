//
//  BitriseManager.swift
//  OdiloRebrand
//
//  Created by csoler on 12/3/25.
//

import Foundation
import Yams

public struct YMLManager {
    
    public static func addTargetToProject(_ appName: String, for projectYMLPath: String) throws {
        var yamlString = try String(contentsOfFile: projectYMLPath, encoding: .utf8)

        let newSection = """
      \(appName):
          build: *commonScheme
    """

        yamlString.append(newSection)

        try yamlString.write(toFile: projectYMLPath, atomically: true, encoding: .utf8)
    }
    
    public static func createWorkflow(_ appName: String, for appBitriseYMLPath: String) throws {
        let appNode = try self.getNodes(from: appBitriseYMLPath)
        let bitriseNode = try self.getNodes(from: "odiloapp_v3_ios/bitrise.yml")
        
        try self.addWorkflow(appNode: appNode, bitriseNode: bitriseNode, appName: appName)
    }
    
    private static func getNodes(from path: String) throws -> Node {
        let yamlString = try String(contentsOfFile: path, encoding: .utf8)
        
        guard let rootNode = try Yams.compose(yaml: yamlString) else {
            throw NSError(domain: "YAMLParsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se pudo parsear el YAML"])
        }
        
        return rootNode
    }
    
    private static func addWorkflow(appNode: Node, bitriseNode: Node, appName: String) throws {
        var allNodes = bitriseNode
        
        guard var workflowsNode = allNodes.mapping?["workflows"] else {
            throw NSError(domain: "YAMLParsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "No se encontró el nodo 'workflows'"])
        }
        
        var modifiedAppNode = appNode[appName]
        modifiedAppNode?.mapping?["steps"] = Node.alias(Node.Alias("commonSteps"))
        
        workflowsNode.mapping?.forEach { (key, node) in
            if key.string?.lowercased() != "waldo", var nodeMapping = node.mapping {
                nodeMapping["steps"] = Node.alias(Node.Alias("commonSteps"))
                workflowsNode.mapping?[key] = Node.mapping(nodeMapping)
            }
        }
        
        workflowsNode[appName] = modifiedAppNode
        
        allNodes.mapping?["workflows"] = try Node(workflowsNode)
        
        do {
            let updatedYAML = try Yams.serialize(node: allNodes, allowUnicode: true).replacingOccurrences(of: "steps:\n  -", with: "steps: &commonSteps\n  -")
            try updatedYAML.write(toFile: "odiloapp_v3_ios/bitrise.yml", atomically: true, encoding: .utf8)
            
            print("✅ Workflow añadido exitosamente")
        } catch {
            print("❌ Error: \(error)")
            throw error
        }
    }
    
}
