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
	
	@IBOutlet var mainBackgroundImage: UIImageView!
	@IBOutlet var settingsView: UIView!
	@IBOutlet var mainView: SKView!
	var currentGame: GameScene!
    var gameOverScene: GameOverScene!

	@IBOutlet var nameTextField: UITextField!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var playButton: UIButton!
	@IBOutlet var statButton: UIButton!
	@IBOutlet var settingsButton: UIButton!
	@IBOutlet var gameTimeLabel: UILabel!
	@IBOutlet var numberOfBubblesLabel: UILabel!
	@IBOutlet var gameSlider: UISlider!
	@IBOutlet var bubblesSlider: UISlider!
	

	
	@IBAction func okSettingButtonClicked(_ sender: Any) {
        GameValues.maxNumberOfBubbles = Int(bubblesSlider.value)
        print("Number of bubbles in game values: \(GameValues.maxNumberOfBubbles)")
        numberOfBubblesLabel.text = "Bubbles in game: \(Int(bubblesSlider.value))"

        GameValues.timerCount = Int(gameSlider.value)
        print("game seconds in game values: \(GameValues.gameSeconds)")
        gameTimeLabel.text = "Game time: \(Int((gameSlider.value)))"

        settingsView.isHidden = true
	}
	
	@IBAction func gameSliderChangedValue(_ sender: Any) {
        gameTimeLabel.text = "Game time: \(Int((gameSlider.value)))"

	}

	@IBAction func bubblesSliderChangedValue(_ sender: Any) {
        numberOfBubblesLabel.text = "Bubbles in game: \(Int(bubblesSlider.value))"
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self;
        self.title = "menuView"
        settingsView.isHidden = true
    }

	@IBAction func settingsButtonClicked(_ sender: Any) {
        settingsView.isHidden = false
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
                mainBackgroundImage.alpha = 0.3

                //TO_DO: check if name is not empty
                GameValues.userName = nameTextField.text!
				
				// Present the scene
				view.presentScene(scene)

			}
			
			view.ignoresSiblingOrder = true
		}

        self.settingsButton.isHidden = true
        self.statButton.isHidden = true

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
