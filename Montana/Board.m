//
//  Board.m
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "Board.h"
#import "Location.h"
#import "Card.h"

@implementation Board

- (instancetype)initWithEmptyBoard {
    self = [super init];
    if (self) {
        NSMutableArray *rows = [NSMutableArray array];
        for (int rowIndex = 0; rowIndex < 4; rowIndex++) {
            NSMutableArray *row = [NSMutableArray array];
            for (int columnIndex = 0; columnIndex < 13; columnIndex++) {
                [row addObject:[NSNull null]];
            }
            [rows addObject:row];
        }
        _rows = rows;
    }
    return self;
}

- (Card *)cardAtLocation:(Location *)location {
    id object = [[_rows objectAtIndex:[location row]] objectAtIndex:[location column]];
    if ([object isKindOfClass:[Card class]]) {
        return object;
    } else {
        return nil;
    }
}

- (Location *)locationOfCard:(Card *)card {
    __block Location *location;
    [_rows enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger rowIndex, BOOL *stop) {
        [row enumerateObjectsUsingBlock:^(id object, NSUInteger columnIndex, BOOL *stop) {
            if ([card isEqual:object]) {
                location = [[Location alloc] initWithRow:rowIndex column:columnIndex];
                *stop = YES;
            }
        }];
        if (location) {
            *stop = YES;
        }
    }];
    return location;
}

- (void)placeCard:(Card *)card atLocation:(Location *)location {
    [[_rows objectAtIndex:[location row]] setObject:card atIndex:[location column]];
}

- (Card *)removeCardAtLocation:(Location *)location {
    Card *card = [self cardAtLocation:location];
    [[_rows objectAtIndex:[location row]] setObject:[NSNull null] atIndex:[location column]];
    return card;
}

- (NSArray *)removeCardAndFollowingCardsAtLocation:(Location *)location {
    NSMutableArray *cards = [NSMutableArray array];
    for (NSUInteger column = [location column]; column < 13; column++) {
        Location *removalLocation = [[Location alloc] initWithRow:[location row] column:column];
        Card *card = [self removeCardAtLocation:removalLocation];
        [cards addObject:card];
    }
    return cards;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            id object = [self cardAtLocation:location];
            NSString *locationDescription = [object isKindOfClass:[Card class]] ? [object compactDescription] : @" ⬜️";
            [description appendString:[NSString stringWithFormat:@"[%@]", locationDescription]];
        }
        [description appendString:@"\n"];
    }
    return description;
}

@end
