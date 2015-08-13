//
//  GameSceneWithAI.m
//  God of Select
//
//  Created by Chen Zhibo on 2/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "GameSceneWithAI.h"

@implementation GameSceneWithAI

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    [self startAI];
}

- (void)startAI
{
    NSTimeInterval interval;
    switch (self.difficultyLevel) {
        case DifficultyLevelEasy:
            interval = 3;
            break;
        case DifficultyLevelMedium:
            interval = 1;
            break;
        case DifficultyLevelHard:
            interval = 0.1;
            break;
            
        default:
            break;
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(difficutTurn:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

- (void)difficutTurn:(NSTimer *)timer
{
    [self.mainLawn enemyDidTapRelativePoint:CGPointMake(0, arc4random()%5) withCurrentType:arc4random()%3];
}

@end
