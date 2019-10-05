//
//  RuinDeck.m
//  Unearth
//
//  Created by Paul Sorenson on 10/5/19.
//  Copyright © 2019 mazerlodge. All rights reserved.
//

#import "RuinDeck.h"

@implementation RuinDeck


- (id) initWithRuinCards: (NSArray *) startDeck {
	
	ruinCards = startDeck;
	
	return self;
	
}

- (RuinCard *) getNextCard {
	
	RuinCard *rval;
	
	rval = ruinCards[nextCardIndex];
	nextCardIndex++;
	
	return rval;
	
}

- (NSInteger) getCount {
	
	NSInteger rval = [ruinCards count] - nextCardIndex;
	
	return rval;
	
}


@end
