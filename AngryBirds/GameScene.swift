//
//  GameScene.swift
//  AngryBirds
//
//  Created by Bünyamin Kılıçer on 9.11.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var wall = SKSpriteNode()
    var bricks = [SKSpriteNode]()
    
    var gameStarted = false
    var birdStartPosition = CGPoint()
    
    override func didMove(to view: SKView) {
        
        

        //backgroundPicture
        let backgroundTexture = SKTexture(imageNamed: "background")
        self.background = SKSpriteNode(texture: backgroundTexture)
        self.background.position = CGPoint(x: 0, y: 0)
        self.background.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.background.zPosition = -1
        self.addChild(self.background)
        
        //bird
        let birdTexture = SKTexture(imageNamed: "bird")
        self.bird = SKSpriteNode(texture: birdTexture)
        self.bird.position = CGPoint(x: -self.frame.width / 3.5, y:  -self.frame.height / (5))
        self.bird.size = CGSize(width: self.frame.width / 10 , height: self.frame.height / 6)
        self.bird.zPosition = 1
            //Physics
        self.bird.physicsBody = SKPhysicsBody(circleOfRadius: self.bird.size.height / (3.14))
        self.bird.physicsBody?.affectedByGravity = false
        self.bird.physicsBody?.isDynamic = true
        self.bird.physicsBody?.mass = 0.15
        self.bird.physicsBody?.allowsRotation = true
        self.bird.physicsBody?.accessibilityFrame = frame
        self.addChild(self.bird)
        self.birdStartPosition = self.bird.position
        
        //wall
        let wallTexture = SKTexture(imageNamed: "wall")
        self.wall = SKSpriteNode(texture: wallTexture)
        self.wall.position = CGPoint(x: -self.frame.width / 3.5, y: -self.frame.height / (3.5))
        self.wall.size = CGSize(width: self.frame.width / 14, height: self.frame.height / 2.5)
        self.wall.zPosition = 0
        self.addChild(self.wall)
        
        //bricks
        let brickTexture = SKTexture(imageNamed: "brick")
        for i in 0...2{
            self.bricks.append(SKSpriteNode(texture: brickTexture))
            self.bricks[i].size = CGSize(width: 100, height: 100)
            let brickHeightPosition = -self.frame.height / Double(2 + (Double(i+3)/Double(10))) + Double(i*90)
            let brickWidthPosition = self.frame.width / Double(3)
            self.bricks[i].position = CGPoint(x: brickWidthPosition, y: brickHeightPosition)
            self.bricks[i].zPosition = 1
            
            //Physics
            self.bricks[i].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
            self.bricks[i].physicsBody?.isDynamic = true
            self.bricks[i].physicsBody?.affectedByGravity = true
            self.bricks[i].physicsBody?.allowsRotation = true
            self.bricks[i].physicsBody?.mass = 0.1
            print(frame.maxX,frame.maxY,frame.height,frame.width)
            self.bricks[i].physicsBody?.accessibilityFrame = frame
            
            self.addChild(self.bricks[i])
        }
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
                    
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.gameStarted == false{
            if let touch = touches.first{
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false{
                    for node in touchNodes{
                        if let sprite = node as? SKSpriteNode{
                            if sprite == self.bird{
                                self.bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
        //self.bird.physicsBody?.affectedByGravity = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.gameStarted == false{
            if let touch = touches.first{
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false{
                    for node in touchNodes{
                        if let sprite = node as? SKSpriteNode{
                            if sprite == self.bird{
                                if touchLocation.x < self.birdStartPosition.x{
                                    self.bird.position = touchLocation
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.gameStarted == false{
            if let touch = touches.first{
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false{
                    for node in touchNodes{
                        if let sprite = node as? SKSpriteNode{
                            if sprite == self.bird{
                                
                                let dx = -(touchLocation.x - self.birdStartPosition.x)
                                let dy = -(touchLocation.y - self.birdStartPosition.y)
                                
                                let impulse = CGVector(dx: dx, dy: dy)
                                
                                self.bird.physicsBody?.affectedByGravity = true
                                self.bird.physicsBody?.applyImpulse(impulse)
                                
                                self.gameStarted = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if gameStarted == true{
            if let birdPhysics = self.bird.physicsBody {
                if birdPhysics.velocity.dx <= 0.1 && birdPhysics.velocity.dy <= 0.1 && birdPhysics.angularVelocity <= 0.1{
                    self.bird.position = self.birdStartPosition
                    birdPhysics.affectedByGravity = false
                    birdPhysics.velocity = CGVector(dx: 0, dy: 0)
                    self.bird.zPosition = 1
                    self.gameStarted = false
                }
            }
        }
        print(bricks[2].position.x, bricks[2].position.y)

        // Called before each frame is rendered
    }
}
