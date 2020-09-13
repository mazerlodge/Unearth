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

- (id) initWithColor: (DelverDieColor) dieColor size:(DelverDieSize) dieSize dieBaseID: (int) dieID {
	// Die data in the form "color, size"

	color = dieColor;
	size = dieSize;
	baseID = dieID;
	
    return self;
    
}




- (NSString *) toString {
	// Supports diagnostic and debug printing

	NSString *rval = [[NSString alloc] initWithFormat:@"Delver Die ID=%.3d color=%d, siz=%d",
					  baseID, (int)color, (int)size];
	
	return rval;
	
}

@end
