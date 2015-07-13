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

@end
