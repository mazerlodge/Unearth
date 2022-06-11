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

+ (NSArray *) GetDieWords {
	
	NSArray *dieWords = [[NSArray alloc] initWithObjects:@"d4", @"d6", @"d8", nil];

	return dieWords;
	
}


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

+ (int) DelverDieSizeToNumber: (DelverDieSize) size {
	int rval = 0;
	
	switch(size) {
		case DelverDieSizeNotSet:
			rval = 0;
			break;

		case DelverDieSize4:
			rval = 4;
			break;
			
		case DelverDieSize6:
			rval = 6;
			break;
			
		case DelverDieSize8:
			rval = 8;
			break;

	}
	
	return rval;

}


+ (NSString *) DelverDieSizeToString: (DelverDieSize) size {
	
	NSString *rval = @"NOT_SET";
	
	switch(size) {
		case DelverDieSizeNotSet:
			rval = @"NOT_SET";
			break;

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


+ (NSInteger) DelverDieStringToNumber: (NSString *) dieString {
	
	NSInteger rval = 0;
	
	// Get integer portion of string (e.g. d4 = 4)
	NSArray *dieWords = [DelverDie GetDieWords];
	for (NSString *dieWord in dieWords) {
		if ([dieWord caseInsensitiveCompare:dieString] == NSEqualToComparison) {
			rval = [[dieString substringFromIndex:1] integerValue];
			break;

		}
	} // for dieWord
	
	return rval;
	
}


+ (DelverDieSize) DelverDieStringToSize: (NSString *) dieString {
	
	DelverDieSize rval = DelverDieSizeNotSet;
	
	// Get integer portion of string (e.g. d4 = 4)
	NSInteger dieNumber = 0;
	bool bDieStringValid = false;
	NSArray *dieWords = [DelverDie GetDieWords];
	for (NSString *dieWord in dieWords) {
		if ([dieWord caseInsensitiveCompare:dieString] == NSEqualToComparison) {
			dieNumber = [[dieString substringFromIndex:1] integerValue];
			bDieStringValid = true;
			break;

		}
	} // for dieWord

	switch(dieNumber) {
		case 4:
			rval = DelverDieSize4;
			break;
			
		case 6:
			rval = DelverDieSize6;
			break;
			
		case 8:
			rval = DelverDieSize8;
			break;
			
	}
	
	return rval;
	
}


- (id) initWithColor: (DelverDieColor) dieColor size:(DelverDieSize) dieSize
		   dieBaseID: (int) dieID randomEngine: (RandomEngine *) randEngine {
	// Die data in the form "color, size"

	color = dieColor;
	size = dieSize;
	baseID = dieID;
	re = randEngine;
	
    return self;
    
}


- (int) getDieID {
	return baseID;
	
}


- (DelverDieSize) getDieSize {
	
	return size;
	
}

- (int) getDieValue {
	
	return dieValue;
	
}

- (int) roll {
	// Roll the die and set it's value

	// Ensure the die can be set to the value specified
	int dieMaxValue = [DelverDie DelverDieSizeToNumber:size];

	dieValue = [re getNextRandBetween:1 maxValueInclusive:dieMaxValue];

	return dieValue;
	
}

- (int) setDieValue: (int) valueToSet {
	// Set dieValue to value specified and returns that value if successful.
	// If value too big or too small returns 0;
	
	int rval = 0;
	
	// Ensure the die can be set to the value specified
	int dieMaxValue = [DelverDie DelverDieSizeToNumber:size];
	
	if ((valueToSet > 0) && (valueToSet <= dieMaxValue)) {
		dieValue = valueToSet;
		rval = valueToSet;
	}
	
	return rval;
	
}

- (NSString *) toString {
	// Supports diagnostic and debug printing
	
	NSString *dieColor = [DelverDie DelverDieColorToString:color];
	NSString *dieSize = [DelverDie DelverDieSizeToString:size];

	NSString *rval = [[NSString alloc] initWithFormat:@"Delver Die ID=%.3d color=%@, size=%@ value=%d",
					  baseID, dieColor, dieSize, dieValue];
	
	return rval;
	
}

@end
