//
//  EndOfAgeCard.h
//  Unearth
//
//  Created by mazerlodge on 11/18/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EndOfAgeCard : NSObject  {
    
    NSString *rawData;
	
	int idNumber;
    int claimValue;
    int stoneValue;
    int stones;
    NSMutableArray *delverDice;
	NSString *title;
	NSString *descriptiveText;
    
}

- (id) initWithString: (NSString *) cardData;
- (NSString *) toString;


/*
 Method list from [Object Library.txt]
 > RuinCard
 - claimValue        // name from rules, delver die total to trigger card claiming.
 - stoneValue        // name from rules, number of stones initially placed on card.
 - stones            // stones currently on the card
 - delverDice        // dice currently on the card
 
 */


@end

NS_ASSUME_NONNULL_END
