//
//  PlaceholderNode.h
//  Montana
//
//  Created by Eileen Xie on 7/18/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class Location;

@interface PlaceholderNode : SKShapeNode

@property (readonly) BOOL movesPossible;
@property CGSize size;
@property Location *location;

- (instancetype)initNormalWithSize:(CGSize)size location:(Location *)location;
- (instancetype)initNoMovesWithSize:(CGSize)size location:(Location *)location;

@end
