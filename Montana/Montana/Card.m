//
//  Card.m
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "Card.h"

@implementation Card

- (instancetype)initWithSuit:(Suit)suit rank:(Rank)rank {
    self = [super init];
    if (self) {
        _suit = suit;
        _rank = rank;
    }
    return self;
}

- (BOOL)canBeFollowedBy:(Card *)card {
    return [[self followingCard] isEqual:card];
}

- (Card *)followingCard {
    if (_rank == RankKing) {
        return nil;
    }
    NSArray *rankOrder = @[
                           @(RankAce),
                           @(Rank2),
                           @(Rank3),
                           @(Rank4),
                           @(Rank5),
                           @(Rank6),
                           @(Rank7),
                           @(Rank8),
                           @(Rank9),
                           @(Rank10),
                           @(RankJack),
                           @(RankQueen),
                           @(RankKing)
                           ];
    NSUInteger currentIndex = [rankOrder indexOfObject:@(_rank)];
    NSNumber *nextRankBoxed = [rankOrder objectAtIndex:(currentIndex + 1)];
    Rank nextRank = (Rank)[nextRankBoxed intValue];
    return [[Card alloc] initWithSuit:_suit rank:nextRank];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToCard:object];
}

- (BOOL)isEqualToCard:(Card *)card {
    return _suit == [card suit] && _rank == [card rank];
}

@end
