//
//  LoadScene.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/18/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "LoadScene.h"
#import "GameScene.h"

@implementation LoadScene

-(void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    
    [self runAction:[SKAction waitForDuration:0.016] completion:^{
        CGSize viewSize = CGSizeMake(ScreenSize().width, ScreenSize().height);
        
        GameScene *scene = [[GameScene alloc] initWithSize:viewSize];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.25];
        
        [self.view presentScene:scene transition:transition];
    }];
}

@end
