#include <dev/test_model/Model.mqh>
// # include <mm.mqh>

struct cmodel_macd_param{
    string          symbol;
    ENUM_TIMEFRAMES timeframe;
    int             fast_ema;
    int             slow_ema;
    int             signal_ema;
};

class cmodel_macd : public CModel{
    int         m_slow_ema;
    int         m_fast_ema;
    int         m_signal_ema;
    int         m_handle_macd;
    double      m_macd_buff_main[];
    double      m_macd_current;
    double      m_macd_previous;

public:
                cmodel_macd();
    bool        Init();
    bool        Init(cmodel_macd_param& m_param);
    bool        Int(string symbol, ENUM_TIMEFRAMES timeframe, int slow_ma, int fast_ma, int smothed_ma);
    bool        Processing();

protected:
    bool        InitIndicators();
    bool        CheckParam(cmodel_macd_param& m_param);
    bool        LongOpened();
    bool        ShortOpened();
    bool        LongClosed();
    bool        ShortClosed();
};

cmodel_macd::cmodel_macd(){
    m_handle_macd = INVALID_HANDLE;
    ArraySetAsSeries(m_macd_buff_main, true);
    m_macd_current = 0.0;
    m_macd_previous = 0.0;
};

bool cmodel_macd::Init(){
    m_magic         = 148394;
    m_model_name    = "MACD MODEL";
    m_symbol        = _Symbol;
    m_timeframe     = _Period;
    m_slow_ema      = 26;
    m_fast_ema      = 12;
    m_signal_ema    = 9;
    m_delta         = 50;
    if(!InitIndicators()) return (false);
    return (true);
}

bool cmodel_macd::Init(cmodel_macd_param& m_param){
    m_magic         = 148394;
    m_model_name    = "MACD MODEL";
    m_symbol        = m_param.symbol;
    m_timeframe     = (ENUM_TIMEFRAMES)m_param.timeframe;
    m_slow_ema      = m_param.slow_ema;
    m_fast_ema      = m_param.fast_ema;
    m_signal_ema    = m_param.signal_ema;
    if(!CheckParam(m_param)) return (false);
    if(!InitIndicators()) return (false);
    return (true);
}

bool cmodel_macd::CheckParam(cmodel_macd_param& m_param){
    if(!SymbolInfoInteger(m_symbol, SYMBOL_SELECTED)){
        Print("Symbol ", m_symbol, " selection has failed. Check name of the symbol");
        return (false);
    }
    if(m_fast_ema == 0){
        Print("Fast EMA must be greater than 0");
        return (false);
    }
    if(m_slow_ema == 0){
        Print("Slow EMA must be greater than 0");
        return (false);
    }
    if(m_signal_ema == 0){
        Print("Signal EMA must be greater than 0");
        return (false);
    }
    return (true);
}

bool cmodel_macd::InitIndicators(){
    if(m_handle_macd == INVALID_HANDLE){
        Print("Load indicators...");
        if((m_handle_macd = iMACD(m_symbol, m_timeframe, m_fast_ema, m_slow_ema, m_signal_ema, PRICE_CLOSE)) == INVALID_HANDLE){
            printf("Error creating MACD indicator");
            return (false);
        }
    }
    return (true);
}