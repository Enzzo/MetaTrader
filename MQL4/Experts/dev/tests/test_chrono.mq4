#include <dev\time_duration.mqh>

int OnInit(){
    {
        TIMER_HINT("CopyRates");
        MqlRates rates[];
        int copied = CopyRates(Symbol(), PERIOD_CURRENT, 0, 10000, rates);
        if(copied != EMPTY_VALUE){
            for(int i = 0; i < ArraySize(rates); ++i){
                ArrayResize(rates, ArraySize(rates) - i);
            }
        }
    }
    {
        TIMER_HINT("Simple View");
        int x = 7;
        Print(x);
    }
    {

    }
    return (INIT_SUCCEEDED);
}

void OnTick(){
    
}

void OnDeinit(const int reason){

}