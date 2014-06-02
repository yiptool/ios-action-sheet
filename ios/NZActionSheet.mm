/* vim: set ai noet ts=4 sw=4 tw=115: */
//
// Copyright (c) 2014 Nikolay Zapolnov (zapolnov@gmail.com).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#import "NZActionSheet.h"
#import <yip-imports/MZFormSheetController/MZFormSheetController.h>

@implementation NZActionSheet

@synthesize onDismiss;

-(id)init
{
	self = [super initWithNibName:nil bundle:nil];
	if (self)
	{
		self.modalPresentationStyle = UIModalPresentationFormSheet;
		self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	}
	return self;
}

-(void)dealloc
{
	[overlayView removeFromSuperview];
	[overlayView release];
	overlayView = nil;

	[sheetView removeFromSuperview];
	[sheetView release];
	sheetView = nil;

	self.onDismiss = nil;
	self.view = nil;

	[super dealloc];
}

-(void)dismiss
{
	[self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadView
{
	overlayView = [[UIView alloc] initWithFrame:CGRectZero];
	overlayView.backgroundColor = [UIColor whiteColor];

	sheetView = [[UIView alloc] initWithFrame:CGRectZero];
	sheetView.translatesAutoresizingMaskIntoConstraints = NO;
	sheetView.backgroundColor = [UIColor whiteColor];

	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:overlayView];
	[self.view addSubview:sheetView];
}

-(void)addContentsView:(UIView *)view
{
	UIView * prevView = sheetView.subviews.lastObject;
	NSLayoutConstraint * constraint;

	view.translatesAutoresizingMaskIntoConstraints = NO;
	[sheetView addSubview:view];

	if (!prevView)
	{
		constraint = [NSLayoutConstraint constraintWithItem:view
			attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sheetView
			attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
		[sheetView addConstraint:constraint];
	}
	else
	{
		[sheetView removeConstraint:sheetView.constraints.lastObject];
		constraint = [NSLayoutConstraint constraintWithItem:prevView
			attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view
			attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
		[sheetView addConstraint:constraint];
	}

	constraint = [NSLayoutConstraint constraintWithItem:view
		attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:sheetView
		attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
	[sheetView addConstraint:constraint];

	constraint = [NSLayoutConstraint constraintWithItem:view
		attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:sheetView
		attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
	[sheetView addConstraint:constraint];

	constraint = [NSLayoutConstraint constraintWithItem:view
		attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sheetView
		attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
	[sheetView addConstraint:constraint];
}

-(void)viewWillLayoutSubviews
{
	CGRect bounds = self.view.bounds;
	overlayView.frame = bounds;

	CGSize contentsSize = [sheetView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	CGFloat y = bounds.size.height - contentsSize.height;
	sheetView.frame = CGRectMake(0.0f, y, bounds.size.width, contentsSize.height);

	[sheetView setNeedsUpdateConstraints];
	[sheetView setNeedsLayout];
	[sheetView layoutIfNeeded];
}

-(void)viewDidDisappear:(BOOL)animated
{
	if (onDismiss)
		onDismiss();
}

-(void)displayInViewController:(UIViewController *)parentController
{
	[parentController mz_presentFormSheetWithViewController:self animated:YES
		transitionStyle:MZFormSheetTransitionStyleSlideFromBottom completionHandler:nil];
}

@end
