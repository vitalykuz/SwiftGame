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
    var gameOverLabel: SKLabelNode!
    var nameLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var scoreResultLabel: SKLabelNode!
    var yourBestLabel: SKLabelNode!
    var bestResultLabel: SKLabelNode!
    var playAgainButton: SKSpriteNode!

    override func didMove(to view: SKView) {
        setUpLabelsAndScores()
    }

    func setUpLabelsAndScores() {

        nameLabel = self.childNode(withName: "nameLabel") as? SKLabelNode

        nameLabel.text = GameValues.userName

        gameOverLabel = self.childNode(withName: "gameOverLabel") as? SKLabelNode

        scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode

        scoreResultLabel = self.childNode(withName: "scoreResultLabel") as? SKLabelNode

        bestResultLabel = self.childNode(withName: "bestResultLabel") as? SKLabelNode

        yourBestLabel = self.childNode(withName: "yourBestLabel") as? SKLabelNode

        playAgainButton = self.childNode(withName: "playAgainImage") as? SKSpriteNode

        setUpFont(for: nameLabel)
        setUpFont(for: gameOverLabel)
        setUpFont(for: scoreLabel)
        setUpFont(for: scoreResultLabel)
        setUpFont(for: yourBestLabel)
        setUpFont(for: bestResultLabel)


        if (GameValues.score > GameValues.bestScore) {
            GameValues.bestScore = GameValues.score
        }

        scoreResultLabel.text = String(GameValues.score)
        bestResultLabel.text = String(GameValues.bestScore)
    }

    func setUpFont(for label: SKLabelNode ) {
        label.fontName = "Chalkduster"
        label.fontSize = 70
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch:UITouch = touches.first! as UITouch
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)

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
                        //TO-DO add the option to choose the time when the game is over and need to start again
                        GameValues.timerCount = 20
                        GameValues.score = 0

                        view.presentScene(scene)

                    }
                    view.ignoresSiblingOrder = true
                }
            }
        }
    }
}
