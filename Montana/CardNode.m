//
//  CardNode.m
//  Montana
//
//  Created by Eileen Xie on 7/18/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "CardNode.h"
#import "Card.h"

@implementation CardNode

+ (CGFloat)widthToHeightRatio {
//    return 2.5 / 3.5; // Standard poker dimensions;
    SKTexture *allCardsTexture = [self allCardsTexture];
    return ([allCardsTexture size].width / 13) / ([allCardsTexture size].height / 4); // Based on image asset
}

+ (SKTexture *)allCardsTexture {
    static SKTexture *allCardsTexture = nil;
    if (allCardsTexture == nil) {
        allCardsTexture = [SKTexture textureWithImageNamed:@"Cards"];
    }
    return allCardsTexture;
}

+ (SKTexture *)textureForCard:(Card *)card {
    CGFloat cardUnitXOffset = [self textureUnitXOffsetForRank:[card rank]];
    CGFloat cardUnitYOffset = [self textureUnitYOffsetForSuit:[card suit]];
    CGRect cardTextureRect = CGRectMake(cardUnitXOffset, cardUnitYOffset, (CGFloat) 1 / 13, (CGFloat) 1 / 4);
    return [SKTexture textureWithRect:cardTextureRect inTexture:[self allCardsTexture]];
}

+ (CGFloat)textureUnitXOffsetForRank:(Rank)rank {
    return (CGFloat) rank / 13;
}

+ (CGFloat)textureUnitYOffsetForSuit:(Suit)suit {
    switch (suit) {
        case SuitClub:
            return (CGFloat) 3 / 4;
        case SuitDiamond:
            return (CGFloat) 0 / 4;
        case SuitHeart:
            return (CGFloat) 1 / 4;
        case SuitSpade:
            return (CGFloat) 2 / 4;
    }
}

- (instancetype)initWithSize:(CGSize)size card:(Card *)card location:(Location *)location {
    self = [super init];
    if (self) {
        SKTexture *texture = [[self class] textureForCard:card];
        [self setTexture:texture];
        [self setAnchorPoint:CGPointMake(0, 0)];
        [self setSize:size];
        _card = card;
        _location = location;
    }
    return self;
}

@end
