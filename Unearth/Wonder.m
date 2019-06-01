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

- (id) initWithString:(NSString *)wonderData {
    
	[self populateWonderFromString:wonderData];
    
    return self;
    
}

- (bool) populateWonderFromString: (NSString *) wonderData {
	
	bool bRval = true;
	
	// Sample string: 300, Lesser Wonders, Lesser Wonders are worth between 2 and 4 points, ??????
	
	// Parse the string on commas
	NSArray *data = [wonderData componentsSeparatedByString:@","];
	
	rawData = wonderData;
	baseID = (int)[(NSString *)[data objectAtIndex:0] integerValue];

	NSCharacterSet *cs = [NSCharacterSet whitespaceCharacterSet];
	NSString *wtn = [(NSString *)[data objectAtIndex:1] stringByTrimmingCharactersInSet:cs];
	wonderType = [Wonder wonderTypeFromWonderName:wtn];
	tileType = HexTileTypeWonder;
	
	
	// TODO: Need to set point value & id for lesser/greater, may have to change flow for lesser and greater wonders
	// Ed: Idea, just expand this if card is lesser/greater, loop through and make tiles to stack on wonder card
	idNumber = 42;
	pointValue = -1;
	
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


@end
