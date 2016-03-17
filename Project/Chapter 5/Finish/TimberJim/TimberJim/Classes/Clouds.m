//
//  Clouds.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/15/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "Clouds.h"

@implementation Clouds

#pragma mark - Init
-(instancetype)init {
    
    if ((self = [super  init])) {
        SKTexture *texture = [[GameTextures sharedInstance] textureWithName:CLOUDS];
        self = [Clouds spriteNodeWithTexture:texture];
        
        [self setup];
    }
    
    return self;
}


#pragma mark - Setup
-(void)setup {
    self.anchorPoint = CGPointZero;
    self.position = CGPointZero;
}


#pragma mark - Update
-(void)update:(NSTimeInterval)delta {
    CGFloat speedX = DeviceIsPad() ? delta * 60 * 0.5 : delta * 60 * 0.25;
    
    self.position = CGPointMake(self.position.x - speedX, self.position.y);
    
    if (self.position.x < (0 - self.size.width  / 2)) {
        self.position = CGPointZero;
    }
}


@end