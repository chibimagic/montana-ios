//
//  Deck.m
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "Deck.h"
#import "Card.h"

@implementation Deck

- (instancetype)initForNewGame {
    self = [super init];
    if (self) {
        _cards = [NSMutableArray array];
        for (Suit suit = SuitClub; suit <= SuitSpade; suit++) {
            for (Rank rank = RankAce; rank <= RankKing; rank++) {
                Card *card = [[Card alloc] initWithSuit:suit rank:rank];
                [_cards addObject:card];
            }
        }
        [self shuffle];
    }
    return self;
}

- (instancetype)initWithCards:(NSArray *)cards {
    self = [super init];
    if (self) {
        [cards enumerateObjectsUsingBlock:^(id card, NSUInteger idx, BOOL *stop) {
            if (![card isKindOfClass:[Card class]]) {
                NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                                 reason:@"Tried to initiate deck with a non-card"
                                                               userInfo:@{
                                                                          @"cards" : cards,
                                                                          @"invalidCard" : card
                                                                          }];
                @throw exception;
            }
        }];
        _cards = [cards mutableCopy];
    }
    return self;
}

- (void)addCards:(NSArray *)cards {
    [_cards addObjectsFromArray:cards];
}

- (Card *)drawCard {
    Card *card = [_cards lastObject];
    [_cards removeLastObject];
    return card;
}

- (void)shuffle {
    NSMutableArray *shuffledCards = [NSMutableArray array];
    while ([_cards count] > 0) {
        NSUInteger randomIndex = arc4random_uniform((int)[_cards count]);
        Card *card = [_cards objectAtIndex:randomIndex];
        [_cards removeObjectAtIndex:randomIndex];
        [shuffledCards addObject:card];
    }
    _cards = shuffledCards;
}

- (NSString *)description {
    return [_cards description];
}

@end
