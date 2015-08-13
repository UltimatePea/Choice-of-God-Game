//
//  GameScene.h
//  Game 001
//

//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@import GameKit;
#import "Lawn.h"

@interface GameScene : SKScene <GKMatchDelegate>

@property (strong, nonatomic) GKMatch *currentMatch;
@property (nonatomic) LawnMovingObjectType userDesiredType;

@property (nonatomic) UIViewController *presentingVC;

//protected
@property (strong, nonatomic) Lawn *mainLawn;

@end
