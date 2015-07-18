//
//  PlaceholderNode.m
//  Montana
//
//  Created by Eileen Xie on 7/18/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "PlaceholderNode.h"

@implementation PlaceholderNode

+ (UIBezierPath *)pathForNormalPlaceholderOfSize:(CGSize)size {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    return path;
}

+ (UIBezierPath *)pathForNoMovesPlaceholderOfSize:(CGSize)size {
    UIBezierPath *path = [self pathForNormalPlaceholderOfSize:size];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path moveToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    return path;
}

- (instancetype)initNormalWithSize:(CGSize)size location:(Location *)location {
    self = [super init];
    if (self) {
        _movesPossible = YES;
        _size = size;
        _location = location;
        CGPathRef path = [[[self class] pathForNormalPlaceholderOfSize:size] CGPath];
        [self setPath:path];
    }
    return self;
}

- (instancetype)initNoMovesWithSize:(CGSize)size location:(Location *)location {
    self = [super init];
    if (self) {
        _movesPossible = NO;
        _size = size;
        _location = location;
        CGPathRef path = [[[self class] pathForNoMovesPlaceholderOfSize:size] CGPath];
        [self setPath:path];
    }
    return self;
}

@end
