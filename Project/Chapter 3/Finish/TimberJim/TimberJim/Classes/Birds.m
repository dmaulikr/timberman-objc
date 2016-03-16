//
//  Birds.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/16/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "Birds.h"

typedef NS_ENUM(NSInteger, Direction) {
    Left,
    Right
};


@interface Birds()

@property SKAction *birdsAnimation;
@property BOOL moving;
@property Direction direction;

@end

@implementation Birds

#pragma mark - Init
-(instancetype)init {
    if ((self = [super init])) {
        SKTexture *texture = [[GameTextures sharedInstance] textureWithName:BIRDS0];
        self = [Birds spriteNodeWithTexture:texture];
        
        [self setupBirds];
        [self setupBirdsAnimation];
    }
    
    return self;
}

#pragma mark - Setup
-(void)setupBirds {
    self.moving = NO;
    
    self.direction = Left;
    
    CGFloat randomY = RandomFloatRange(ScreenSize().height * 0.45 , ScreenSize().height * 0.9);
    
    self.position = CGPointMake(ScreenSize().width, randomY);
    
    [self runAction:[SKAction waitForDuration:0.016] completion:^{
        self.moving = YES;
    }];
}

-(void)setupBirdsAnimation {
    SKTexture *frame0 = [[GameTextures sharedInstance] textureWithName:BIRDS0];
    SKTexture *frame1 = [[GameTextures sharedInstance] textureWithName:BIRDS1];
    
    _birdsAnimation = [SKAction animateWithTextures:@[frame0, frame1] timePerFrame:0.1];
    
    [self runAction:[SKAction repeatActionForever:_birdsAnimation]];
}


#pragma mark - Update
-(void)update:(NSTimeInterval)delta {
    if (self.moving) {
        CGFloat speedX = DeviceIsPad() ? delta * 60 * 3 : delta * 60 * 1.5;
        
        switch (self.direction) {
                
            case Left:
                self.position = CGPointMake(self.position.x - speedX, self.position.y);
                
                if (self.position.x < (0 - self.size.width)) {
                    [self changeDirection];
                }
                
                break;
                
            case Right:
                self.position = CGPointMake(self.position.x + speedX, self.position.y);
                
                if (self.position.x > (ScreenSize().width + self.size.width)) {
                    [self changeDirection];
                }
                
                break;
        }
    }
}

#pragma mark - Direction
-(void)changeDirection {
    CGFloat randomY = RandomFloatRange(ScreenSize().height * 0.45, ScreenSize().height * 0.9);
    
    self.position = CGPointMake(self.position.x, randomY);
    
    self.xScale = self.xScale * -1;
    
    self.direction = self.direction == Left ? Right : Left;
}

@end
