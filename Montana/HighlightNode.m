//
//  HighlightNode.m
//  Montana
//
//  Created by Eileen Xie on 7/20/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "HighlightNode.h"

@implementation HighlightNode

+ (CGPathRef)pathForSize:(CGSize)size {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    return [path CGPath];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self setName:@"HighlightNode"];
        CGPathRef path = [[self class] pathForSize:size];
        [self setPath:path];
        [self setFillColor:[UIColor yellowColor]];
        [self setAlpha:0.5];
        [self setZPosition:1];
    }
    return self;
}

@end
