//
//  GameScene.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/11/16.
//  Copyright (c) 2016 Jeremy Novak. All rights reserved.
//

#import "GameScene.h"

#pragma mark - Class Private Interface
@interface GameScene()

@end

#pragma mark - Class Implementation
@implementation GameScene

#pragma mark - Init
-(instancetype)initWithSize:(CGSize)size {
    
    if ((self = [super initWithSize:size])) {
        
        [self setupScene];
    }
    
    return self;
}


#pragma mark - Setup
-(void)setupScene {
    
    self.backgroundColor = [SKColor blackColor];
    
    BMGlyphFont *glyphFont = [BMGlyphFont fontWithName:@"GameFont"];
    BMGlyphLabel *label = [BMGlyphLabel labelWithText:@"Yay, it works!" font:glyphFont];
    label.position = CGPointMake(ScreenSize().width / 2, ScreenSize().height / 2);
    [self addChild:label];
    
    [label runAction:[SKAction scaleTo:1.1 duration:0.25] completion:^{
        [label runAction:[SKAction scaleTo:1.0 duration:0.25]];
    }];
    
}

#pragma mark - Touch Handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


#pragma mark - Update
-(void)update:(NSTimeInterval)currentTime {
    
}

@end
