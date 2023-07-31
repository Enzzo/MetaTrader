#property copyright "Sergey Vasilev"
#property link "http://www.mql5.com/enzzo"
#property version "1.00"

#include <dev/generateHTML.mqh>

int OnInit(){
    html_file hf("hello.html", "title");
    
    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason){

}

void OnTick(){

}