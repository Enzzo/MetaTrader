#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <dev/model_ma.mqh>
#include <Arrays/List.mqh>

CList* list = new CList();
model_ma* ma = new model_ma();

int OnInit(){
    list.Add(ma);

    return (INIT_SUCCEEDED);
}

void OnTick(){
    for(int i = 0; i < list.Total(); ++i){
        // list.GetNodeAtIndex(i).proccessing();
    }
}

void OnDeinit(const int reason){

}