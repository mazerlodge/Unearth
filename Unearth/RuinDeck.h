//
//  RuinDeck.h
//  Unearth
//
//  Created by Paul Sorenson on 10/5/19.
//  Copyright © 2019 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuinCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface RuinDeck : NSObject {
	
	int nextCardIndex;
	NSArray *ruinCards;
	
}

- (id) initWithRuinCards: (NSArray *) startDeck;
- (RuinCard *) getNextCard;
- (NSInteger) getCount;

@end

NS_ASSUME_NONNULL_END
