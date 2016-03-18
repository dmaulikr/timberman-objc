//
//  GameSettings.h
//  TimberJim
//
//  Created by Jeremy Novak on 3/18/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

+(instancetype)sharedInstance;
-(void)saveBestScore:(int)score;
-(int)getBestScore;

@end
