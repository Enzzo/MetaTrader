#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Arrays/List.mqh>

#include <dev/time_duration.mqh>

#include <dev/model_single_ma.mqh>
#include <dev/model_buruz_rsi.mqh>
#include <dev/model_rsi.mqh>

#define DEBUG

// ----------- BURUZ INPS -----------
input int Magic = 888888;
input int RSI_Period = 14;
input int Overbought_Level = 70;
input int Oversold_Level = 30;
input double LotSize = 0.05;
input int StopLoss_Points = 200;
input int TakeProfit_Points = 100;
// ----------- BURUZ INPS -----------

single_ma_inps smi = {PERIOD_M1, 0, MODE_EMA, PRICE_CLOSE};

CList* list = new CList();


// +--------------------------------------+
// | int OnInit                           |
// +--------------------------------------+
int OnInit(){
    b_inps.magic = Magic;
    b_inps.rsi_period = RSI_Period;
    b_inps.overbought_level = Overbought_Level;
    b_inps.oversold_level = Oversold_Level;
    b_inps.stop_loss_points = StopLoss_Points;
    b_inps.take_profit_points = TakeProfit_Points;
    b_inps.lot_size = LotSize;

    model* ma = new model_single_ma(smi);
    model* rsi = new model_rsi("rsi");
    model* brsi = new model_buruz_rsi(b_inps);

    if(CheckPointer(ma) == POINTER_DYNAMIC){
        list.Add(ma);
    }

    if(CheckPointer(rsi) == POINTER_DYNAMIC){
        list.Add(rsi);
    }

    if(CheckPointer(brsi) == POINTER_DYNAMIC){
        list.Add(brsi);
    }

    return (INIT_SUCCEEDED);
}

// +--------------------------------------+
// |              void OnTick             |
// +--------------------------------------+
void OnTick(){
    #ifdef DEBUG
      TIMER;
    #endif
    
    for(int i = 0; i < list.Total(); ++i){
        model* m = list.GetNodeAtIndex(i);
        if(CheckPointer(m) == POINTER_DYNAMIC){
            m.proccessing();
        }
    }
}

// +--------------------------------------+
// |              void OnDeinit           |
// +--------------------------------------+
void OnDeinit(const int reason){
    list.Clear();
    delete (list);
}