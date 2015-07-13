//
//  Card.h
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SuitClub,
    SuitDiamond,
    SuitHeart,
    SuitSpade
} Suit;

typedef enum : NSUInteger {
    RankAce,
    Rank2,
    Rank3,
    Rank4,
    Rank5,
    Rank6,
    Rank7,
    Rank8,
    Rank9,
    Rank10,
    RankJack,
    RankQueen,
    RankKing
} Rank;

@interface Card : NSObject

@property Suit suit;
@property Rank rank;

+ (instancetype)cardWithSuit:(Suit)suit rank:(Rank)rank;
- (BOOL)canBeFollowedBy:(Card *)card;
- (Card *)followingCard;

@end
