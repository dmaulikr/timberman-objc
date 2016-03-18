//
//  Scoreboard.h
//  TimberJim
//
//  Created by Jeremy Novak on 3/18/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Scoreboard : SKSpriteNode

-(instancetype)initWithScore:(int)score;
-(void)animateIn;

@end
