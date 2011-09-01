//
//  StoryCell.m
//  HackerNewsReader
//
//  Created by Deon Botha on 05/09/2010.
//  Copyright 2010 None. All rights reserved.
//

#import "StoryCell.h"


@implementation StoryCell
@dynamic story;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{	
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
		
		for (UIView *view in [self subviews])
		{
			[view setBackgroundColor:[UIColor whiteColor]];
			[view setOpaque:YES];
		}
		
		self.superview.opaque = YES;
		self.superview.backgroundColor = [UIColor whiteColor];
		
		for (UIView *view in [[self superview] subviews])
		{
			[view setBackgroundColor:[UIColor whiteColor]];
			[view setOpaque:YES];
		}
		
		_story = nil;
		
		_storyTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];		
		_storyTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_storyTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[_storyTitleLabel setTextColor:[UIColor blueColor]];
		[_storyTitleLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[_storyTitleLabel setNumberOfLines:0];
		
		_domainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_domainLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_domainLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[_domainLabel setTextColor:[UIColor grayColor]];
		[_domainLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[_domainLabel setNumberOfLines:0];
		
		_additionalDetailsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_additionalDetailsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[_additionalDetailsLabel setFont:[UIFont systemFontOfSize:12]];
		[_additionalDetailsLabel setTextColor:[UIColor grayColor]];
		[_additionalDetailsLabel setLineBreakMode:UILineBreakModeTailTruncation];
		[_additionalDetailsLabel setNumberOfLines:0];
		
		[[self contentView] addSubview:_storyTitleLabel];
		[[self contentView] addSubview:_domainLabel];
		[[self contentView] addSubview:_additionalDetailsLabel];
    }
	
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat labelWidth = self.bounds.size.width - 20;
	CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
	CGSize titleSize = [_story.title sizeWithFont:[UIFont boldSystemFontOfSize:14] 
								constrainedToSize: maxSize
									lineBreakMode: UILineBreakModeTailTruncation];
	
	CGSize domainSize = [_domainLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:12] 
									  constrainedToSize: maxSize
										  lineBreakMode: UILineBreakModeTailTruncation]; 
	
	CGSize detailsSize = [_additionalDetailsLabel.text sizeWithFont:[UIFont systemFontOfSize:12] 
												  constrainedToSize: maxSize
													  lineBreakMode: UILineBreakModeTailTruncation];
	
	static NSUInteger yoff = 0;
	NSUInteger y = yoff + 5;
	_storyTitleLabel.frame = CGRectMake(10.0f, y, labelWidth, titleSize.height);
	
	if ([[_domainLabel.text stringByTrimmingCharactersInSet: 
		  [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0) {
		y += yoff + titleSize.height;
		_domainLabel.frame     = CGRectMake(10.0f, y, labelWidth, domainSize.height);
	}
	y += yoff + domainSize.height;
	_additionalDetailsLabel.frame = CGRectMake(10.0f, y, labelWidth, detailsSize.height);
}

- (Story *)story {
	return _story;
}

- (void)setStory:(Story *)story {
	[_story autorelease];
	_story = [story retain];
	
	[_storyTitleLabel setTextColor: story.visited 
								  ? [UIColor grayColor] 
								  : [UIColor blackColor]];
	_storyTitleLabel.text = story.title;
	[_storyTitleLabel setNeedsDisplay];
	
	_domainLabel.text = story.domain;
	[_domainLabel setNeedsDisplay];
	
	_additionalDetailsLabel.text = [NSString stringWithFormat: @"%d points | posted by %@", story.numPoints, story.submitterUsername];
	[_additionalDetailsLabel setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[_story release];
    [super dealloc];
}


@end
