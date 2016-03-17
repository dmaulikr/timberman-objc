//
//  Branch.h
//  TimberJim
//
//  Created by Jeremy Novak on 3/16/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Branch : SKSpriteNode

typedef NS_ENUM(NSInteger, BranchType) {
    BranchLeft,
    BranchRight
};

-(instancetype)initWithBranch:(BranchType)branchType;

@end
