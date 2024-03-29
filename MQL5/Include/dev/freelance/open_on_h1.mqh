#include <Object.mqh>

class OpenOnH1Model : public CObject{
public:

    OpenOnH1Model(){};

    void Init(int magic, string symbol, int offset, int tp, int sl){
        _orders_placed = false;
        _magic  = magic;
        _symbol = symbol;
        _offset = offset;
        _tp     = tp;
        _sl     = sl;
    }

public:
            void Proccessing();
            bool SetOrders(){return false;};
            bool CloseOrder();
    inline  bool IsFilled();

public:
    inline  void SetMagic(int magic)        {_magic = magic;};
    inline  void SetSymbol(string symbol)   {_symbol = symbol;};
    inline  void SetOffset(int offset)      {_offset = offset;};
    inline  void SetTP(int tp)              {_tp = tp;};
    inline  void SetSL(int sl)              {_sl = sl;};

public:
    inline  int GetMagic()      const {return _magic;};
    inline  string GetSymbol()  const {return _symbol;};
    inline  int GetOffset()     const {return _offset;};
    inline  int GetTP()         const {return _tp;};
    inline  int GetSL()         const {return _sl;};

private:
    inline  bool IsNewHour()    const;
    inline  int TotalOrdersOnHour() const;
            bool PlaceOrders();

private:
    bool _orders_placed;
    int _magic, _tp, _sl, _offset;
    string _symbol;
};

// Функция, которая будет выполняться в блоке OnTick()
void OpenOnH1Model::Proccessing(){
    if(IsNewHour()){
        _orders_placed = false;
        #ifdef DEBUG
            Print("Is new hour!");
        #endif
        // сбрасываем флаг
    }

    if(!_orders_placed && TotalOrdersOnHour() < 2){
        _orders_placed = PlaceOrders();
    }
}

//  Функция определяет новый часовой бар
bool OpenOnH1Model::IsNewHour() const{
    static  datetime prev_bar_time[1];
            datetime new_bar_time[1];

    CopyTime(_symbol, PERIOD_H1, 0, 1, new_bar_time);
    if(new_bar_time[0] != prev_bar_time[0]){
        prev_bar_time[0] = new_bar_time[0];
        return true;
    }

    return false;
}

int OpenOnH1Model::TotalOrdersOnHour() const{
    int count = 0;
    int total = OrdersTotal();

    for(int i = total-1; i >= 0; --i){
        ulong   ticket  = OrderGetTicket(i);
        string  symbol  = OrderGetString(ORDER_SYMBOL);
        ulong   magic   = OrderGetInteger(ORDER_MAGIC);

        if(_magic == magic && _symbol == symbol){            
            datetime current_hour[1];
            MqlDateTime order_time_struct;
            datetime order_placed_hour = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
            
            CopyTime(_symbol, PERIOD_H1, 0, 1, current_hour);            
            TimeToStruct(order_placed_hour, order_time_struct);

        }
    }

    return count;
}

bool OpenOnH1Model::PlaceOrders(){
    
    // Определить уровень открытия предыдущего часа
    double h1_open[];
    CopyOpen(_symbol, PERIOD_H1, 1, 1, h1_open);
    
    // Рассчитать уровни для ордеров, используя уровень открытия и сдвиги
    double buy_stop = h1_open[0] + NormalizeDouble(_offset * Points(), Digits())

    // Разместить два ордера на этих уровнях

    return false;
}