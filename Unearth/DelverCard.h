//
//  DelverCard.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelverCard : NSObject {
    NSString *rawData;
	
	int baseID;
	NSString *title;
	NSString *descriptiveText;
	
    
}


- (id) initWithString: (NSString *) cardData;
- (NSString *) toString;

/*
 Method list from [Object Library.txt]
 > DelverCard
 - type                 // used to access name, text, and rule impact

 */

@end
