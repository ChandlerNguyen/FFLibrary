//
//  GDataXMLNode+NLAdditions.m
//  MyApp
//
//  Created by Nguyen Nang on 6/3/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "GDataXMLNode+NLAdditions.h"

static const int kGDataHTMLParseOptions = (HTML_PARSE_NOWARNING | HTML_PARSE_NOERROR);

@implementation GDataXMLNode (NLAdditions)

- (GDataXMLNode *)parent{
    if (xmlNode_ != NULL && xmlNode_->parent!=NULL){
        GDataXMLNode *node = [GDataXMLNode nodeBorrowingXMLNode:xmlNode_->parent];
        return node;
    }
    return nil;
}

- (GDataXMLNode *)nextSibling{
    if (xmlNode_ != NULL && xmlNode_->next!=NULL){
        GDataXMLNode *node = [GDataXMLNode nodeBorrowingXMLNode:xmlNode_->next];
        return node;
    }
    return nil;
}

- (GDataXMLNode *)previousSibling{
    if (xmlNode_ != NULL && xmlNode_->prev!=NULL){
        GDataXMLNode *node = [GDataXMLNode nodeBorrowingXMLNode:xmlNode_->prev];
        return node;
    }
    return nil;
}

@end

@implementation GDataXMLElement (NLAdditions)

- (GDataXMLElement*)removeNodesWithXPaths:(NSArray *)xpaths {
    return [self removeNodesWithXPaths:xpaths isRemoveParentNode:NO];
}
// Nếu isRemoveParentNode = YES thì sẽ remove parent node của các node tìm được
- (GDataXMLElement*)removeNodesWithXPaths:(NSArray *)xpaths isRemoveParentNode:(BOOL)isRemoveParentNode {
    NSError *error;
    NSArray *willRemoveNodes = nil;
    for (NSString *xpath in xpaths) {
        willRemoveNodes = [self nodesForXPath:xpath error:&error];
        if (willRemoveNodes) {
            for (GDataXMLElement *item in willRemoveNodes) {
                if (isRemoveParentNode) {
                    GDataXMLNode *parent = [item parent];
                    if (parent) {
                        [self removeChild:parent];
                    }
                } else {
                    if (item) {
                        [self removeChild:item];
                    }
                }
            }
        }
    }

    return self;
}

@end

@implementation GDataXMLDocument (XHTML)

- (id)initWithHTMLString:(NSString *)str options:(unsigned int)mask error:(NSError **)error {
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    GDataXMLDocument *doc = [self initWithHTMLData:data options:mask error:error];
    return doc;
}

- (id)initWithHTMLData:(NSData *)data options:(unsigned int)mask error:(NSError **)error {
    
    self = [super init];
    if (self) {
        
        const char *baseURL = NULL;
        const char *encoding = NULL;
        
        // NOTE: We are assuming [data length] fits into an int.
        xmlDoc_ = htmlReadMemory((const char*)[data bytes], (int)[data length], baseURL, encoding,
                                 kGDataHTMLParseOptions); // TODO(grobbins) map option values
        if (xmlDoc_ == NULL) {
            if (error) {
                *error = [NSError errorWithDomain:@"com.google.GDataXML HTML"
                                             code:-1
                                         userInfo:nil];
                // TODO(grobbins) use xmlSetGenericErrorFunc to capture error
            }
            //[self release];
            self = nil;
            return nil;
        } else {
            if (error) *error = NULL;
            
            [self addStringsCacheToDoc];
        }
    }
    
    return self;
}

@end