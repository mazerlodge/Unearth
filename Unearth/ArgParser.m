//
//  ArgParser.m
//  ArgParserTest
//
//  Created by mazerlodge on 6/9/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#include "ArgParser.h"

@implementation ArgParser

- (id) initWithArgs: (NSArray *) args {
    
    argsList = args;
    
    return self;
    
}

- (bool) populateArgParserFromString: (NSString *) paramString preserveZeroParam: (bool) bPreserveZero {
    //  Populate the argParser with contents of the specified string.

    bool bRval = true;
    
    if (bPreserveZero) {
        NSString *zeroParam = [argsList objectAtIndex:0];
        argsList = [[NSArray alloc] initWithObjects:zeroParam, nil];
        argsList = [argsList arrayByAddingObjectsFromArray:[paramString componentsSeparatedByString:@" "]];
    }
    else {
        argsList = [paramString componentsSeparatedByString:@" "];
    }
    
    return bRval;
}

- (bool) addArgsFromString: (NSString *) paramString {
    // Adds the contents of the specifice string as additional parameters
    bool bRval = true;
    
    // Note: Using mutable array to prepare for removal of duplicates in a future version.
    NSMutableArray *expandedArgs = [[NSMutableArray alloc] initWithArray:argsList];
    NSArray *argsToAdd = [paramString componentsSeparatedByString:@" "];
    for (NSString *aArg in argsToAdd) {
        // TODO: Add check for arg (and assoc val) already in array
        [expandedArgs addObject:aArg];
    }

    argsList = expandedArgs;

    return bRval;
}


- (bool) isInArgs: (NSString *) name withAValue: (bool) bWithValue {
    // Returns true if the specified arg is found, with/without value determined by second parameter.
    // Note: if an arg is supplied WITH a value and withAValue param is false, still returns true.
    
    // TODO: Make AP.isInArgs method case insensitive and add a version with a caseSensitive: true/false param.
    
    bool bRval = false;
    
    // Get the index of the arg specified within the argList
    NSUInteger indexOfArg = [argsList indexOfObject:name];
    if (indexOfArg != NSNotFound) {
        // arg name found, determine if a value must be supplied
        if (bWithValue) {
            // Must have a value in the next index (defined as not starting with dash).
            // Is there anything after this index
            if ([argsList count] > indexOfArg+1) {
                NSString *nextVal = [argsList objectAtIndex:indexOfArg + 1];
                if ([nextVal characterAtIndex:0] != '-')
                    bRval = true;
                
            }
        }
        else {
            // No arg required
            bRval = true;
            
        }
    }
    
    return bRval;
    
}

- (NSString *) getArgValue: (NSString *) name {
    // Returns the value associated with the specified arg.
    
    NSString *rval = @"NOT_SET";
    
    // If the name is in args with a value, get the value
    if ([self isInArgs:name withAValue:true]) {
        NSUInteger index = [argsList indexOfObject:name];
        rval = [argsList objectAtIndex:index+1];
        
    }

    return rval;
    
}

- (bool) doesArg: (NSString *) name haveValue: (NSString *) value {
    // Returns true if the arg specified has the value specified.
    
    bool bRval = false;
    
    // determine if the arg has a value, and if so if it has the value specified.
    if ([self isInArgs:name withAValue:true])
        if ([[self getArgValue:name] isEqualToString:value])
            bRval = true;
    
    return bRval;
    
}

- (void) dumpArgsToCLI: (CommandLineInterface *) cli {
    // Output list of arguments.
    
    NSString *msg = @"ArgParser, == start dump args ==\n";
    int argIndex =0;
	
    for (NSString *aArg in argsList) {
        msg = [msg stringByAppendingFormat:@"[%d] = %@ \n", argIndex, aArg];
        argIndex++;
    }
	
	msg = [msg stringByAppendingString:@"ArgParser, == end dump args ==\n"];
	[cli put:msg];

}

- (NSString *) getArgByNumber:(NSUInteger)argNumber {
    // Returns the value associated with the specified arg.
    
    NSString *rval = @"NOT_SET";
    
    if ([argsList count] > argNumber)
        rval = [argsList objectAtIndex:argNumber];
    
    return rval;
    
}

@end


















