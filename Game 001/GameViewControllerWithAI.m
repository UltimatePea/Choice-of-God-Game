//
//  GameViewControllerWithAI.m
//  God of Select
//
//  Created by Chen Zhibo on 2/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "GameViewControllerWithAI.h"
#import "GameSceneWithAI.h"

@interface GameViewControllerWithAI ()


@property (strong, nonatomic) GameSceneWithAI *gameScene;
@end

@implementation GameViewControllerWithAI

- (void)viewDidLoad
{
    GameSceneWithAI *scene = [GameSceneWithAI sceneWithSize:self.view.bounds.size];
    
    SKView *view = (SKView *)self.view;
//    view.showsFPS = YES;
//    view.showsNodeCount = YES;
    switch(self.difficultyLevelIndex) {
        case 0:
            scene.difficultyLevel = DifficultyLevelEasy;
            break;
        case 1:
            scene.difficultyLevel = DifficultyLevelMedium;
            break;
        case 2:
            scene.difficultyLevel = DifficultyLevelHard;
            break;
            
            
        default:
            break;
    }
    [view presentScene:scene];
    scene.presentingVC = self;
    self.gameScene = scene;
    
    
    
    
    
    
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


@end
