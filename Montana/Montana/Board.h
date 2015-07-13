//
//  Board.h
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;

typedef struct {
    int row;
    int column;
} Location;

@interface Board : NSObject

@property NSArray *rows;

- (instancetype)initWithEmptyBoard;
- (Card *)cardAtLocation:(Location)location;
- (void)placeCard:(Card *)card atLocation:(Location)location;
- (Card *)removeCardAtLocation:(Location)location;

@end
