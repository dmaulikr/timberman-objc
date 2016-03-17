//
//  Branch.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/16/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "Branch.h"

@implementation Branch

#pragma mark - Init
-(instancetype)initWithBranch:(BranchType)branchType {
    if ((self = [super init])) {
        SKTexture *texture = [[GameTextures sharedInstance] textureWithName:BRANCH];
        self = [Branch spriteNodeWithTexture:texture];
        
        switch (branchType) {
            case BranchLeft:
                break;
                
            case BranchRight:
                self.xScale = self.xScale * -1;
                break;
        }
        
        [self setupPhysics];
        
    }
    
    return self;
}

#pragma mark - Setup
-(void)setupPhysics {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size center:self.anchorPoint];
    self.physicsBody.categoryBitMask = ContactBranch;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = ContactPlayer;
    self.physicsBody.affectedByGravity = NO;
}

@end
