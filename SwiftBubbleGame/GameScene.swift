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
import Foundation

class GameScene: SKScene {
	
	weak var viewController: MenuViewController!
    var gameOverScene: GameOverScene!

    //keeps the list of all bubbles images (textures) I have in assests folder
    var bubbleTextures = [SKTexture]()
    // the current bubble in list
    var currentBubbleTextureInArrayOfBubbles = 0
    var maximumNumber = 1
    var bubbles = [SKSpriteNode]()
    var timerLabel: SKLabelNode?
    var scoreLabel: SKLabelNode?
    var score: Int = 0
    var timer: Timer!
    var timerCount = 5
    var userName: String!

    override func didMove(to view: SKView) {

        bubbleTextures.append(SKTexture(imageNamed: "bubbleRed"))
        bubbleTextures.append(SKTexture(imageNamed: "bubblePink"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleGreen"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleBlue"))
        bubbleTextures.append(SKTexture(imageNamed: "bubbleGray"))

        //bubbleTextures.append(SKTexture(imageNamed: "bubbleCyan"))
        //bubbleTextures.append(SKTexture(imageNamed: "bubblePurple"))
        //bubbleTextures.append(SKTexture(imageNamed: "bubbleOrange"))


        //SKPhysicsBody is a new data type that stores physical shapes of things. The next line creates a wall that cannot be passed by bubbles
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        // sets the gravity to 0. By default objects fall down like in real world from the top
        physicsWorld.gravity = CGVector.zero


		for _ in 1...15 {
			generateBubbleWithProbability()
		}
		
		createLabels()

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func updateTimer() {
        if (timerCount == 0) {
            gameOver()
            return
        }
        timerCount -= 1
        timerLabel?.text = "Timer: \(timerCount)"
    }



    func gameOver() {
        timer.invalidate()

        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameOverScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill

                gameOverScene = scene as! GameOverScene
                gameOverScene.score = self.score
                gameOverScene.userName = self.userName
                // Present the scene
                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
	
	func createLabels() {

        timerLabel = self.childNode(withName: "timerLabel") as? SKLabelNode
        //creates a timer label
		timerLabel?.fontName = "Chalkduster"
		timerLabel?.fontSize = 45
		//timerLabel?.fontColor = SKColor.green

        //creates a score label
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel?.fontName = "Chalkduster"
        scoreLabel?.fontSize = 45
        scoreLabel?.text = "Score: \(score)"
        //scoreLabel?.fontColor = SKColor.green
		
	}

    func createBubble(with index: Int) {
        // 1. create a new Sprite node from the array of all images (textures)
        let bubble = SKSpriteNode(texture: bubbleTextures[index])
        bubble.name = String(index)
        print("Bubble name: \(String(describing: bubble.name))")

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

        calculateScore(node)

        node.physicsBody = nil
        node.name = nil

        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let scaleUp = SKAction.scale(by: 1.5, duration: 0.3)
        scaleUp.timingMode = .easeOut
        let group = SKAction.group([fadeOut, scaleUp])

        let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
        node.run(sequence)

        run(SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false))

    }

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

        if let name = touchedNode.name
        {
            if name == "timerLabel" || name == "scoreLabel"
            {
                touchedNode.isUserInteractionEnabled = false
            } else {
                pop(touchedNode as! SKSpriteNode)
                return
            }
        }
    }

    func generateBubbleWithProbability() {
		let number  =  randomNumber(probabilities: [0.4,0.3,0.15,0.10,0.05])
        createBubble(with: number)
    }

    // code was found on http://stackoverflow.com/questions/30309556/generate-random-numbers-with-a-given-distribution
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

    func calculateScore(_ node: SKSpriteNode) {

        if (node.name == "0") {
            score += 1
        } else if (node.name == "1") {
            score += 2
        } else if (node.name == "2") {
            score += 5
        } else if (node.name == "3") {
            score += 8
        } else if (node.name == "4") {
            score += 10
        }
        scoreLabel?.text = "Score: \(score)"
    }
}










