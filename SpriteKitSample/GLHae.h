//
//  GLHae.h
//  SpriteKitSample
//
//  Created by Yohei Yamaguchi on 2014/03/21.
//  Copyright (c) 2014年 Yohei Yamaguchi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol GLHaeDelegate;

@interface GLHae : SKSpriteNode

@property (weak) id<GLHaeDelegate> delegate;
- (void)move:(CFTimeInterval)timeSinceLastUpdate;

@end

@protocol GLHaeDelegate <NSObject>

- (void)hasTouchedWithHae:(GLHae *)hae;

@end
