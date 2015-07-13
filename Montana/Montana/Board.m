//
//  Board.m
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "Board.h"

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

- (Card *)cardInRow:(int)row column:(int)column {
    return [[_rows objectAtIndex:row] objectAtIndex:column];
}

- (void)placeCard:(Card *)card inRow:(int)row column:(int)column {
    [[_rows objectAtIndex:row] setObject:card atIndex:column];
}

- (Card *)removeCardInRow:(int)row column:(int)column {
    Card *card = [self cardInRow:row column:column];
    [[_rows objectAtIndex:row] removeObjectAtIndex:column];
    return card;
}

@end
