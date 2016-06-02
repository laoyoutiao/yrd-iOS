
//
//  QFHttpDownload.m
//  JSON
//

#import "QFHttpDownload.h"

@implementation QFHttpDownload
{
    NSURLConnection *connection;
    
}
-(void)dealloc {
    [connection release];
    [_downloadData release];
    [super dealloc];
}

- (id)initWithUrl:(NSString *)string
{
    self = [super init];
    if (self) {
        NSLog(@"%@",string);
        
        _downloadData = [[NSMutableData alloc] init];
        
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        
    }
    return self;
}
#pragma mark -NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)respons{

    [_downloadData setLength:0];
    

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    [_downloadData appendData:data];

}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

    [self.delegate downloadSuccess:self];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{

    NSLog(@"下载失败");
}

@end
