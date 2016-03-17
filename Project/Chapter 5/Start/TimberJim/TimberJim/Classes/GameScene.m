//
//  GameScene.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/11/16.
//  Copyright (c) 2016 Jeremy Novak. All rights reserved.
//

#import "GameScene.h"
#import "Clouds.h"
#import "Birds.h"
#import "StackController.h"
#import "Player.h"

#pragma mark - Class Private Interface
@interface GameScene() <SKPhysicsContactDelegate>

// Scene member variables
@property NSTimeInterval lastUpdateTime;

// Node member variables
@property Clouds *clouds;
@property Birds *birds;
@property StackController *stackController;
@property Player *player;

@end

#pragma mark - Class Implementation
@implementation GameScene

#pragma mark - Init
-(instancetype)initWithSize:(CGSize)size {
    
    if ((self = [super initWithSize:size])) {
        
        [self setupScene];
    }
    
    return self;
}


#pragma mark - Setup
-(void)setupScene {
    self.physicsWorld.contactDelegate = self;
    
    self.lastUpdateTime = 0.0;
    
    self.clouds = [[Clouds alloc] init];
    [self addChild:self.clouds];
    
    self.birds = [[Birds alloc] init];
    [self addChild:self.birds];
    
    SKSpriteNode *forest = [[GameTextures sharedInstance] spriteWithName:FOREST];
    forest.anchorPoint = CGPointZero;
    forest.position = CGPointZero;
    [self addChild:forest];
    
    self.stackController = [[StackController alloc] init];
    [self addChild:self.stackController];
    
    self.player = [[Player alloc] init];
    [self addChild:self.player];
}

#pragma mark - Touch Handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    
    if (touchLocation.x > ScreenSize().width / 2) {
        [self.player chopRight];
        [self.stackController moveStack];
    } else if (touchLocation.x < ScreenSize().width / 2) {
        [self.player chopLeft];
        [self.stackController moveStack];
    }
    
}


#pragma mark - Update
-(void)update:(NSTimeInterval)currentTime {
    // Calculate "Delta"
    NSTimeInterval delta = currentTime - self.lastUpdateTime;
    self.lastUpdateTime = currentTime;
    
    [self.clouds update:delta];
    
    [self.birds update:delta];
    
//    [self.stackController update:delta];
}


#pragma mark - Contact
-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *other = contact.bodyA.categoryBitMask == ContactPlayer ? contact.bodyB : contact.bodyA;
    
    if (other.categoryBitMask == ContactBranch) {
        [self.player gameOver];
    }
}

@end
