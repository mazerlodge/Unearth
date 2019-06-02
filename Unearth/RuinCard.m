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


- (id) initWithColor: (RuinCardColor) color claimValue: (int) claimVal stoneValue: (int) stoneVal {
    
    bFaceDown = true;
    cardColor = color;
    claimValue = claimVal;
    stoneValue = stoneVal;
    
    stones = [[NSMutableArray alloc] initWithCapacity:stoneVal];
    delverDice = [[NSMutableArray alloc] init];
    
    return self;
    
}


- (NSString *) toString {
	// Supports diagnostic and debug printing
	
	// TODO: Add Delver Dice to output string.
	
	NSString *rval = [[NSString alloc] initWithFormat:@"Ruin Card color=%@ claimValue=%d StoneValue=%d",
					  [RuinCard RuinCardColorToString:cardColor], claimValue, stoneValue];
	
	return rval;
	
}
@end
