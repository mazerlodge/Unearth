//
//  Wonder.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "HexTile.h"

typedef enum WonderType : NSUInteger {
    WonderTypeNamed = 0,
    WonderTypeGreater = 1,
    WonderTypeLesser = 2
} WonderType;

@interface Wonder : HexTile {
    int idNumber;       // used to identify rule modifications
    WonderType wonderType;
    bool isOwned;
    int pointValue;
	NSString *title;
	NSString *descriptiveText;
	NSString *requiredPattern;
    NSString *rawData;

}

+ (NSString *) wonderTypeToString: (WonderType) wonderType;

+ (WonderType) wonderTypeFromWonderName: (NSString *) wonderName;
+ (WonderType) wonderTypeFromRawData: (NSString *) rawData;
+ (NSString *) wonderNameFromRawData: (NSString *) rawData;

- (id) initWithString: (NSString *) wonderData newID: (int) newID pointValue: (int) value;
- (int) getWonderID;
- (WonderType) wonderType;
- (NSString *) getWonderTypeAsShortString;
- (NSString *) toString;
- (NSString *) toStringBriefOutput: (bool) bBriefOutput;

/*
 Method list from [Object Library.txt]
 > Wonder : HexTile
 - id                // used to link to scoring information, rule impact.
 - wonderType         // One of Named, Greater, Lesser
 - isOwned            // boolean, relevant to named wonders.
 - pointValue        // varies per wonder instance.

 */

@end
