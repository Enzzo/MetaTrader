#property copyright "Sergey Vasilev"
#property link "https://www.mql5.com/ru/users/enzzo/"
#property version "1.00"

#include <dev/queue.mqh>

queue<int> q;

int OnInit(){
    q.push(1);
    q.push(2);
    q.push(3);
    
    return (INIT_SUCCEEDED);
}

void OnTick(){

}

void OnDeinit(const int reason){
    
}