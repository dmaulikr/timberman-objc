//
//  GameViewController.m
//  TimberJim
//
//  Created by Jeremy Novak on 3/11/16.
//  Copyright (c) 2016 Jeremy Novak. All rights reserved.
//

#import "GameViewController.h"
#import "LoadScene.h"

@implementation GameViewController


-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    SKView *skView = (SKView *)self.view;
    
    if (!skView.scene) {
        
        if (kDebug) {
            skView.showsFPS = YES;
            skView.showsNodeCount = YES;
            skView.showsPhysics = YES;
        }
        
        LoadScene *scene = [[LoadScene alloc] init];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.25];
        
        [skView presentScene:scene transition:transition];
        
        // Preload Sound Effects
        [[OALSimpleAudio sharedInstance] preloadEffect:@"Chop.caf"];
        [[OALSimpleAudio sharedInstance] preloadEffect:@"GameOver.caf"];
        [[OALSimpleAudio sharedInstance] preloadEffect:@"Pop.caf"];
        
        // Preload and play Music
        [[OALSimpleAudio sharedInstance] playBg:@"SpiritualMoments.mp3" loop:YES];
    }
    
}


- (BOOL)shouldAutorotate {
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

-(void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end
