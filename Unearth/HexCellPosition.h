//
//  HexCellPosition.h
//  Unearth
//
//  Created by Mazerlodge on 2/16/19.
//  Copyright © 2019 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexDirection.h"

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



@end

NS_ASSUME_NONNULL_END
