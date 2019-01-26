//
//  HexMap.m
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "HexMap.h"

@implementation HexMap

- (id) init {
	
	cli = [[CommandLineInterface alloc] init];
    HexCell *aCell = [[HexCell alloc] initWithRow:50 Column:50];
    hexCells = [[NSArray alloc] initWithObjects:aCell, nil];

    return self;
    
}

- (HexCell *) getOriginHexCell {
	// Return the origin hex cell, it was loaded at index 0 during init.
	return [hexCells objectAtIndex:0];
	
}

- (bool) addStone: (Stone *) s atHexCell: (HexCell *) c {
	bool bRval = false;
	
	// TODO: Flesh out Hex Map addStone method.
	NSString *msg = [NSString stringWithFormat:@"In addStone atHexCell with Stone %d\n", [s getStoneID]];
	[cli put:msg];
	
	return bRval;
	
}

- (bool) addStone: (Stone *) s touchingHexCell: (HexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;
    
	// TODO: Flesh out Hex Map addStone w/ 'touching' param method.
	NSString *msg = [NSString stringWithFormat:@"In addStone touchingHexCell with Stone %d\n", [s getStoneID]];
	[cli put:msg];
    
    return bRval;
    
}

- (bool) addWonder: (Wonder *) w atHexCell: (HexCell *) c {
	bool bRval = false;
	
	// TODO: Flesh out Hex Map addWonder method.
	NSString *msg = [NSString stringWithFormat:@"In addWonder atHexCell with Stone %d\n", [w getBaseID]];
	[cli put:msg];

	return bRval;
	
}

- (bool) addWonder: (Wonder *) w touchingHexCell: (HexCell *) c onSide: (HexDirection) direction {
    bool bRval = false;

	// TODO: Flesh out Hex Map addWonder w/ 'touching' param method.
	NSString *msg = [NSString stringWithFormat:@"In addWonder with Wonder %d\n", [w getBaseID]];
	[cli put:msg];

    return bRval;
    
}

@end
