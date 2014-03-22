//
//  GLButtonNode.h
//  SpriteKitSample
//
//  Created by Yohei Yamaguchi on 2014/03/22.
//  Copyright (c) 2014年 Yohei Yamaguchi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol  GLButtonNodeDelegate;

@interface GLButtonNode : SKLabelNode
@property (weak) id<GLButtonNodeDelegate> delegate;

@end

@protocol GLButtonNodeDelegate <NSObject>

- (void)didButtonPressed:(GLButtonNode *)buttonNode;

@end
