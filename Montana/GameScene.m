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
#import "HighlightNode.h"

CGFloat const intercardSpacing = 5;

@interface GameScene ()

@property CGSize cardSize;
@property CGPoint playingAreaBottomLeft;
@property SKLabelNode *redealsRemainingCountNode;
@property CardNode *activeCardNode;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    SKLabelNode *redealsRemainingTextLabel = [SKLabelNode labelNodeWithText:@"Redeals Remaining:"];
    [redealsRemainingTextLabel setFontName:@"Arial Bold"];
    [redealsRemainingTextLabel setFontSize:12];
    [redealsRemainingTextLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    CGPoint textLabelPosition = CGPointMake(screenSize.width - 20, screenSize.height - 15);
    [redealsRemainingTextLabel setPosition:textLabelPosition];
    [self addChild:redealsRemainingTextLabel];
    
    _redealsRemainingCountNode = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%d", [_game redealsRemaining]]];
    [_redealsRemainingCountNode setFontName:@"Arial Bold"];
    [_redealsRemainingCountNode setFontSize:12];
    CGPoint countNodePosition = CGPointMake(screenSize.width - 15, screenSize.height - 15);
    [_redealsRemainingCountNode setPosition:countNodePosition];
    [self addChild:_redealsRemainingCountNode];
    
    CGFloat cardWidthToHeightRatio = [CardNode widthToHeightRatio];
    CGFloat cardWidth = (screenSize.width - (14 * intercardSpacing)) / 13;
    CGFloat cardHeight = cardWidth / cardWidthToHeightRatio;
    _cardSize = CGSizeMake(cardWidth, cardHeight);
    
    CGFloat playingAreaLeft = intercardSpacing;
    CGFloat playingAreaHeight = (4 * cardHeight) + (3 * intercardSpacing);
    CGFloat playingAreaBottom = (screenSize.height - playingAreaHeight) / 2;
    _playingAreaBottomLeft = CGPointMake(playingAreaLeft, playingAreaBottom);
    
    CGFloat middleLeftRight = screenSize.width/2;
    CGFloat topMiddle = screenSize.height - (playingAreaBottom / 2);
    CGPoint topMiddleCentered = CGPointMake(middleLeftRight, topMiddle);
    SKShapeNode *redealBackground = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(50, 20) cornerRadius:5];
    [redealBackground setPosition:topMiddleCentered];
    [redealBackground setName:@"Redeal"];
    [self addChild:redealBackground];
    SKLabelNode *redealText = [SKLabelNode labelNodeWithText:@"Redeal"];
    [redealText setFontName:@"Arial Bold"];
    [redealText setFontSize:12];
    [redealText setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [redealText setPosition:topMiddleCentered];
    [redealText setName:@"Redeal"];
    [self addChild:redealText];

    CGPoint topLeft = CGPointMake(50, screenSize.height - 15);
    SKShapeNode *newGameBackground = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(70, 20) cornerRadius:5];
    [newGameBackground setPosition:topLeft];
    [newGameBackground setName:@"New Game"];
    [self addChild:newGameBackground];
    SKLabelNode *newGameText = [SKLabelNode labelNodeWithText:@"New Game"];
    [newGameText setFontName:@"Arial Bold"];
    [newGameText setFontSize:12];
    [newGameText setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [newGameText setPosition:topLeft];
    [newGameText setName:@"New Game"];
    [self addChild:newGameText];

    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            [self drawObjectForLocation:location];
        }
    }
}

-(void)drawObjectForLocation:(Location *)location {
    SKNode *node;
    id object = [[_game board] cardAtLocation:location];
    if ([object isKindOfClass:[Card class]]) {
        node = [[CardNode alloc] initWithSize:_cardSize card:object location:location];
    } else if ([[_game availableCardsForLocation:location] count] >= 1) {
        node = [[PlaceholderNode alloc] initNormalWithSize:_cardSize location:location];
    } else {
        node = [[PlaceholderNode alloc] initNoMovesWithSize:_cardSize location:location];
    }
    CGPoint position = [self positionForLocation:location];
    [node setPosition:position];
    [self addChild:node];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchPosition = [touch locationInNode:self];
        SKNode *touchedNode = [self nodeAtPoint:touchPosition];
        if ([touchedNode isKindOfClass:[CardNode class]]) {
            CardNode *touchedCardNode = (CardNode *)touchedNode;
            NSArray *availableLocations = [_game availableLocationsForCard:[touchedCardNode card]];
            if ([availableLocations count] == 1) {
                [self moveCardNode:touchedCardNode to:[availableLocations objectAtIndex:0]];
            } else if ([availableLocations count] > 1) {
                _activeCardNode = touchedCardNode;
            } else {
                NSArray *potentialLocations = [_game potentialLocationsForCard:[touchedCardNode card]];
                for (Location *potentialLocation in potentialLocations) {
                    Card *blockingCard = [[_game board] cardAtLocation:potentialLocation];
                    SKNode *blockingCardNode = [self childNodeWithName:[blockingCard description]];
                    HighlightNode *highlightNode = [[HighlightNode alloc] initWithSize:_cardSize];
                    [highlightNode setPosition:[blockingCardNode position]];
                    [self addChild:highlightNode];
                }
            }
        } else if ([touchedNode isKindOfClass:[PlaceholderNode class]]) {
            PlaceholderNode *touchedPlaceholderNode = (PlaceholderNode *)touchedNode;
            if (_activeCardNode) {
                [self moveCardNode:_activeCardNode to:[touchedPlaceholderNode location]];
                _activeCardNode = nil;
            } else {
                NSArray *availableCards = [_game availableCardsForLocation:[touchedPlaceholderNode location]];
                for (Card *availableCard in availableCards) {
                    SKNode *cardNode = [self childNodeWithName:[availableCard description]];
                    HighlightNode *highlightNode = [[HighlightNode alloc] initWithSize:_cardSize];
                    [highlightNode setPosition:[cardNode position]];
                    [self addChild:highlightNode];
                }
            }
        } else if ([[touchedNode name] isEqualToString:@"Redeal"]) {
            [self redeal];
        } else if ([[touchedNode name] isEqualToString:@"New Game"]) {
            [self newGame];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self enumerateChildNodesWithName:@"HighlightNode" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
}

- (void)moveCardNode:(CardNode *)cardNode to:(Location *)location {
    Card *card = [cardNode card];
    Location *oldLocation = [[_game board] locationOfCard:card];
    [_game moveCard:card to:location];

    SKNode *placeholderNode = [self childNodeWithName:[location description]];
    [placeholderNode removeFromParent];

    CGPoint position = [self positionForLocation:location];
    [cardNode setPosition:position];

    [self drawObjectForLocation:oldLocation];
}

- (void)redeal {
    if ([_game redealsRemaining] == 0) {
        return;
    }
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            Card *card = [[_game board] cardAtLocation:location];
            if (card) {
                [[self childNodeWithName:[card description]] removeFromParent];
            } else {
                [[self childNodeWithName:[location description]] removeFromParent];
            }
        }
    }
    [_game redeal];
    [_redealsRemainingCountNode setText:[NSString stringWithFormat:@"%d", [_game redealsRemaining]]];
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            [self drawObjectForLocation:location];
        }
    }
    if ([_game redealsRemaining] == 0) {
        [self enumerateChildNodesWithName:@"Redeal" usingBlock:^(SKNode *node, BOOL *stop) {
            [node setHidden:YES];
        }];
    }
}

- (void)newGame {
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            Card *card = [[_game board] cardAtLocation:location];
            if (card) {
                [[self childNodeWithName:[card description]] removeFromParent];
            } else {
                [[self childNodeWithName:[location description]] removeFromParent];
            }
        }
    }
    _game = [[Game alloc] init];
    [self enumerateChildNodesWithName:@"Redeal" usingBlock:^(SKNode *node, BOOL *stop) {
        [node setHidden:NO];
    }];
    [_redealsRemainingCountNode setText:[NSString stringWithFormat:@"%d", [_game redealsRemaining]]];
    for (int row = 0; row < 4; row++) {
        for (int column = 0; column < 13; column++) {
            Location *location = [[Location alloc] initWithRow:row column:column];
            [self drawObjectForLocation:location];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (CGPoint)positionForLocation:(Location *)location {
    CGFloat x = _playingAreaBottomLeft.x + ([location column] * _cardSize.width) + ([location column] * intercardSpacing);
    CGFloat y = _playingAreaBottomLeft.y + ((3 - [location row]) * _cardSize.height) + ((3 - [location row]) * intercardSpacing);
    return CGPointMake(x, y);
}

@end
