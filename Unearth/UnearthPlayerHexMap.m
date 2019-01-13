//
//  UnearthPlayerHexMap.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthPlayerHexMap.h"

@implementation UnearthPlayerHexMap

- (id) init {
	
	cli = [[CommandLineInterface alloc] init];
    UnearthPlayerHexCell *aCell = [[UnearthPlayerHexCell alloc] initWithRow:50 Column:50];
    hexCells = [[NSArray alloc] initWithObjects:aCell, nil];

    return self;
    
}

- (UnearthPlayerHexCell *) getOriginHexCell {
	// Return the origin hex cell, it was loaded at index 0 during init.
	return [hexCells objectAtIndex:0];
	
}

- (bool) addStone: (Stone *) s atHexCell: (UnearthPlayerHexCell *) c {
	bool bRval = false;
	
	// TODO: Flesh out Hex Map addStone method.
	NSString *msg = [NSString stringWithFormat:@"In addStone atHexCell with Stone %d\n", [s getStoneID]];
	[cli put:msg];
	
	return bRval;
	
}

- (bool) addStone: (Stone *) s touchingHexCell: (UnearthPlayerHexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;
    
    // TODO: Flesh out Hex Map addStone method.
	NSString *msg = [NSString stringWithFormat:@"In addStone touchingHexCell with Stone %d\n", [s getStoneID]];
	[cli put:msg];
    
    return bRval;
    
}

- (bool) addWonder: (Wonder *) w atHexCell: (UnearthPlayerHexCell *) c {
	bool bRval = false;
	
	// TODO: Flesh out Hex Map addWonder method.
	NSString *msg = [NSString stringWithFormat:@"In addWonder atHexCell with Stone %d\n", [w getBaseID]];
	[cli put:msg];

	return bRval;
	
}

- (bool) addWonder: (Wonder *) w touchingHexCell: (UnearthPlayerHexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;

    // TODO: Flesh out Hex Map addWonder method.
	NSString *msg = [NSString stringWithFormat:@"In addWonder with Wonder %d\n", [w getBaseID]];
	[cli put:msg];

    return bRval;
    
}

@end
