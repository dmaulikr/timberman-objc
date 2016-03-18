//
//  GameSettings.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/18/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#import "GameSettings.h"

@interface GameSettings()

@property NSUserDefaults *localDefaults;
@property NSString *keyFirstRun;
@property NSString *keyBestScore;
@property int bestScore;

@end

@implementation GameSettings

#pragma mark - Init
+(instancetype)sharedInstance {
    static GameSettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype)init {
    
    if ((self = [super init])) {
        [self setup];
        
        if ([self.localDefaults objectForKey:self.keyFirstRun] == nil) {
            [self firstLaunch];
        }
    }
    
    return self;
}

#pragma mark - Setup
-(void)setup {
    self.localDefaults = [NSUserDefaults standardUserDefaults];
    self.keyFirstRun = @"FirstRun";
    self.keyBestScore = @"BestScore";
}

-(void)firstLaunch {
    [self.localDefaults setInteger:0 forKey:self.keyBestScore];
    [self.localDefaults setBool:NO forKey:self.keyFirstRun];
    [self.localDefaults synchronize];
}

#pragma mark - Public Saving Functions
-(void)saveBestScore:(int)score {
    [self.localDefaults setInteger:score forKey:self.keyBestScore];
    [self.localDefaults synchronize];
}

-(int)getBestScore {
    return (int)[self.localDefaults integerForKey:self.keyBestScore];
}

@end
