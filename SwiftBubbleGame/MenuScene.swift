//
//  MenuScene.swift
//  SwiftBubbleGame
//
//  Created by Vitaly Kuzenkov on 22/4/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
	
	

	override func didMove(to view: SKView) {
		/* Setup your scene here */
		self.backgroundColor = SKColor(red: 0.15, green:0.15, blue:0.3, alpha: 1.0)
		let button = SKSpriteNode(imageNamed: "Spaceship.png")
		button.name = "spaceship"
		
		self.addChild(button)

		//let label = self.childNode(withName: "label") as? SKLabelNode

		setupLabel()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		// 1 - Choose one of the touches to work with
		guard let touch = touches.first else {
			return
		}
		let touchLocation = touch.location(in: self)
		//let clickedBubble = nodes(at: touchLocation)
		let node = atPoint(touchLocation)

		// If next button is touched, start transition to second scene
		if (node.name == "spaceship") {
			let secondScene = GameScene(size: self.size)
			let transition = SKTransition.flipVertical(withDuration: 1.0)
			secondScene.scaleMode = SKSceneScaleMode.aspectFill
			self.scene!.view?.presentScene(secondScene, transition: transition)
		}
	}
	
	func setupLabel() {
		let label = self.childNode(withName: "label") as? SKLabelNode

		label?.fontName = "Chalkduster"
		label?.text = "You Win!"
		label?.fontSize = 65
		label?.fontColor = SKColor.green

	}
}
