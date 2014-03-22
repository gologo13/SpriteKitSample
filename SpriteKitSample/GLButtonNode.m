//
//  GLButtonNode.m
//  SpriteKitSample
//
//  Created by Yohei Yamaguchi on 2014/03/22.
//  Copyright (c) 2014年 Yohei Yamaguchi. All rights reserved.
//

#import "GLButtonNode.h"

@implementation GLButtonNode

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(didButtonPressed:)]) {
        [self.delegate didButtonPressed:self];
    }
}

@end
