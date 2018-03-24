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
    init(_ model: String, named name: String, sized size: Float, at location: SCNVector3) {
        super.init()
        
        guard let scene = SCNScene(named: model),
            let modelNode = scene.rootNode.childNode(withName: "model", recursively: false)
            else { return }
        modelNode.name = name + "ModelNode"
        
        var xDimension = abs(modelNode.boundingBox.max.x - modelNode.boundingBox.min.x)
        xDimension = xDimension + (xDimension / 100 * 35)
        var yDimension = abs(modelNode.boundingBox.max.z - modelNode.boundingBox.min.z)
        yDimension = yDimension + (yDimension / 100 * 35)
        let nodeSize = max(xDimension, yDimension)
        
        self.name = name + "Node"
        self.position = location
        self.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
        let plane = SCNPlane(width: CGFloat(xDimension), height: CGFloat(yDimension))
        plane.cornerRadius = CGFloat(nodeSize)
        self.geometry = plane
        self.scale = modelNode.scale
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red.withAlphaComponent(0.50)
        self.geometry!.materials = [material]
        
        self.addChildNode(modelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
