//
//  HexCellPosition.h
//  Unearth
//
//  Created by Mazerlodge on 2/16/19.
//  Copyright © 2019 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef HexDirection_h
#import "HexDirection.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface HexCellPosition : NSObject {
	int row;
	int column;

}

+ (HexCellPosition *) getPosAtDirection: (HexDirection) direction fromPosition: (HexCellPosition *) basePos;

- (id) initWithRow: (int) r Column: (int) c;
- (void) setRow: (int) r Column: (int) c;

- (int) getRow;
- (int) getColumn;

- (bool) positionEquals: (HexCellPosition *) cellPosition;
- (NSString *) toString;

@end

NS_ASSUME_NONNULL_END
