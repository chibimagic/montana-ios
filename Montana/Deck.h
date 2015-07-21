//
//  Deck.h
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;

@interface Deck : NSObject

@property NSMutableArray *cards;

- (instancetype)initForNewGame;
- (instancetype)initWithCards:(NSArray *)cards;
- (void)addCards:(NSArray *)cards;
- (Card *)drawCard;
- (void)shuffle;

@end
