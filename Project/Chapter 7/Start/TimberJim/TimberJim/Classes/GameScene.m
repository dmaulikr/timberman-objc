//
//  GameScene.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/11/16.
//  Copyright (c) 2016 Jeremy Novak. All rights reserved.
//

#import "GameScene.h"
#import "Clouds.h"
#import "Birds.h"
#import "StackController.h"
#import "Player.h"
#import "TutorialButton.h"
#import "PlayButton.h"
#import "ScoreLabel.h"
#import "TimeBar.h"

typedef NS_ENUM(NSInteger, GameState) {
    Waiting, Running, Paused, GameOver
};


#pragma mark - Class Private Interface
@interface GameScene() <SKPhysicsContactDelegate>

// Scene member variables
@property NSTimeInterval lastUpdateTime;
@property GameState state;
@property GameState previousState;
@property NSTimeInterval timeLeft;

// Node member variables
@property Clouds *clouds;
@property Birds *birds;
@property StackController *stackController;
@property Player *player;
@property TutorialButton *tutorialButton;
@property PlayButton *playButton;
@property ScoreLabel *scoreLabel;
@property TimeBar *timeBar;

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
    self.physicsWorld.contactDelegate = self;
    
    self.lastUpdateTime = 0.0;
    
    self.clouds = [[Clouds alloc] init];
    [self addChild:self.clouds];
    
    self.birds = [[Birds alloc] init];
    [self addChild:self.birds];
    
    SKSpriteNode *forest = [[GameTextures sharedInstance] spriteWithName:FOREST];
    forest.anchorPoint = CGPointZero;
    forest.position = CGPointZero;
    [self addChild:forest];
    
    self.stackController = [[StackController alloc] init];
    [self addChild:self.stackController];
    
    self.player = [[Player alloc] init];
    [self addChild:self.player];
    
    self.tutorialButton = [[TutorialButton alloc] init];
    [self addChild:self.tutorialButton];
    
    self.playButton = [[PlayButton alloc] init];
    
    [self switchToWaiting];
    
    self.scoreLabel = [[ScoreLabel alloc] init];
    [self addChild:self.scoreLabel];
    
    self.timeBar = [[TimeBar alloc] init];
    [self addChild:self.timeBar];
}

#pragma mark - Touch Handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    
    switch (self.state) {
        case Waiting:
            [self switchToRunning];
            break;
            
        case Running: {
            if (touchLocation.x > ScreenSize().width / 2) {
                [self.player chopRight];
                [self.stackController moveStack];
                [self.scoreLabel updateLabel:[self.player getTaps]];
                [self addSecondsToTime];
                
            } else if (touchLocation.x < ScreenSize().width / 2) {
                [self.player chopLeft];
                [self.stackController moveStack];
                [self.scoreLabel updateLabel:[self.player getTaps]];
                [self addSecondsToTime];
                
            }
            break;
        }
            
        case Paused:
            break;
            
        case GameOver:
            if ([self.playButton containsPoint:touchLocation]) {
                [self resetGame];
            }
    }
}


#pragma mark - Update
-(void)update:(NSTimeInterval)currentTime {
    
    switch (self.state) {
        case Waiting:
        case GameOver: {
            NSTimeInterval delta = currentTime - self.lastUpdateTime;
            self.lastUpdateTime = currentTime;
            
            [self.clouds update:delta];
            [self.birds update:delta];
            
            break;
        }
        case Running: {
            NSTimeInterval delta = currentTime - self.lastUpdateTime;
            self.lastUpdateTime = currentTime;
            
            [self.clouds update:delta];
            [self.birds update:delta];
            
            self.timeLeft -= delta * 4;
            
            [self.timeBar updateTimeBar:self.timeLeft];
            
            if (self.timeLeft <= 0) {
                [self switchToGameOver];
            }
            
            break;
        }
            
        case Paused:
            break;
    }
}


#pragma mark - Contact
-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    if (self.state != Running) {
        return;
    } else {
        SKPhysicsBody *other = contact.bodyA.categoryBitMask == ContactPlayer ? contact.bodyB : contact.bodyA;
        
        if (other.categoryBitMask == ContactBranch) {
            [self switchToGameOver];
        }
    }
    
}

#pragma mark - State Functions
-(void)switchToWaiting {
    self.state = Waiting;
    
    [self.tutorialButton animateIn];
}

-(void)switchToRunning {
    self.state = Running;
    
    [self.tutorialButton animateOut];
    
    self.timeLeft = 6.0;
}

-(void)switchToPaused {
    self.previousState = self.state;
    
    self.state = Paused;
}

-(void)switchToResume {
    self.state = self.previousState;
}

-(void)switchToGameOver {
    self.state = GameOver;
    
    [self.player gameOver];
    
    [self displayGameOver];
}

-(void)displayGameOver {
    [self runAction:[SKAction waitForDuration:0.5] completion:^{
        [self addChild:self.playButton];
        [self.playButton animateIn];
    }];
}

-(void)resetGame {
    [[OALSimpleAudio sharedInstance] playEffect:@"Pop.caf"];
    
    [self removeAllChildren];
    
    SKScene *scene = [GameScene sceneWithSize:ScreenSize()];
    
    SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:1.0];
    
    [self.view presentScene:scene transition:transition];
}

#pragma mark - Timer Functions
-(void)addSecondsToTime {
    
    if (self.timeLeft < 6.0) {
        self.timeLeft += 1.0;
    } else {
        self.timeLeft = 6.0;
    }
    
    [self.timeBar updateTimeBar:self.timeLeft];
}

@end
