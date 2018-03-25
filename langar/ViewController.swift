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
    
    var currentQuiz = Quiz(object: "pen")
    
    @IBOutlet var sceneView: ARSCNView!
    
    // Interrogation Code
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var buttonOne: UIButton!
    @IBOutlet var buttonTwo: UIButton!
    @IBOutlet var buttonThree: UIButton!
    
    @IBAction func Press(_ sender: UIButton) {
        selectedResponse = sender.title(for: .normal)
        let result = self.currentQuiz.checkSolution(guess: selectedResponse!)
        if result {
            questionTextView.text = "Correct!"
        } else {
            questionTextView.text = "Wrong answer."
        }
        sceneView.scene.rootNode.childNode(withName: "quizObject", recursively: false)?.removeFromParentNode()
    }
    
    // Variables for correct/selected button label
    public var correctResponse: String?
    public var selectedResponse: String?
    
    // Counter for quiz generation (mock random)
    public var quiz = 0
    
    // ARKit Code
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
            #selector(ViewController.placeVirtualObjectInSceneView(withGestureRecognizer:)))
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
    
    @objc func placeVirtualObjectInSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first?.worldTransform.columns.3 else { return }
        let x = hitTestResult.x
        let y = hitTestResult.y
        let z = hitTestResult.z
        
        let possibleObjects = ["banana", "money", "pen", "flower", "sneaker", "spoon", "tree", "bottle"]
        
        let randomIndex = Int(arc4random_uniform(UInt32(possibleObjects.count)))
        let object = possibleObjects[randomIndex]
        //let object = possibleObjects[1]
            
        let voNode = VirtualObject("art.scnassets/\(object)/\(object).scn", named: object, at: SCNVector3(x, y, z))
        voNode.name = "quizObject"
        // penNode.setHighlightType(.indicated)
        sceneView.scene.rootNode.addChildNode(voNode)
        
        self.currentQuiz = Quiz(object: object)
        let options = self.currentQuiz.getOptions()
        buttonOne.setTitle(options[0], for: [])
        buttonTwo.setTitle(options[1], for: [])
        buttonThree.setTitle(options[2], for: [])
        questionTextView.text = "Đây là một _________"
    }
}
