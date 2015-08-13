//
//  GameViewController.m
//  Game 001
//
//  Created by Chen Zhibo on 2/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"


@interface GameViewController () <GKMatchDelegate>

@property (nonatomic) BOOL matchStarted;

@property (strong, nonatomic) GameScene *gameScene;
@property (weak, nonatomic) IBOutlet UILabel *waitToConnectLabel;

@end


@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentMatch.delegate = self;
    if (!self.matchStarted && self.currentMatch.expectedPlayerCount == 0)
    {
        self.matchStarted = YES;
        // Handle initial match negotiation.
        [self presentScene];
    }
    
    
    
}

- (void)presentScene
{
    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    
    // Create and configure the scene.
    GameScene *gameScene = [GameScene sceneWithSize:self.view.bounds.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFill;
    gameScene.currentMatch = self.currentMatch;
    self.currentMatch.delegate = gameScene;
    self.gameScene = gameScene;
    // Present the scene.
    [skView presentScene:gameScene];
    self.waitToConnectLabel.text = nil;
    gameScene.presentingVC = self;
}

- (void)match:(GKMatch *)match player:(GKPlayer *)player didChangeConnectionState:(GKPlayerConnectionState)state
{
    switch (state)
    {
        case GKPlayerStateConnected:
            // Handle a new player connection.
            NSLog(@"A new player connected");
            break;
        case GKPlayerStateDisconnected:
            // A player just disconnected.
            NSLog(@"A player has disconnected");
            break;
        
        case GKPlayerStateUnknown:
            NSLog(@"Unknown state");
            break;
    }
    if (!self.matchStarted && match.expectedPlayerCount == 0)
    {
        self.matchStarted = YES;
        // Handle initial match negotiation.
        [self presentScene];
    }
}
- (IBAction)tapWood:(UIButton *)sender {
    self.gameScene.userDesiredType = LawnMovingObjectTypeWood;
}
- (IBAction)tapWater:(UIButton *)sender {
    self.gameScene.userDesiredType = LawnMovingObjectTypeWater;
}
- (IBAction)tapFire:(UIButton *)sender {
    self.gameScene.userDesiredType = LawnMovingObjectTypeFire;
}
/*
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
*/

@end
