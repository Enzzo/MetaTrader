#include <dev\model.mqh>

struct single_ma_inps{
    int timeframe, ma_period, ma_shift, 
        ma_method, applied_price,
        stop_loss, take_profit;
};

class model_single_ma : public model{
public:
    model_single_ma(){};
    model_single_ma(const single_ma_inps& inp) : _symbol(Symbol()), _timeframe(inp.timeframe) {
    };
    virtual void proccessing() override{
        Print("ma " + _symbol);
    };

private:
    const string _symbol;
    int _timeframe;
};