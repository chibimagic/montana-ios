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
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:13];
            [rows addObject:row];
        }
    }
    return self;
}

- (Card *)cardAtLocation:(Location *)location {
    return [[_rows objectAtIndex:[location row]] objectAtIndex:[location column]];
}

- (Location *)locationOfCard:(Card *)card {
    __block Location *location;
    [_rows enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger rowIndex, BOOL *stop) {
        [row enumerateObjectsUsingBlock:^(Card *boardCard, NSUInteger columnIndex, BOOL *stop) {
            if ([card isEqual:boardCard]) {
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
    [[_rows objectAtIndex:[location row]] removeObjectAtIndex:[location column]];
    return card;
}

@end
