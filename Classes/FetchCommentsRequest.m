//
//  FetchCommentsRequest.m
//  HackerNewsReader
//
//  Created by Deon Botha on 09/10/2010.
//  Copyright 2010 None. All rights reserved.
//

#import "FetchCommentsRequest.h"
#import "Comment.h"
#import "RegexKitLite.h"

@implementation FetchCommentsRequest

+ (NSArray/*<Comment>*/ *)getCommentsFromHTML:(NSString *) html {
	//	<tr>
	//		<td>
	//			<img src="http://ycombinator.com/images/s.gif" height="1" width="0" />
	//		</td>
	//		<td valign="top">
	//			<center>
	//				<a id="up_1664273" onclick=
	//				"return vote(this)" href=
	//				"vote?for=1664273&amp;dir=up&amp;by=dbotha&amp;auth=c6a60c14e0242cf5a1c89121c93a4595ff53dc3d&amp;whence=%69%74%65%6d%3f%69%64%3d%31%36%36%33%38%35%38"
	//				name="up_1664273"><img src=
	//				"http://ycombinator.com/images/grayarrow.gif"
	//				border="0" vspace="3" hspace=
	//				"2" /></a><span id=
	//				"down_1664273"></span>
	//			</center>
	//		</td>
	//		<td class="default">
	//			<div style="margin-top:2px; margin-bottom:-10px;">
	//			<span class="comhead">
	//				<span id="score_1664273">5 points</span> by
	//				<a href="user?id=mahmud">mahmud</a>
	//				58 minutes ago | <a href="item?id=1664273">link</a>
	//			</span>
	//			</div><br />
	//	
	//			<span class="comment">
	//				<font color="#000000">
	//					Yesterday I submitted "A Problem Course in Compilation: From
	//					Python to x86 Assembly". An 80 page book with worked examples. It got ZERO up
	//					votes.
	//				</font>
	//			</span>
	//			<p>
	//				<span class="comment">
	//					<font color="#000000">
	//						<a href="http://news.ycombinator.com/item?id=1662430"
	//						rel="nofollow">http://news.ycombinator.com/item?id=1662430</a>
	//					</font>
	//				</span>
	//			</p>
	//			<p>
	//				<span class="comment">
	//					<font color="#000000">
	//						Yeah, I am jealous.
	//					</font>
	//				</span>
	//			</p>
	//			<p>
	//			<font size="1"><u><a href=
	//			"reply?id=1664273&amp;whence=%69%74%65%6d%3f%69%64%3d%31%36%36%33%38%35%38">
	//			reply</a></u></font>
	//			</p>
	//		</td>
	//	</tr>
	
	NSArray *rows = [html componentsMatchedByRegex: @"<tr(.|\\s)*?<\\/tr"];
	NSMutableArray *parentComments = [[NSMutableArray alloc] initWithCapacity: 10];
	NSMutableArray *rootComments = [NSMutableArray arrayWithCapacity: 100];
	for (int i = 0; i < [rows count]; ++i) {
		NSString *row = [rows objectAtIndex: i];
		
		NSArray *tds = [row componentsMatchedByRegex: @"<td(.|\\s)*?<\\/td"];
		if ([tds count] == 3) {
			BOOL containsComhead = [[tds objectAtIndex: 2] isMatchedByRegex: @"class=\"comhead\""];
			BOOL containsComment = [[tds objectAtIndex: 2] isMatchedByRegex: @"class=\"comment\""];
			if (!containsComhead || !containsComment) {
				continue; // based on the above structure, these tds don't represent comment data
			}
			
			/* determine comment depth, based on the img elems width attribute value (0,40,80...) */
			//		<td>
			//			<img src="http://ycombinator.com/images/s.gif" height="1" width="0" />
			//		</td>
			NSString *commentDepthStr = [[tds objectAtIndex: 0] 
										 stringByMatching: @"width=.*?(\\d+)" capture: 1];
			if (commentDepthStr == nil) {
				continue;
			}
			NSUInteger commentDepth = [commentDepthStr intValue];
			
			/* get comment points, submitter & submitter profile url */
			//	<span class="comhead">
			//		<span id="score_1664273">5 points</span> by
			//		<a href="user?id=mahmud">mahmud</a>
			//		58 minutes ago | <a href="item?id=1664273">link</a>
			//	</span>
			NSString *td3 = [tds objectAtIndex: 2];
			NSString *commentPointsStr = [td3 stringByMatching: @"(-?\\d+)\\s+[Pp]oints?" capture: 1];
			NSInteger commentPoints = [commentPointsStr intValue];
			NSString *submissionTime = [td3 stringByMatching: @"\\d+\\s+([Ss]econd|[Mm]inute|[Hh]our|[Dd]ay)s?"];
			NSString *submitterProfileURLStr = [td3 stringByMatching: @"(user\\?id=.+?)(\\s|\")" capture: 1];
			NSString *submitter = [td3 stringByMatching: @"user\\?id=.+?>(.+?)<" capture: 1];
			
			/* collect all parts that make up the comment, each part forms the value for a font elem */
			// <span class="comment">
			//		<font color="#000000">
			//			Yeah, I am jealous.
			//		</font>
			//	</span>
			NSString *commentStr = @"";
			NSArray *commentComponents = [td3 componentsMatchedByRegex: @"class=\"comment\".+?<font.+?>((\\s|.)+?)<\\/font" capture: 1];
			for (NSString *part in commentComponents) {
				commentStr = [commentStr stringByAppendingString: part];
			}
			
			Comment *comment = [[Comment alloc] initWithSubmitter: submitter 
												   submissionTime: submissionTime 
										   submitterProfileURLStr: submitterProfileURLStr 
														  comment: commentStr 
														numPoints: commentPoints
															depth: commentDepth];
			Comment *parent = nil;
			while ((parent = [parentComments lastObject]) != nil 
				   && parent.depth >= commentDepth) {
				[parentComments removeLastObject]; // pop the stack until we find a parent or nil
			}
			
			if (parent == nil) {
				[rootComments addObject: comment];
			} else {
				[parent addReply: comment];
			}
			
			[parentComments addObject: comment]; // add to 'stack' incase comment has replies
			[comment release];
		}
	}
	
	[parentComments release];
	return rootComments;
}

@end
