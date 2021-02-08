//
//  ztOATreeTableCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-2-28.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOATreeTableCell.h"

@implementation ztOATreeTableCell
@synthesize cellLabel,cellIconImage,cellSelectedIcon,cellBackImage;
@synthesize delegate = _delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        cellBackImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cellBackImage];
        [cellBackImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self.cellBackImage addGestureRecognizer:tapGesture];
        
        cellIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
        cellIconImage.backgroundColor = [UIColor clearColor];
        [self.contentView  addSubview:cellIconImage];
        
        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,5, self.width-40-40, 30)];
        cellLabel.textAlignment = NSTextAlignmentLeft;
        cellLabel.textColor = [UIColor blackColor];
        cellLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView  addSubview:cellLabel];
        
        cellSelectedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-40, 5, 30, 30)];
        cellSelectedIcon.backgroundColor = [UIColor clearColor];
        [self.contentView  addSubview:cellSelectedIcon];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
#pragma mark - Draw controls messages

- (void)drawRect:(CGRect)rect
{
    CGRect cellFrame = self.cellLabel.frame;
    CGRect buttonFrame = self.cellIconImage.frame;
    int indentation = self.treeNode.nodeLevel * 25;
    cellFrame.origin.x = buttonFrame.size.width + indentation + 5;
    buttonFrame.origin.x = 2 + indentation;
    cellFrame.size.width = self.width-cellFrame.origin.x-40;
    self.cellLabel.frame = cellFrame;
    self.cellIconImage.frame = buttonFrame;
}

- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage
{
    [self.cellIconImage setImage:backgroundImage];
}
- (void)setTheSelectedIconImage:(UIImage *)imageName
{
    [self.cellSelectedIcon setImage:imageName];
}
- (void)addGestureTouchUp:(BOOL)isCan
{
    if (isCan==YES) {
        [self.cellIconImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [self.cellLabel addGestureRecognizer:tapGesture];
        [self.cellIconImage addGestureRecognizer:tapGesture];
        [self.cellSelectedIcon addGestureRecognizer:tapGesture];
    }
    else
    {
    
    }
}
- (void)expand:(id)sender
{
    self.treeNode.isExpanded = !self.treeNode.isExpanded;
    [self setSelected:NO];
    //postNWithInfos(@"ProjectTreeNodeButtonClicked", nil, self.treeNode.infoDic);
    if (self.treeNode.isExpanded==NO || self.treeNode.nodeChildren.count!=0 || self.treeNode.haveChildNodFlag==NO) {
        if ([(id)_delegate respondsToSelector:@selector(addnodeChildren: hasLoadData:) ])
        {
            [_delegate addnodeChildren:self.treeNode hasLoadData:NO];
            
        }
    }
    else
    {
        if ([(id)_delegate respondsToSelector:@selector(addnodeChildren: hasLoadData:) ])
        {
            [_delegate addnodeChildren:self.treeNode hasLoadData:YES];
            
        }
    }
   
}
@end
