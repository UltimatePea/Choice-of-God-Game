//
//  Lawn.m
//  Game 001
//
//  Created by Chen Zhibo on 2/10/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "Lawn.h"
#import "CoordinateManager.h"
#import "TextureManager.h"

@interface Lawn ()

@property (strong, nonatomic) CoordinateManager *coordinateManager;
@property (strong, nonatomic) TextureManager *textureManager;

@property (strong, nonatomic) NSMutableArray *nodesOnTheLeft, *nodesOnTheRight, *backgroundNodes;

@end

@implementation Lawn

#pragma mark - lazy instantiation
- (CoordinateManager *)coordinateManager
{
    if (!_coordinateManager) {
        _coordinateManager = [[CoordinateManager alloc] initWithSize:self.size withGridWidth:8 withGridHeight:5];
    }
    return _coordinateManager;
}

- (NSMutableArray *)nodesOnTheLeft
{
    if (!_nodesOnTheLeft) {
        _nodesOnTheLeft = [[NSMutableArray alloc] init];
    }
    return _nodesOnTheLeft;
}

- (NSMutableArray *)nodesOnTheRight
{
    if (!_nodesOnTheRight) {
        _nodesOnTheRight = [[NSMutableArray alloc] init];
    }
    return _nodesOnTheRight;
}

- (NSMutableArray *)backgroundNodes
{
    if (!_backgroundNodes) {
        _backgroundNodes = [NSMutableArray array];
    }
    return _backgroundNodes;
}

- (TextureManager *)textureManager
{
    return [TextureManager sharedManager];
}

#pragma mark - init and set up

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.size = size;
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setupBackground];
    
}

- (void)setupBackground
{
    
    for (int i = 0; i < self.coordinateManager.gridWidth; i +=2) {
        for (int j = 0; j < self.coordinateManager.gridHeight; j +=2 ) {
            [self addGridOfType:0 ofX:i ofY:j];
        }
    }
    for (int i = 1; i < self.coordinateManager.gridWidth; i +=2) {
        for (int j = 1; j < self.coordinateManager.gridHeight; j +=2 ) {
            [self addGridOfType:0 ofX:i ofY:j];
        }
    }
    for (int i = 0; i < self.coordinateManager.gridWidth; i +=2) {
        for (int j = 1; j < self.coordinateManager.gridHeight; j +=2 ) {
            [self addGridOfType:1 ofX:i ofY:j];
        }
    }
    for (int i = 1; i < self.coordinateManager.gridWidth; i +=2) {
        for (int j = 0; j < self.coordinateManager.gridHeight; j +=2 ) {
            [self addGridOfType:1 ofX:i ofY:j];
        }
    }
}
/**
 @param type 0 or 1
 */


- (void)addGridOfType:(NSInteger)type ofX:(int)i ofY:(int)j
{
    SKSpriteNode *dark = [SKSpriteNode spriteNodeWithTexture:[self.textureManager textureForResource:[NSString stringWithFormat:@"ground_grass_gen_0%d", arc4random()%10]] size:[self.coordinateManager standardNodeSize]];
    dark.size = [self.coordinateManager standardNodeSize];
    dark.position = [self.coordinateManager absoluteCenterPositionOfNodeOfRelativeCoordinate:CGPointMake(i, j)];
    [self addChild:dark];
    [self.backgroundNodes addObject:dark];
}


#pragma mark - addition methods
- (void)addMovingObjectOfType:(LawnMovingObjectType)type withDirection:(LawnMovingObjectDirection)direction withRowNumbered:(int)row
{
    SKTexture *texture;
    switch (type) {
        case LawnMovingObjectTypeFire:
            texture = [self.textureManager textureForResource:FIRE_1];
            break;
        case LawnMovingObjectTypeWood:
            texture = [self.textureManager textureForResource:TREE];
            break;
        case LawnMovingObjectTypeWater:
            texture = [self.textureManager textureForResource:WATER];
            break;
        default:
            break;
    }
    
    
    
    
    NodeWithLawnType *node = [NodeWithLawnType spriteNodeWithTexture:texture];
    if (type == LawnMovingObjectTypeFire) {
        SKAction *fire = [SKAction animateWithTextures:@[
                                                         [self.textureManager textureForResource:FIRE_1],
                                                         [self.textureManager textureForResource:FIRE_2]
                                                         ]
                                          timePerFrame:0.2];
        [node runAction:[SKAction repeatActionForever:fire]];
        if (direction == LawnMovingObjectDirectionWest) {
            node.zRotation = M_PI;
        }
    }
    
    
    
    
    
    node.size = [self.coordinateManager standardNodeSize];
    node.lawnMovingObjectType = type;
    node.position = [self.coordinateManager absoluteCenterPositionOfNodeOfRelativeCoordinate:CGPointMake((direction==LawnMovingObjectDirectionEast)?0:self.coordinateManager.gridWidth-1, row)];
    SKAction *move = [SKAction moveBy:CGVectorMake((direction==LawnMovingObjectDirectionEast)?1:-1, 0) duration:0.02];
    switch (direction) {
        case LawnMovingObjectDirectionEast:
            [self.nodesOnTheLeft addObject:node];
            break;
            
        case LawnMovingObjectDirectionWest:
            [self.nodesOnTheRight addObject:node];
            break;
        default:
            break;
    }
    [self addChild:node];
    [node runAction:[SKAction repeatActionForever:move]];
}

#pragma mark - protocol

- (void)detectContact
{
    //detect contact with other nodes
    [self.nodesOnTheLeft enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NodeWithLawnType *nodeOnTheLeft = obj;
        
        [self.nodesOnTheRight enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NodeWithLawnType *nodeOnTheRight = obj;
            
            if ([self nodeOnTheLeft:nodeOnTheLeft contactsNodeOnTheRight:nodeOnTheRight]) {
                [self.lawnCollisionDelegate nodeOnTheLeft:nodeOnTheLeft didHitNodeOnTheRight:nodeOnTheRight];
            }
            
        }];
        
    }];
    
    //detect contact with bounds
    [self.nodesOnTheLeft enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NodeWithLawnType *node = obj;
        if (![self nodeIsInBound:node]) {
            [self.lawnCollisionDelegate node:node didGoOffBoundWithDirection:LawnMovingObjectDirectionEast];
        }
    }];
    [self.nodesOnTheRight enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NodeWithLawnType *node = obj;
        if (![self nodeIsInBound:node]) {
            [self.lawnCollisionDelegate node:node didGoOffBoundWithDirection:LawnMovingObjectDirectionWest];
        }
    }];
}

- (BOOL)nodeOnTheLeft:(NodeWithLawnType *)nodeOnTheLeft contactsNodeOnTheRight:(NodeWithLawnType *)nodeOnTheRight

{
    BOOL result = NO;
    CGPoint positionForLeftNode = [self.coordinateManager relatePointWithAbsolutePoint:nodeOnTheLeft.position];
    CGPoint positionForRightNode = [self.coordinateManager relatePointWithAbsolutePoint:nodeOnTheRight.position];
    if (
        ((int)(positionForLeftNode.x))
        >=
        ((int)(positionForRightNode.x))
        && positionForLeftNode.y == positionForRightNode.y) {
        result = YES;
    }
    return result;
}

- (BOOL)nodeIsInBound:(NodeWithLawnType *)node
{
    /*
    __block BOOL result;
    [self.backgroundNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKSpriteNode *backgroundTile;
        if ([backgroundTile intersectsNode:node]) {
            result = YES;
        }
    }];
    */
    BOOL result = YES;
    CGPoint convertedPoint = CGPointMake(self.size.width / 2 + node.position.x, self.size.height/ 2 + node.position.y);
    CGPoint relativeCoordinate = [self.coordinateManager relatePointWithAbsolutePoint:convertedPoint];
    //NSLog(@"%f", relativeCoordinate.x);
    if (relativeCoordinate.x > self.coordinateManager.gridWidth - 1 || relativeCoordinate.x < 0) {
        result = NO;
    }
    
    return result;
}

- (void)userDidTapPoint:(CGPoint)point withCurrentType:(LawnMovingObjectType)type
{
    //because the anchor point is in the middle, convert the point first
    
    
    CGPoint relativePoint = [self.coordinateManager relatePointWithAbsolutePoint:point];
    [self addMovingObjectOfType:type withDirection:self.defaultDirection withRowNumbered:relativePoint.y];
}

- (CGPoint)relativeCoordinateOfAbsolutePoint:(CGPoint)absolutePoint;
{
    return [self.coordinateManager relatePointWithAbsolutePoint:absolutePoint];
}

- (void)enemyDidTapRelativePoint:(CGPoint)point withCurrentType:(LawnMovingObjectType)type
{

    [self addMovingObjectOfType:type withDirection:LawnMovingObjectDirectionWest withRowNumbered:point.y];
    
}

- (void)enemyDidTapAbsolutePoint:(CGPoint)point withCurrentType:(LawnMovingObjectType)type
{
    CGPoint relativePoint = [self.coordinateManager relatePointWithAbsolutePoint:point];
    [self enemyDidTapRelativePoint:relativePoint withCurrentType:type];
}

- (void)deleteNode:(NodeWithLawnType *)node withDirection:(LawnMovingObjectDirection)direction
{
    switch (direction) {
        case LawnMovingObjectDirectionEast:
            [self.nodesOnTheLeft removeObject:node];
            [node removeFromParent];
            node = nil;
            break;
        case LawnMovingObjectDirectionWest:
            [self.nodesOnTheRight removeObject:node];
            [node removeFromParent];
            node = nil;
            break;
        default:
            break;
    }
}

@end
