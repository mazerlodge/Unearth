//
//  Wonder.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "Wonder.h"

@implementation Wonder

- (id) initWithString:(NSString *)wonderData {
    
    rawData = wonderData;
	
	baseID = 42; // TODO: Replace this w/ parsed value from wonderData 
    
    return self;
    
}

@end
