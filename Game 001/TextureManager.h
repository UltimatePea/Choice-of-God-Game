//
//  TextureManager.h
//  Choice of God
//
//  Created by Chen Zhibo on 2/17/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LAWN_0 @"ground_grass_gen_00"
#define LAWN_1 @"ground_grass_gen_01"
#define LAWN_2 @"ground_grass_gen_02"
#define LAWN_3 @"ground_grass_gen_03"
#define LAWN_4 @"ground_grass_gen_04"
#define LAWN_5 @"ground_grass_gen_05"
#define LAWN_6 @"ground_grass_gen_06"
#define LAWN_7 @"ground_grass_gen_07"
#define LAWN_8 @"ground_grass_gen_08"
#define LAWN_9 @"ground_grass_gen_09"
#define TREE @"tree"
#define FIRE_1 @"fireblast1"
#define FIRE_2 @"fireblast2"
#define WATER @"ball_blue"
@import SpriteKit;

@interface TextureManager : NSObject

+ (instancetype)sharedManager;

/**
 load all the resources;
 */
- (void)loadResource;
- (SKTexture *)textureForResource:(NSString *)resourceName;

@end
