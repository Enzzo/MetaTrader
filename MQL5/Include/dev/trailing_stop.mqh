#include <Object.mqh>
#include <trade\PositionInfo.mqh>

enum ENUM_TRAL_TYPE{
    NONE,
    TRAL_BREAKEVEN = 1,
    TRAL_POINTS = 2,
    TRAL_MA = 4,
    TRAL_PARABOLIC = 8
};

class TrailingStop : public CObject{
public:
    TrailingStop()
        : _tral_type(0)
        , _magic(0)
        , _symbol(""){};

    TrailingStop* SetTralType(ushort tral_type){
        _tral_type = tral_type;
        return &this;
    }

    TrailingStop* SetMagic(int magic){
        _magic = magic;
        return &this;
    }

    TrailingStop* SetSymbol(string symbol){
        _symbol = symbol;
        return &this;
    }

    ushort GetTralType()const{return _tral_type;};

    void Display() const{
        if((_tral_type & TRAL_BREAKEVEN) == TRAL_BREAKEVEN) Print("Breakeven");
        if((_tral_type & TRAL_POINTS) == TRAL_POINTS) Print("Points");
        if((_tral_type & TRAL_MA) == TRAL_MA) Print("MA");
        if((_tral_type & TRAL_PARABOLIC) == TRAL_PARABOLIC) Print("Parabolic");
    }
private:
    ushort          _tral_type;
    int             _magic;
    string          _symbol;
    CPositionInfo*  _position;
};