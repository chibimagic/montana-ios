//
//  Game.h
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Board;
@class Location;
@class Card;

@interface Game : NSObject

@property int redealsRemaining;
@property Board *board;

- (instancetype)init;
- (void)redeal;
- (BOOL)anyMovesPossible;
- (void)moveCard:(Card *)card to:(Location *)location;
- (NSArray *)possibleLocationsForCard:(Card *)card;
- (NSArray *)possibleCardsForLocation:(Location *)location;

@end
