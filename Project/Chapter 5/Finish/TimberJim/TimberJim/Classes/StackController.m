//
//  StackController.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/16/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "StackController.h"
#import "Branch.h"


typedef NS_ENUM(NSInteger, Side)  {
    Left,
    Right,
    None
};

@interface StackController()

@property NSMutableArray *branchArray;
@property NSMutableArray *pieceArray;
@property CGPoint basePosition;
@property Side currentSide;
@property CGFloat frameCount;

@end

@implementation StackController

#pragma mark - Init
-(instancetype)init {
    if ((self = [super init])) {
        
        [self setup];
        
    }
    
    return self;
}

#pragma mark - Setup
-(void)setup {
    Branch *leftBranch = [[Branch alloc] initWithBranch:BranchLeft];
    Branch *rightBranch = [[Branch alloc] initWithBranch:BranchRight];
    
    self.branchArray = [[NSMutableArray alloc] init];
    
    [self.branchArray addObject:leftBranch];
    [self.branchArray addObject:rightBranch];
    
    self.pieceArray = [[NSMutableArray alloc] init];
    
    self.basePosition = CGPointMake(ScreenSize().width / 2, ScreenSize().height * 0.3);
    
    self.currentSide = Left;
    
    [self spawnStack];
}

#pragma mark - Stack and Branch
-(void)spawnStack {
    SKSpriteNode *piece0 = [[GameTextures sharedInstance] spriteWithName:LOG0];
    SKSpriteNode *piece1 = [[GameTextures sharedInstance] spriteWithName:LOG1];
    
    NSArray *spriteArray = @[piece0, piece1];
    
    for (int i = 0; i < 12; i++) {
        SKSpriteNode *log = [[spriteArray objectAtIndex:i % 2] copy];
        
        log.position = CGPointMake(self.basePosition.x, self.basePosition.y + log.size.height * i);
        
        [self spawnBranch:log];
        
        [self addChild:log];
        
        [self.pieceArray addObject:log];
    }
}

-(void)chooseSide {
    CGFloat randomNumber = RandomFloatRange(0.0, 1.0);
    
    
    if (self.currentSide != None) {
        self.currentSide = None;
        
    } else {
        if (randomNumber < 0.45) {
            self.currentSide = Left;
            
        } else if (randomNumber < 0.9) {
            self.currentSide = Right;
            
        } else {
            self.currentSide = None;
            
        }
    }
}

-(void)spawnBranch:(SKSpriteNode *)log {
    
    [self chooseSide];
    
    if (self.currentSide == Left) {
        CGPoint position = CGPointMake(-log.size.width, 0);
        Branch *branch = [[self.branchArray objectAtIndex:0] copy];
        branch.position = position;
        
        [log addChild:branch];
        
    } else if (self.currentSide == Right) {
        CGPoint position = CGPointMake(log.size.width, 0);
        Branch *branch = [[self.branchArray objectAtIndex:1] copy];
        branch.position = position;
        
        [log addChild:branch];
    }
}

#pragma mark - Stack Management
-(void)moveStack {
    NSTimeInterval oneFrame = 0.016;
    
    [self runAction:[SKAction waitForDuration:oneFrame] completion:^{
        SKSpriteNode *log = [self.pieceArray objectAtIndex:0];
        
        [self.pieceArray addObject:log];
        
        [self.pieceArray removeObjectAtIndex:0];
        
        [log removeAllChildren];
        
        [self spawnBranch:log];
        
        for (int i = 0; i < self.pieceArray.count; i++) {
            SKSpriteNode *chunk = [self.pieceArray objectAtIndex:i];
            
            chunk.position = CGPointMake(self.basePosition.x, self.basePosition.y + chunk.size.height * i);
        }
    }];
}

#pragma mark - Update
-(void)update:(NSTimeInterval)delta {
    self.frameCount += delta;
    
    if (self.frameCount >= 1.0) {
        [self moveStack];
        
        self.frameCount = 0.0;
    }
}

@end
