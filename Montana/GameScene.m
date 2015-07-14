//
//  GameScene.m
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "GameScene.h"
#import "Card.h"
#import "Location.h"
#import "Board.h"

CGFloat const intercardSpacing = 5;

@interface GameScene ()

@property SKTexture *allCardsTexture;
@property CGSize cardSize;
@property CGPoint playingAreaBottomLeft;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    SKLabelNode *redealsRemainingTextLabel = [SKLabelNode labelNodeWithText:@"Redeals Remaining:"];
    [redealsRemainingTextLabel setFontName:@"Arial Bold"];
    [redealsRemainingTextLabel setFontSize:12];
    [redealsRemainingTextLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    CGPoint upperRightCorner = CGPointMake([self frame].size.width - 20, [self frame].size.height - 15);
    [redealsRemainingTextLabel setPosition:upperRightCorner];
    [self addChild:redealsRemainingTextLabel];
    
    _allCardsTexture = [SKTexture textureWithImageNamed:@"Cards"];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    //    CGFloat cardWidthToHeightRatio = 2.5 / 3.5; // Standard poker dimensions;
    CGFloat cardWidthToHeightRatio = ([_allCardsTexture size].width / 13) / ([_allCardsTexture size].height / 4); // Based on image asset
    CGFloat cardWidth = (screenSize.width - (14 * intercardSpacing)) / 13;
    CGFloat cardHeight = cardWidth / cardWidthToHeightRatio;
    _cardSize = CGSizeMake(cardWidth, cardHeight);
    
    CGFloat playingAreaLeft = intercardSpacing;
    CGFloat playingAreaHeight = (4 * cardHeight) + (3 * intercardSpacing);
    CGFloat playingAreaBottom = (screenSize.height - playingAreaHeight) / 2;
    _playingAreaBottomLeft = CGPointMake(playingAreaLeft, playingAreaBottom);
    
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            id object = [_board cardAtLocation:location];
            if ([object isKindOfClass:[Card class]]) {
                [self displayCard:object atLocation:location];
            }
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)displayCard:(Card *)card atLocation:(Location *)location {
    SKTexture *cardTexture = [self textureForCard:card];
    CGPoint position = [self positionForLocation:location];
    SKSpriteNode *cardNode = [SKSpriteNode spriteNodeWithTexture:cardTexture size:_cardSize];
    [cardNode setAnchorPoint:CGPointMake(0, 0)];
    [cardNode setPosition:position];
    [self addChild:cardNode];
}

- (SKTexture *)textureForCard:(Card *)card {
    CGFloat cardUnitXOffset = [self textureUnitXOffsetForRank:[card rank]];
    CGFloat cardUnitYOffset = [self textureUnitYOffsetForSuit:[card suit]];
    CGRect cardTextureRect = CGRectMake(cardUnitXOffset, cardUnitYOffset, (CGFloat) 1 / 13, (CGFloat) 1 / 4);
    return [SKTexture textureWithRect:cardTextureRect inTexture:_allCardsTexture];
}

- (CGFloat)textureUnitXOffsetForRank:(Rank)rank {
    return (CGFloat) rank / 13;
}

- (CGFloat)textureUnitYOffsetForSuit:(Suit)suit {
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

- (CGPoint)positionForLocation:(Location *)location {
    CGFloat x = _playingAreaBottomLeft.x + ([location column] * _cardSize.width) + ([location column] * intercardSpacing);
    CGFloat y = _playingAreaBottomLeft.y + ((3 - [location row]) * _cardSize.height) + ((3 - [location row]) * intercardSpacing);
    return CGPointMake(x, y);
}

@end
