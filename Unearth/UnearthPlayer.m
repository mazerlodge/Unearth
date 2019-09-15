//
//  UnearthPlayer.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthPlayer.h"

@implementation UnearthPlayer

- (id) initWithPlayerType: (UnearthPlayerType) type dieColor: (DelverDieColor) color playerName: (NSString *) name {
    playerType = type;
    playerName = name;
    dieColor = color;
	
	delverCards = [[NSMutableArray alloc] initWithCapacity:2];
	
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

- (DelverCard *) playDelverCard: (int) cardID {
	// Returns a card with baseID = -1 if specified cardID wasn't found.
	
	DelverCard *cardToPlay = [[DelverCard alloc] initWithString:@"-1,NOT_SET,NOT_SET,-1"];
	
	for (DelverCard *aCard in delverCards) {
		if ([aCard cardID] == cardID)
			cardToPlay = aCard;
	}
	
	return cardToPlay;
	
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
