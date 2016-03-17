//
//  Player.h
//  TimberJim
//
//  Created by Jeremy Novak on 3/17/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

-(void)chopLeft;
-(void)chopRight;
-(int)getTaps;
-(void)gameOver;

@end
