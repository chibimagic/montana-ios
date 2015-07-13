//
//  Location.h
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property NSUInteger row;
@property NSUInteger column;

- (instancetype)initWithRow:(NSUInteger)row column:(NSUInteger)column;

@end
