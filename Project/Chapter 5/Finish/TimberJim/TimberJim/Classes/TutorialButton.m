//
//  TutorialButton.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/17/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "TutorialButton.h"

@interface TutorialButton()

@property SKSpriteNode *leftTap;
@property SKSpriteNode *rightTap;

@property CGPoint startLeftTapPosition;
@property CGPoint endLeftTapPosition;
@property CGPoint startRightTapPosition;
@property CGPoint endRightTapPosition;

@end

@implementation TutorialButton

#pragma mark - Init
-(instancetype)init {
    if ((self = [super init])) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Setup
-(void)setup {
    self.leftTap = [[GameTextures sharedInstance] spriteWithName:TAPLEFT];
    self.rightTap = [[GameTextures sharedInstance] spriteWithName:TAPRIGHT];
    
    self.startLeftTapPosition = CGPointMake(0 - self.leftTap.size.width, ScreenSize().height * 0.2);
    self.endLeftTapPosition = CGPointMake(ScreenSize().width * 0.15, ScreenSize().height * 0.2);
    self.startRightTapPosition = CGPointMake(ScreenSize().width + self.rightTap.size.width, ScreenSize().height * 0.2);
    self.endRightTapPosition = CGPointMake(ScreenSize().width * 0.85, ScreenSize().height * 0.2);
    
    self.leftTap.position = self.startLeftTapPosition;
    self.rightTap.position = self.startRightTapPosition;
    
    [self addChild:self.leftTap];
    [self addChild:self.rightTap];
}

#pragma mark - Animations
-(void)animateIn {
    SKAction *leftAction = [SKAction moveTo:self.endLeftTapPosition duration:0.5];
    SKAction *rightAction = [SKAction moveTo:self.endRightTapPosition duration:0.5];
    
    [self.leftTap runAction:leftAction];
    [self.rightTap runAction:rightAction];
    
    SKAction *scaleUp = [SKAction scaleTo:1.1 duration:0.25];
    SKAction *scaleNormal = [SKAction scaleTo:1.0 duration:0.25];
    SKAction *scaleSequence = [SKAction sequence:@[scaleUp, scaleNormal]];
    
    [self.leftTap runAction:[SKAction repeatActionForever:scaleSequence]];
    [self.rightTap runAction:[SKAction repeatActionForever:scaleSequence]];
}

-(void)animateOut {
    [self.leftTap removeAllActions];
    [self.rightTap removeAllActions];
    
    [self.leftTap runAction:[SKAction moveTo:self.startLeftTapPosition duration:0.25]];
    [self.rightTap runAction:[SKAction moveTo:self.startRightTapPosition duration:0.25]];
    
    
    [[OALSimpleAudio sharedInstance] playEffect:@"Pop.caf"];
    
}

@end
