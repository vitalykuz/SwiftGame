//
//  GameScene.swift
//  SwiftBubbleGame
//
//  Created by Vitaly Kuzenkov on 21/4/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {

    //keeps the list of all bubbles images (textures) I have in assests folder
    var bubbleTextures = [SKTexture]()
    // the current bubble in list
    var currentBubbleImage = 0
    var maximumNumber = 1
    var bubbles = [SKSpriteNode]()
    var bubbleTimer = Timer()

    override func didMove(to view: SKView) {

        bubbleTextures.append(SKTexture(imageNamed: "bubbleRed"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleBlue"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleCyan"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleGray"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleGreen"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleOrange"))
        bubbleTextures.append(SKTexture(imageNamed: "bubblePink"))
        bubbleTextures.append(SKTexture(imageNamed: "bubblePurple"))

        //SKPhysicsBody is a new data type that stores physical shapes of things. The next line creates a wall that cannot be passed by bubbles
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        // sets the gravity to 0. By default objects fall down like in real world from the top
        physicsWorld.gravity = CGVector.zero

        for _ in 1...8 {
            createBubble()
        }

        bubbleTimer = Timer.scheduledTimer(timeInterval: 3, target: self,
                selector: #selector(createBubble), userInfo: nil, repeats: true)
    }

    func createBubble() {

        // 1. create a new Sprite node from the array of all images (textures)
        let bubble = SKSpriteNode(texture: bubbleTextures[currentBubbleImage])

        // 2. give the new bubble a string name
        bubble.name = String(maximumNumber)

        // 3. give it the position of z = 1, so that it appears above any background
        bubble.zPosition = 1

        // 4. create a label node with the current number
        let labelNode = SKLabelNode(fontNamed: "HelveticaNeue-Light")
        labelNode.text = bubble.name
        labelNode.color = UIColor.white
        labelNode.fontSize = 64

        // 5. Make te label center itself vertically and draw above the bubble
        labelNode.verticalAlignmentMode = .center
        labelNode.zPosition = 2

        // 6. add the label to the bubble, then the bubble to the game scene
        bubble.addChild(labelNode)
        addChild(bubble)

        // 7. add the new bubble to array of bubbles on screen to later use
        bubbles.append(bubble)

        // 8. make it appear somewhere randomly inside the game screen
        let xPosition = GKARC4RandomSource.sharedRandom().nextInt(upperBound: 800)
        let yPosition = GKARC4RandomSource.sharedRandom().nextInt(upperBound: 1300)

        bubble.position = CGPoint(x: xPosition, y: yPosition)

        let scale = CGFloat(GKRandomSource.sharedRandom().nextUniform())
        bubble.setScale(max(0.7, scale))

        bubble.alpha = 0
        bubble.run(SKAction.fadeIn(withDuration: 0.5))

        configurePhysics(for: bubble)
        nextBubble()
    }

    func nextBubble() {

        //move on to the next bubble texture
        currentBubbleImage += 1

        //if we've used all the bubble textures, start at the beginning
        if currentBubbleImage == bubbleTextures.count {
            currentBubbleImage = 0
        }

        //add a random number between 1 and 3 to maximumNumber
        maximumNumber += GKRandomSource.sharedRandom().nextInt(upperBound: 3) + 1

        //fix the mystery problem
        let strMaximumNumber = String(maximumNumber)

        if strMaximumNumber.characters.last! == "6" {
            maximumNumber += 1
        }

        if strMaximumNumber.characters.last! == "9" {
            maximumNumber += 1
        }
    }

    func configurePhysics(for bubble: SKSpriteNode) {

        bubble.physicsBody = SKPhysicsBody(circleOfRadius: bubble.size.width / 2)
        bubble.physicsBody?.linearDamping = 0.0
        bubble.physicsBody?.angularDamping = 0.0
        bubble.physicsBody?.restitution = 1.0
        bubble.physicsBody?.friction = 0.0

        //random number between -200 and 200
        let motionX = GKRandomSource.sharedRandom().nextInt(upperBound: 400) - 200
        let motionY = GKRandomSource.sharedRandom().nextInt(upperBound: 400) - 200

        //vector is a direction with attitude
        bubble.physicsBody?.velocity = CGVector(dx: motionX, dy: motionY)
        bubble.physicsBody?.angularVelocity = CGFloat(GKRandomSource.sharedRandom().nextUniform())
    }

    func pop(_ node: SKSpriteNode) {

        guard let index = bubbles.index(of: node) else {
            return
        }
        bubbles.remove(at: index)

        node.physicsBody = nil
        node.name = nil

        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let scaleUp = SKAction.scale(by: 1.5, duration: 0.3)
        scaleUp.timingMode = .easeOut
        let group = SKAction.group([fadeOut, scaleUp])

        let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
        node.run(sequence)

        run(SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false))

        if bubbles.count == 0 {
            bubbleTimer.invalidate()
        }

    }

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		// 1 - Choose one of the touches to work with
		guard let touch = touches.first else {
			return
		}
		let touchLocation = touch.location(in: self)
		
		//let clickedBubble = nodes(at: touchLocation)
		

		        let clickedNodes = nodes(at: touchLocation).filter {
		            $0.name != nil
		        }
		
		        //make sure at least one clicked node remains
		        guard clickedNodes.count != 0 else {
		            return
		        }
		
		        //find the lowest-numbered bubble on the screen
		        let lowestBubble = bubbles.min {
		            Int($0.name!)! < Int($1.name!)!
		        }
		        guard let bestNumber = lowestBubble?.name else {
		            return
		        }
		
		        //go through all nodes the user clicked to see if any of them is the best number
		        for node in clickedNodes {
		            if node.name == bestNumber {
		                //they were correct - pop the bubble!
		                pop(node as! SKSpriteNode)
		
		                //exit the method so we don't create new bubbles
		                return
		            }
		        }
		//if we're still here it means they were incorrect; create two penalty bubbles
		        createBubble()
		        createBubble()
	}
	
}












