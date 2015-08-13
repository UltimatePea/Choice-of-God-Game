//
//  ResultViewController.h
//  God of Select
//
//  Created by Chen Zhibo on 2/14/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    ResultVictory,
    ResultDefeat,
} Result;

@interface ResultViewController : UIViewController

@property (nonatomic) Result result;

@end
