//
//  GLMyScene.m
//  SpriteKitSample
//
//  Created by Yohei Yamaguchi on 2014/02/26.
//  Copyright (c) 2014年 Yohei Yamaguchi. All rights reserved.
//

#import "GLMyScene.h"

#import "GLHae.h"
#import "GLButtonNode.h"

static const NSInteger kNumberOfSpriteNodes = 5;
static const CFTimeInterval kGameInterval = 10.0f;

@interface GLMyScene ()  <GLHaeDelegate, GLButtonNodeDelegate>

@property (strong) NSMutableArray *haeNodes;
@property (strong) SKLabelNode *labelNode;
@property (strong) SKLabelNode *remainingTimeNode;
@property (strong) GLButtonNode *retryButtonNode;
@property (assign) CFTimeInterval lastUpdatedAt;
@property (assign) float point;
@property (assign) CFTimeInterval gamePassedTime;

- (void)initializeNodes;

@end

@implementation GLMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.point = 0.0f;
        [self initializeNodes];
    }
    return self;
}

- (void)initializeNodes
{
    // point
    self.labelNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.labelNode.text = @"0";
    self.labelNode.fontSize = 30.0f;
    self.labelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:self.labelNode];
    
    // remainint time
    self.remainingTimeNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.remainingTimeNode.text = [NSString stringWithFormat:@"%d", (NSInteger)kGameInterval];
    self.remainingTimeNode.position = CGPointMake(CGRectGetMidX(self.frame), 50.0f);
    [self addChild:self.remainingTimeNode];
    
    // hae
    self.haeNodes = @[].mutableCopy;
    for (NSInteger i = 0; i < kNumberOfSpriteNodes; ++i) {
        GLHae *sprite = [GLHae spriteNodeWithImageNamed:@"Spaceship"];
        sprite.position = CGPointMake((float)arc4random() / (float)ULONG_MAX * self.size.width,
                                      (float)arc4random() / (float)ULONG_MAX * self.size.height);
        sprite.xScale = 0.1f;
        sprite.yScale = 0.1f;
        sprite.zRotation = - M_PI;
        sprite.userInteractionEnabled = YES;
        sprite.delegate = self;
        [self addChild:sprite];
        [self.haeNodes addObject:sprite];
    }
    
    // retry buton
    self.retryButtonNode = [GLButtonNode labelNodeWithFontNamed:@"Chalkduster"];
    self.retryButtonNode.text = @"Retry";
    self.retryButtonNode.fontSize = 30;
    self.retryButtonNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50);
    self.retryButtonNode.userInteractionEnabled = YES;
    self.retryButtonNode.delegate = self;
    self.retryButtonNode.hidden = YES;
    [self addChild:self.retryButtonNode];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    return;
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        //  create a node
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        //  add a node onto the scene
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.lastUpdatedAt = currentTime;
    });
    
    //  update laste updatedAt
    CFTimeInterval timeInterval = currentTime - self.lastUpdatedAt;
    self.lastUpdatedAt = currentTime;
    
    for (GLHae *hae in self.haeNodes) {
        [hae move:timeInterval];
        
        
        float kBoundaryMargin = 50.0f;
        float kLeftBoundary = - kBoundaryMargin;
        float kRightBoundary = self.size.width + kBoundaryMargin;
        float kUpperBoundary = self.size.height + kBoundaryMargin;
        float kLowerBoundary = - kBoundaryMargin;
        
        // left boundary
        if (hae.position.x < kLeftBoundary) {
            hae.position = CGPointMake(self.size.width, hae.position.y);
        }
        // right boundary
        if (hae.position.x > kRightBoundary) {
            hae.position = CGPointMake(0, hae.position.y);
        }
        //  lower boundary
        if (hae.position.y < kLowerBoundary) {
            hae.position = CGPointMake(hae.position.x, self.size.height);
        }
        //  upper boundary
        if (hae.position.y > kUpperBoundary) {
            hae.position = CGPointMake(hae.position.x, 0);
        }
    }
    
    // game remaining time
    self.gamePassedTime += timeInterval;
    if ([self isGameOver]) {
        self.remainingTimeNode.text = @"Game Over";
        
        self.retryButtonNode.hidden = NO;
    } else {
        CFTimeInterval remainingTime = kGameInterval - self.gamePassedTime;
        self.remainingTimeNode.text = [NSString stringWithFormat:@"%d", (NSInteger)ceil(remainingTime)];
    }
}

#pragma mark -

- (BOOL)isGameOver
{
    return kGameInterval - self.gamePassedTime < 0.0;
}

- (void)hasTouchedWithHae:(GLHae *)hae
{
    if ([self isGameOver]) {
        return;
    }
    
    NSLog(@"panched");
    self.point += 100.0f;
    
    self.labelNode.text = [NSString stringWithFormat:@"%d", (NSInteger)self.point];
}

- (void)didButtonPressed:(GLButtonNode *)buttonNode
{
    [self retryGame];
}

- (void)retryGame
{
    self.gamePassedTime = 0.0f;
    self.point = 0.0f;
    self.labelNode.text = @"0";
    self.retryButtonNode.hidden = YES;
}

@end
