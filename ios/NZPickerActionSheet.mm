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
#import "NZPickerActionSheet.h"

@implementation NZPickerActionSheet

@synthesize pickerView;

-(void)loadView
{
	[pickerView release];
	pickerView = nil;

	[super loadView];

	pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
	[pickerView selectRow:selectedIndex inComponent:0 animated:NO];
	[self addContentsView:pickerView];

	UIButton * okButton = [UIButton buttonWithType:UIButtonTypeSystem];
	okButton.titleLabel.font = [UIFont systemFontOfSize:25.0f];
	[okButton setTitle:@"OK" forState:UIControlStateNormal];
	[okButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
	[self addContentsView:okButton];

	[self.view setNeedsLayout];
}

-(void)dealloc
{
	[pickerView release];
	pickerView = nil;

	[items release];
	items = nil;

	[super dealloc];
}

-(int)selectedIndex
{
	return selectedIndex;
}

-(void)setSelectedIndex:(int)index
{
	selectedIndex = index;
	[pickerView selectRow:index inComponent:0 animated:NO];
}

-(NSArray *)items
{
	return items;
}

-(void)setItems:(NSArray *)array
{
	[items release];
	items = nil;

	items = [array retain];
	[pickerView reloadAllComponents];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return items.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [items objectAtIndex:row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 300.0f;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	selectedIndex = int(row);
}

+(void)displayInViewController:(UIViewController *)parentController items:(NSArray *)items
	selected:(int)selected callback:(void (^)(int selected))callback
{
	__block NZPickerActionSheet * actionSheet = [[NZPickerActionSheet alloc] init];
	actionSheet.items = items;
	actionSheet.selectedIndex = selected;

	actionSheet.onDismiss = ^{
		callback(actionSheet.selectedIndex);
		[actionSheet release];
	};

	[actionSheet displayInViewController:parentController];
}

@end
