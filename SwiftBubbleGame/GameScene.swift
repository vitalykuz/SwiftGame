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

struct GameValues {
	static var score: Double = 0;
	static var bestScore: Double = 0;
	static var userName: String = "";
    static var gameSeconds: Int! = 60
    static var timerCount: Int = 10
    static var maxNumberOfBubbles: Int = 15
}

class GameScene: SKScene {
	
	weak var viewController: MenuViewController!
    var gameOverScene: GameOverScene!

    //keeps the list of all bubbles images (textures) I have in assests folder
    var bubbleTextures = [SKTexture]()

    var bubbles = [SKSpriteNode]()
    var timerLabel: SKLabelNode?
    var scoreLabel: SKLabelNode?
    var highScoreLabel: SKLabelNode?
    var timer: Timer!


	var currentlyClickedBubbleName = ""
	var comboMultiplication: Double = 1;
    var numberOfTheSameBubblesClicked = 0
	

    override func didMove(to view: SKView) {
        //print("User name in Game: \(userName)")

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


		createRandomBubbles(maxNumberOfBubbles: GameValues.maxNumberOfBubbles)
		
		createLabels()

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    func updateTimer() {
        if (GameValues.timerCount == 0) {
            gameOver()
            return
        }
        GameValues.timerCount -= 1

        if (GameValues.score >= GameValues.bestScore) {
            highScoreLabel?.text = "High Score: \(GameValues.score)"
        }
        timerLabel?.text = "Timer: \(GameValues.timerCount)"

        removeBubbleFromScreen()
        createRandomBubbles(maxNumberOfBubbles: GameValues.maxNumberOfBubbles)
    }

    func removeBubbleFromScreen() {
		
		let diceRoll = Int(arc4random_uniform(UInt32(bubbles.count)))
		print("Random number of bubbles to remove: \(diceRoll)")
		for _ in 0...diceRoll {
            if(bubbles.count > 0) {
                let randomIndex = Int(arc4random_uniform(UInt32(bubbles.count - 1)))
                let randomBubble = bubbles[randomIndex]

                randomBubble.removeFromParent()


                bubbles.remove(at: randomIndex)
            }
		}
    }

    func createRandomBubbles(maxNumberOfBubbles: Int) {

        let diceRoll = Int(arc4random_uniform(UInt32(maxNumberOfBubbles - bubbles.count)))
		
        for _ in 0...diceRoll {
            generateBubbleWithProbability()
        }
		print("How many bubbles to create? \(diceRoll)")

    }

    func gameOver() {
        timer.invalidate()

        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameOverScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill

                gameOverScene = scene as! GameOverScene


                // Present the scene
                view.presentScene(scene)
            }

            view.ignoresSiblingOrder = true
        }
    }
	
	func createLabels() {

        timerLabel = self.childNode(withName: "timerLabel") as? SKLabelNode
        //creates a timer label
		timerLabel?.fontName = "Chalkduster"
		timerLabel?.fontSize = 45
        timerLabel?.text = "Timer: \(GameValues.timerCount)"
		//timerLabel?.fontColor = SKColor.green

        //creates a score label
        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        scoreLabel?.fontName = "Chalkduster"
        scoreLabel?.fontSize = 45
        scoreLabel?.text = "Score: \(GameValues.score)"
        //scoreLabel?.fontColor = SKColor.green

        highScoreLabel = self.childNode(withName: "highScoreLabel") as? SKLabelNode
        highScoreLabel?.fontName = "Chalkduster"
        highScoreLabel?.fontSize = 45
        highScoreLabel?.text = "High Score: \(GameValues.bestScore)"
	}

    func createBubble(with index: Int) {
        //print("I am in create bubble")

        // 1. create a new Sprite node from the array of all images (textures)
        let bubble = SKSpriteNode(texture: bubbleTextures[index])
        bubble.name = String(index)
        //print("Bubble name: \(bubble.name)")

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
        //print("I am in configu physics")

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
            if name == "timerLabel" || name == "scoreLabel" || name == "highScoreLabel"
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
			calculateCombo(node)
            GameValues.score += 1 * comboMultiplication
        } else if (node.name == "1") {
            calculateCombo(node)
            GameValues.score += 2 * comboMultiplication
        } else if (node.name == "2") {
			calculateCombo(node)
            GameValues.score += 5 * comboMultiplication
        } else if (node.name == "3") {
			calculateCombo(node)
            GameValues.score += 8 * comboMultiplication
        } else if (node.name == "4") {
			calculateCombo(node)
            GameValues.score += 10 * comboMultiplication
        }
        scoreLabel?.text = "Score: \(GameValues.score)"
    }

    func calculateCombo(_ node: SKSpriteNode) {
        if currentlyClickedBubbleName == node.name {
            comboMultiplication = 1.5;
            numberOfTheSameBubblesClicked += 1
            if (numberOfTheSameBubblesClicked >= 2) {
                run(SKAction.playSoundFileNamed("Unstoppable.mp3", waitForCompletion: false))
            }
        } else {
            comboMultiplication = 1;
            numberOfTheSameBubblesClicked = 0
        }
        currentlyClickedBubbleName = node.name!
    }
}










