//
//  RandomEngine.m
//  RandomUtility
//
//  Created by mazerlodge on 10/4/09.
//  Copyright 2009 mazerlodge. All rights reserved.
//

#import "RandomEngine.h"
#include <time.h>  // used by getTimeBasedSeed.
#include <math.h>


@implementation RandomEngine

- (id) init {
	
	// Get Date/Time value and use as default seed.
	currentSeed = [self getTimeBasedSeed];
	[self setSeed:currentSeed];
	
    
	// Set current random numbers to 0, none set yet.
	currentRaw = 0;
	currentRandValue = 0;
	
	return self;
	
}

- (int) getTimeBasedSeed {
	// Use the time components multipled together to get a seed.
	// Use +1 for each to avoid zeros.  
	// Add day of week to cause variance between days.
	
	time_t theTime;
	theTime = time(&theTime);
	
	struct tm *t;
	t = localtime(&theTime);
	
	int seedVal = (t->tm_hour+1) * (t->tm_min+1) * (t->tm_sec+1) * (t->tm_wday+1);
	
	return seedVal;
}

- (void) setSeed: (int) seedValue {
	// Set currentSeed to seedValue.
	
	currentSeed = seedValue;
	srandom(currentSeed);
	
}

- (int) getSeed {
	// return the seed currently in use.
	
	return currentSeed;
	
}

- (int) getCurrentRaw {
	// return current raw value.
	
	return currentRaw;
	
}

- (int) getCurrentRandValue {
	// return current random value.
	
	return currentRandValue;
	
}

- (int) getNextRand: (int) numberOfDigits {
	// Return a random number with the specified number of digits.
	// NOTE: 9 digits is pretty much the maximum (randomly, 10 might work).
	
	int rval = 0;
	
	int rv = (int)random();

	// calculate modulus operation denominator.
	int modValue = 1;
	int x;
	for (x=0; x<numberOfDigits; x++)
		modValue = modValue * 10;
	
	modValue = pow(10, numberOfDigits);
	
	rval = rv % modValue;
	
	currentRaw = rv;
	currentRandValue = rval;
	
	return rval;
	
}

- (int) getNextRandInRange: (NSRange) theRange {
	// Return a random number within the specified range, inclusive of endpoints.
	// Process is to get a random number between zero and the number of numbers in the range
	//   then add the minimum number to the random number to get a value in range.
	
	// determine number of digits in range length.
	int digitCount = 1;
	int x;
	for(x=0; x<=10; x++) {
		int divisor = pow(10, x);
		if ((theRange.length / divisor) == 0) {
			digitCount = x;
			break;
		}
		
	}
	
	// get a random number between 0 and length of the range.
	[self getNextRand:digitCount];
	
	// random value is greater than max in range, subtract max in range.
	// repeat until value is within range.
	while (currentRandValue > theRange.length) {
		currentRandValue -= theRange.length;
	}
	
	// add the location value from the range to the currentRandValue to get target random number.
	currentRandValue += theRange.location;
	
	return currentRandValue;
	
}

- (int) getNextRandBetween: (int) minValueInclusive maxValueInclusive: (int) maxValue {
	
	// Create a range from the values specified
	NSRange theRange;
	
	theRange.location = minValueInclusive;
	theRange.length = maxValue - minValueInclusive;
	
	[self getNextRandInRange:theRange];
	
	return currentRandValue;
	
}

@end
