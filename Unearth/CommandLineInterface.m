//
//  CommandLineInterface.m
//  Unearth
//
//  Created by mazerlodge on 9/2/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "CommandLineInterface.h"

@implementation CommandLineInterface

- (id) init {
	bInDebug = false;
	minDebugMsgLevel = -1;
	
	return self;
	
}

- (id) initWithDebugOn: (bool) bDebugOn minDebugMsgLevel: (int) debugLevel {
	
	bInDebug = bDebugOn;
	minDebugMsgLevel = debugLevel;
	
	return self;
	
}

- (NSString * ) getStr: (NSString *) msg {
    NSString *rval = @"NOT_SET";
    	
    printf("%s", [msg UTF8String]);
	char *cmd = malloc(256);
	fgets(cmd, 256, stdin);

	// Remove trailing newline
    if ((strlen(cmd) > 0) && (cmd[strlen(cmd)-1] == '\n'))
        cmd[strlen(cmd)-1] = '\0';

	// Convert CString into NSString
	NSString *inMessage = [[NSString alloc] initWithUTF8String:cmd];
    rval = inMessage;
    
	free(cmd);
	
    return rval;
    
}

- (int) getInt: (NSString *) msg  {
    
    int rval = -1;
	
	NSString *rawInput = [self getStr:msg];
	rval = (int)[rawInput integerValue];

	/*
    printf("%s", [msg UTF8String]);
    scanf("%i",&rval);
    */
	
    return rval;
    
}

- (float) getFloat: (NSString *) msg {
    
    float rval = 0.0;

	NSString *rawInput = [self getStr:msg];
	rval = (float)[rawInput floatValue];

	/*
    printf("%s", [msg UTF8String]);
    scanf("%f",&rval);
	*/
	
    return rval;
    
}


- (void) put: (NSString *) msg {
    
	[self put:msg withNewline:false];
    
}

- (void) put: (NSString *) msg withNewline: (bool) bAddNewLine {
	
	if (bAddNewLine)
		printf("%s\n", [msg UTF8String]);
	else
		printf("%s", [msg UTF8String]);

	
}

- (void) debugMsg: (NSString *) msg {
	// If debug mode is turned on output the specified message via the command line interface.
	
	[self debugMsg:msg level:0];
	
}

- (void) debugMsg: (NSString *) msg level: (int) msgLevel {
	// If debug mode is turned on output the specified message via the command line interface.
	
	// Add the message level to the message
	msg = [msg stringByAppendingFormat:@" (S: %d)\n", msgLevel];
	
	if (bInDebug && (msgLevel >= minDebugMsgLevel))
		[self put:msg];
	
}
@end
