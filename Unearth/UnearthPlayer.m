//
//  UnearthPlayer.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthPlayer.h"

@implementation UnearthPlayer

- (id) initWithPlayerType: (UnearthPlayerType) type dieColor: (DelverDieColor) color playerName: (NSString *) name randomEngine:(RandomEngine *) randomEngine {
    playerType = type;
    playerName = name;
    dieColor = color;
	re = randomEngine;
	
	delverCards = [[NSMutableArray alloc] initWithCapacity:2];
	ruinCards = [[NSMutableArray alloc] initWithCapacity:1];

    return self;
    
}

- (DelverDieColor) dieColor {
    return dieColor;
    
}

- (NSString *) playerName {
    return playerName;
    
}

- (NSUInteger) addDelverCard: (DelverCard *) card {
	NSUInteger delverCardCount = 0;
	
	[delverCards addObject:card];
	delverCardCount = [delverCards count];
	
	return delverCardCount;
}

- (NSUInteger) addRuinCard: (RuinCard *) card {

	NSUInteger ruinCardCount = 0;
	
	[ruinCards addObject:card];
	ruinCardCount = [ruinCards count];
	
	return ruinCardCount;

}

- (DelverCard *) playDelverCard: (int) cardID {
	// Returns a card with baseID = -1 if specified cardID wasn't found.
	
	DelverCard *cardToPlay = [[DelverCard alloc] initWithString:@"-1,NOT_SET,NOT_SET,-1"];
	
	for (DelverCard *aCard in delverCards) {
		if ([aCard cardID] == cardID)
			cardToPlay = aCard;
	}
	
	return cardToPlay;
	
}

- (int) roleDie: (DelverDieSize) dieSize {
	
	int rval = -1;
	int maxDieVal = -1;
	
	switch (dieSize) {
		case DelverDieSize4:
			maxDieVal = 4;
			break;
		
		case DelverDieSize6:
			maxDieVal = 6;
			break;
			
		case DelverDieSize8:
			maxDieVal = 8;
			break;
			
		default:
			break;
	}
	
	rval = [re getNextRandBetween:1 maxValueInclusive:maxDieVal];
	
	return rval;
}


- (NSString *) toString {
	// Supports diagnostic and debug printing
	
	NSString *rval = [[NSString alloc] initWithFormat:@"UnearthPlayer name=%@ type=%lu dieColor=%lu",
					  playerName,
					  playerType,
					  dieColor];
	
	return rval;
	

}
@end
