//
//  GLHae.m
//  SpriteKitSample
//
//  Created by Yohei Yamaguchi on 2014/03/21.
//  Copyright (c) 2014年 Yohei Yamaguchi. All rights reserved.
//

#import "GLHae.h"

const float kSpriteNodeSpeed = 30.0f;
const float kSpriteNodeRotationSpeed = M_PI * 2 / 10;

@interface GLHae ()

@property (assign) float angularVelocity;
+ (float)newAngularVelocity;

@end

@implementation GLHae

+ (instancetype)spriteNodeWithImageNamed:(NSString *)name
{
    GLHae *hae = [super spriteNodeWithImageNamed:name];
    hae.angularVelocity = [[self class] newAngularVelocity];
    return hae;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(hasTouchedWithHae:)]) {
        [self.delegate hasTouchedWithHae:self];
    }
}

- (void)move:(CFTimeInterval)timeInterval
{
    if ((float)arc4random() / (float)ULONG_MAX < 0.1f) {
        self.angularVelocity = [[self class] newAngularVelocity];
    }
    
    //  new z rotation
    self.zRotation += self.angularVelocity * timeInterval;
    float theta = self.zRotation * M_PI_2;
    
    //  new position
    CGPoint newPosition = self.position;
    newPosition.x += kSpriteNodeSpeed * timeInterval * cos(theta);
    newPosition.y += kSpriteNodeSpeed * timeInterval * sin(theta);
    self.position = newPosition;
}

+ (float)newAngularVelocity
{
    return (float)arc4random() / (float)ULONG_MAX * 2 * M_PI - M_PI;
}

@end
