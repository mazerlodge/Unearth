//
//  DelverDie.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "DelverDie.h"

@implementation DelverDie

@synthesize dieID = baseID;
@synthesize dieColor = color;
@synthesize dieSize = size;

+ (NSString *) DelverDieColorToString: (DelverDieColor) color {
	
	NSString *rval = @"NOT_SET";
	
	switch(color) {
		case DelverDieColorOrange:
			rval = @"Orange";
			break;
			
		case DelverDieColorYellow:
			rval = @"Yellow";
			break;
			
		case DelverDieColorGreen:
			rval = @"Green";
			break;
			
		case DelverDieColorBlue:
			rval = @"Blue";
			break;
			
	}
	
	return rval;
	
}

+ (NSString *) DelverDieSizeToString: (DelverDieSize) size {
	
	NSString *rval = @"NOT_SET";
	
	switch(size) {
		case DelverDieSize4:
			rval = @"D4";
			break;
			
		case DelverDieSize6:
			rval = @"D6";
			break;
			
		case DelverDieSize8:
			rval = @"D8";
			break;
			
	}
	
	return rval;
	
}

- (id) initWithColor: (DelverDieColor) dieColor size:(DelverDieSize) dieSize dieBaseID: (int) dieID {
	// Die data in the form "color, size"

	color = dieColor;
	size = dieSize;
	baseID = dieID;
	
    return self;
    
}




- (NSString *) toString {
	// Supports diagnostic and debug printing
	
	NSString *dieColor = [DelverDie DelverDieColorToString:color];
	NSString *dieSize = [DelverDie DelverDieSizeToString:size];

	NSString *rval = [[NSString alloc] initWithFormat:@"Delver Die ID=%.3d color=%@, size=%@",
					  baseID, dieColor, dieSize];
	
	return rval;
	
}

@end
