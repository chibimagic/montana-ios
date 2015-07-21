//
//  Game.m
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "Game.h"
#import "Board.h"
#import "Location.h"
#import "Deck.h"
#import "Card.h"

@implementation Game

- (instancetype)init {
    self = [super init];
    if (self) {
        _redealsRemaining = 3;
        _board = [[Board alloc] initWithEmptyBoard];
        Deck *deck = [[Deck alloc] initForNewGame];
        [self placeCards:deck];
        [self removeAces];
    }
    return self;
}

- (void)redeal {
    Deck *deck = [self removeIncorrectCards];
    [deck shuffle];
    [self placeCards:deck];
    [self removeAces];
    _redealsRemaining--;
}

- (BOOL)anyMovesPossible {
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            if ([[self possibleCardsForLocation:location] count] > 0) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)moveCardFrom:(Location *)fromLocation to:(Location *)toLocation {
    Card *card = [_board cardAtLocation:fromLocation];
    [_board removeCardAtLocation:fromLocation];
    [_board placeCard:card atLocation:toLocation];
}

- (NSArray *)possibleLocationsForCard:(Card *)card {
    NSArray *potentialLocations;
    if ([card rank] == Rank2) {
        potentialLocations = @[
                               [[Location alloc] initWithRow:0 column:0],
                               [[Location alloc] initWithRow:1 column:0],
                               [[Location alloc] initWithRow:2 column:0],
                               [[Location alloc] initWithRow:3 column:0]
                               ];
    } else {
        Card *precedingCard = [card precedingCard];
        Location *location = [[_board locationOfCard:precedingCard] followingLocation];
        if (location) {
            potentialLocations = @[location];
        } else {
            potentialLocations = @[];
        }
    }
    NSMutableArray *availableLocations = [NSMutableArray array];
    [potentialLocations enumerateObjectsUsingBlock:^(Location *location, NSUInteger idx, BOOL *stop) {
        if (![_board cardAtLocation:location]) {
            [availableLocations addObject:location];
        }
    }];
    return availableLocations;
}

- (NSArray *)possibleCardsForLocation:(Location *)location {
    if ([_board cardAtLocation:location]) {
        return @[];
    }
    if ([location column] == 0) {
        NSArray *twos = @[
                          [[Card alloc] initWithSuit:SuitClub rank:Rank2],
                          [[Card alloc] initWithSuit:SuitDiamond rank:Rank2],
                          [[Card alloc] initWithSuit:SuitHeart rank:Rank2],
                          [[Card alloc] initWithSuit:SuitSpade rank:Rank2]
                          ];
        return twos;
    }
    Location *preceedingLocation = [location precedingLocation];
    Card *card = [[_board cardAtLocation:preceedingLocation] followingCard];
    if (!card) {
        return @[];
    }
    return @[card];
}

- (Deck *)removeIncorrectCards {
    NSMutableArray *allRemovedCards = [NSMutableArray array];
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            Card *card = [_board cardAtLocation:location];
            Rank expectedRank = [self expectedRankForLocation:location];
            if (!card || [card rank] != expectedRank) {
                NSArray *rowRemovedCards = [_board removeCardAndFollowingCardsAtLocation:location];
                [allRemovedCards addObjectsFromArray:rowRemovedCards];
                break;
            }
        }
    }
    return [[Deck alloc] initWithCards:allRemovedCards];
}

- (Rank)expectedRankForLocation:(Location *)location {
    return (Rank)[location column] - 1;
}

- (void)placeCards:(Deck *)deck {
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            if ([_board cardAtLocation:location]) {
                continue;
            }
            Card *card = [deck drawCard];
            [_board placeCard:card atLocation:location];
        }
    }
}

- (void)removeAces {
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            Card *card = [_board cardAtLocation:location];
            if ([card rank] == RankAce) {
                [_board removeCardAtLocation:location];
            }
        }
    }
}

@end
