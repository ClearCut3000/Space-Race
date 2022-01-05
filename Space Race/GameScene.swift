//
//  GameScene.swift
//  Space Race
//
//  Created by Николай Никитин on 05.01.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  //MARK: - Properties
  var starfield: SKEmitterNode!
  var player: SKSpriteNode!
  var scoreLabel: SKLabelNode!
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }

  //MARK: - Scene
    override func didMove(to view: SKView) {
      backgroundColor = .black
      starfield = SKEmitterNode(fileNamed: "starfield")!
      starfield.position = CGPoint(x: 1024, y: 384)
      starfield.advanceSimulationTime(10)
      addChild(starfield)
      starfield.zPosition = -1

      player = SKSpriteNode(imageNamed: "player")
      player.position = CGPoint(x: 100, y: 384)
      player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
      player.physicsBody?.contactTestBitMask = 1
      addChild(player)

      scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
      scoreLabel.position = CGPoint(x: 16, y: 16)
      scoreLabel.horizontalAlignmentMode = .left
      addChild(scoreLabel)

      score = 0

      physicsWorld.gravity = .zero
      physicsWorld.contactDelegate = self
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
