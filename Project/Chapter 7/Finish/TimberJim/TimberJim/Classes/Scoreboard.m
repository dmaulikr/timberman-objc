//
//  Scoreboard.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/18/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "Scoreboard.h"
#import "GameSettings.h"

@implementation Scoreboard

#pragma mark - Init
-(instancetype)initWithScore:(int)score {
    
    if ((self = [super init])) {
        
        [self setupWithScore:score];
    }
    
    return self;
}

#pragma mark - Setup
-(void)setupWithScore:(int)score {
    
    self.position = CGPointMake(ScreenSize().width / 2, ScreenSize().height * 0.6);
    
    // Scoreboard Sprite
    SKSpriteNode *background = [[GameTextures sharedInstance] spriteWithName:SCOREBOARD];
    [self addChild:background];
    
    // Glyph Font
    BMGlyphFont *font = [BMGlyphFont fontWithName:@"GameFont"];
    
    // Score Label
    BMGlyphLabel *currentScore = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"%d", score] font:font];
    currentScore.position = CGPointMake(0, background.size.height * 0.15);
    currentScore.textJustify = BMGlyphJustifyLeft;
    
    // Best Score Label
    int highScore = [[GameSettings sharedInstance] getBestScore];
    BMGlyphLabel *bestScore = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"%d", highScore] font:font];
    bestScore.position = CGPointMake(0, -background.size.height * 0.25);
    bestScore.textJustify = BMGlyphJustifyLeft;
    
    [background addChild:currentScore];
    [background addChild:bestScore];
    
    [self setScale:0];
}

-(void)animateIn {
    [self runAction:[SKAction scaleTo:1.1 duration:0.25] completion:^{
        [self runAction:[SKAction scaleTo:1.0 duration:0.25]];
    }];
}

@end
