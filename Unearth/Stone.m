//
//  Stone.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "Stone.h"

@implementation Stone


+ (NSString *) StoneColorToString: (StoneColor) color {
	
	NSString *rval;
	
	switch(color) {
		case StoneColorRed:
			rval = @"Red";
			break;
			
		case StoneColorBlue:
			rval = @"Blue";
			break;
			
		case StoneColorBlack:
			rval = @"Black";
			break;
			
		case StoneColorYellow:
			rval = @"Yellow";
			break;
			
		default:
			rval = @"Unknown";
			break;
		
	}
	
	return rval;
	
}


- (id) initWithColor: (StoneColor) initColor idNumber:(int) initID {
    
    idNumber = initID;
	baseID = initID;
	
    color = initColor;
    
    return self;
    
}


- (NSString *) getStoneColorAsShortString {
	
	NSString *rval = @"!?!";
	
	switch(color) {
		case StoneColorRed:
			rval = @"Red";
			break;
			
		case StoneColorBlue:
			rval = @"Blu";
			break;
			
		case StoneColorBlack:
			rval = @"Blk";
			break;
			
		case StoneColorYellow:
			rval = @"Yel";
			break;
			
		default:
			rval = @"???";
			break;
	}
	
	return rval;

}


- (int) getStoneID {

    return idNumber;
    
}


- (NSString *) toString {
	// Supports diagnostic and debug printing
	NSString *rval = [[NSString alloc] initWithFormat:@"Stone id=%d color=%@",
					  idNumber, [Stone StoneColorToString:color]];
	
	return rval;
	
}

@end
