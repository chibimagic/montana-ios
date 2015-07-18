//
//  CardNode.h
//  Montana
//
//  Created by Eileen Xie on 7/18/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class Card;
@class Location;

@interface CardNode : SKSpriteNode

@property Card *card;
@property Location *location;

+ (CGFloat)widthToHeightRatio;
- (instancetype)initWithSize:(CGSize)size card:(Card *)card location:(Location *)location;

@end
