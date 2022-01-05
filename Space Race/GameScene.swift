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
  var possibleEnemies = ["ball", "hummer", "tv"]
  var gameTimer: Timer?
  var isGameOver = false

  //MARK: - Scene
    override func didMove(to view: SKView) {
      //Background
      backgroundColor = .black
      starfield = SKEmitterNode(fileNamed: "starfield")!
      starfield.position = CGPoint(x: 1024, y: 384)
      starfield.advanceSimulationTime(10)
      addChild(starfield)
      starfield.zPosition = -1

      //Player
      player = SKSpriteNode(imageNamed: "player")
      player.position = CGPoint(x: 100, y: 384)
      player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
      player.physicsBody?.contactTestBitMask = 1
      addChild(player)

      //Score label
      scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
      scoreLabel.position = CGPoint(x: 16, y: 16)
      scoreLabel.horizontalAlignmentMode = .left
      addChild(scoreLabel)

      score = 0

      //Worlds physics
      physicsWorld.gravity = .zero
      physicsWorld.contactDelegate = self

      gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }

  //MARK: - UI Methods
  @objc func createEnemy(){
    guard let enemy = possibleEnemies.randomElement() else { return }
    let sprite = SKSpriteNode(imageNamed: enemy)
    sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
    addChild(sprite)
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.categoryBitMask = 1
    sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
    sprite.physicsBody?.angularVelocity = 5
    sprite.physicsBody?.linearDamping = 0
    sprite.physicsBody?.angularDamping = 0
  }
    
    override func update(_ currentTime: TimeInterval) {
      for node in children {
        if node.position.x < -300 {
          node.removeFromParent()
        }
      }
      if !isGameOver {
        score += 1
      }
    }
}
