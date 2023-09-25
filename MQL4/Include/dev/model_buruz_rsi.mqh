#include <dev\mm.mqh>
#include <dev\model.mqh>
#include <dev\trade.mqh>

// +--------------------------------------+
// |          struct buruz_inps           |
// +--------------------------------------+
struct buruz_inps{
    int magic;
    int rsi_period;
    int overbought_level;
    int oversold_level;    
    int stop_loss_points;
    int take_profit_points;
    double lot_size;
}b_inps;

// +--------------------------------------+
// |       class model_buruz_rsi          |
// +--------------------------------------+
class model_buruz_rsi : public model{
public:    
    model_buruz_rsi(const buruz_inps& inp) : 
        _symbol             (Symbol()),
        _magic              (inp.magic),
        _rsi_period         (inp.rsi_period),
        _overbought_level   (inp.overbought_level),
        _oversold_level     (inp.oversold_level),    
        _stop_loss_points   (inp.stop_loss_points),
        _take_profit_points (inp.take_profit_points),
        _lot_size           (inp.lot_size)
    {
        _last_rsi = iRSI(_symbol, 0, _rsi_period, PRICE_CLOSE, 0);
        _trade = new CTrade();
        _mm = new mm(_symbol);
    };
    ~model_buruz_rsi(){
        if(CheckPointer(_trade) == POINTER_DYNAMIC){
            delete (_trade);
        }
        if(CheckPointer(_mm) == POINTER_DYNAMIC){
            delete (_mm);
        }
    }
    virtual void proccessing() override{
        if(CheckPointer(_trade)){
            if(_trade.TradesTotal() == 0){
                // if(OrdersTotal()>0) return; // do not trade if there is an already opened order
                double currentRSI = iRSI(_symbol, 0, _rsi_period, PRICE_CLOSE, 0);
                
                // Check for RSI cross over oversold or overbought levels
                if (_last_rsi < _oversold_level && currentRSI >= _oversold_level) {
                    // Buy order
                    // OrderSend(Symbol(), OP_BUY, LotSize, Ask, 3, Ask-StopLoss_Points*_Point, Ask+TakeProfit_Points*_Point, "RSI Cross Over Buy", 0, clrRed);
                    _trade.Buy(_symbol, _lot_size, _stop_loss_points, _take_profit_points, 3, "RSI Cross Over Buy");
                } else if (_last_rsi > _oversold_level && currentRSI <= _oversold_level) {
                    // Sell order
                    // OrderSend(Symbol(), OP_SELL, LotSize, Bid, 3, Bid+StopLoss_Points*_Point, Bid-TakeProfit_Points*_Point, "RSI Cross Over Sell", 0, clrBlue);
                    _trade.Sell(_symbol, _lot_size, _stop_loss_points, _take_profit_points, 3, "RSI Cross Over Sell");
                }
                
                _last_rsi = currentRSI;
            }
        }
    };

private:
    const int _magic;
    const int _rsi_period;
    const int _overbought_level;
    const int _oversold_level;    
    const int _stop_loss_points;
    const int _take_profit_points;
    const double _lot_size;
    double _last_rsi;
    const string _symbol;

    CTrade* _trade;
    mm* _mm;
};