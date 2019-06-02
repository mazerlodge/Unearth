//
//  EndOfAgeCard.m
//  Unearth
//
//  Created by mazerlodge on 11/18/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "EndOfAgeCard.h"

@implementation EndOfAgeCard

- (id) initWithString: (NSString *) cardData {
    
	[self populateEOACardFromString:cardData];
    
    return self;
    
}

- (bool) populateEOACardFromString: (NSString *) cardData {
	bool bRval = true;
	
	// Sample string: #ID, Title, Text, ClaimValue, StoneValue
	// Sample string: 200, Day of Rest, Each player draws three cards from the Delver deck, 0, 0
	
	// Parse the string on commas
	NSArray *data = [cardData componentsSeparatedByString:@","];
	NSCharacterSet *cs = [NSCharacterSet whitespaceCharacterSet];

	rawData = cardData;
	idNumber = (int)[(NSString *)[data objectAtIndex:0] integerValue];
	title = [(NSString *)[data objectAtIndex:1] stringByTrimmingCharactersInSet:cs];
	descriptiveText = [(NSString *)[data objectAtIndex:2] stringByTrimmingCharactersInSet:cs];
	claimValue = (int)[(NSString *)[data objectAtIndex:3] integerValue];
	stoneValue = (int)[(NSString *)[data objectAtIndex:4] integerValue];

	return bRval;
	
}

- (NSString *) toString {
	// Supports diagnostic and debug printing
	
	// TODO: Add Delver Dice to output string.
	
	NSString *rval = [[NSString alloc] initWithFormat:@"End Of Age Card id=%d title=%@\
					  									\nclaimValue=%d StoneValue=%d\nText=%@",
					  					idNumber, title, claimValue, stoneValue, descriptiveText];
	
	return rval;
	
}


@end
