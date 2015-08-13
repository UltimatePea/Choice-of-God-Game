//
//  GameSceneWithAI.h
//  God of Select
//
//  Created by Chen Zhibo on 2/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "GameScene.h"

typedef enum : NSUInteger {
    DifficultyLevelEasy,
    DifficultyLevelMedium,
    DifficultyLevelHard,
} DifficultyLevel;

@interface GameSceneWithAI : GameScene

@property (nonatomic) DifficultyLevel difficultyLevel;

@end
