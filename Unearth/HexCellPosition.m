//
//  HexCellPosition.m
//  Unearth
//
//  Created by Mazerlodge on 2/16/19.
//  Copyright © 2019 mazerlodge. All rights reserved.
//

#import "HexCellPosition.h"

@implementation HexCellPosition


- (id) initWithRow: (int) r Column: (int) c {
	
	row = r;
	column = c;
	
	return self;
	
}

+ (HexCellPosition *) getPosAtDirection: (HexDirection) direction fromPosition: (HexCellPosition *) basePos {
	
	int c = [basePos getColumn];
	int r = [basePos getRow];
	HexCellPosition *pos = [[HexCellPosition alloc] initWithRow:r Column:c];

	switch(direction) {
		case HexDirectionSW:
			c -= 1;
			r += 1;
			break;
			
		case HexDirectionE:
			c += 2;
			break;
			
		case HexDirectionNE:
			c += 1;
			r -= 1;
			break;
			
		case HexDirectionNW:
			c -= 1;
			r -= 1;
			break;
			
		case HexDirectionSE:
			c += 1;
			r += 1;
			break;
			
		case HexDirectionW:
			c -= 2;
			break;
	
	}
	
	[pos setRow:r Column:c];

	return pos;
}

- (void) setRow: (int) r Column: (int) c {

	row = r;
	column = c;
	
}

- (int) getRow {
	
	return row;
	
}

- (int) getColumn {
	
	return column;
	
}
- (bool) positionEquals: (HexCellPosition *) cellPosition {
	// if x and y of this cell's position equal the x and y of the specified position return true.
	
	bool bRval = false;
	
	if ((row == [cellPosition getRow])
		&& (column == [cellPosition getColumn]))
		bRval = true;
	
	return bRval;
}

- (NSString *) toString {
	
	NSString *rval = [[NSString alloc] initWithFormat:@"(%d, %d)",
					  column,
					  row];
	
	return rval;

}

@end
