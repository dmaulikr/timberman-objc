//
//  PlayButton.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/17/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "PlayButton.h"

@implementation PlayButton

#pragma mark - Init
-(instancetype)init {
    if ((self = [super init])) {
        SKTexture *texture = [[GameTextures sharedInstance] textureWithName:PLAYBUTTON];
        self = [PlayButton spriteNodeWithTexture:texture];
        
        [self setup];
    }
    
    return self;
}

#pragma mark - Setup
-(void)setup {
    self.position = CGPointMake(ScreenSize().width / 2, ScreenSize().height * 0.15);
    [self setScale:0];
}

#pragma mark - Animations
-(void)animateIn {
    [self runAction:[SKAction scaleTo:1.1 duration:0.25] completion:^{
        [self runAction:[SKAction scaleTo:1.0 duration:0.25]];
    }];
}


-(void)animateOut {
    [self runAction:[SKAction scaleTo:0 duration:0.25]];
}

@end
