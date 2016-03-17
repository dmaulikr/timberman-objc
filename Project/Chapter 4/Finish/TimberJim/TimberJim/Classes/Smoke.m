//
//  Smoke.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/16/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "Smoke.h"

@interface Smoke()

@property SKAction *animation;

@end


@implementation Smoke

#pragma mark - Init
-(instancetype)init {
    if ((self = [super init])) {
        SKTexture *texture = [[GameTextures sharedInstance] textureWithName:SMOKE0];
        self = [Smoke spriteNodeWithTexture:texture];
        
        [self setup];
    }
    
    return self;
}

#pragma mark - Setup
-(void)setup {
    SKTexture *frame0 = [[GameTextures sharedInstance] textureWithName:SMOKE0];
    SKTexture *frame1 = [[GameTextures sharedInstance] textureWithName:SMOKE1];
    SKTexture *frame2 = [[GameTextures sharedInstance] textureWithName:SMOKE2];
    SKTexture *frame3 = [[GameTextures sharedInstance] textureWithName:SMOKE3];
    SKTexture *frame4 = [[GameTextures sharedInstance] textureWithName:SMOKE4];
    
    self.animation = [SKAction animateWithTextures:@[frame0, frame1, frame2, frame3, frame4] timePerFrame:0.1];
    
    self.alpha = 0.0;
}

#pragma mark - Animations
-(void)animateSmoke {
    self.alpha = 1.0;
    
    [self runAction:self.animation completion:^{
        self.alpha = 0.0;
    }];
}

@end
