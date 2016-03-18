//
//  ScoreLabel.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/17/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "ScoreLabel.h"

@interface ScoreLabel()

@property BMGlyphLabel *label;

@end

@implementation ScoreLabel

#pragma mark - Init
-(instancetype)init {
    if ((self = [super init])) {
        [self setup];
    }
    
    return self;
}


#pragma mark - Setup
-(void)setup {
    BMGlyphFont *font = [BMGlyphFont fontWithName:@"GameFont"];
    self.label = [BMGlyphLabel labelWithText:@"0" font:font];
    self.label.position = CGPointMake(ScreenSize().width / 2, ScreenSize().height * 0.7);
    
    [self.label setScale:2.0];
    
    [self addChild:self.label];
}


#pragma mark - Public Actions
-(void)updateLabel:(int)score {
    self.label.text = [NSString stringWithFormat:@"%d", score];
}

@end
