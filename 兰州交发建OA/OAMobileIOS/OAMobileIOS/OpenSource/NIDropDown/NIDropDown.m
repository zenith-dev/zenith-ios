//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;

- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr{
    btnSender = b;
    self = [super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        int height_origin=0;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            height_origin=20;
        } else{
            height_origin=40;
        }
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height+height_origin, btn.size.width, 0);
        self.backgroundColor = [UIColor whiteColor];
        self.list = [NSArray arrayWithArray:arr];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height+height_origin, btn.size.width, *height);
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [UIView commitAnimations];
        
        [b.superview.superview.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    int height_origin=0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        height_origin=0;
    } else{
        height_origin=20;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height+height_origin, btn.size.width, 0);
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}   


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    UILabel *lbs=[[UILabel alloc]initWithFrame:CGRectMake(2, 0, table.width-4, cell.height)];
    lbs.font=Font(12);
    lbs.textColor=[UIColor blackColor];
    lbs.text=[list objectAtIndex:indexPath.row];
    lbs.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:lbs];
    UIImageView *breakLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-1,table.width, 1)];
    breakLine.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    [cell addSubview:breakLine];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    [btnSender setTitle:[list objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self myDelegate:indexPath.row];
}

- (void) myDelegate:(int)index {
    [self.delegate niDropDownDelegateMethod:self index:index] ;
}

-(void)dealloc {
    [table release];
    [self release];
    [super dealloc];
}

@end
