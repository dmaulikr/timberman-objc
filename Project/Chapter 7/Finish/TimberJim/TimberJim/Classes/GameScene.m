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
#import "PauseButton.h"
#import "Scoreboard.h"

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
@property PauseButton *pauseButton;
@property SKNode *gameNode;
@property Scoreboard *scoreboard;

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
    
    // All nodes are now a child of gameNode
    self.gameNode = [SKNode node];
    [self addChild:self.gameNode];
    
    // Clouds
    self.clouds = [[Clouds alloc] init];
    [self.gameNode addChild:self.clouds];
    
    // Birds
    self.birds = [[Birds alloc] init];
    [self.gameNode addChild:self.birds];
    
    // Forest
    SKSpriteNode *forest = [[GameTextures sharedInstance] spriteWithName:FOREST];
    forest.anchorPoint = CGPointZero;
    forest.position = CGPointZero;
    [self.gameNode addChild:forest];

    // Stack Controller
    self.stackController = [[StackController alloc] init];
    [self.gameNode addChild:self.stackController];
    
    // Player
    self.player = [[Player alloc] init];
    [self.gameNode addChild:self.player];
    
    // Tutorial Button
    self.tutorialButton = [[TutorialButton alloc] init];
    [self.gameNode addChild:self.tutorialButton];
    
    // Play Button, not added to scene until switchToGameOver
    self.playButton = [[PlayButton alloc] init];
    
    // Score Label
    self.scoreLabel = [[ScoreLabel alloc] init];
    [self.gameNode addChild:self.scoreLabel];
    
    // Time Bar
    self.timeBar = [[TimeBar alloc] init];
    [self.gameNode addChild:self.timeBar];
    
    // Pause Button
    self.pauseButton = [[PauseButton alloc] init];
    [self.gameNode addChild:self.pauseButton];
    
    // Set the state to Waiting
    [self switchToWaiting];
}

#pragma mark - Touch Handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    
    switch (self.state) {
        case Waiting:
            if ([self.pauseButton containsPoint:touchLocation]) {
                [self pauseButtonPressed];
            } else {
                [self switchToRunning];
            }
            
            break;
            
        case Running: {
            
            if ([self.pauseButton containsPoint:touchLocation]) {
                [self pauseButtonPressed];
                
            } else {
                
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
                
            }
            
            break;
        }
            
        case Paused:
            if ([self.pauseButton containsPoint:touchLocation]) {
                [self pauseButtonPressed];
            }
            
            break;
            
        case GameOver:
            if ([self.pauseButton containsPoint:touchLocation]) {
                [self pauseButtonPressed];
            } else if ([self.playButton containsPoint:touchLocation]) {
                [self resetGame];
            }
            
            break;
    }
}


#pragma mark - Update
-(void)update:(NSTimeInterval)currentTime {
    // Calculate "delta"
    NSTimeInterval delta = currentTime - self.lastUpdateTime;
    self.lastUpdateTime = currentTime;
    
    switch (self.state) {
        case Waiting:
        case GameOver: {
            if (!self.gameNode.paused) {
                
                [self.clouds update:delta];
                [self.birds update:delta];
            }
            
            break;
        }
        case Running: {
            if (!self.gameNode.paused) {
                
                [self.clouds update:delta];
                [self.birds update:delta];
                
                self.timeLeft -= delta * 4;
                
                [self.timeBar updateTimeBar:self.timeLeft];
                
                if (self.timeLeft <= 0) {
                    [self switchToGameOver];
                }
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
        [self.gameNode addChild:self.playButton];
        [self.playButton animateIn];
        
        Scoreboard *scoreboard = [[Scoreboard alloc] initWithScore:[self.player getTaps]];
        [self.gameNode addChild:scoreboard];
        [scoreboard animateIn];
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

#pragma mark - Pause Function
-(void)pauseButtonPressed {
    [self.pauseButton tapped];
    
    if (self.pauseButton.getPaused) {
        
        self.gameNode.paused = YES;
        
        [self switchToPaused];
        
        [OALSimpleAudio sharedInstance].bgPaused = YES;
        
    } else {
        
        self.gameNode.paused = NO;
        
        [self switchToResume];
        
        
        [OALSimpleAudio sharedInstance].bgPaused = NO;
    }
}

@end
