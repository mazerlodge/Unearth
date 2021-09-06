//
//  RuinCard.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "RuinCard.h"

@implementation RuinCard

+ (NSString *) RuinCardColorToString: (RuinCardColor) color {
	
	NSString *rval = @"NOT_SET";
	
	switch(color) {
		case RuinCardColorBlue:
			rval = @"Blue";
			break;
			
		case RuinCardColorGray:
			rval = @"Gray";
			break;
			
		case RuinCardColorGreen:
			rval = @"Green";
			break;
			
		case RuinCardColorPeach:
			rval = @"Peach";
			break;
			
		case RuinCardColorPurple:
			rval = @"Purple";
			break;
	}
	
	return rval;
	
}


- (id) initWithColor: (RuinCardColor) color claimValue: (int) claimVal stoneValue: (int) stoneVal cardIdentifier: (int) cardIdentifier {
    
    bFaceDown = true;
    cardColor = color;
    claimValue = claimVal;
    cardStoneValue = stoneVal;
	cardID = cardIdentifier;
    stones = [[NSMutableArray alloc] initWithCapacity:stoneVal];
    delverDice = [[NSMutableArray alloc] init];
    
    return self;
    
}

- (NSUInteger) addDieToCard: (DelverDie *) dieToAdd {
	[delverDice addObject:dieToAdd];
	
	// Add up total of dice on card, return that total (used to determine if card has been claimed)
	NSUInteger total = 0;
	for (DelverDie *aDie in delverDice)
		total += [aDie getDieValue];
	
	return total;
	
}

- (NSUInteger) addStoneToCard: (Stone *) stoneToAdd {
	[stones addObject:stoneToAdd];
	
	return [stones count];
}

- (int) getRuinID {
	return cardID;
	
}

- (int) getDiceTotal {
	// Recalc die total and return value
	int rval = 0;
	
	for (DelverDie *aDie in delverDice)
		rval += [aDie getDieValue];
	
	return rval;
}


- (int) stoneValue {
	return cardStoneValue;
	
}


- (NSString *) toString {
	// Supports diagnostic and debug printing

	NSString *rval = [[NSString alloc] initWithFormat:@"Ruin Card id=%d color=%@ claimValue=%d cardStoneValue=%d diceTotal=%d",
					  cardID, [RuinCard RuinCardColorToString:cardColor], claimValue,
					  cardStoneValue, [self getDiceTotal]];
	
	if ([stones count] > 0) {
		NSString *stonesMsg = @"\nStones on card:\n";
		for (int x=0; x<[stones count]; x++) {
			Stone *currentStone = [stones objectAtIndex:x];
			stonesMsg = [stonesMsg stringByAppendingFormat:@"\t%@\n", [currentStone toString]];
		}

		rval = [rval stringByAppendingFormat:@"%@", stonesMsg];
	}

	if ([delverDice count] > 0) {
		NSString *diceMsg = @"\nDice on card:\n";
		for (DelverDie *aDie in delverDice) {
			diceMsg = [diceMsg stringByAppendingFormat:@"\t%@\n", [aDie toString]];
		}

		rval = [rval stringByAppendingFormat:@"%@", diceMsg];
	}

	
	return rval;
	
}
@end
