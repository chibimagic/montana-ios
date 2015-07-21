//
//  Location.m
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column {
    self = [super init];
    if (self) {
        _row = row;
        _column = column;
    }
    return self;
}

- (Location *)precedingLocation {
    if (_column == 0) {
        return nil;
    }
    NSUInteger previousColumn = _column - 1;
    return [[Location alloc] initWithRow:_row column:previousColumn];
}

- (Location *)followingLocation {
    if (_column == 12) {
        return nil;
    }
    NSUInteger nextColumn = _column + 1;
    return [[Location alloc] initWithRow:_row column:nextColumn];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"row %d, column %d", _row, _column];
}

@end
