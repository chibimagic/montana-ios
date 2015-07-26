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
    [deck addCards:@[
                     [[Card alloc] initWithSuit:SuitClub rank:RankAce],
                     [[Card alloc] initWithSuit:SuitDiamond rank:RankAce],
                     [[Card alloc] initWithSuit:SuitHeart rank:RankAce],
                     [[Card alloc] initWithSuit:SuitSpade rank:RankAce]
                     ]];
    [deck shuffle];
    [self placeCards:deck];
    [self removeAces];
    _redealsRemaining--;
}

- (BOOL)anyMovesPossible {
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            if ([[self availableCardsForLocation:location] count] > 0) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)gameWon {
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            Card *card = [_board cardAtLocation:location];
            if (column == 12) {
                if (card) {
                    return NO;
                } else {
                    continue;
                }
            }
            Rank expectedRank = [self expectedRankForLocation:location];
            if ([card rank] != expectedRank) {
                return NO;
            }
            Card *precedingCard = [_board cardAtLocation:[location precedingLocation]];
            if (column > 0 && [card suit] != [precedingCard suit]) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)moveCard:(Card *)card to:(Location *)location {
    Location *fromLocation = [_board locationOfCard:card];
    [_board removeCardAtLocation:fromLocation];
    [_board placeCard:card atLocation:location];
}

- (NSArray *)potentialLocationsForCard:(Card *)card {
    if ([card rank] == Rank2) {
        NSArray *firstColumn = @[
                                 [[Location alloc] initWithRow:0 column:0],
                                 [[Location alloc] initWithRow:1 column:0],
                                 [[Location alloc] initWithRow:2 column:0],
                                 [[Location alloc] initWithRow:3 column:0]
                                 ];
        return firstColumn;
    }
    Card *precedingCard = [card precedingCard];
    Location *location = [[_board locationOfCard:precedingCard] followingLocation];
    if (!location) {
        return @[];
    }
    return @[location];
}

- (NSArray *)availableLocationsForCard:(Card *)card {
    NSArray *potentialLocations = [self potentialLocationsForCard:card];
    NSMutableArray *availableLocations = [NSMutableArray array];
    [potentialLocations enumerateObjectsUsingBlock:^(Location *location, NSUInteger idx, BOOL *stop) {
        if (![_board cardAtLocation:location]) {
            [availableLocations addObject:location];
        }
    }];
    return availableLocations;
}

- (NSArray *)availableCardsForLocation:(Location *)location {
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
    Location *precedingLocation = [location precedingLocation];
    Card *precedingCard = [_board cardAtLocation:precedingLocation];
    NSArray *precedingCards = precedingCard ? @[precedingCard] : [self availableCardsForLocation:precedingLocation];
    NSMutableArray *availableCards = [NSMutableArray array];
    [precedingCards enumerateObjectsUsingBlock:^(Card *precedingCard, NSUInteger idx, BOOL *stop) {
        Card *availableCard = [precedingCard followingCard];
        if (availableCard) {
            [availableCards addObject:availableCard];
        }
    }];
    return availableCards;
}

- (Deck *)removeIncorrectCards {
    NSMutableArray *allRemovedCards = [NSMutableArray array];
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            Card *card = [_board cardAtLocation:location];
            Rank expectedRank = [self expectedRankForLocation:location];
            Card *precedingCard = [_board cardAtLocation:[location precedingLocation]];
            if (!card || [card rank] != expectedRank || (column > 0 && [card suit] != [precedingCard suit])) {
                NSArray *rowRemovedCards = [_board removeCardAndFollowingCardsAtLocation:location];
                [allRemovedCards addObjectsFromArray:rowRemovedCards];
                break;
            }
        }
    }
    return [[Deck alloc] initWithCards:allRemovedCards];
}

- (Rank)expectedRankForLocation:(Location *)location {
    return (Rank)([location column] + 1);
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
