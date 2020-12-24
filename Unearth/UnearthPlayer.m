//
//  UnearthPlayer.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthPlayer.h"

@implementation UnearthPlayer


+ (NSString *) UnearthPlayerTypeToString: (UnearthPlayerType) playerType {
	
	NSString *rval = @"NOT_SET";
	
	switch(playerType) {
		case UnearthPlayerNotSet:
			rval = @"NOT_SET";
			break;

		case UnearthPlayerHuman:
			rval = @"Human";
			break;
			
		case UnearthPlayerAI:
			rval = @"AI";
			break;
						
	}
	
	return rval;
}

+ (NSString *) PlayerActionVerbToString: (PlayerActionVerb) verb {
	
	NSString *rval = @"NOT_SET";
	
	switch(verb) {
		case PlayerActionVerbNotSet:
			rval = @"NOT_SET";
			break;
			
		case PlayerActionVerbHelp:
			rval = @"Help";
			break;

		case PlayerActionVerbQuit:
			rval = @"Quit";
			break;

		case PlayerActionVerbDone:
			rval = @"Done";
			break;

		case PlayerActionVerbShow:
			rval = @"Show";
			break;
			
		case PlayerActionVerbRoll:
			rval = @"Roll";
			break;

		case PlayerActionVerbExamine:
			rval = @"Examine";
			break;

	}
	
	return rval;
}

+ (NSString *) PlayerActionTargetToString: (PlayerActionTarget) target {
	
	NSString *rval = @"NOT_SET";
	
	switch(target) {
		case PlayerActionTargetNotSet:
			rval = @"NOT_SET";
			break;
			
		case PlayerActionTargetHelp:
			rval = @"Help";
			break;

		case PlayerActionTargetDelver:
			rval = @"Delver";
			break;

		case PlayerActionTargetDice:
			rval = @"Dice";
			break;

		case PlayerActionTargetMap:
			rval = @"Map";
			break;
			
		case PlayerActionTargetRuin:
			rval = @"Ruin";
			break;

		case PlayerActionTargetWonder:
			rval = @"Wonder";
			break;

	}
	
	return rval;
}

+ (NSString *) PlayerActionTargetLocationToString: (PlayerActionTargetLocation) location {
	
	NSString *rval = @"NOT_SET";
	
	switch(location) {
		case PlayerActionTargetLocationNotSet:
			rval = @"NOT_SET";
			break;
			
		case PlayerActionTargetLocationHelp:
			rval = @"Help";
			break;

		case PlayerActionTargetLocationHand:
			rval = @"Hand";
			break;

		case PlayerActionTargetLocationBoard:
			rval = @"Board";
			break;

	}
	
	return rval;
}

- (id) initWithPlayerType: (UnearthPlayerType) type
				 dieColor: (DelverDieColor) color
				  diceSet: (NSMutableArray *) playerDice
			   playerName: (NSString *) name
				   hexMap: (HexMap *) aMap
			 randomEngine:(RandomEngine *) randomEngine {
	re = randomEngine;
	map = aMap;
    playerType = type;
    playerName = name;
	DelverDie *aDie = [playerDice objectAtIndex:0];
    dieColor = [aDie dieColor];
	
	delverCards = [[NSMutableArray alloc] initWithCapacity:2];
	ruinCards = [[NSMutableArray alloc] initWithCapacity:1];
	dice = playerDice;


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

- (Wonder *) getWonderByID:(NSUInteger)objectID {
	
	Wonder *rval = nil;
	
	[map getWonderByID:objectID];
	
	return rval;
	
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
	rval.target = [self parsePlayerActionTargetFromString:phrase];
	rval.targetLocation = [self parsePlayerActionTargetLocationFromString:phrase];
	rval.objectID = [self parsePlayerActionObjectIDFromString: phrase];
	
	return rval;
}

- (PlayerActionVerb) parsePlayerActionVerbFromString: (NSString *) phrase {
	
	PlayerActionVerb rval = PlayerActionVerbNotSet;
	
	// Find verb in phrase
	NSArray *keywords = [[NSArray alloc] initWithObjects:@"help", @"quit", @"done", @"show",
														 @"roll", @"examine", nil];
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

		case 5:
			rval = PlayerActionVerbExamine;
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
	
	NSArray *keywords = [[NSArray alloc] initWithObjects:@"help", @"hand", @"board", @"table", nil];
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
		case 3:
			rval = PlayerActionTargetLocationBoard;
			break;

	}
	
	return rval;
}


- (NSUInteger) parsePlayerActionObjectIDFromString: (NSString *) phrase {
	// Return the first number found in the specified phrase (e.g. examine wonder 089 returns 89)
		
	NSUInteger rval = 999;
	
	NSArray *words = [phrase componentsSeparatedByString:@" "];
	
	for (NSString *aWord in words) {
		NSUInteger sampleVal = [aWord integerValue];
		if (sampleVal > 0) {
			rval = sampleVal;
			break;
			
		}
		
	} // for aWord

	return rval;
	
}

- (NSString *) showDelverCards {
	
	NSString *rval = @"Delver Cards:\n";
	
	for (DelverCard *dc in delverCards)
		rval = [rval stringByAppendingFormat:@"%@\n", [dc toString]];
	
	return rval;
	
}

- (NSString *) showRuinCards {
	
	NSString *rval = @"Ruin Cards:\n";
	
	for (RuinCard *rc in ruinCards)
		rval = [rval stringByAppendingFormat:@"%@\n", [rc toString]];
	
	return rval;
	
}

- (NSString *) showDice {
	
	NSString *rval = @"Dice in player's hand:\n";
	
	for (DelverDie *die in dice)
		rval = [rval stringByAppendingFormat:@"%@\n", [die toString]];
	
	return rval;
	
}

- (void) showMap {
	
	[map drawMap];
	
}

- (void) showMapWonders {
	// Print a list of wonders from the map.
	
	[map showWonders];
	
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
