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
    var currentBubbleTextureInArrayOfBubbles = 0
    var maximumNumber = 1
    var bubbles = [SKSpriteNode]()
    var bubbleTimer = Timer()
	var count0 = 0, count1 = 0, count2 = 0, count3 = 0, count4 = 0, countDefault  = 0

    override func didMove(to view: SKView) {

        bubbleTextures.append(SKTexture(imageNamed: "bubbleRed"))
        bubbleTextures.append(SKTexture(imageNamed: "bubblePink"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleGreen"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleBlue"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleOrange"))

        //bubbleTextures.append(SKTexture(imageNamed: "bubbleCyan"))
        //bubbleTextures.append(SKTexture(imageNamed: "bubblePurple"))
        //bubbleTextures.append(SKTexture(imageNamed: "bubbleGray"))


        //SKPhysicsBody is a new data type that stores physical shapes of things. The next line creates a wall that cannot be passed by bubbles
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        // sets the gravity to 0. By default objects fall down like in real world from the top
        physicsWorld.gravity = CGVector.zero

//        for _ in 1...8 {
//            createBubble()
//        }

		for _ in 1...15 {
			generateBubbleWithProbability()
		}

//        for _ in 1...100 {
//            let number  =  randomNumber(probabilities: [0.4,0.3,0.15,0.10,0.05])
//            print(number);
//        }


//        bubbleTimer = Timer.scheduledTimer(timeInterval: 3, target: self,
//                selector: #selector(createBubble), userInfo: nil, repeats: true)
    }

    func createBubble(with index: Int) {
        // 1. create a new Sprite node from the array of all images (textures)
        let bubble = SKSpriteNode(texture: bubbleTextures[index])

        // 3. give it the position of z = 1, so that it appears above any background
        bubble.zPosition = 1

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
    }

    func createBubble() {

        // 1. create a new Sprite node from the array of all images (textures)
        let bubble = SKSpriteNode(texture: bubbleTextures[currentBubbleTextureInArrayOfBubbles])

        // 3. give it the position of z = 1, so that it appears above any background
        bubble.zPosition = 1

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
        //nextBubble()
    }

    func nextBubble() {

        //move on to the next bubble texture
        currentBubbleTextureInArrayOfBubbles += 1

        //if we've used all the bubble textures, start at the beginning
        if currentBubbleTextureInArrayOfBubbles == bubbleTextures.count {
            currentBubbleTextureInArrayOfBubbles = 0
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

        //go through all nodes the user clicked to see if any of them is the best number
        for node in clickedNodes {
                pop(node as! SKSpriteNode)
                return
        }
    }

    func randomPermille() -> Int {
        return Int(arc4random_uniform(1000))
    }


    func generateBubbleWithProbability() {

		let number  =  randomNumber(probabilities: [0.4,0.3,0.15,0.10,0.05])
		print(number);

        createBubble(with: number)
//        switch (number) {
//        case 0:
//			count0 += 1
//            print("Red bubble: \(count0)")
//            createBubble(with: number)
//		case 1:
//            count1 += 1
//            print("Pink bubble:  \(count1)")
//        case 2:
//            count2 += 1
//            print("Green: \(count2)")
//        case 3:
//            count3 += 1
//            print("Blue: \(count3)")
//		case 4:
//			count4 += 1
//			print("Black: \(count4)")
//        default:
//            countDefault += 1
//            print("Default \(countDefault)")
//        }
    }

    func randomNumber(probabilities: [Double]) -> Int {

        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
    }
}










