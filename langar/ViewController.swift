//
//  ViewController.swift
//  langar
//
//  Created by ws on 3/24/18.
//  Copyright © 2018 ws. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    // START
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonThree: UIButton!
    
    @IBAction func Press(_ sender: UIButton) {
        selectedResponse = sender.accessibilityLabel!
    }
    
    // Variables for correct/selected button label
    public var correctResponse: String?
    public var selectedResponse: String?
    
    // Counter for quiz generation (mock random)
    public var quiz = 0
    
    var planes = [UUID: VirtualPlane]()
    var objectsHaveBeenPlaced = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/empty.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(ViewController.placeComponentsInSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = VirtualPlane(anchor: planeAnchor)
            self.planes[planeAnchor.identifier] = plane
            node.addChildNode(plane)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor, let plane = planes[planeAnchor.identifier] {
            plane.updateWithNewAnchor(planeAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor, let index = planes.index(forKey: planeAnchor.identifier) {
            planes.remove(at: index)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func checkSolution() -> Bool {
        // Check the user's guess against the correct response, return a Bool
        return selectedResponse == correctResponse
    }
    func setQuiz(soln: String) -> String {
        // Set UI elements for current identification quiz, based on model (soln)
        let wrongAnswers = ["máy vi tính", "cá vàng", "con sông", "điện thoại", "bàn"]
        questionTextView.text = "Đây là một _________"
        // Set the values of the text field, and buttons
        switch quiz % 3 {
        case 0: // buttonOne is correct
            buttonOne.setTitle(soln, for: [])
            buttonTwo.setTitle(wrongAnswers[quiz%5], for: [])
            buttonThree.setTitle(wrongAnswers[(quiz+1)%5], for: [])
            quiz += 1
            return "buttonOne"
        case 1: // buttonThree is correct
            buttonThree.setTitle(soln, for: [])
            buttonTwo.setTitle(wrongAnswers[quiz%5], for: [])
            buttonOne.setTitle(wrongAnswers[(quiz+1)%5], for: [])
            quiz += 1
            return "buttonThree"
        case 2: // buttonTwo is correct
            buttonOne.setTitle(wrongAnswers[quiz%5], for: [])
            buttonTwo.setTitle(soln, for: [])
            buttonThree.setTitle(wrongAnswers[(quiz+1)%5], for: [])
            quiz += 1
            return "buttonTwo"
        default:
            // Inaccessible code
            return "buttonFour"
        }
    }
    //END
    
    @objc func placeComponentsInSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        
        if !objectsHaveBeenPlaced {
            let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
            
            guard let hitTestResult = hitTestResults.first?.worldTransform.columns.3 else { return }
            let x = hitTestResult.x
            let y = hitTestResult.y
            let z = hitTestResult.z
            
            let penNode = SCNNode()
            penNode.name = "PenNode"
            let penNodeSize = CGFloat(0.1)
            penNode.position = SCNVector3(x,y + 0.0001,z)
            penNode.rotation = SCNVector4(1, 0, 0, -Float.pi / 2)
            let plane = SCNPlane(width: penNodeSize, height: penNodeSize)
            plane.cornerRadius = penNodeSize / 2
            penNode.geometry = plane
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red.withAlphaComponent(0.50)
            penNode.geometry!.materials = [material]
            
            
            guard let penScene = SCNScene(named: "art.scnassets/pen/pen.scn"),
                let penModelNode = penScene.rootNode.childNode(withName: "pen", recursively: false)
                else { return }
            penModelNode.name = "PenModelNode"
            penModelNode.scale = SCNVector3(0.012, 0.012, 0.012)
            penModelNode.rotation = SCNVector4(1, 1, 0, -Float.pi / 2)
            
            penNode.addChildNode(penModelNode)
            sceneView.scene.rootNode.addChildNode(penNode)
            
            objectsHaveBeenPlaced = true
            
            // Solution based on model generated
            var soln = "tờ báo" // TODO: change hardcode
            
            // Set values of quiz (onto UI elements)
            correctResponse = setQuiz(soln: soln)
            
            // Wait for button press
            while (selectedResponse == nil) {  }
            
            // Response if right/wrong
            if checkSolution() {
                questionTextView.text = "CORRECT!"
            } else {
                questionTextView.text = "The correct answer was: " + soln
                sleep(3)
            } // Delays to see correct answer ~ response of app
            sleep(3)
            
            // Loop, change model at same location???
            
        } else {
            let hitTestResults = sceneView.hitTest(tapLocation)
            guard let hitTestResult = hitTestResults.first else { return }
            if let name = hitTestResult.node.name {
                print(name)
            }
        }
    }
}
