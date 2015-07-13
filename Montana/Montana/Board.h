//
//  Board.h
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Card;

@interface Board : NSObject

@property NSArray *rows;

- (instancetype)initWithEmptyBoard;
- (Card *)cardInRow:(int)row column:(int)column;
- (void)placeCard:(Card *)card inRow:(int)row column:(int)column;
- (Card *)removeCardInRow:(int)row column:(int)column;

@end
