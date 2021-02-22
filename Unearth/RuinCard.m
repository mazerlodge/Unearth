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

- (NSUInteger) addStoneToCard: (Stone *) stoneToAdd {
	[stones addObject:stoneToAdd];
	
	return [stones count];
}

- (int) stoneValue {
	return cardStoneValue;
	
}

- (NSString *) toString {
	// Supports diagnostic and debug printing
	
	// TODO: Add Delver Dice to output string.
	
	
	
	NSString *rval = [[NSString alloc] initWithFormat:@"Ruin Card id=%d color=%@ claimValue=%d cardStoneValue=%d",
					  cardID, [RuinCard RuinCardColorToString:cardColor], claimValue, cardStoneValue];
	
	if ([stones count] > 0) {
		NSString *stonesMsg = @"\nStones on card:\n";
		for (int x=0; x<[stones count]; x++) {
			Stone *currentStone = [stones objectAtIndex:x];
			stonesMsg = [stonesMsg stringByAppendingFormat:@"\t%@\n", [currentStone toString]];
		}

		rval = [rval stringByAppendingFormat:@"%@", stonesMsg];
	}
	
	
	return rval;
	
}
@end
