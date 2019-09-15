//
//  DelverCard.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "DelverCard.h"

@implementation DelverCard

@synthesize cardID = baseID;

- (id) initWithString: (NSString *) cardData; {
    
	[self populateDelverCardFromString:cardData];
    
    return self;
    
}


- (bool) populateDelverCardFromString: (NSString *) cardData {
	bool bRval = true;
	
	// Sample string: #ID, Title, Text, Count
	// Sample string: 100, Ancient Map, This turn you may reroll your Excavation roll., 5
	
	// Parse the string on commas
	NSArray *data = [cardData componentsSeparatedByString:@","];
	NSCharacterSet *cs = [NSCharacterSet whitespaceCharacterSet];
	
	rawData = cardData;
	baseID = (int)[(NSString *)[data objectAtIndex:0] integerValue];
	title = [(NSString *)[data objectAtIndex:1] stringByTrimmingCharactersInSet:cs];
	descriptiveText = [(NSString *)[data objectAtIndex:2] stringByTrimmingCharactersInSet:cs];
	
	return bRval;
	
}


- (NSString *) toString {
	// Supports diagnostic and debug printing

	NSString *rval = [[NSString alloc] initWithFormat:@"Delver Card baseID=%d title=%@\
					  \nText=%@",
					  baseID, title, descriptiveText];
	
	return rval;
	
}


@end
