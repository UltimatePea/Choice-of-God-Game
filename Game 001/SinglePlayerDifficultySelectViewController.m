//
//  SinglePlayerDifficultySelectViewController.m
//  God of Select
//
//  Created by Chen Zhibo on 2/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "SinglePlayerDifficultySelectViewController.h"
#import "GameViewControllerWithAI.h"

@interface SinglePlayerDifficultySelectViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *difficultyButtons;


@end

@implementation SinglePlayerDifficultySelectViewController

- (IBAction)back:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[GameViewControllerWithAI class]]) {
        GameViewControllerWithAI *gvcAI = segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"ShowGameSceneEasy"]){
            gvcAI.difficultyLevelIndex = 0;
        }
        if ([segue.identifier isEqualToString:@"ShowGameSceneMedium"]){
            gvcAI.difficultyLevelIndex = 1;
        }
        if ([segue.identifier isEqualToString:@"ShowGameSceneDifficult"]){
            gvcAI.difficultyLevelIndex = 2;
        }
        
    }
    
}

@end
