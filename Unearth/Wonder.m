//
//  Wonder.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "Wonder.h"

@implementation Wonder

+ (NSString *) wonderTypeToString: (WonderType) wonderType {
	
	NSString *rval = @"NOT_SET";
	
	switch(wonderType) {
		case WonderTypeNamed:
			rval = @"Named Wonder";
			break;
			
		case WonderTypeGreater:
			rval = @"Greater Wonder";
			break;
			
		case WonderTypeLesser:
			rval = @"Lesser Wonder";
			break;
	}
	
	return rval;
			
}

+ (WonderType) wonderTypeFromWonderName: (NSString *) wonderName {
	
	WonderType rval = WonderTypeNamed;
	
	if ([wonderName compare:@"Greater Wonders"] == NSOrderedSame)
		rval = WonderTypeGreater;
	
	if ([wonderName compare:@"Lesser Wonders"] == NSOrderedSame)
		rval = WonderTypeLesser;

	return rval;
}

+ (WonderType) wonderTypeFromRawData: (NSString *) rawData {

	WonderType rval = WonderTypeNamed;
	
	NSString *wonderName = [Wonder wonderNameFromRawData:rawData];
	
	
	if ([wonderName compare:@"Greater Wonders"] == NSOrderedSame)
		rval = WonderTypeGreater;
	
	if ([wonderName compare:@"Lesser Wonders"] == NSOrderedSame)
		rval = WonderTypeLesser;
	
	return rval;
}

+ (NSString *) wonderNameFromRawData: (NSString *) rawData {
	
	NSCharacterSet *cs = [NSCharacterSet whitespaceCharacterSet];
	NSArray *data = [rawData componentsSeparatedByString:@","];

	NSString *rval = [(NSString *)[data objectAtIndex:1] stringByTrimmingCharactersInSet:cs];

	return rval;
}


- (id) initWithString:(NSString *)wonderData newID: (int) newID pointValue: (int) value{
    
	[self populateWonderFromString:wonderData newID: newID pointValue:value];
    
    return self;
    
}

- (bool) populateWonderFromString: (NSString *) wonderData newID: (int) newID pointValue: (int) value {
	// Note: If cardValue passed in is -1, the value is determined from the 4th segment of the wonderData.
	bool bRval = true;
	
	// Sample string: 300, Lesser Wonders, Lesser Wonders are worth between 2 and 4 points, ??????, -1
	
	// Parse the string on commas
	NSArray *data = [wonderData componentsSeparatedByString:@","];
	
	rawData = wonderData;
	baseID = (int)[(NSString *)[data objectAtIndex:0] integerValue];
	wonderType = [Wonder wonderTypeFromRawData:wonderData];
	tileType = HexTileTypeWonder;
	title = (NSString *)[[data objectAtIndex:1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	descriptiveText = (NSString *)[[data objectAtIndex:2] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	requiredPattern = (NSString *)[[data objectAtIndex:3] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	idNumber = newID;
	
	if (value == -1)
		pointValue = (int)[(NSString *)[data objectAtIndex:4] integerValue];
	else
		pointValue = value;

	return bRval;
	
}

- (WonderType) wonderType {
	return wonderType;
	
}

- (NSString *) getWonderTypeAsShortString {
	
	NSString *rval = @"!?!";
	
	switch(wonderType) {
		case WonderTypeGreater:
			rval = @"GRT";
			break;
			
		case WonderTypeLesser:
			rval = @"LES";
			break;
			
		case WonderTypeNamed:
			rval = @"NME";
			break;
			
		default:
			rval = @"???";
			break;
	}
	
	return rval;
	
}

- (int) getWonderID {
	
	return idNumber;
	
}

- (NSString *) toString {
	// Supports diagnostic and debug printing
	
	return [self toStringBriefOutput:false];
	
}

- (NSString *) toStringBriefOutput: (bool) bBriefOutput {
	// Supports diagnostic and debug printing
	
	NSString *pointValueMsg = [[NSString alloc] initWithFormat:@"%d", pointValue];
	if (pointValue == 0)
		pointValueMsg = @"Determined at end of game";
	
	NSString *rval;
	
	if (bBriefOutput) {
		rval = [[NSString alloc] initWithFormat:@"%.3d Pattern=%@ Title=%@", idNumber, requiredPattern, title];

	}
	else {
		rval = [[NSString alloc] initWithFormat:@"Wonder ID=%d Title=%@\n\tType=%@\n\tDescriptive text=%@\n\tValue=%@\n\tRequired Pattern=%@",
						  idNumber, title,
				[Wonder wonderTypeToString:wonderType],
				descriptiveText,
				pointValueMsg,
				requiredPattern];

	}
	
	return rval;
	
}

@end
