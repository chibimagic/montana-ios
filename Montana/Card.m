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

- (Card *)precedingCard {
    if (_rank == RankAce || _rank == Rank2) {
        return nil;
    }
    Rank previousRank = _rank--;
    return [[Card alloc] initWithSuit:_suit rank:previousRank];
}

- (Card *)followingCard {
    if (_rank == RankAce || _rank == RankKing) {
        return nil;
    }
    Rank nextRank = _rank++;
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
