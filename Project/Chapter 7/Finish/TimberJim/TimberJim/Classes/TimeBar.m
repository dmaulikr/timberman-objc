//
//  TimeBar.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/17/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "TimeBar.h"

@interface TimeBar()

@property SKSpriteNode *timeBar;

@end


@implementation TimeBar

#pragma mark - Init
-(instancetype)init {
    
    if ((self = [super init])) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Setup
-(void)setup {
    // Background
    SKSpriteNode *background = [[GameTextures sharedInstance] spriteWithName:TIMEBARBACKGROUND];
    background.position = CGPointMake(ScreenSize().width / 2, ScreenSize().height * 0.85);
    [self addChild:background];
    
    // Time Bar
    self.timeBar = [[GameTextures sharedInstance] spriteWithName:TIMEBAR];
    self.timeBar.anchorPoint = CGPointMake(0, 0.5);
    self.timeBar.position = CGPointMake(-self.timeBar.size.width / 2, 0);
    [background addChild:self.timeBar];
}

#pragma mark - Actions
-(void)updateTimeBar:(NSTimeInterval)seconds {
    
    if (seconds > 6.0) {
        return;
    }
    
    if (seconds > 0) {
        self.timeBar.xScale = seconds / 6;
    } else {
        self.timeBar.hidden = YES;
    }
    
}

@end
