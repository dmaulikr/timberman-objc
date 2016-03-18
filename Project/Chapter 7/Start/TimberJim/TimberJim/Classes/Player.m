//
//  Player.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/17/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "Player.h"
#import "Smoke.h"

@interface Player()

@property CGPoint leftSide;
@property CGPoint rightSide;

@property SKAction *animationIdle;
@property SKAction *animationChop;

@property int taps;

@end


@implementation Player

#pragma mark - Init
-(instancetype)init {
    if ((self = [super init])) {
        SKTexture *texture = [[GameTextures sharedInstance] textureWithName:PLAYER0];
        self = [Player spriteNodeWithTexture:texture];
        
        [self setupPlayer];
        [self setupAnmations];
        [self setupPhysics];
    }
    
    return self;
}

#pragma mark - Setup
-(void)setupPlayer {
    self.leftSide = CGPointMake(ScreenSize().width * 0.22, ScreenSize().height * 0.27);
    self.rightSide = CGPointMake(ScreenSize().width * 0.78, ScreenSize().height * 0.27);
    
    self.position = self.leftSide;
}

-(void)setupAnmations {
    SKTexture *frame0 = [[GameTextures sharedInstance] textureWithName:PLAYER0];
    SKTexture *frame1 = [[GameTextures sharedInstance] textureWithName:PLAYER1];
    SKTexture *frame2 = [[GameTextures sharedInstance] textureWithName:PLAYER2];
    
    self.animationIdle = [SKAction animateWithTextures:@[frame0, frame1] timePerFrame:0.25];
    
    self.animationChop = [SKAction animateWithTextures:@[frame2] timePerFrame:0.032];
    
    [self runAction:[SKAction repeatActionForever:self.animationIdle]];
}


-(void)setupPhysics {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height / 3];
    self.physicsBody.categoryBitMask = ContactPlayer;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = ContactBranch;
    self.physicsBody.affectedByGravity = NO;
}

#pragma mark - Actions
-(void)chopLeft {
    self.taps++;
    
    self.position = self.leftSide;
    
    self.xScale = 1;
    
    [self runAction:self.animationChop];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"Chop.caf"];
}

-(void)chopRight {
    self.taps++;
    
    self.position = self.rightSide;
    
    self.xScale = -1;
    
    [self runAction:self.animationChop];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"Chop.caf"];
}

#pragma mark - Get Taps
-(int)getTaps {
    return self.taps;
}

#pragma mark - Animation
-(void)animateSmoke {
    Smoke *smoke = [[Smoke alloc] init];
    
    [self addChild:smoke];
    
    [smoke animateSmoke];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"GameOver.caf"];
}

#pragma mark - Game Over
-(void)gameOver {
    [self removeAllActions];
    
    SKTexture *texture = [[GameTextures sharedInstance] textureWithName:TOMBSTONE];
    
    if (self.position.x > ScreenSize().width / 2) {
        self.texture = texture;
        self.xScale = -1;
    } else {
        self.texture = texture;
    }
    
    [self animateSmoke];
}

@end
