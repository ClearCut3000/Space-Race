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
  var wavesLabel: SKLabelNode!
  var enemiesLeftLabel: SKLabelNode!
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  var possibleEnemies = ["ball", "hammer", "tv"]
  var gameTimer: Timer?
  var isGameOver = false
  var currentPlayerPosition = CGPoint(x: 100, y: 384)
  var enemies = 20 {
    didSet {
      enemiesLeftLabel.text = "Enemies left: \(enemies)"
    }
  }
  var timeInterval = 1.0
  var waveCount = 10 {
    didSet {
      wavesLabel.text = "Wave: \(waveCount)"
    }
  }

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

    enemiesLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
    enemiesLeftLabel.position = CGPoint(x: 250, y: 16)
    enemiesLeftLabel.horizontalAlignmentMode = .left
    addChild(enemiesLeftLabel)

    wavesLabel = SKLabelNode(fontNamed: "Chalkduster")
    wavesLabel.position = CGPoint(x: 600, y: 16)
    wavesLabel.horizontalAlignmentMode = .left
    addChild(wavesLabel)

    score = 0
    enemies = 20
    waveCount = 10

    //Worlds physics
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self

    //Timer
    setGameTimer(with: timeInterval)
  }

  //MARK: - UI Methods
  func setGameTimer(with timeInterval: Double) -> Timer? {
    if (gameTimer?.isValid) != nil {
      gameTimer?.invalidate()
      print ("Game timer has been updated with timeInterval \(timeInterval)")
    }
    gameTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    return gameTimer
  }

  @objc func createEnemy(){
    guard let enemy = possibleEnemies.randomElement() else { return }
    let sprite = SKSpriteNode(imageNamed: enemy)
    sprite.name = "enemy"
    sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
    addChild(sprite)
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.categoryBitMask = 1
    sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
    sprite.physicsBody?.angularVelocity = 5
    sprite.physicsBody?.linearDamping = 0
    sprite.physicsBody?.angularDamping = 0
    enemies -= 1
    if enemies <= 0 {
      if timeInterval > 0.1 {
        timeInterval -= 0.1
        enemies = 20
        waveCount -= 1
        setGameTimer(with: timeInterval)
      } else {
        gameTimer?.invalidate()
        player.position = CGPoint(x: 512, y: 384)
        scoreLabel.text = "Congratulations"
        wavesLabel.text = "you have passed"
        enemiesLeftLabel.text = "the game!"
      }
    }
  }

  override func update(_ currentTime: TimeInterval) {
    for node in children {
      if node.name == "enemy" && node.position.x < 1 {
        let dismiss = SKEmitterNode(fileNamed: "dismiss")!
        dismiss.position = node.position
        addChild(dismiss)
        node.removeFromParent()
        if !isGameOver {
          score += 1
        } else if isGameOver { score = 0 }
      }
    }
  }

  //MARK: - Touches methods
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    var location = touch.location(in: self)
    if nodes(at: location).contains(player) {
      if location.y < 100 {
        location.y = 100
      } else if location.y > 668 {
        location.y = 668
      }
      player.position = location
      currentPlayerPosition = player.position
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    player.position = currentPlayerPosition
  }

  //MARK: - Contact methods
  func didBegin(_ contact: SKPhysicsContact) {
    let explosion = SKEmitterNode(fileNamed: "explosion")!
    explosion.position = player.position
    addChild(explosion)
    player.removeFromParent()
    isGameOver = true
    gameTimer?.invalidate()
    print ("timeInterval \(timeInterval)")
  }
}
