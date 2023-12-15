#include <Object.mqh>
#include <trade\PositionInfo.mqh>

//  +-------------------------------------------------------------------------------+
//  |   ENUM_TRAL_TYPE                                                              |
//  +-------------------------------------------------------------------------------+
//  |   
enum ENUM_TRAL_TYPE{
    NONE,
    TRAL_BREAKEVEN  = 1 << 0,
    TRAL_POINTS     = 1 << 1,
    TRAL_CANDLES    = 1 << 2,
    TRAL_MA         = 1 << 3,
    TRAL_PARABOLIC  = 1 << 4
};

//  +-------------------------------------------------------------------------------+
//  |   TrailingStop                                                                |
//  +-------------------------------------------------------------------------------+
//  |   Класс позволяет выставлять безупыток и тралить стоплоссы открытых позиций   |
//  +-------------------------------------------------------------------------------+
//  |   _show_alert   - флаг служит для отображения критически-важной информации    |
//  |                   срабатывает только один раз в функции Run(), затем пере-    |
//  |                   ключается в состояние false                                 |
//  +-------------------------------------------------------------------------------+
//  |   _tral_type    - способ трала (безубыток и прочие)                           |
//  |                   Если равен 0, то трал работать не будет                     |
//  +-------------------------------------------------------------------------------+
//  |   _magic        - идентификатор позиций, с которыми может работать этот трал  |
//  |                   Если равен 0, то советник будет тралить стопы, не глядя на  |
//  |                   magic                                                       |
//  |                   Если _symbol и _magic не заданы, то тралятся все стопы      |
//  +-------------------------------------------------------------------------------+
//  |   _symbol       - символ инструмента, с которыми может работать этот трал     |
//  |                   Если не задан, то советник будет тралить стопы, не глядя на |
//  |                   Symbol                                                      |
//  |                   Если _symbol и _magic не заданы, то тралятся все стопы      |
//  +-------------------------------------------------------------------------------+
class TrailingStop : public CObject{
public:
    TrailingStop()
        : _show_alert(true)
        , _magic(0)
        , _symbol(""){};

    TrailingStop* AddMagic(int magic);
    TrailingStop* AddSymbol(string symbol);

    ushort GetTralType()const{return _tral_type;};

    void EnableBreakeven(ushort target_step = 100, ushort offset = 10);
    void EnableTralPoints(int step = 100, int stop = 100);
    void EnableTralCandles(int last_candle = 1, int offset = 10);
    void EnableTralMA();
    void EnableTralParabolic();

    void Run() const;
    void ShowAlert() const;

    #ifdef DEBUG
        void Display() const;
    #endif

private:
    bool IsBreakeven()      const{return (_tral_type & TRAL_BREAKEVEN)  == TRAL_BREAKEVEN;};
    bool IsTralPoints()     const{return (_tral_type & TRAL_POINTS)     == TRAL_POINTS;};
    bool IsTralCandles()    const{return (_tral_type & TRAL_CANDLES)    == TRAL_CANDLES;};
    bool IsTralMA()         const{return (_tral_type & TRAL_MA)         == TRAL_MA;};
    bool IsTralParabolic()  const{return (_tral_type & TRAL_PARABOLIC)  == TRAL_PARABOLIC;};

private:
    bool            _show_alert;    // предупреждает, если не заданы _tral_type, _magic, или _symbol. После срабаывания этот флаг выключается в методе Run()
    ushort          _tral_type;
    int             _magic;
    string          _symbol;
    CPositionInfo*  _position;

    // breakeven setup:
    ushort _be_target_step, _be_offset;
};
//  +-------------------------------------------------------------------------------+
//  |   TrailingStop                                                                |
//  +-------------------------------------------------------------------------------+
//  |   Run                                                                         |
//  +-------------------------------------------------------------------------------+
void TrailingStop::Run()const{
    
    uint total = PositionsTotal();
    for(uint i = 0; i < total; ++i){
        string  symbol  = PositionGetSymbol(i);
        ulong   magic   = PositionGetInteger(POSITION_MAGIC);

        if( (_symbol == "" || _symbol == symbol) &&
            (_magic == 0 || _magic == magic)){
                #ifdef DEBUG
                    Print("Found position: "+symbol+" "+IntegerToString(magic));
                #endif
            }
    }
}

//  +-------------------------------------------------------------------------------+
//  |   TrailingStop                                                                |
//  +-------------------------------------------------------------------------------+
//  |   ShowAlert                                                                   |
//  +-------------------------------------------------------------------------------+
void TrailingStop::ShowAlert()const{
    string alert_info = "";
    if(_tral_type == 0){
        alert_info = "Не задан ни один тип для трала.";
    }
    else{
        if(_magic == 0){
            alert_info = "MAGIC равен нулю. Советник будет тралить ордера, не обращая внимание на MAGIC.";
        }
        if(_symbol == ""){
            alert_info += "Symbol не задан. Советник будет тралить ордера, не обращая внимание на Symbol.";
        }
    }
}

#ifdef DEBUG
//  +-------------------------------------------------------------------------------+
//  |   TrailingStop                                                                |
//  +-------------------------------------------------------------------------------+
//  |   Display                                                                     |
//  +-------------------------------------------------------------------------------+
void TrailingStop::Display() const{
    if(IsBreakeven())       Print("Breakeven");
    if(IsTralCandles())     Print("Candles");
    if(IsTralPoints())      Print("Points");
    if(IsTralMA())          Print("MA");
    if(IsTralParabolic())   Print("Parabolic");
}
#endif

//  +-------------------------------------------------------------------------------+
//  |   TrailingStop                                                                |
//  +-------------------------------------------------------------------------------+
//  |   AddMagic                                                                    |
//  +-------------------------------------------------------------------------------+
TrailingStop* TrailingStop::AddMagic(int magic){
    _magic = magic;
    return &this;
}

//  +-------------------------------------------------------------------------------+
//  |   TrailingStop                                                                |
//  +-------------------------------------------------------------------------------+
//  |   AddSymbol                                                                   |
//  +-------------------------------------------------------------------------------+
TrailingStop* TrailingStop::AddSymbol(string symbol){
    _symbol = symbol;
    return &this;
}

//  +-------------------------------------------------------------------------------+
//  |   TrailingStop                                                                |
//  +-------------------------------------------------------------------------------+
//  |   EnableBreakeven                                                             |
//  +-------------------------------------------------------------------------------+
//  |   Метод включает безубыток. Все остальные тралы зависят от первого            |
//  |   срабатывания безубытка                                                      |
void TrailingStop::EnableBreakeven(ushort target_step = 100, ushort offset = 10){
    _tral_type |= TRAL_BREAKEVEN;
    _be_target_step = target_step; _be_offset = offset;
}