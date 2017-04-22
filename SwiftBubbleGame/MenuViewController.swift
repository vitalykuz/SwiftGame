//
//  MenuViewController.swift
//  SwiftBubbleGame
//
//  Created by Vitaly Kuzenkov on 21/4/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MenuViewController: UIViewController, UITextFieldDelegate {
	
	var currentGame: GameScene!
	@IBOutlet var nameTextField: UITextField!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var playButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
		
		

        self.nameTextField.delegate = self;
	
		
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

	@IBAction func nextSceneButtonClicked(_ sender: Any) {
		if let view = self.view as! SKView? {
			// Load the SKScene from 'GameScene.sks'
			if let scene = SKScene(fileNamed: "GameScene") {
				// Set the scale mode to scale to fit the window
				scene.scaleMode = .aspectFill
				
				// Present the scene
				view.presentScene(scene)
				currentGame = scene as! GameScene
				currentGame.viewController = self
			}
			
			view.ignoresSiblingOrder = true
			
			view.showsFPS = true
			view.showsNodeCount = true
		}
		
		self.nameTextField.isHidden = true
		self.playButton.isHidden = true
		self.nameLabel.isHidden = true
	}

	
	
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
