//
//  GameScene.m
//  Game 001
//
//  Created by Chen Zhibo on 2/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "GameScene.h"
#import "ResultViewController.h"
#import "Lawn.h"

@interface GameScene () <LawnCollisionDelegate>



@end



@implementation GameScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    Lawn *lawn = [[Lawn alloc] initWithSize:CGSizeMake(self.size.width * 4/5, self.size.height)];
    [self addChild:lawn];
    lawn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    //lawn.anchorPoint = CGPointZero;
    //lawn.position = CGPointZero;
    lawn.lawnCollisionDelegate = self;
    self.mainLawn = lawn;
    self.currentMatch.delegate = self;
    //[self runAction:[SKAction playSoundFileNamed:@"BGM.mp3" waitForCompletion:NO]];
    
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count]>1) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint localLocation = [touch locationInNode:self.mainLawn];
    CGPoint destinationLocation = CGPointMake(localLocation.x + self.mainLawn.size.width / 2, localLocation.y + self.mainLawn.size.height / 2);
    [self.mainLawn userDidTapPoint:destinationLocation withCurrentType:self.userDesiredType];
    
    CGPoint locationToSend = [self.mainLawn relativeCoordinateOfAbsolutePoint:destinationLocation];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",locationToSend.y], [NSString stringWithFormat:@"%lu", self.userDesiredType], nil] forKeys:[NSArray arrayWithObjects:@"y", @"type", nil]];;
    
    
    
    [self.currentMatch sendDataToAllPlayers:[NSKeyedArchiver archivedDataWithRootObject:dic] withDataMode:GKMatchSendDataReliable error:NULL];
}



- (void)nodeOnTheLeft:(NodeWithLawnType *)nodeOnTheLeft didHitNodeOnTheRight:(NodeWithLawnType *)nodeOnTheRight
{
    //Water > Fire > Wood > Water
    switch (nodeOnTheLeft.lawnMovingObjectType) {
            
            
        case LawnMovingObjectTypeFire:
            switch (nodeOnTheRight.lawnMovingObjectType) {
                case LawnMovingObjectTypeFire:
                    [self.mainLawn deleteNode:nodeOnTheLeft withDirection:LawnMovingObjectDirectionEast];
                    [self.mainLawn deleteNode:nodeOnTheRight withDirection:LawnMovingObjectDirectionWest];
                    break;
                case LawnMovingObjectTypeWater:
                    [self.mainLawn deleteNode:nodeOnTheLeft withDirection:LawnMovingObjectDirectionEast];
                    break;
                case LawnMovingObjectTypeWood:
                    [self.mainLawn deleteNode:nodeOnTheRight withDirection:LawnMovingObjectDirectionWest];
                    break;
                case LawnMovingObjectTypeDefault:
                    NSLog(@"Default Type, FATEL ERROR with object:  %@", nodeOnTheRight);
                    break;
                    
                default:
                    break;
            }
            break;
            
            
            
        case LawnMovingObjectTypeWood:
            switch (nodeOnTheRight.lawnMovingObjectType) {
                case LawnMovingObjectTypeWood:
                    [self.mainLawn deleteNode:nodeOnTheLeft withDirection:LawnMovingObjectDirectionEast];
                    [self.mainLawn deleteNode:nodeOnTheRight withDirection:LawnMovingObjectDirectionWest];
                    break;
                case LawnMovingObjectTypeFire:
                    [self.mainLawn deleteNode:nodeOnTheLeft withDirection:LawnMovingObjectDirectionEast];
                    break;
                case LawnMovingObjectTypeWater:
                    [self.mainLawn deleteNode:nodeOnTheRight withDirection:LawnMovingObjectDirectionWest];
                    break;
                case LawnMovingObjectTypeDefault:
                    NSLog(@"Default Type, FATEL ERROR with object:  %@", nodeOnTheRight);
                    break;
                default:
                    break;
            }
            break;
            
            
        //Water > Fire > Wood > Water
        case LawnMovingObjectTypeWater:
            switch (nodeOnTheRight.lawnMovingObjectType) {
                case LawnMovingObjectTypeWater:
                    [self.mainLawn deleteNode:nodeOnTheLeft withDirection:LawnMovingObjectDirectionEast];
                    [self.mainLawn deleteNode:nodeOnTheRight withDirection:LawnMovingObjectDirectionWest];
                    break;
                case LawnMovingObjectTypeWood:
                    [self.mainLawn deleteNode:nodeOnTheLeft withDirection:LawnMovingObjectDirectionEast];
                    break;
                case LawnMovingObjectTypeFire:
                    [self.mainLawn deleteNode:nodeOnTheRight withDirection:LawnMovingObjectDirectionWest];
                    break;
                case LawnMovingObjectTypeDefault:
                    NSLog(@"Default Type, FATEL ERROR with object:  %@", nodeOnTheRight);
                    break;
                default:
                    break;
            }
            break;
            
            
        case LawnMovingObjectTypeDefault:
            NSLog(@"Default Type, FATEL ERROR with object:  %@", nodeOnTheLeft);
            break;
            
        default:
            break;
    }
    
}

- (void)node:(NodeWithLawnType *)node didGoOffBoundWithDirection:(LawnMovingObjectDirection)direction
{
    NSLog(@"node off bound");
    ResultViewController *rvc = [self.presentingVC.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
    switch (direction) {
        case LawnMovingObjectDirectionEast:
            NSLog(@"Victory");
            rvc.result = ResultVictory;
            break;
        case LawnMovingObjectDirectionWest:
            NSLog(@"Defeat");
            rvc.result = ResultDefeat;
            break;
            
        default:
            break;
    }
    //[self.mainLawn deleteNode:node withDirection:direction];
    
    [self.presentingVC presentViewController:rvc animated:YES completion:nil];
    
    //[self.view presentScene:nil];
//    SKAction *animate = [SKAction moveTo:CGPointMake(self.size.width, self.size.height) duration:2];
//    SKAction *showResult = [SKAction runBlock:^{
//        [self.presentingVC presentViewController:rvc animated:YES completion:nil];
//    }];
//    [node runAction:[SKAction sequence:@[animate, showResult]]];
    self.mainLawn = nil;
    
}

- (void)update:(NSTimeInterval)currentTime
{
    [self.mainLawn detectContact];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer *)player
{
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.mainLawn enemyDidTapRelativePoint:CGPointMake(0, [[dic objectForKey:@"y"] floatValue]) withCurrentType:[[dic objectForKey:@"type"] intValue]];
}

@end
