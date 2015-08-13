//
//  TextureManager.m
//  Choice of God
//
//  Created by Chen Zhibo on 2/17/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "TextureManager.h"



@interface TextureManager ()

@property (strong, nonatomic) NSMutableDictionary *texture;

@end

@implementation TextureManager

- (NSMutableDictionary *)texture
{
    if (!_texture) {
        _texture = [[NSMutableDictionary alloc] init];
    }
    return _texture;
}

static TextureManager *sharedManager;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            sharedManager = [[self alloc] init];
        
    });
    return sharedManager;
}


- (void)loadResource
{
    [self setTextureForKeys:@[TREE, FIRE_1, FIRE_2, WATER]];
    [self setTextureForKeys:@[LAWN_0, LAWN_1, LAWN_2, LAWN_3, LAWN_4, LAWN_5, LAWN_6, LAWN_7, LAWN_8, LAWN_9]];
    
}

- (void)setTextureForKeys:(NSArray *)keys
{
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = obj;
        [self setTextureForKey:key];
    }];
}

- (void)setTextureForKey:(NSString *)key
{
    [self.texture setObject:[SKTexture textureWithImageNamed:key] forKey:key];
}

- (SKTexture *)textureForResource:(NSString *)resourceName
{
    return [self.texture objectForKey:resourceName];
}


@end
