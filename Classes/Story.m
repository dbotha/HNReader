//
//  Story.m
//  HackerNewsReader
//
//  Created by Deon Botha on 04/09/2010.
//  Copyright 2010 None. All rights reserved.
//

#import "Story.h"


@implementation Story

@synthesize title=_title, urlStr=_urlStr, domain=_domain, submissionTime=_submissionTime, 
submitterUsername=_submitterUsername, submitterProfileURLStr=_submitterProfileURLStr, 
numComments=_numComments, numPoints=_numPoints, commentsURLStr=_commentsURLStr, visited=_visited;

-(id) initWithTitle: (NSString *) title 
			 urlStr: (NSString *) urlStr 
			 domain: (NSString *) domain 
		  submitter: (NSString *) submitterUsername 
submitterProfileURLStr: (NSString *) submitterProfileURLStr
	 submissionTime: (NSString *) submissionTime
	 commentsURLStr: (NSString *) commentsURLStr
		  numPoints: (NSUInteger) numPoints 
		numComments: (NSUInteger) numComments {
	
	if (self = [super init]) {
		_title				    = [title retain];
		_urlStr			        = [urlStr retain];
		_domain					= [domain retain];
		_submitterUsername      = [submitterUsername retain];
		_submitterProfileURLStr = [submitterProfileURLStr retain];
		_submissionTime         = [submissionTime retain];
		_commentsURLStr			= [commentsURLStr retain];
		_numPoints              = numPoints;
		_numComments            = numComments;
	}
	return self;
}
	
-(void) dealloc {
	[_title release];
	[_urlStr release];
	[_domain release];
	[_submitterUsername release];
	[_submitterProfileURLStr release];
	[_submissionTime release];
	[_commentsURLStr release];
	[super dealloc];
}

@end
