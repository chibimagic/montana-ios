//
//  GameScene.h
//  Montana
//

//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class Board;

@interface GameScene : SKScene

@property Board *board;
@property int redealsRemaining;

@end
