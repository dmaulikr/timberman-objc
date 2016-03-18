//
//  PauseButton.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/18/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "PauseButton.h"

@interface PauseButton()

@property BOOL gamePaused;
@property SKTexture *pauseTexture;
@property SKTexture *resumeTexture;

@end

@implementation PauseButton

#pragma mark - Init
-(instancetype)init {
    if ((self = [super init])) {
        SKTexture *texture = [[GameTextures sharedInstance] textureWithName:PAUSEBUTTON];
        self = [PauseButton spriteNodeWithTexture:texture];
        
        [self setup];
    }
    
    return self;
}

#pragma mark - Setup
-(void)setup {
    self.gamePaused = NO;
    
    self.pauseTexture = [[GameTextures sharedInstance] textureWithName:PAUSEBUTTON];
    self.resumeTexture = [[GameTextures sharedInstance] textureWithName:RESUMEBUTTON];
    
    self.anchorPoint = CGPointMake(1.0, 1.0);
    self.position = CGPointMake(ScreenSize().width, ScreenSize().height);
}

#pragma mark - Actions
-(void)tapped {
    self.gamePaused = !self.gamePaused;
    
    [self setTexture:(self.gamePaused ? self.resumeTexture : self.pauseTexture)];
}

-(BOOL)getPaused {
    return self.gamePaused;
}

@end
