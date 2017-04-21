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
	var arrayOfAllBubblesImages = [SKTexture]()
	// the current bubble in list
	var currentBubbleImage = 0
	var maximumNumber = 1
	var arrayOfBubblesOnScreen = [SKSpriteNode]()
	
    override func didMove(to view: SKView) {
		
		arrayOfAllBubblesImages.append(SKTexture (imageNamed: "bubbleRed"))
		arrayOfAllBubblesImages.append(SKTexture (imageNamed: "bubbleBlue"))
		arrayOfAllBubblesImages.append(SKTexture (imageNamed: "bubbleCyan"))
		arrayOfAllBubblesImages.append(SKTexture (imageNamed: "bubbleGrey"))
		arrayOfAllBubblesImages.append(SKTexture (imageNamed: "bubbleGreen"))
		arrayOfAllBubblesImages.append(SKTexture (imageNamed: "bubbleOrange"))
		arrayOfAllBubblesImages.append(SKTexture (imageNamed: "bubblePink"))
		arrayOfAllBubblesImages.append(SKTexture (imageNamed: "bubblePurple"))

        for _ in 1...5 {
            createBubble()
        }
	}
    
    func createBubble(){

		// 1. create a new Sprite node from the array of all images (textures)
		let bubble = SKSpriteNode(texture: arrayOfAllBubblesImages[currentBubbleImage])

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
        arrayOfBubblesOnScreen.append(bubble)

        // 8. make it appear somewhere randomly inside the game screen
        let xPosition = GKARC4RandomSource.sharedRandom().nextInt(upperBound: 800)
        let yPosition = GKARC4RandomSource.sharedRandom().nextInt(upperBound: 1300)

        bubble.position = CGPoint(x: xPosition, y: yPosition)
	}
}











