//
//  MTEditPlacePhotoViewController.m
//  Maptube
//
//  Created by Vivian on 14-3-28.
//  Copyright (c) 2014年 Bing W. All rights reserved.
//

#import "MTEditPlacePhotoViewController.h"

@interface MTEditPlacePhotoViewController ()

@end

@implementation MTEditPlacePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Edit Photo";
    [self.navigationController setNavigationBarHidden:NO];
    self.selectImageArray = [[NSMutableArray alloc]initWithCapacity:10];
   
    UIButton * button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(0, 0, 40, 32);
    [button addTarget:self action:@selector(chooseDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleBordered target:self action:@selector(close)];

    [self initPlaceView];
    [self initImageView];
}

-(void)initPlaceView{
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake(5, 65, 310, 50)];
    placeView.layer.borderWidth = 1;
    placeView.layer.borderColor = [UIColor grayColor].CGColor;
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 310, 20)];
    label.text = self.place.title;
    label.textAlignment = NSTextAlignmentLeft;
    [placeView addSubview:label];
    
    label  = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 310, 20)];
    label.text = self.location;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor grayColor];
    [placeView addSubview:label];
    
    [self.view addSubview:placeView];

}

-(void)initImageView{
    
    int width = 95;
    int height = 95;
    int x;
    int y;
    UIImageView *addImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addpic.png"]];
    addImageView.frame = CGRectMake(15, 120, width, height);
    addImageView.userInteractionEnabled = YES;
    //addImageView.backgroundColor = [UIColor grayColor];
    UITapGestureRecognizer  *singleTap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(addPic)];
    [addImageView addGestureRecognizer:singleTap];
    [self.view addSubview:addImageView];
    self.totalImageCount = self.imageStrArray.count;
    for(int i = 0;i<self.imageStrArray.count;i++){
        NSString *str = [self.imageStrArray objectAtIndex:i];
        UIImageView *view = [[UIImageView alloc]init];
        
        if(i%3==0)
            x = 115;
        else if(i%3==1)
            x = 215;
        else{
            x = 15;
        }
        if(i<=1) y = 120;
        else if(i>4) y = 330;
        else y = 225;
        view.frame = CGRectMake(x, y, width, height);
     
        view.tag = i;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer  *singleTap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(clickImage:)];
        
        [view addGestureRecognizer:singleTap];
        
        [view setImageWithURL:[NSURL URLWithString:str]];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mark.png"]];
        imgView.tag = 1;
        imgView.frame = CGRectMake(80, 0, 15, 15);
        [view addSubview:imgView];
        imgView.hidden = YES;
        [self.view addSubview:view];
        

    }
    if(self.imageStrArray.count==0){
        if(self.place.placePhotos.count!=0){
            
            for (int i=0; i<self.place.placePhotos.count; i++)  {
                
                AVFile *picObject = self.place.placePhotos[i];
                NSData *imageData = [picObject getData];
                [self addImageView:[UIImage imageWithData:imageData]];
  
            }

        
        
        }
    }
}

-(void)addImageView:(UIImage *)image{
    UIImageView *view = [[UIImageView alloc]init];

    int width = 95;
    int height = 95;
    int x;
    int y;
    int i = self.totalImageCount;
    if(i%3==0)
        x = 115;
    else if(i%3==1)
        x = 215;
    else{
        x = 15;
    }
    if(i<=1) y = 120;
    else if(i>4) y = 330;
    else y = 225;
    view.frame = CGRectMake(x, y, width, height);
    view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer  *singleTap = [[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(clickImage:)];
    [view addGestureRecognizer:singleTap];
    view.image = image;
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mark.png"]];
    imgView.tag = 1;
    imgView.frame = CGRectMake(80, 0, 15, 15);
    [view addSubview:imgView];
    imgView.hidden = YES;
    [self.view addSubview:view];
    self.totalImageCount++;

}

-(void)clickImage:(UITapGestureRecognizer *)gestureRecognizer{
   
    UIImageView *view = (UIImageView*)gestureRecognizer.view;
    UIImageView *imgView = (UIImageView *)[view viewWithTag:1];
    imgView.hidden = !imgView.hidden;
    if(imgView.hidden){
        [self.selectImageArray removeObject:view.image];
    }
    else {
        [self.selectImageArray addObject:view.image];
    }
    
}

-(void)close{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)chooseDone{
    
    for(UIImage *image in self.selectImageArray){
        NSString *str = [NSString stringWithFormat:@"%@.jpg", self.place.objectId ];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
        AVFile *imageFile = [AVFile fileWithName:str data:imageData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
               if(!self.place.placePhotos) self.place.placePhotos = [[NSMutableArray alloc]initWithCapacity:10];
                [self.place.placePhotos addObject:imageFile];
                [self.place setObject:self.place.placePhotos forKey:PlacePhotos];
                
                
                [self.place saveInBackground];

            }
            else {}
        }];
            }
        [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)addPic{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Take Photo With Camera"
                                  otherButtonTitles:@"Select Photo From Library",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    
}
#pragma mark - actionsheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        if (buttonIndex == 0) {   //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }
        else if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
        else if(buttonIndex == 2) {
            return;
        }
    }
    else {
        
        if (buttonIndex == 2) {
            
            
            
            return;
            
        } else {
            
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
        }
        
    }
    
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
    
    
}

#pragma mark image delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self addImageView:image];
   
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
