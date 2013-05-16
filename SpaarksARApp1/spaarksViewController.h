//
//  spaarksViewController.h
//  SpaarksARApp1
//
//  Created by martin steel on 10/05/2013.
//  Copyright (c) 2013 martin steel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MetaioSDKViewController.h"
#import "EAGLView.h"
#import <metaioSDK/GestureHandlerIOS.h>

@interface spaarksViewController : MetaioSDKViewController
{
    GestureHandlerIOS* m_gestureHandler;
    
    int m_gestures;
}
@end

