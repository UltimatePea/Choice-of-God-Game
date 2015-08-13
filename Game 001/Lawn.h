//
//  Lawn.h
//  Game 001
//
//  Created by Chen Zhibo on 2/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LawnMovingObjectType.h"
#import "NodeWithLawnType.h"


typedef enum : NSUInteger {
    LawnMovingObjectDirectionEast,
    LawnMovingObjectDirectionWest,
    
} LawnMovingObjectDirection;

@protocol LawnCollisionDelegate <NSObject>

@required
- (void)nodeOnTheLeft:(NodeWithLawnType *)nodeOnTheLeft didHitNodeOnTheRight:(NodeWithLawnType *)nodeOnTheRight;
- (void)node:(NodeWithLawnType *)node didGoOffBoundWithDirection:(LawnMovingObjectDirection)direction;

@end

@protocol LawnProtocol <NSObject>

@required
/**
 this method starts to calculate whether two nodes are in contact,
 if so, the delegate method is called;
 */
- (void)detectContact;

- (void)userDidTapPoint:(CGPoint)point withCurrentType:(LawnMovingObjectType)type;
- (void)enemyDidTapRelativePoint:(CGPoint)point withCurrentType:(LawnMovingObjectType)type;;
- (void)enemyDidTapAbsolutePoint:(CGPoint)point withCurrentType:(LawnMovingObjectType)type;;

- (void)deleteNode:(NodeWithLawnType *)node withDirection:(LawnMovingObjectDirection)direction;
@end

@interface Lawn : SKNode <LawnProtocol>

- (instancetype)initWithSize:(CGSize)size;

- (void)addMovingObjectOfType:(LawnMovingObjectType)type withDirection:(LawnMovingObjectDirection)direction withRowNumbered:(int)row;

@property (weak, nonatomic) id<LawnCollisionDelegate> lawnCollisionDelegate;
@property (nonatomic) LawnMovingObjectDirection defaultDirection;
@property ( nonatomic) CGSize size;

- (CGPoint)relativeCoordinateOfAbsolutePoint:(CGPoint)absolutePoint;
@end
