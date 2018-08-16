//
//  ArgParser.h
//  ArgParserTest
//
//  Created by mazerlodge on 6/9/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#ifndef ArgParser_h
#define ArgParser_h

#import <Foundation/Foundation.h>

@interface ArgParser : NSObject {
    
    NSArray *argsList;
    
}

- (id) initWithArgs: (NSArray *) args;

//    - Create ArgParser.populateArgParserFromString() method, to be used by UGF.makeGame() method 0701
- (bool) populateArgParserFromString: (NSString *) paramString;

- (bool) isInArgs: (NSString *) name withAValue: (bool) bWithValue;

- (NSString *) getArgValue: (NSString *) name;

- (bool) doesArg: (NSString *) name haveValue: (NSString *) value;


@end



#endif /* ArgParser_h */
