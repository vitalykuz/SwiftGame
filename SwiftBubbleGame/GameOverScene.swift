//
//  GameOverScene.swift
//  SwiftBubbleGame
//
//  Created by Vitaly Kuzenkov on 23/4/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    var currentGame: GameScene!

    public var score: Int = 0
    var bestScore: Int = 0

    var gameOverLabel: SKLabelNode!
    var nameLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var scoreResultLabel: SKLabelNode!
    var yourBestLabel: SKLabelNode!
    var bestResultLabel: SKLabelNode!
    var playAgainButton: SKSpriteNode!

    var userName: String!

    override func didMove(to view: SKView) {
        setUpLabelsAndScores()

        //timerLabel = self.childNode(withName: "timerLabel") as? SKLabelNode

    }

    func setUpLabelsAndScores() {
        nameLabel = self.childNode(withName: "nameLabel") as? SKLabelNode
        // print("Name in game over in controller: \(viewController.nameLabel.text) ")
        nameLabel.text = userName

        gameOverLabel = self.childNode(withName: "gameOverLabel") as? SKLabelNode

        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode

        scoreResultLabel = self.childNode(withName: "scoreResultLabel") as? SKLabelNode

        bestResultLabel = self.childNode(withName: "bestResultLabel") as? SKLabelNode

        yourBestLabel = self.childNode(withName: "yourBestLabel") as? SKLabelNode

        playAgainButton = self.childNode(withName: "playAgainImage") as? SKSpriteNode
        //playAgainButton.name = "playAgainButton"

        setUpFont(for: nameLabel)
        setUpFont(for: gameOverLabel)
        setUpFont(for: scoreLabel)
        setUpFont(for: scoreResultLabel)
        setUpFont(for: yourBestLabel)
        setUpFont(for: bestResultLabel)


        if (score > bestScore) {
            bestScore = score
        }

        scoreResultLabel.text = String(score)
        bestResultLabel.text = String(bestScore)
    }

    func setUpFont(for label: SKLabelNode ) {
        label.fontName = "Chalkduster"
        label.fontSize = 70
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

//        if let name = touchedNode.name {
//            if name == "playAgainButton" {
//                print("Play again clicked")
//            }
//        }

        if let name = touchedNode.name
        {
            if name == "playAgainButton"
            {
                if let view = self.view {
                    // Load the SKScene from 'GameScene.sks'
                    if let scene = SKScene(fileNamed: "GameScene") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill

                        currentGame = scene as! GameScene

                        // Present the scene
                        view.presentScene(scene)

                    }

                    view.ignoresSiblingOrder = true

                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
}
