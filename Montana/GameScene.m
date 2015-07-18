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
#import "Game.h"
#import "CardNode.h"
#import "PlaceholderNode.h"

CGFloat const intercardSpacing = 5;

@interface GameScene ()

@property CGSize cardSize;
@property CGPoint playingAreaBottomLeft;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    SKLabelNode *redealsRemainingTextLabel = [SKLabelNode labelNodeWithText:@"Redeals Remaining:"];
    [redealsRemainingTextLabel setFontName:@"Arial Bold"];
    [redealsRemainingTextLabel setFontSize:12];
    [redealsRemainingTextLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    CGPoint textLabelPosition = CGPointMake([self frame].size.width - 20, [self frame].size.height - 15);
    [redealsRemainingTextLabel setPosition:textLabelPosition];
    [self addChild:redealsRemainingTextLabel];
    
    SKLabelNode *redealsRemainingCountLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d", [_game redealsRemaining]]];
    [redealsRemainingCountLabel setFontName:@"Arial Bold"];
    [redealsRemainingCountLabel setFontSize:12];
    CGPoint countLabelPosition = CGPointMake([self frame].size.width - 15, [self frame].size.height - 15);
    [redealsRemainingCountLabel setPosition:countLabelPosition];
    [self addChild:redealsRemainingCountLabel];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat cardWidthToHeightRatio = [CardNode widthToHeightRatio];
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
            id object = [[_game board] cardAtLocation:location];
            if ([object isKindOfClass:[Card class]]) {
                [self displayCard:object atLocation:location];
            } else if ([[_game possibleCardsForLocation:location] count] >= 1) {
                [self displayBlankSpaceAtLocation:location];
            } else {
                [self displayNoMoveSpaceAtLocation:location];
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
    CGPoint position = [self positionForLocation:location];
    CardNode *cardNode = [[CardNode alloc] initWithSize:_cardSize card:card location:location];
    [cardNode setPosition:position];
    [self addChild:cardNode];
}

- (CGPoint)positionForLocation:(Location *)location {
    CGFloat x = _playingAreaBottomLeft.x + ([location column] * _cardSize.width) + ([location column] * intercardSpacing);
    CGFloat y = _playingAreaBottomLeft.y + ((3 - [location row]) * _cardSize.height) + ((3 - [location row]) * intercardSpacing);
    return CGPointMake(x, y);
}

- (void)displayBlankSpaceAtLocation:(Location *)location {
    CGPoint position = [self positionForLocation:location];
    PlaceholderNode *placeholderNode = [[PlaceholderNode alloc] initNormalWithSize:_cardSize location:location];
    [placeholderNode setPosition:position];
    [self addChild:placeholderNode];
}

- (void)displayNoMoveSpaceAtLocation:(Location *)location {
    CGPoint position = [self positionForLocation:location];
    PlaceholderNode *noMoveNode = [[PlaceholderNode alloc] initNoMovesWithSize:_cardSize location:location];
    [noMoveNode setPosition:position];
    [self addChild:noMoveNode];
}

@end
