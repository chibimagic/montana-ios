//
//  Game.h
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Board;
@class Card;

@interface Game : NSObject

@property int redealsRemaining;
@property Board *board;

+ (instancetype)newGame;
- (void)redeal;
- (void)moveCard:(Card *)card;
- (BOOL)anyMovesPossibke;
- (NSArray *)possibleCardsForRow:(int)row column:(int)column;

@end
