//
//  Wonder.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "Wonder.h"

@implementation Wonder

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

- (id) initWithString:(NSString *)wonderData newID: (int) newID cardValue: (int) cardValue{
    
	[self populateWonderFromString:wonderData newID: newID cardValue: (int) cardValue];
    
    return self;
    
}

- (bool) populateWonderFromString: (NSString *) wonderData newID: (int) newID cardValue: (int) cardValue {
	
	bool bRval = true;
	
	// Sample string: 300, Lesser Wonders, Lesser Wonders are worth between 2 and 4 points, ??????
	
	// Parse the string on commas
	NSArray *data = [wonderData componentsSeparatedByString:@","];
	
	rawData = wonderData;
	baseID = (int)[(NSString *)[data objectAtIndex:0] integerValue];
	wonderType = [Wonder wonderTypeFromRawData:wonderData];
	tileType = HexTileTypeWonder;
	descriptiveText = (NSString *)[data objectAtIndex:2];
	requiredPattern = (NSString *)[data objectAtIndex:3];
	idNumber = newID;
	pointValue = cardValue;
	
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
	NSString *rval = [[NSString alloc] initWithFormat:@"Wonder id=%d type=%@ value=%d\ndescriptive text=%@",
					  idNumber, [Wonder wonderTypeToString:wonderType], pointValue, descriptiveText];
	
	return rval;
	
}



@end
