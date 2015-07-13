//
//  Deck.h
//  Montana
//
//  Created by Eileen Xie on 7/13/15.
//  Copyright (c) 2015 chibimagic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deck : NSObject

@property NSMutableArray *cards;

+ (instancetype)deckForNewGame;
- (instancetype)initWithCards:(NSArray *)cards;
- (void)shuffle;

@end
