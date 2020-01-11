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
	
	// Remove the card from the player's hand 
	[delverCards removeObject:cardToPlay];
	
	return cardToPlay;
	
}

- (NSString *) showPlayerActionHelp {
	
	NSString *msg = @"Player action words are:\n";
	
	//TODO: Refactor this to get keywords into a single location
	NSArray *keywords = [[NSArray alloc] initWithObjects:@"help", @"quit", @"done", @"show", @"roll", nil];

	for (NSString *keyword in keywords) {
		msg = [msg stringByAppendingFormat:@"%@\n", keyword];
	}
	
	return msg;
	
}

- (NSString *) showPlayerActionTargetHelp {
	
	NSString *msg = @"Player action target words are:\n";
	
	//TODO: Refactor this to get keywords into a single location
	NSArray *keywords = [[NSArray alloc] initWithObjects:@"help", @"delver", @"dice", @"map", @"ruin", @"wonder", nil];

	for (NSString *keyword in keywords) {
		msg = [msg stringByAppendingFormat:@"%@\n", keyword];
	}
	
	return msg;
	
}

- (NSString *) showPlayerActionTargetLocationHelp {
	
	NSString *msg = @"Player action words are:\n";
	
	//TODO: Refactor this to get keywords into a single location
	NSArray *keywords = [[NSArray alloc] initWithObjects:@"help", @"hand", @"board", nil];

	for (NSString *keyword in keywords) {
		msg = [msg stringByAppendingFormat:@"%@\n", keyword];
	}
	
	return msg;
	
}

- (struct PlayerAction) makePlayerActionNotSet {

	struct PlayerAction rval;
	rval.verb = PlayerActionVerbNotSet;
	rval.target = PlayerActionTargetNotSet;
	rval.targetLocation = PlayerActionTargetLocationNotSet;
	
	return rval;
	
}

- (struct PlayerAction) parsePlayerActionFromString: (NSString *) phrase {

	struct PlayerAction rval = [self makePlayerActionNotSet];

	rval.verb = [self parsePlayerActionVerbFromString:phrase];
	rval.target = [self parsePlayerActionTargetLocationFromString:phrase];
	rval.targetLocation = [self parsePlayerActionTargetLocationFromString:phrase];
	
	return rval;
}

- (PlayerActionVerb) parsePlayerActionVerbFromString: (NSString *) phrase {
	
	PlayerActionVerb rval = PlayerActionVerbNotSet;
	
	// Find verb in phrase
	NSArray *keywords = [[NSArray alloc] initWithObjects:@"help", @"quit", @"done", @"show", @"roll", nil];
	int keyIdxFound = 999;
	int i=0;
	for (NSString *keyword in keywords) {
		NSRange keywordRange = [phrase rangeOfString:keyword options:NSCaseInsensitiveSearch];
		
		if (keywordRange.location != NSNotFound) {
			keyIdxFound = i;
			break;
		}
		
		i++;
	}
	
	// If a keyword wasn't found, return not set as action.
	if (keyIdxFound == 999)
		return rval;
	
	switch(keyIdxFound) {
		case 0:
			rval = PlayerActionVerbHelp;
			break;

		case 1:
			rval = PlayerActionVerbQuit;
			break;

		case 2:
			rval = PlayerActionVerbDone;
			break;

		case 3:
			rval = PlayerActionVerbShow;
			break;

		case 4:
			rval = PlayerActionVerbRoll;
			break;

	}
	
	return rval;
}

- (PlayerActionTarget) parsePlayerActionTargetFromString: (NSString *) phrase {
	
	PlayerActionTarget rval = PlayerActionTargetNotSet;

	NSArray *keywords = [[NSArray alloc] initWithObjects:@"help", @"delver", @"dice", @"map", @"ruin", @"wonder", nil];
	int keyIdxFound = 999;
	int i=0;
	for (NSString *keyword in keywords) {
		NSRange keywordRange = [phrase rangeOfString:keyword options:NSCaseInsensitiveSearch];
		
		if (keywordRange.location != NSNotFound) {
			keyIdxFound = i;
			break;
		}
		
		i++;
	}
	
	// If a keyword wasn't found, return not set as action.
	if (keyIdxFound == 999)
		return rval;
	
	switch(keyIdxFound) {
		case 0:
			rval = PlayerActionTargetHelp;
			break;

		case 1:
			rval = PlayerActionTargetDelver;
			break;

		case 2:
			rval = PlayerActionTargetDice;
			break;

		case 3:
			rval = PlayerActionTargetMap;
			break;

		case 4:
			rval = PlayerActionTargetRuin;
			break;

		case 5:
			rval = PlayerActionTargetWonder;
			break;

	}
	
	return rval;
}

- (PlayerActionTargetLocation) parsePlayerActionTargetLocationFromString: (NSString *) phrase {
	
	PlayerActionTargetLocation rval = PlayerActionTargetLocationNotSet;
	
	NSArray *keywords = [[NSArray alloc] initWithObjects:@"help", @"hand", @"board", nil];
	int keyIdxFound = 999;
	int i=0;
	for (NSString *keyword in keywords) {
		NSRange keywordRange = [phrase rangeOfString:keyword options:NSCaseInsensitiveSearch];
		
		if (keywordRange.location != NSNotFound) {
			keyIdxFound = i;
			break;
		}
		
		i++;
	}
	
	// If a keyword wasn't found, return not set as action.
	if (keyIdxFound == 999)
		return rval;
	
	switch(keyIdxFound) {
		case 0:
			rval = PlayerActionTargetLocationHelp;
			break;

		case 1:
			rval = PlayerActionTargetLocationHand;
			break;

		case 2:
			rval = PlayerActionTargetLocationBoard;
			break;

	}
	
	return rval;
}

- (NSString *) showDelverCards {
	
	NSString *rval = @"Delver Cards:\n";
	
	for (DelverCard *dc in delverCards)
		rval = [rval stringByAppendingFormat:@"%@\n", [dc toString]];
	
	return rval;
	
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

- (UnearthPlayerType) getPlayerType {
	return playerType;
	
}

- (NSString *) toString {
	// Supports diagnostic and debug printing
	
	NSString *rval = [[NSString alloc] initWithFormat:@"UnearthPlayer name=%@ type=%lu dieColor=%lu\n%@\n",
					  playerName,
					  playerType,
					  dieColor,
					  [self showDelverCards]];
	
	return rval;
	

}
@end
