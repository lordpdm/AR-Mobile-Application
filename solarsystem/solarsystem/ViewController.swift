//
//  ViewController.swift
//  solarsystem
//
//  Created by Romain on 08/03/2018.
//  Copyright © 2018 Romain. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
		
		//// Section 1 - Solar System with Scene editor
		let scene = SCNScene(named: "art.scnassets/solarSystem.scn")!
		sceneView.scene = scene

		
		//// Section2 - solar system with code
        //let scene = SCNScene() // empty scene
        //sceneView.scene = scene
		//createSolarSystem()
    }
	
	
	func createSolarSystem() {
		
		//parent Node
		let parentNode = SCNNode()
		parentNode.position.z = -1.5
		
		
		//planets
		let mercury = Planet(name: "mercury", radius: 0.14, rotation: 32.degreesToRadians, color: .orange, sunDistance: 1.3)
		let venus = Planet(name: "venus", radius: 0.35, rotation: 10.degreesToRadians, color: .cyan, sunDistance: 2)
		let earth = Planet(name: "earth", radius: 0.5, rotation: 18.degreesToRadians, color: .blue, sunDistance: 7)
		let saturn = Planet(name: "saturn", radius: 1, rotation: 12.degreesToRadians, color: .brown, sunDistance: 12)
        let mars = Planet(name: "mars", radius: 0.75, rotation: 19.degreesToRadians, color: .brown, sunDistance: 12)
        let uranus = Planet(name: "uaranus", radius: 0.9, rotation: 15.degreesToRadians, color: .brown, sunDistance: 12)
        let jupiter = Planet(name: "jupiter", radius: 1.2, rotation: 23.degreesToRadians, color: .brown, sunDistance: 12)
		
		let planets = [mercury, venus, earth, saturn, mars, uranus, jupiter]
		
		for planet in planets {
			parentNode.addChildNode(createNode(from : planet))
		}
		
		//light
		let light = SCNLight()
		light.type = .omni
		parentNode.light = light
			
		//stars
		let stars = SCNParticleSystem(named: "stars.scnp", inDirectory: nil)!
		parentNode.addParticleSystem(stars)
		
		//sun
		let sun = SCNParticleSystem(named: "sun.scnp", inDirectory: nil)!
		parentNode.addParticleSystem(sun)
		
		sceneView.scene.rootNode.addChildNode(parentNode)
	}
	
	func createNode(from planet : Planet) -> SCNNode {
		
		let parentNode = SCNNode()
		let rotateAction = SCNAction.rotateBy(x: 0, y: planet.rotation, z: 0, duration: 1)
		parentNode.runAction(.repeatForever(rotateAction))
		let sphereGeometry = SCNSphere(radius: planet.radius)
		sphereGeometry.firstMaterial?.diffuse.contents = planet.color
		let planetNode = SCNNode(geometry: sphereGeometry)
		planetNode.position.z = -planet.sunDistance
		planetNode.name = planet.name
		parentNode.addChildNode(planetNode)
		
		if planet.name == "saturn" {
			let ringGeometry = SCNTube(innerRadius: 1.2, outerRadius: 1.8, height: 0.05)
			ringGeometry.firstMaterial?.diffuse.contents = UIColor.darkGray
			let ringNode = SCNNode(geometry: ringGeometry)
			ringNode.eulerAngles.x = Float(10.degreesToRadians)
			planetNode.addChildNode(ringNode)
		}
		
		return parentNode
	}
	
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
}

extension Int {
	var degreesToRadians : CGFloat {
		return CGFloat(self) * .pi / 180
	}
}
