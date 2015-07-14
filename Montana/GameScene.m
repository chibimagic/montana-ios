//
//  GameScene.m
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import "GameScene.h"
#import "Card.h"

CGFloat const intercardSpacing = 5;

@interface GameScene ()

@property SKTexture *allCardsTexture;

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

@end
