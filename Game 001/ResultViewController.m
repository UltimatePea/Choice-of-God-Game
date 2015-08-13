//
//  ResultViewController.m
//  God of Select
//
//  Created by Chen Zhibo on 2/14/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;


@end

@implementation ResultViewController

- (void)viewDidLoad
{
    switch (self.result) {
        case ResultDefeat:
            self.resultLabel.text = @"DEFEAT";
            break;
        case ResultVictory:
            self.resultLabel.text = @"VICTORY";
        
        default:
            break;
    }
}

- (IBAction)exit:(UIButton *)sender {
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
