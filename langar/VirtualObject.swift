//
//  VirtualObject.swift
//  langar
//
//  Created by ws on 3/24/18.
//  Copyright © 2018 ws. All rights reserved.
//

import Foundation
import SceneKit

class VirtualObject: SCNNode {
    
    init(_ model: String, named name: String, at location: SCNVector3) {
        super.init()
        
        self.name = name + "Node"
        
        guard let scene = SCNScene(named: model),
            let modelNode = scene.rootNode.childNode(withName: "model", recursively: false)
            else { return }
        modelNode.name = name + "ModelNode"
        
        let xDimension = abs(modelNode.boundingBox.max.x - modelNode.boundingBox.min.x)
        let yDimension = abs(modelNode.boundingBox.max.z - modelNode.boundingBox.min.z)
        let nodeSize = max(xDimension, yDimension)
        self.position = location
        self.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        
        let selectorNode = SCNNode()
        selectorNode.name = name + "SelectorNode"
        let selectorSizeIncrease = Float(0.35)
        let plane = SCNPlane(width: CGFloat(xDimension + (xDimension * selectorSizeIncrease)),
                             height: CGFloat(yDimension + (yDimension * selectorSizeIncrease)))
        plane.cornerRadius = CGFloat(nodeSize)
        selectorNode.geometry = plane
        selectorNode.scale = modelNode.scale
        
        self.addChildNode(modelNode)
        self.addChildNode(selectorNode)
        
        self.setHighlightType(.none)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlightType(_ type: HighlightType) {
        let material = SCNMaterial()
        let selectorNode = self.childNode(withName: self.name!.dropLast(4) + "SelectorNode", recursively: false)! // we drop the last four because, for example, we don't want "PenNodeSelectorNode" but rather just "PenSelectorNode"
        
        switch type {
        case .selected:
            material.diffuse.contents = UIColor.blue.withAlphaComponent(0.50)
            selectorNode.geometry!.materials = [material]
        case .indicated:
            material.diffuse.contents = UIColor.red.withAlphaComponent(0.50)
            selectorNode.geometry!.materials = [material]
        case .none:
            material.diffuse.contents = UIColor.clear.withAlphaComponent(0.0)
            selectorNode.geometry!.materials = [material]
        }
    }
}

/**
Objects can be highlighted, displaying a colored plane below them.
 
 Types of highlighting:
 selected: for when a user selects an object
 indicated: the app intends to indicate an object or bring attention to it.
 **/
enum HighlightType {
    case selected, indicated, none
}
