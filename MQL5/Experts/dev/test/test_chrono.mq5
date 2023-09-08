#include <dev\time_duration.mqh>

int OnInit(){
    {
        TIMER;
        MqlRates rates[];
        int copied = CopyRates(Symbol(), PERIOD_CURRENT, 0, 10000, rates);
        if(copied != EMPTY_VALUE){
            for(int i = 0; i < ArraySize(rates); ++i){
                ArrayResize(rates, ArraySize(rates) - i);
            }
        }
    }
    return (INIT_SUCCEEDED);
}

void OnTick(){
    
}

void OnDeinit(const int reason){

}