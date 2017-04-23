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
    var gameOverScene: GameOverScene!
    var userName: String!
	@IBOutlet var nameTextField: UITextField!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var playButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self;
    }

	@IBAction func settingsButtonClicked(_ sender: Any) {
		let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
		
//		alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
//			switch action.style{
//			case .Default:
//				print("default")
//				
//			case .Cancel:
//				print("cancel")
//				
//			case .Destructive:
//				print("destructive")
//			}
//		}))
	}
	
	@IBAction func statButtonClicked(_ sender: Any) {
		
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

                currentGame = scene as! GameScene
                currentGame.viewController = self

                //TO_DO: check if name is not empty
                userName = nameTextField.text
                print("User name in controller: \(userName)")
                currentGame.userName = userName

				// Present the scene
				view.presentScene(scene)

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
